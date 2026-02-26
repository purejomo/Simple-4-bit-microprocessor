# UVM Verification Environment — Simple 4-bit Microprocessor

이 디렉토리는 **Simple 4-bit Microprocessor** 프로젝트의  
**UVM(Universal Verification Methodology)** 기반 기능 검증 환경을 포함합니다.

기존 `sim_1/` 의 Verilog 테스트벤치는 directed simulation 수준에 머물러 있습니다.  
본 UVM 환경은 **랜덤 자극**, **Constraint**, **Scoreboard**, **기능 커버리지**를 통해  
검증 완성도(Quality of Verification)를 체계적으로 높이는 것을 목표로 합니다.

---

## 목차

- [검증 대상 IP](#검증-대상-ip)
- [디렉토리 구조](#디렉토리-구조)
- [UVM 아키텍처](#uvm-아키텍처)
- [컴포넌트 설명](#컴포넌트-설명)
- [구현 계획표 (Roadmap)](#구현-계획표-roadmap)
- [실행 환경 및 도구](#실행-환경-및-도구)
- [실행 방법](#실행-방법)
- [커버리지 목표](#커버리지-목표)

---

## 검증 대상 IP

| 우선순위 | 모듈 파일 | 기능 요약 | 검증 이유 |
|:---:|---|---|---|
| ★★★ | `alu.v` | ADD / SUB / AND / MUL / DIV + 플래그(sign, carry, zero) | 연산 종류 5가지 × 피연산자 조합 → 경우의 수 多, 핵심 IP |
| ★★★ | `control_block.v` | FSM 기반 마이크로 제어신호 생성 | 상태 전이 누락 시 전체 CPU 오동작 |
| ★★☆ | `pc.v` | Program Counter 증가 / 분기(load_pc) | 분기 조건(z_f, s_f) 및 경계 케이스 |
| ★★☆ | `aluNacc.v` | ALU + Accumulator 통합 동작 | 다단계 누산 결과 누적 검증 |
| ★☆☆ | `reg4.v` / `reg8.v` | 4/8비트 레지스터 입출력 제어 | inen/oen 동시 활성 등 edge case |
| ★☆☆ | `decoder.v` | 명령어 디코딩 | 전 opcode 커버리지 |

---

## 디렉토리 구조

```
verification/
├── README.md                  ← (현재 파일) 검증 계획 전체 문서
│
├── alu_uvm/                   ← Phase 1: ALU IP 단위 검증 환경
│   ├── alu_if.sv                   Interface
│   ├── alu_transaction.sv          Sequence Item (random + constraints)
│   ├── alu_sequence.sv             Stimulus Sequences (rand / directed)
│   ├── alu_sequencer.sv            Sequencer
│   ├── alu_driver.sv               Driver (IF 구동)
│   ├── alu_monitor.sv              Monitor (출력 관찰)
│   ├── alu_scoreboard.sv           Scoreboard (Golden model 비교)
│   ├── alu_coverage.sv             Functional Coverage collector
│   ├── alu_agent.sv                Agent (Driver + Monitor + Sequencer 묶음)
│   ├── alu_env.sv                  Environment (Agent + Scoreboard + Coverage)
│   ├── alu_test.sv                 Test (시나리오 선택 및 실행)
│   ├── tb_alu_uvm.sv               Top Testbench (IF 인스턴스, DUT 연결)
│   └── run.do                      Questa/ModelSim 실행 스크립트
│
├── ctrl_uvm/                  ← Phase 3: Control Block FSM 검증 환경
│   ├── ctrl_if.sv
│   ├── ctrl_transaction.sv
│   ├── ctrl_sequence.sv
│   ├── ctrl_driver.sv
│   ├── ctrl_monitor.sv
│   ├── ctrl_scoreboard.sv
│   ├── ctrl_coverage.sv
│   ├── ctrl_agent.sv
│   ├── ctrl_env.sv
│   ├── ctrl_test.sv
│   └── tb_ctrl_uvm.sv
│
└── processor_uvm/             ← Phase 4 (선택): CPU 통합 검증 환경
    ├── proc_if.sv
    ├── proc_transaction.sv
    ├── proc_sequence.sv
    ├── proc_scoreboard.sv
    ├── proc_env.sv
    ├── proc_test.sv
    └── tb_proc_uvm.sv
```

---

## UVM 아키텍처

아래는 `alu_uvm` 환경의 계층 구조입니다.

```
alu_test
  └── alu_env
        ├── alu_agent
        │     ├── alu_sequencer ←── alu_sequence (자극 생성)
        │     ├── alu_driver    ──→ alu_if ──→ DUT (alu.v)
        │     └── alu_monitor   ←── alu_if ←── DUT (alu.v)
        │                              │
        ├── alu_scoreboard  ←──────────┘  (monitor → analysis port)
        └── alu_coverage    ←──────────┘  (monitor → analysis port)
```

- **Driver**: Transaction을 받아 Interface의 클럭 기반 신호를 구동
- **Monitor**: Interface를 수동 관찰하여 Transaction으로 변환, Analysis Port로 전송
- **Scoreboard**: SW Golden 모델 결과와 DUT 출력 비교 → PASS/FAIL 판정
- **Coverage**: 수신 Transaction으로 Covergroup 샘플링 → 기능 커버리지 측정

---

## 컴포넌트 설명

### 1. Interface (`alu_if.sv`)

DUT의 포트를 추상화하고 Clocking Block으로 타이밍을 정의합니다.

```systemverilog
interface alu_if(input logic clk);
    logic        alu_add, alu_sub, alu_and, alu_mul, alu_div;
    logic        al_lsb, clr;
    logic [3:0]  AH_in, BREG_in;
    logic [3:0]  ALU_out;
    logic        Fa_cout, sign_flag, carry_flag, zero_flag;

    // Driver 관점: 출력 신호 구동
    clocking driver_cb @(posedge clk);
        output AH_in, BREG_in, alu_add, alu_sub, alu_and, alu_mul, alu_div, al_lsb, clr;
    endclocking

    // Monitor 관점: 입력/출력 관찰
    clocking monitor_cb @(posedge clk);
        input  AH_in, BREG_in, alu_add, alu_sub, alu_and, alu_mul, alu_div;
        input  ALU_out, Fa_cout, sign_flag, carry_flag, zero_flag;
    endclocking
endinterface
```

---

### 2. Transaction / Sequence Item (`alu_transaction.sv`)

한 번의 ALU 연산 자극과 결과를 담는 데이터 클래스입니다.  
`rand` 필드와 `constraint`로 유효한 랜덤 자극을 자동 생성합니다.

```systemverilog
class alu_transaction extends uvm_sequence_item;
    `uvm_object_utils(alu_transaction)

    // 입력 (자극)
    rand logic [3:0] AH_in, BREG_in;
    rand logic       alu_add, alu_sub, alu_and, alu_mul, alu_div;
    rand logic       al_lsb;

    // 출력 (관찰값)
    logic [3:0] ALU_out;
    logic       Fa_cout, sign_flag, carry_flag, zero_flag;

    // 제약: 한 번에 하나의 연산만 활성화 (one-hot)
    constraint one_hot_op {
        $onehot({alu_add, alu_sub, alu_and, alu_mul, alu_div}) == 1;
    }
    // 제약: 나눗셈 시 0으로 나누기 금지
    constraint no_div_by_zero {
        alu_div |-> (BREG_in != 4'd0);
    }
endclass
```

---

### 3. Sequences (`alu_sequence.sv`)

다양한 시나리오를 담은 시퀀스 클래스들입니다.

| Sequence 이름 | 설명 |
|---|---|
| `alu_rand_seq` | 100회 완전 랜덤 자극 (constraint 범위 내) |
| `alu_corner_seq` | 최대값(0xF), 0, overflow 등 경계 케이스 집중 |
| `alu_add_only_seq` | ADD 연산만 반복하여 carry 플래그 집중 검증 |
| `alu_sub_zero_seq` | SUB → 결과 0 유도로 zero_flag, sign_flag 검증 |

---

### 4. Scoreboard (`alu_scoreboard.sv`)

DUT 출력을 **SystemVerilog 기반 SW Golden 모델**과 비교합니다.

```
입력: AH_in=5, BREG_in=3, alu_add=1
Golden: 5 + 3 = 8  →  exp_out = 4'h8
DUT:    ALU_out = 4'h8  →  ✅ PASS

입력: AH_in=5, BREG_in=3, alu_sub=1
Golden: 5 - 3 = 2  →  exp_out = 4'h2
DUT:    ALU_out = 4'h3  →  ❌ MISMATCH (버그 감지)
```

---

### 5. Coverage (`alu_coverage.sv`)

기능 커버리지를 측정합니다.

```systemverilog
covergroup alu_cg;
    // 연산 종류 커버리지
    cp_opcode: coverpoint {alu_add, alu_sub, alu_and, alu_mul, alu_div} {
        bins ADD  = {5'b10000};
        bins SUB  = {5'b01000};
        bins AND  = {5'b00100};
        bins MUL  = {5'b00010};
        bins DIV  = {5'b00001};
    }
    // 피연산자 A 범위 커버리지
    cp_AH: coverpoint AH_in {
        bins zero    = {4'h0};
        bins max     = {4'hF};
        bins mid     = {[4'h1 : 4'hE]};
    }
    // 피연산자 B 범위 커버리지
    cp_BR: coverpoint BREG_in {
        bins zero    = {4'h0};
        bins max     = {4'hF};
        bins mid     = {[4'h1 : 4'hE]};
    }
    // 연산 종류 × 피연산자 조합 교차 커버리지
    cx_op_operands: cross cp_opcode, cp_AH, cp_BR;
endgroup
```

---

## 구현 계획표 (Roadmap)

| Phase | 기간 | 대상 모듈 | 구현 내용 | 완료 조건 |
|:---:|---|---|---|---|
| **Phase 1** | Week 1~2 | `alu.v` | Interface, Transaction (rand + constraints), Driver, Monitor 구현 | Directed test PASS, 시뮬레이션 파형 확인 |
| **Phase 2** | Week 3 | `alu.v` | Scoreboard (SW Golden model), 랜덤 시퀀스 100회 자동 검증 | Scoreboard PASS율 100% |
| **Phase 3** | Week 4 | `alu.v` | Coverage collector, covergroup 정의, 교차 커버리지 | 기능 커버리지 90% 이상 |
| **Phase 4** | Week 5~6 | `control_block.v` | FSM Interface, Transaction (opcode → 제어신호), Scoreboard | 모든 opcode 상태 전이 커버 |
| **Phase 5** | Week 7 | `control_block.v` | FSM 상태 커버리지 (state coverage), Sequence 다양화 | FSM 상태 커버리지 100% |
| **Phase 6** | Week 8 | `pc.v`, `aluNacc.v` | 단위 UVM 환경 구축, 분기/누산 동작 검증 | 각 모듈 독립 완전 검증 |
| **Phase 7** *(선택)* | Week 9~10 | `processor.v` (CPU 전체) | 통합 UVM 환경, 명령어 스트림 시퀀스로 프로그램 실행 검증 | 정해진 프로그램 실행 결과 golden 비교 |

### 세부 마일스톤

```
[Week 1]  alu_if.sv, alu_transaction.sv 작성 및 컴파일 확인
[Week 2]  alu_driver.sv, alu_monitor.sv 작성, tb_alu_uvm.sv에서 DUT 연결, 파형 확인
[Week 3]  alu_scoreboard.sv 작성, alu_rand_seq.sv 100회 자동 검증 → 버그 헌팅
[Week 4]  alu_coverage.sv 작성, Coverage 리포트 출력, 목표 90% 도달까지 자극 보강
[Week 5]  ctrl_if.sv, ctrl_transaction.sv (opcode 필드 정의) 작성
[Week 6]  ctrl_scoreboard.sv (제어신호 True Table 기반 Golden) 작성 및 검증
[Week 7]  cp_state covergroup 작성, ctrl FSM 상태 전이 완전 커버
[Week 8]  pc_uvm, aluNacc_uvm 단위 환경 구축
[Week 9~] (선택) processor_uvm 통합 환경, 명령어 시퀀스 시나리오 작성
```

---

## 실행 환경 및 도구

| 항목 | 권장 사양 |
|---|---|
| **시뮬레이터** | Questa Prime / ModelSim (UVM 1.2 내장), Synopsys VCS, Cadence Xcelium |
| **UVM 버전** | UVM 1.2 (IEEE 1800.2 호환) |
| **언어** | SystemVerilog (IEEE 1800-2017) |
| **Vivado 연동** | Simulation Settings → Questa 선택, `-L uvm` compile option 추가 |
| **컴파일 옵션** | `vlog +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv` |

---

## 실행 방법

### Questa / ModelSim

```bash
# 1. UVM 라이브러리 컴파일
vlib work
vlog +incdir+$UVM_HOME/src $UVM_HOME/src/uvm_pkg.sv

# 2. RTL 소스 컴파일
vlog ../../sources_1/new/fa.v
vlog ../../sources_1/new/fa4.v
vlog ../../sources_1/new/alu.v

# 3. UVM TB 컴파일
vlog -sv alu_uvm/alu_if.sv
vlog -sv alu_uvm/alu_transaction.sv
vlog -sv alu_uvm/alu_sequence.sv
vlog -sv alu_uvm/alu_sequencer.sv
vlog -sv alu_uvm/alu_driver.sv
vlog -sv alu_uvm/alu_monitor.sv
vlog -sv alu_uvm/alu_scoreboard.sv
vlog -sv alu_uvm/alu_coverage.sv
vlog -sv alu_uvm/alu_agent.sv
vlog -sv alu_uvm/alu_env.sv
vlog -sv alu_uvm/alu_test.sv
vlog -sv alu_uvm/tb_alu_uvm.sv

# 4. 시뮬레이션 실행
vsim -c tb_alu_uvm -do "run -all; quit"
```

### run.do 스크립트 사용 (간편 실행)

```bash
cd verification/alu_uvm
vsim -do run.do
```

---

## 커버리지 목표

| 커버리지 항목 | 목표 |
|---|---|
| 연산 종류 (ADD/SUB/AND/MUL/DIV) | **100%** |
| 피연산자 A 범위 (0, max, mid) | **100%** |
| 피연산자 B 범위 (0, max, mid) | **100%** |
| 연산 × 피연산자 교차 커버리지 | **≥ 90%** |
| FSM 상태 커버리지 (Phase 4~5) | **100%** |
| 전체 기능 커버리지 종합 | **≥ 90%** |

---

## 참고

- UVM Reference: [Accellera UVM 1.2 User Guide](https://www.accellera.org/images/downloads/standards/uvm/uvm_users_guide_1.2.pdf)
- 기존 Verilog TB 위치: `../sim_1/new/` (directed simulation, 레거시)
- RTL 소스 위치: `../sources_1/new/`
