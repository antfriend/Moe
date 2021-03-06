{{
***************************************
*        Ping))) Object V1.2          *
* Author:  Chris Savage & Jeff Martin *
* Copyright (c) 2006 Parallax, Inc.   *
* See end of file for terms of use.   *    
* Started: 05-08-2006                 *
***************************************

Interface to Ping))) sensor and measure its ultrasonic travel time.  Measurements can be in units of time or distance.
Each method requires one parameter, Pin, that is the I/O pin that is connected to the Ping)))'s signal line.

  ┌───────────────────┐
  │┌───┐         ┌───┐│    Connection To Propeller
  ││ ‣ │ PING))) │ ‣ ││    Remember PING))) Requires
  │└───┘         └───┘│    +5V Power Supply
  │    GND +5V SIG    │
  └─────┬───┬───┬─────┘
        │  │    3.3K
          └┘   └ Pin

--------------------------REVISION HISTORY--------------------------
 v1.2 - Updated 06/13/2011 to change SIG resistor from 1K to 3.3K
 v1.1 - Updated 03/20/2007 to change SIG resistor from 10K to 1K
 
}}

CON

  TO_IN = 73_746                                                                ' Inches
  TO_CM = 29_034                                                                ' Centimeters
  _CLKMODE = XTAL1 + PLL16X  
  _CLKFREQ = 80_000_000
  
OBJ
  clock            : "Clock"

PUB Ticks(In_Pin, Out_Pin) : Microseconds | cnt1, cnt2
''Return Ping)))'s one-way ultrasonic travel time in microseconds
                                                                                 
  outa[Out_Pin]~                                                                    ' Clear I/O Pin
  dira[Out_Pin]~~                                                                   ' Make Pin Output
  clock.PauseUSec(2)
  outa[Out_Pin]~~                                                                   ' Set I/O Pin
  clock.PauseUSec(5)
  outa[Out_Pin]~                                                                    ' Clear I/O Pin (> 2 µs pulse)

  dira[In_Pin]~                                                                    ' Make I/O Pin Input
  waitpne(0, |< In_Pin, 0)                                                         ' Wait For Pin To Go HIGH
  cnt1 := cnt                                                                   ' Store Current Counter Value
  waitpeq(0, |< In_Pin, 0)                                                         ' Wait For Pin To Go LOW 
  cnt2 := cnt                                                                   ' Store New Counter Value
  Microseconds := (||(cnt1 - cnt2) / (clkfreq / 1_000_000)) >> 1                ' Return Time in µs
  
                                                                            
PUB Bad_Ticks(In_Pin, Out_Pin) : Microseconds | cnt1, cnt2
''Return Ping)))'s one-way ultrasonic travel time in microseconds

  clock.Init(5_000_000)
  clock.SetClock(_CLKMODE)

  outa[In_Pin]~~ 'set in pin pull up
  dira[In_Pin]~  'set in pin for in
                                                                               
  outa[Out_Pin]~  'out pin should be low                                                                 
  dira[Out_Pin]~~ 'out ping for out
  clock.PauseUSec(2)

  outa[Out_Pin]~~
  clock.PauseUSec(5)'Wait for 5 us
  
  outa[Out_Pin]~
  cnt1 := cnt                                                  
  waitpne(0, |< In_Pin, 0) ' Wait For Pin To Go HIGH
  'waitcnt(1_000 + cnt) 'Wait for 10 microseconds (42 inches)
  clock.PauseUSec(10)'Wait for 10 us
  ' Store Current Counter Value
  waitpeq(0, |< In_Pin, 0)
  if(ina[In_Pin] == 0)
     'waitcnt(1_000 + cnt) 'Wait for 10 microseconds
     clock.PauseUSec(10)
  else
     waitcnt(200 + cnt) 'Wait for 2 ms
                                                            ' Wait For Pin To Go LOW 
  cnt2 := cnt                                                                   ' Store New Counter Value
  Microseconds := (||(cnt1 - cnt2) / (clkfreq / 1_000_000)) >> 1                ' Return Time in µs

{
        http://www.elecfreaks.com/244.html
        
        digitalWrite(TP, LOW);
         delayMicroseconds(2);
         digitalWrite(TP, HIGH);                 // pull the Trig pin to high level for more than 10us impulse
         delayMicroseconds(10);
         digitalWrite(TP, LOW);
         long microseconds = pulseIn(EP,HIGH);   // waits for the pin to go HIGH, and returns the length of the pulse in microseconds
         return microseconds;
 } 

PUB Inches(In_Pin, Out_Pin) : Distance
''Measure object distance in inches

  Distance := Ticks(In_Pin, Out_Pin) * 1_000 / TO_IN                                        ' Distance In Inches
                                                                                 
                                                                                 
PUB Centimeters(In_Pin, Out_Pin) : Distance                                                  
''Measure object distance in centimeters
                                              
  Distance := Millimeters(In_Pin, Out_Pin) / 10                                             ' Distance In Centimeters
                                                                                 
                                                                                 
PUB Millimeters(In_Pin, Out_Pin) : Distance                                                  
''Measure object distance in millimeters
                                              
  Distance := Ticks(In_Pin, Out_Pin) * 10_000 / TO_CM                                       ' Distance In Millimeters

PRI wait_this_fraction_of_a_second(the_decimal)'1/the_decimal, e.g. 1/2, 1/4th, 1/10
  waitcnt(clkfreq / the_decimal + cnt)'if the_decimal=4, then we wait 1/4 sec


{{ 
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                  │                                                            
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    │ 
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software│
│is furnished to do so, subject to the following conditions:                                                                   │
│                                                                                                                              │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.│
│                                                                                                                              │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
}}          