# AI VLSI Factory — Generation Report

**Module:** `apb_verif`  
**Request:** Create an APB Verification Environment  
**Generated:** 2026-06-16 16:25:36  

---

## File Validation

| File | Status | Detail |
|---|---|---|
| `README.md` | ✅ PASS | OK |
| `docs\coverage_plan.md` | ✅ PASS | OK |
| `docs\design_spec.md` | ✅ PASS | OK |
| `docs\generation_report.md` | ✅ PASS | OK |
| `rtl\apb_verification_env.sv` | ✅ PASS | OK |
| `sva\apb_verif_sva.sv` | ✅ PASS | OK |
| `sva\_sva.sv` | ✅ PASS | OK |

## Simulation Results

**Status:** ✅ PASSED  
**Auto-fix attempts:** 1  

## Generated Files

- `.git\config` (353 bytes)
- `.git\description` (73 bytes)
- `.git\HEAD` (23 bytes)
- `.git\hooks\applypatch-msg.sample` (478 bytes)
- `.git\hooks\commit-msg.sample` (896 bytes)
- `.git\hooks\fsmonitor-watchman.sample` (4726 bytes)
- `.git\hooks\post-update.sample` (189 bytes)
- `.git\hooks\pre-applypatch.sample` (424 bytes)
- `.git\hooks\pre-commit.sample` (1649 bytes)
- `.git\hooks\pre-merge-commit.sample` (416 bytes)
- `.git\hooks\pre-push.sample` (1374 bytes)
- `.git\hooks\pre-rebase.sample` (4898 bytes)
- `.git\hooks\pre-receive.sample` (544 bytes)
- `.git\hooks\prepare-commit-msg.sample` (1492 bytes)
- `.git\hooks\push-to-checkout.sample` (2783 bytes)
- `.git\hooks\sendemail-validate.sample` (2308 bytes)
- `.git\hooks\update.sample` (3650 bytes)
- `.git\index` (864 bytes)
- `.git\info\exclude` (240 bytes)
- `.git\logs\HEAD` (338 bytes)
- `.git\logs\refs\heads\master` (374 bytes)
- `.git\logs\refs\remotes\origin\main` (152 bytes)
- `.git\objects\10\ed38327e0e2a1b2e24ab12c5257701569c240f` (55 bytes)
- `.git\objects\2c\a30644d724cf399b2924622d11349c6ac3e272` (465 bytes)
- `.git\objects\67\e51e2871332c93f3a3d3e68e22fc6774ab97cb` (1191 bytes)
- `.git\objects\6a\54278fe260a32c65b068c2c56db257a57d666c` (188 bytes)
- `.git\objects\74\370a9ffac141e86cf65073b1dccc482e26e978` (85 bytes)
- `.git\objects\75\3128c507f4af6fc48341e93b2481b608ac33c2` (1118 bytes)
- `.git\objects\7c\6922e0d647daa15c52f6f79c4760a83629bc81` (1040 bytes)
- `.git\objects\85\f7f05e4504932b8e1ed1954236f244345962b1` (260 bytes)
- `.git\objects\8b\149c6855e1e51844411ef8a417050b5b044f9c` (51 bytes)
- `.git\objects\9e\35c1577fc740905435163e7f531c3c9ed85474` (57 bytes)
- `.git\objects\a5\880858ebda1c0a797a4be50d239165deee5880` (227 bytes)
- `.git\objects\a6\80f1df2edef21e227e6f112c383dd340a4488d` (227 bytes)
- `.git\objects\ad\fa363f615439bd11c4476779d0f3b7d8102074` (1088 bytes)
- `.git\objects\af\334cebfba95e8ca7d64f2c09bea63d0bf92a9f` (499 bytes)
- `.git\objects\b8\53b3e5a3fd930492d112d3932dabe6a7c2341a` (2064 bytes)
- `.git\objects\ce\45ee8cd86850aac105f7429b973ddf22815fed` (270 bytes)
- `.git\objects\dc\b684c6b1ad7c3453f271b4839c97384d5bdffe` (140 bytes)
- `.git\objects\ed\d02330efddf857f44fcdaadf9ab6f430876e25` (51 bytes)
- `.git\objects\f0\8d4d5585cf16f43f3f872fe04e0e50c5cdbbe7` (119 bytes)
- `.git\objects\f2\13f4364e2f682db16dc319a5679922694d7920` (984 bytes)
- `.git\objects\f7\5bb5a431449800cb72979ea2106dc36d45f77c` (990 bytes)
- `.git\refs\heads\master` (41 bytes)
- `.git\refs\remotes\origin\main` (41 bytes)
- `.gitignore` (134 bytes)
- `_raw_response_debug.txt` (9583 bytes)
- `docs\coverage_plan.md` (620 bytes)
- `docs\design_spec.md` (2146 bytes)
- `docs\generation_report.md` (1029 bytes)
- `README.md` (895 bytes)
- `rtl\apb_verification_env.sv` (1186 bytes)
- `sim\sim.vvp` (4174 bytes)
- `sim\waves.gtkw` (476 bytes)
- `sim\waves.vcd` (4034 bytes)
- `sva\_sva.sv` (1269 bytes)
- `sva\apb_verif_sva.sv` (3467 bytes)

## How to Run

```bash
# Compile
iverilog -g2012 -o sim/sim.vvp rtl/apb_verif.sv tb/apb_verif_tb.sv

# Simulate
vvp sim/sim.vvp
```
