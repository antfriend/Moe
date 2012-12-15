{{
'*********************************************************************************************************************
'*********************************************************************************************************************
'****** Moe the Mobot ************************************************************************************************
'*********************************************************************************************************************
'*********************************************************************************************************************
'*********************************************************************************************************************
}}    

CON
'********************************************************************
  _CLKMODE = XTAL1 + PLL16X 
  _CLKFREQ = 80_000_000

'********************************************************************


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
  Motion_detector = 15
  
  'position constants
  Head_Up = 2300
  Head_Level = 1500
  Head_Down = 800
  
  Head_Right = 1900
  Head_Forward = 1450
  Head_Left = 1000

  Foot_Right_Out = 2250
  Foot_Right_Flat = 2200
  Foot_Right_In = 1500 

  Foot_Left_Out = 1250
  Foot_Left_Flat = 1300
  Foot_Left_In = 1900

  Right_Hip_In = 2400
  Right_Hip_Ahead = 2100
  Right_Hip_Out = 1501

  Left_Hip_Out = 1100
  Left_Hip_Ahead = 850  
  Left_Hip_In = 600
  
VAR
  Long ButtonState_Stack[20]'stack space allotment 
  Long Serial_On
  Long Servo_Head_position
  Long Servo_Neck_position
  
    
OBJ

  'Buttons          : "Touch Buttons"
  clock            : "Clock"
  SERVO            : "Servo32v7.spin"
  ping             : "Ping"
  DEBUG            : "Parallax Serial Terminal"                            ' for debugging



    
