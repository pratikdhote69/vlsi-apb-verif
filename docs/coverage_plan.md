# APB Verification Environment Coverage Plan
| Functional Coverage Point | Description |
| --- | --- |
| `psel` | Select signal coverage |
| `penable` | Enable signal coverage |
| `pwrite` | Write signal coverage |
| `pwdata` | Write data coverage |
| `prdata` | Read data coverage |
| `pready` | Ready signal coverage |
| `perr` | Error signal coverage |
| `paddr` | Address signal coverage |

```systemverilog
covergroup apb_cg;
  coverpoint psel;
  coverpoint penable;
  coverpoint pwrite;
  coverpoint pwdata;
  coverpoint prdata;
  coverpoint pready;
  coverpoint perr;
  coverpoint paddr;
endgroup
```

## Coverage Goals
- `psel`: 100%
- `penable`: 100%
- `pwrite`: 100%
- `pwdata`: 100%
- `prdata`: 100%
- `pready`: 100%
- `perr`: 100%
- `paddr`: 100%

## Corner Cases to Cover
- `psel` and `penable` both high
- `psel` and `penable` both low
- `pwrite` high and `pwdata` non-zero
- `pwrite` low and `prdata` non-zero
- `pready` high and `perr` low
- `pready` low and `perr` high
- `paddr` covering all possible values