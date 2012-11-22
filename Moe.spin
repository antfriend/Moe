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
  'position constants
  Head_Up = 2300
  Head_Level = 1500
  Head_Down = 800
  
  Head_Right = 1900
  Head_Forward = 1450
  Head_Left = 1000

  Foot_Right_Out = 2400
  Foot_Right_Flat = 2200
  Foot_Right_In = 1500 

  Foot_Left_Out = 1200
  Foot_Left_Flat = 1300
  Foot_Left_In = 1800

  Right_Hip_In = 2490
  Right_Hip_Ahead = 2100
  Right_Hip_Out = 1800

  Left_Hip_Out = 1100
  Left_Hip_Ahead = 800  
  Left_Hip_In = 500
  
VAR
  Long ButtonState_Stack[20]'stack space allotment 
    
OBJ

  'Buttons          : "Touch Buttons"
  SERVO            : "Servo32v7.spin"
  ping             : "Ping"
  'DEBUG            : "Parallax Serial Terminal"                            ' for debugging

PRI Initialization
  dira[23..16]~~                                        ' Set the LEDs as outputs
  Lights_On
  Relax
  Tedasena(1)
  wait_this_fraction_of_a_second(1)
  SERVO.Start
  SERVO.Ramp
  'Relax
  wait_this_fraction_of_a_second(1)
  
PRI Lights_On
    outa[23..16]~~

PRI Lights_Off
    outa[23..16]~

PRI pausefor(this_long)
  repeat this_long
    wait_this_fraction_of_a_second(120)'this sets pace - smaller is slower, like 100, bigger is faster, like 500

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
  look_left(the_duration) 

  the_duration:=20
  Lights_Off
  look_right(the_duration) 
  pausefor(the_duration)
  the_duration:=10
  Lights_On
  look_forward(the_duration)
  'pausefor(the_duration)
    
PRI Position_Walkthrough   | the_duration

  'swing_head
  'Move_Head_All_Around
  
  'SERVO.SetRamp(Servo_right_Hip,2500,the_duration)'2200 is RIGHT HIP straight ahead
  'SERVO.SetRamp(Servo_left_Hip,1500,the_duration)'800 is LEFT HIP straight ahead
  'SERVO.SetRamp(Servo_Neck,2000,the_duration) '1500 is NECK a little left of center
  'SERVO.SetRamp(Servo_right_Hip,2500,the_duration)'2200 is RIGHT HIP straight ahead
  'SERVO.SetRamp(Servo_left_Hip,1500,the_duration)'800 is LEFT HIP straight ahead
  'SERVO.SetRamp(Servo_Neck,2000,the_duration) '1500 is NECK a little left of center
  Lights_Off  
  pausefor(the_duration)
  'a change
  'repeat 3
  '  wait_this_fraction_of_a_second(1)
    
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
    look_right(the_duration)
    swing_right(the_duration)
    set_feet_flat(the_duration*2)
     
    tip_right(the_duration)
    look_left(the_duration)
    swing_left(the_duration)
    set_feet_flat(the_duration*2)
  
  wait_this_fraction_of_a_second(1)
  
PRI swing_head  | the_duration, i
  the_duration:=300
  look_forward(the_duration)
  
  repeat i from 10 to 3
    the_duration:=10 * i
     
    look_right(the_duration)
    look_left(the_duration)
    
  the_duration:=300
  look_forward(the_duration)
      
PUB Main | i, ping_dist, pace

  Initialization
  
  'center_all_servos(250)'don't use this until all parts are callibrated
    
  wait_this_fraction_of_a_second(1)
  Position_Walkthrough
  
  Lights_On
  Tedasena(300)
  wait_this_fraction_of_a_second(1)
  Lights_Off
  Relax

   'ButtonStateCheck
     {
  'repeat
    'wait_this_fraction_of_a_second(1)
    DEBUG.Str(String(DEBUG#CS))   
    DEBUG.Str(String(DEBUG#NL, DEBUG#NL, "~~~MOE~~~", DEBUG#NL))
    repeat i from 1 to 20
      DEBUG.Str(String("*"))
      'ButtonStateCheck
      wait_this_fraction_of_a_second(20)
      DEBUG.Str(String("PING )))")) 
      'ping_dist := ping.Ticks(Ping_In, Ping_Out)

      DEBUG.Dec(ping_dist)
      }

      {  &&&&&&&&&&&&&&&
       }    'begin
         {
        repeat 2
          pace:=500
          lean_right(pace)'lean right and tip left foot, arch up
          pace:=400
          shift_left(pace)
          pace:=300
          lean_left(pace)'lean left and tip right foot, arch up
          pace:=200
          shift_right(pace)
         }
        
       {     end
      } '&&&&&&&&&&&&&&&
      {
      center_all_servos(3)
      Tedasena(pace)
      outa[23..16]~ 'lights off
      wait_this_fraction_of_a_second(8)
      outa[23..16]~~
      Relax
      wait_this_fraction_of_a_second(8)
      Tedasena(pace) 
      wait_this_fraction_of_a_second(1)
      Relax
      }
      
PRI wait_this_fraction_of_a_second(the_decimal)'1/the_decimal, e.g. 1/2, 1/4th, 1/10
  waitcnt(clkfreq / the_decimal + cnt)'if the_decimal=4, then we wait 1/4 sec

PRI look_up(the_duration)
  'SERVO.SetRamp(Pin, Width,Delay)<-- 100 = 1 sec 6000 = 1 min    
  SERVO.SetRamp(Servo_Head,Head_Up,the_duration) 
  pausefor(the_duration)
     
PRI look_down(the_duration)
  SERVO.SetRamp(Servo_Head,Head_Down,the_duration)
  pausefor(the_duration)

PRI look_ahead(the_duration)
  SERVO.SetRamp(Servo_Head,Head_Level,the_duration)
  pausefor(the_duration)

PRI look_right(the_duration)
  SERVO.SetRamp(Servo_Neck,Head_Right,the_duration)
  pausefor(the_duration)
  
PRI look_forward(the_duration)
  SERVO.SetRamp(Servo_Neck,Head_Forward,the_duration)
  pausefor(the_duration) 

PRI look_left(the_duration)
  SERVO.SetRamp(Servo_Neck,Head_Left,the_duration)
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
  SERVO.SetRamp(Servo_left_Hip,Left_Hip_In,the_duration/2)
  SERVO.SetRamp(Servo_right_Hip,Right_Hip_Out,the_duration) 
  'look_right(the_duration)
  pausefor(the_duration)

PRI swing_left(the_duration)
  SERVO.SetRamp(Servo_right_Hip,Right_Hip_In,the_duration/2)
  SERVO.SetRamp(Servo_left_Hip,Left_Hip_Out,the_duration)
  'look_left(the_duration)
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
  look_forward(the_duration)
  look_ahead(the_duration)
       
PRI Relax
  SERVO.Set(Servo_Head,0)
  wait_this_fraction_of_a_second(8)
  SERVO.Set(Servo_Neck,0)
  wait_this_fraction_of_a_second(8)
  SERVO.Set(Servo_right_Hip,0)
  wait_this_fraction_of_a_second(8)
  SERVO.Set(Servo_right_Foot,0)
  wait_this_fraction_of_a_second(8)
  SERVO.Set(Servo_left_Hip,0)
  wait_this_fraction_of_a_second(8)
  SERVO.Set(Servo_left_Foot,0)
  
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