PUB Main | i, ping_dist, pace, the_duration

  Initialization

  the_duration := 100
  Lights_Off
  
  Position_Walkthrough
  Relax
  
  repeat 10
      LED_Ranger(ping.Ticks(Ping_In, Ping_Out))
      wait_this_fraction_of_a_second(4) 
  
  repeat
    'check if the sensor is detecting
    Lights_Off
    Relax
    waitpne(0, |< Motion_detector, 0)' Wait For Pin To Go HIGH
    Lights_On
    Awaken'
    wait_this_fraction_of_a_second(4)
    turn_right(the_duration)
    wait_this_fraction_of_a_second(4)
    
    Relax
    repeat until ina[Motion_detector]==0
      Lights_Off
      LED_Ranger(ping.Ticks(Ping_In, Ping_Out))
      wait_this_fraction_of_a_second(4)
    
    'check if the sensor is detecting
    Lights_Off
    Relax
    waitpne(0, |< Motion_detector, 0)' Wait For Pin To Go HIGH
    Lights_On
    Awaken
    wait_this_fraction_of_a_second(4)
    turn_left(the_duration)
    wait_this_fraction_of_a_second(4)
    
    Relax 
    repeat until ina[Motion_detector]==0
      Lights_Off 
      LED_Ranger(ping.Ticks(Ping_In, Ping_Out))
      wait_this_fraction_of_a_second(4)      


  
  
  if Serial_On == 1
      repeat 9
      Serial_String(String("*"))
      wait_this_fraction_of_a_second(3)
    Serial_String(String(DEBUG#CS))   
    Serial_String(String(DEBUG#NL, DEBUG#NL, "~~~MOE~~~", DEBUG#NL))
    Serial_Number(clkfreq)
    ping_dist := ping.Ticks(Ping_In, Ping_Out)
    Serial_String(String(DEBUG#NL, "PING!",DEBUG#NL))
    'Serial_String(String(DEBUG#NL, DEBUG#NL, "~~~MOE~~~", DEBUG#NL))
    repeat 3
      ping_dist := ping.Ticks(Ping_In, Ping_Out)
      Serial_String(String(DEBUG#NL, "PING!",DEBUG#NL))
      Serial_Number(ping_dist)
      clock.PauseMSec(250)



     
  Position_Walkthrough
  
  Lights_On
  Tedasena(300)
  wait_this_fraction_of_a_second(1)
  Lights_Off
  Relax
    


PRI wait_this_fraction_of_a_second(the_decimal)'1/the_decimal, e.g. 1/2, 1/4th, 1/10
  waitcnt(clkfreq / the_decimal + cnt)'if the_decimal=4, then we wait 1/4 sec

PRI Initialization
  dira[23..16]~~
  Lights_On
  clock.Init(5_000_000)
  clock.SetClock(_CLKMODE)
  dira[Motion_detector]~   ' Make I/O Pin Input
  { &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    try to make a serial connection?        &&&
  }'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
  Serial_On := 0 '1 is "yes" attempt serial &&&
  
  
  repeat 4                                      ' Set the LEDs as outputs
    Lights_On
    clock.PauseMSec(200)
    'wait_this_fraction_of_a_second(5000)
    'pause(1000)
    Lights_Off
    clock.PauseMSec(50)
    'wait_this_fraction_of_a_second(5000)
    'pause(1000)
    
  'Relax
  Tedasena(1)
  wait_this_fraction_of_a_second(2)
  SERVO.Start
  SERVO.Ramp
  'Relax
  Initialize_Serial
  wait_this_fraction_of_a_second(2)

PRI Initialize_Serial
  if Serial_On == 1      '1 == yes/true
    Serial_On := 0
    if DEBUG.start(250000)
      Serial_On := 1

PRI Serial_String(this_string)
  if Serial_On == 1
    DEBUG.Str(this_string)

PRI Serial_Number(this_number)
  if Serial_On == 1
    DEBUG.Dec(this_number)
  
PRI Lights_On
    outa[23..16]~~

PRI Lights_Off
    outa[23..16]~

PRI Blink(the_duration)
  Lights_On
  pausefor(the_duration)
  Lights_Off
   
PRI pausefor(this_long)
  repeat this_long
    wait_this_fraction_of_a_second(600)'this sets pace - smaller is slower, like 100, bigger is faster, like 500

PRI Move_Head_All_Around  | the_duration  
  the_duration:=100
  
  Lights_Off
  look_up(the_duration)

  the_duration:=90
  Lights_On
  look_down(the_duration) 

  the_duration:=70
  Lights_Off
  look_ahead(the_duration)

  the_duration:=40
  Lights_On
  turn_left(the_duration) 

  the_duration:=20
  Lights_Off
  turn_right(the_duration) 
  pausefor(the_duration)
  the_duration:=10
  Lights_On
  turn_center(the_duration)
  'pausefor(the_duration)
    
PRI Position_Walkthrough   | the_duration
  Lights_Off

  swing_head
  Move_Head_All_Around
  
  the_duration:=100
  repeat 0  
    tip_right(the_duration)
    'pausefor(the_duration)
    set_feet_flat(the_duration)
    tip_left(the_duration)
    'pausefor(the_duration)
    set_feet_flat(the_duration)

  repeat 4
    tip_left(the_duration)
    turn_right(the_duration)
    swing_right(the_duration)
    set_feet_flat(the_duration*2)
     
    tip_right(the_duration)
    turn_left(the_duration)
    swing_left(the_duration)
    set_feet_flat(the_duration*2)
  
  wait_this_fraction_of_a_second(1)
  
PRI swing_head  | the_duration, i
  the_duration:=300
  turn_center(the_duration)
  
  repeat i from 10 to 3
    the_duration:=10 * i
     
    turn_right(the_duration)
    turn_left(the_duration)
    
  the_duration:=300
  turn_center(the_duration)

PRI LED_Ranger(ping_dist) | base, multiple
  
  base := 100
  multiple := 100
  
  'outa[23..16]~~
  Lights_Off'clear the slate
  if ping_dist < (1 * multiple) + base
    outa[16]~~
  if ping_dist < (2 * multiple) + base
    outa[17]~~
  if ping_dist < (4 * multiple) + base
    outa[18]~~
  if ping_dist < (6 * multiple) + base
    outa[19]~~
  if ping_dist < (8 * multiple) + base
    outa[20]~~
  if ping_dist < (10 * multiple) + base
    outa[21]~~
  if ping_dist < (12 * multiple) + base
    outa[22]~~
  if ping_dist < (14 * multiple) + base
    outa[23]~~
  if ping_dist < (16 * multiple) + base
    Lights_Off  
  
'set the LED according to the distance







PRI look_up(the_duration)
  'SERVO.SetRamp(Pin, Width,Delay)<-- 100 = 1 sec 6000 = 1 min
  Servo_Head_position := Head_Up
  SERVO.SetRamp(Servo_Head,Head_Up,the_duration) 
  pausefor(the_duration)
     
PRI look_down(the_duration)
  Servo_Head_position := Head_Down
  SERVO.SetRamp(Servo_Head,Servo_Head_position,the_duration)
  pausefor(the_duration)

PRI look_ahead(the_duration)
  Servo_Head_position := Head_Level
  SERVO.SetRamp(Servo_Head,Servo_Head_position,the_duration)
  pausefor(the_duration)

PRI turn_right(the_duration)
  Servo_Neck_position := Head_Right
  SERVO.SetRamp(Servo_Neck,Servo_Neck_position,the_duration)
  pausefor(the_duration)
  
PRI turn_center(the_duration)
  Servo_Neck_position := Head_Forward
  SERVO.SetRamp(Servo_Neck,Servo_Neck_position,the_duration)
  pausefor(the_duration) 

PRI turn_left(the_duration)
  Servo_Neck_position := Head_Left
  SERVO.SetRamp(Servo_Neck,Servo_Neck_position,the_duration) 
  pausefor(the_duration)

PRI tip_left(the_duration)
  SERVO.SetRamp(Servo_left_Foot,Foot_Left_Out,the_duration/2)
  SERVO.SetRamp(Servo_right_Foot,Foot_Right_In,the_duration)
  pausefor(the_duration)

PRI tip_right(the_duration)
  SERVO.SetRamp(Servo_right_Foot,Foot_Right_Out,the_duration/2)
  SERVO.SetRamp(Servo_left_Foot,Foot_Left_In,the_duration)
  pausefor(the_duration)

PRI set_feet_flat(the_duration)
  SERVO.SetRamp(Servo_right_Foot,Foot_Right_Flat,the_duration/2)
  SERVO.SetRamp(Servo_left_Foot,Foot_Left_Flat,the_duration/2)'center is 1300   Foot_Left_Flat = 1300
  pausefor(the_duration)

PRI hips_ahead(the_duration)
  SERVO.SetRamp(Servo_right_Hip,Right_Hip_Ahead,the_duration)'2200 is RIGHT HIP straight ahead
  SERVO.SetRamp(Servo_left_Hip,Left_Hip_Ahead,the_duration)'800 is LEFT HIP straight ahead
  pausefor(the_duration)
 
PRI swing_right(the_duration)
  SERVO.SetRamp(Servo_left_Hip,Left_Hip_In,the_duration)
  SERVO.SetRamp(Servo_right_Hip,Right_Hip_Out,the_duration*2) 
  'turn_right(the_duration)
  pausefor(the_duration)

PRI swing_left(the_duration)
  SERVO.SetRamp(Servo_right_Hip,Right_Hip_In,the_duration)
  SERVO.SetRamp(Servo_left_Hip,Left_Hip_Out,the_duration*2)
  'turn_left(the_duration)
  pausefor(the_duration)
   
PRI lean_right(the_duration)'lean right and tip right foot, arch up
  SERVO.SetRamp(Servo_right_Foot,2500,the_duration)'center is 2200 
  'SERVO.Set(Servo_right_Foot,2500)'center is 2200
  SERVO.SetRamp(Servo_left_Foot,2000,the_duration)'center is 1300
  SERVO.SetRamp(Servo_Neck,2000,the_duration)'1500 is NECK a little left of center 
 
  SERVO.SetRamp(Servo_right_Hip,2500,the_duration)'2200 is RIGHT HIP straight ahead 

 
  repeat the_duration
    wait_this_fraction_of_a_second(600)

PRI shift_left(the_duration)
  SERVO.SetRamp(Servo_right_Hip,2200,the_duration)'2200 is RIGHT HIP straight ahead
  SERVO.SetRamp(Servo_left_Hip,1000,the_duration)'800 is LEFT HIP straight ahead
  SERVO.SetRamp(Servo_Neck,900,the_duration) '1500 is NECK a little left of center
  repeat the_duration
    wait_this_fraction_of_a_second(600)

PRI lean_left(the_duration)'lean left and tip right foot, arch up

  SERVO.SetRamp(Servo_left_Foot,1500,the_duration)'center is 2200
  SERVO.SetRamp(Servo_right_Foot,1500,the_duration) 'center is 1300
  SERVO.SetRamp(Servo_left_Hip,800,the_duration)'2200 is RIGHT HIP straight ahead
  SERVO.SetRamp(Servo_Neck,900,the_duration) '1500 is NECK a little left of center  
  repeat the_duration
    wait_this_fraction_of_a_second(600)

PRI shift_right(the_duration)
  SERVO.SetRamp(Servo_right_Hip,2500,the_duration)'2200 is RIGHT HIP straight ahead
  SERVO.SetRamp(Servo_left_Hip,1500,the_duration)'800 is LEFT HIP straight ahead
  SERVO.SetRamp(Servo_Neck,2000,the_duration) '1500 is NECK a little left of center
  repeat the_duration
    wait_this_fraction_of_a_second(600)
      
PRI Tedasena(the_duration) 
  hips_ahead(the_duration/2) 
  set_feet_flat(the_duration/2)
  turn_center(the_duration)
  look_ahead(the_duration)
       
PRI Relax | fraction_of_second
  fraction_of_second := 8
  'first complete any remaining movement
  Awaken
  wait_this_fraction_of_a_second(fraction_of_second)
  SERVO.Set(Servo_Head,0)
  wait_this_fraction_of_a_second(fraction_of_second)
  SERVO.Set(Servo_Neck,0)
  wait_this_fraction_of_a_second(fraction_of_second)
  SERVO.Set(Servo_right_Hip,0)
  wait_this_fraction_of_a_second(fraction_of_second)
  SERVO.Set(Servo_right_Foot,0)
  wait_this_fraction_of_a_second(fraction_of_second)
  SERVO.Set(Servo_left_Hip,0)
  wait_this_fraction_of_a_second(fraction_of_second)
  SERVO.Set(Servo_left_Foot,0)
  wait_this_fraction_of_a_second(fraction_of_second)
  
PRI Awaken
  SERVO.Set(Servo_Neck,Servo_Neck_position)
  SERVO.Set(Servo_Head,Servo_Head_position)







  
  
PRI center_all_servos(the_duration)
  outa[23..16]~
  'the_delay_time := 1
  outa[16]~~
  SERVO.SetRamp(Servo_Head,1500,the_duration)                          'HEAD straight ahead
  pausefor(the_duration)
  outa[17]~~
  SERVO.SetRamp(Servo_Neck,1500,the_duration)                          'NECK a little left of center
  pausefor(the_duration)  
  outa[18]~~
  SERVO.SetRamp(Servo_right_Hip,2200,the_duration)                     'RIGHT HIP straight ahead
  pausefor(the_duration)
  outa[19]~~
  SERVO.SetRamp(Servo_right_Foot,2200,the_duration)                    'RIGHT FOOT level
  pausefor(the_duration)
  outa[20]~~
  SERVO.SetRamp(Servo_left_Hip,800,the_duration)                       'LEFT HIP straight ahead
  pausefor(the_duration)
  outa[21]~~
  SERVO.SetRamp(Servo_left_Foot,1300,the_duration)                     'LEFT FOOT level   2200 is tipped way in   800 is way out
  pausefor(the_duration)
  'Relax
    
  {
  SERVO.Set(Servo_left_Hip,1500)
  SERVO.Set(Servo_left_Foot,1500)
  }  