## Functional Coverage Points
| Coverage Point | Description |
| --- | --- |
| paddr | Address signal |
| pwrite | Write signal |
| psel | Select signal |
| penable | Enable signal |

## Covergroup Definitions
```systemverilog
covergroup cg @(posedge pclk);
    coverpoint paddr;
    coverpoint pwrite;
    coverpoint psel;
    coverpoint penable;
endgroup
```

## Coverage Goals
- Address signal: 100%
- Write signal: 100%
- Select signal: 100%
- Enable signal: 100%

## Corner Cases
- Write to address 0x0
- Read from address 0x0
- Write to address 0xFFFFFFFF
- Read from address 0xFFFFFFFF