CON

  BUTTON_PINS   = $FF           ' The QuickStart's touch buttons are on the eight LSBs
  SAMPLES       = 32            ' Require 32 high redings to return true


VAR
  
  long  Results


PUB Start(Rate)

  Results := Rate
  cognew(@Entry, @Results)      ' Launch a new cog to read samples


PUB State | Accumulator

  Accumulator := Results        ' Sample multiple times and return true
  repeat constant(SAMPLES - 1)  '  if every sample was highw
    Accumulator &= Results
  return Accumulator


DAT

                        org
Entry                                                                                                                                    
              rdlong    WaitTime, par
              mov       outa, #BUTTON_PINS              ' set TestPins high, but keep as inputs

              mov       Wait, cnt                       ' preset the counter
              add       Wait, WaitTime
Loop
              or        dira, #BUTTON_PINS              ' set TestPins as outputs (high)
              andn      dira, #BUTTON_PINS              ' set TestPins as inputs (floating)
              mov       Reading, #BUTTON_PINS           ' create a mask of applicable pins
              waitcnt   Wait, WaitTime                  ' wait for the voltage to decay
              andn      Reading, ina                    ' clear decayed pins from the mask
              wrlong    Reading, par                    ' write the result to RAM
              jmp       #Loop

Reading       res       1
WaitTime      res       1
Wait          res       1