//Developed by Rajarshi Roy and James Bruce, modified by Xubin Chen
import java.awt.Robot; //java library that lets us take screenshots
import java.awt.AWTException;
import java.awt.event.InputEvent;
import java.awt.image.BufferedImage;
import java.awt.Rectangle;
import java.awt.Dimension;
import java.io.*;
import java.awt.Color;
import processing.serial.*; //library for serial communication
 
 
Serial port; //creates object "port" of serial class
Robot robby; //creates object "robby" of robot class
 
void setup()
{
println(Serial.list());
port = new Serial(this, Serial.list()[0],9600); //set baud rate
size(100, 100); //window size (doesn't matter)
try //standard Robot class error check
{
robby = new Robot();
}
catch (AWTException e)
{
println("Robot class not supported by your system!");
exit();
}
}
 
void draw()
{
int pixel; //ARGB variable with 32 int bytes where
//sets of 8 bytes are: Alpha, Red, Green, Blue
float r=0;
float g=0;
float b=0;
 
int skipValue = 1;
int x = displayWidth; //possibly displayWidth
int y =  displayHeight; //possible displayHeight instead
 
//get screenshot into object "screenshot" of class BufferedImage
BufferedImage screenshot = robby.createScreenCapture(new Rectangle(new Dimension(x,y)));

 
int i=0;
int j=0;
//I skip every alternate pixel making my program 4 times faster
for(i=0; i<x; i=i+skipValue){
for(j=0; j<y; j=j+skipValue){
pixel = screenshot.getRGB(i,j); //the ARGB integer has the colors of pixel (i,j)
r = r+(int)(255&(pixel>>16)); //add up reds
g = g+(int)(255&(pixel>>8)); //add up greens
b = b+(int)(255&(pixel)); //add up blues
}
}
int aX = x/skipValue;
int aY = y/skipValue;
r=r/(aX*aY); //average red
g=g/(aX*aY); //average green
b=b/(aX*aY); //average blue
 
//println(r+","+g+","+b);
 
// filter values to increase saturation
float maxColorInt;
float minColorInt;
 
maxColorInt = max(r,g,b);
if(maxColorInt == r){
  // red
  if(maxColorInt < (225-20)){
    r = maxColorInt + 20;  
  }
}
else if (maxColorInt == g){
  //green
  if(maxColorInt < (225-20)){
    g = maxColorInt + 20;  
  }
}
else {
   //blue
   if(maxColorInt < (225-20)){
    b = maxColorInt + 20;  
  }  
}
 
//minimise smallest
minColorInt = min(r,g,b);
if(minColorInt == r){
  // red
  if(minColorInt > 20){
    r = minColorInt - 20;  
  }
}
else if (minColorInt == g){
  //green
  if(minColorInt > 20){
    g = minColorInt - 20;  
  }
}
else {
   //blue
   if(minColorInt > 20){
    b = minColorInt - 20;  
  }  
}

//Convert RGB values to HSV(Hue Saturation and Brightness) 
float[] hsv = new float[3];
Color.RGBtoHSB(Math.round(r),Math.round(g),Math.round(b),hsv);
//You can multiply SAT or BRI by a digit to make it less saturated or bright
float HUE= hsv[0] * 65535;
float SAT= hsv[1] * 255;
float BRI= hsv[2] * 255;

//Convert floats to integers
String hue = String.valueOf(Math.round(HUE));
String sat = String.valueOf(Math.round(SAT));
String bri = String.valueOf(Math.round(BRI));

port.write(0xff); //write marker (0xff) for synchronization
port.write((byte)(r)); //write red value
port.write((byte)(g)); //write green value
port.write((byte)(b)); //write blue value
delay(100); //delay for safety

//This portion calls the bash file which allows Curl PUT to write the HSV values to Philips Hue
try{
  
           // create a new array of 4 strings
         String[] cmdArray = new String[4];

         // first argument is the program we want to open, in this case I put it within the App I created later
         cmdArray[0] = "/Applications/AmbiHue.app/hue.sh";

         // the following arguments are HSV values
         cmdArray[1] = hue;
         cmdArray[2] = sat;     
         cmdArray[3] = bri;

         // print a message, this is just for testing purpose
         System.out.println(hue);
         System.out.println(sat);
         System.out.println(bri);
         // create a process and execute cmdArray and currect environment
         Process process = Runtime.getRuntime().exec(cmdArray);
  
}catch(IOException e){
}
finally{}


background(r,g,b); //make window background average color
}
