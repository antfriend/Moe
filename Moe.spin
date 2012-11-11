{{
'*********************************************************************************************************************
'*********************************************************************************************************************
'****** Moe ***********************************************************************************************************
'*********************************************************************************************************************
'*********************************************************************************************************************
'*********************************************************************************************************************
}}

CON
'********************************************************************
  _CLKMODE = XTAL1 + PLL16X 
  _CLKFREQ = 80_000_000
'********************************************************************
   ' _XINFREQ = 5_000_000

  Blab = 0
  Servo_Head = 11
  Servo_Neck = 9
  Servo_right_Hip = 8
  Servo_right_Foot = 10
  Servo_left_Hip = 12
  Servo_left_Foot = 14
  Ping_Out = 26 'correct!
  Ping_In = 24  'correct!
  BUTTON_PINS   = $FF
  

VAR
  Long ButtonState_Stack[20]'stack space allotment 
    
OBJ

  Buttons          : "Touch Buttons"
  SERVO            : "Servo32v7.spin"
  ping             : "Ping"
  DEBUG            : "Parallax Serial Terminal"                            ' for debugging

PRI Initialization
  Buttons.start(_CLKFREQ / 15)                         ' Launch the touch buttons driver
  dira[23..16]~~                                        ' Set the LEDs as outputs
  cognew(ButtonStateCheck, @ButtonState_Stack)
  
  SERVO.Start
  SERVO.Ramp
  
  DEBUG.start(250000)   
  DEBUG.Str(String(DEBUG#CS))

PRI ButtonStateCheck
  repeat
    outa[23..16] := Buttons.State                       ' Light the LEDs when touching the corresponding buttons 
  
PUB Main | i, ping_dist
  Initialization
  {{
  repeat 20
    wait_this_fraction_of_a_second(1)
    outa[23..16]~~
    wait_this_fraction_of_a_second(1)
    outa[23..16]~
   }}   
  repeat
    wait_this_fraction_of_a_second(1)
    DEBUG.Str(String(DEBUG#CS))   
    DEBUG.Str(String(DEBUG#NL, DEBUG#NL, "~~~MOE~~~", DEBUG#NL))
    repeat i from 1 to 20
      DEBUG.Str(String("*"))
      'ButtonStateCheck
      wait_this_fraction_of_a_second(20)
      DEBUG.Str(String("PING )))")) 
      'ping_dist := ping.Ticks(Ping_In, Ping_Out)
      repeat i from 16 to 23
        outa[23..16]~
        outa[i]~~
        wait_this_fraction_of_a_second(8) 
      DEBUG.Dec(ping_dist)
      center_all_servos
      outa[23..16]~
      wait_this_fraction_of_a_second(8)
      outa[23..16]~~
      Relax
      wait_this_fraction_of_a_second(1)
      
PRI wait_this_fraction_of_a_second(the_decimal)'1/the_decimal, e.g. 1/2, 1/4th, 1/10
  waitcnt(clkfreq / the_decimal + cnt)'if the_decimal=4, then we wait 1/4 sec

PRI Tedasena
  SERVO.Set(Servo_Head,1500)                            'HEAD straight ahead

PRI Relax
  SERVO.Set(Servo_Head,0)
  SERVO.Set(Servo_Neck,0)
  SERVO.Set(Servo_right_Hip,0)
  SERVO.Set(Servo_right_Foot,0)
  SERVO.Set(Servo_left_Hip,0)
  SERVO.Set(Servo_left_Foot,0)
  
PRI center_all_servos | the_delay_time
  outa[23..16]~
  the_delay_time := 1
  outa[16]~~
  SERVO.Set(Servo_Head,1500)                            'HEAD straight ahead
  wait_this_fraction_of_a_second(the_delay_time)
  outa[17]~~
  SERVO.Set(Servo_Neck,1500)                            'NECK a little left of center
  wait_this_fraction_of_a_second(the_delay_time)
  
  outa[18]~~
  SERVO.Set(Servo_right_Hip,2200)                       'RIGHT HIP straight ahead
  wait_this_fraction_of_a_second(the_delay_time)
  outa[19]~~
  SERVO.Set(Servo_right_Foot,2200)                      'RIGHT FOOT level
  wait_this_fraction_of_a_second(the_delay_time)

  outa[20]~~
  SERVO.Set(Servo_left_Hip,800)                       'LEFT HIP straight ahead
  wait_this_fraction_of_a_second(the_delay_time)
  outa[21]~~
  SERVO.Set(Servo_left_Foot,1300)                      'LEFT FOOT level   2200 is tipped way in   800 is way out
  wait_this_fraction_of_a_second(the_delay_time)
  Relax
    
  {
  SERVO.Set(Servo_left_Hip,1500)
  SERVO.Set(Servo_left_Foot,1500)
  }  