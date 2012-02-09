/**
*  BezierTool
*  Touchwonders
*  http://www.touchwonders.com
*  Use this tool to generate a line of code for creating a CAMediaTimingFunction to be used with CABasicAnimation or CAKeyframeAnimation.
*/

ControlPoint cp1;
ControlPoint cp2;
int graphWidth, graphHeight, offsetX, offsetY;
float normalizedX1, normalizedY1, normalizedX2, normalizedY2;
PFont font;
ClipHelper clipBoard = new ClipHelper();
  
void setup() {
  // setup window and background
  size(800, 800);
  frame.setTitle("Touchwonder BezierTool");
  smooth();
  background(255);

  // setup graph frame
  graphWidth = 500;
  graphHeight = 500;
  offsetX = 150;
  offsetY = 150;
  
  // load the font
  font = loadFont("Menlo-Regular-11.vlw"); 
  
  // setup the control points
  cp1 = new ControlPoint();
  cp2 = new ControlPoint();
  cp1.setup(offsetX + 125, offsetY + 50, 20);
  cp2.setup(offsetX + 375, offsetY + 450, 20);
}

void draw() {
  background(255); 
  
  // do not fill the following shapes
  noFill();
  
  // draw lines from controlpoints to (0,0) and (1,1)
  stroke(255, 102, 0, 130);
  line(offsetX, offsetY + graphHeight, cp1.x, cp1.y);
  line(offsetX + graphWidth, offsetY, cp2.x, cp2.y);
  
  // draw grid
  // draw rect around graph
  stroke(40);
  strokeWeight(2);
  rect(offsetX, offsetY, graphWidth, graphHeight);
  
  // horizontal
  stroke(100, 50);
  strokeWeight(1);
  int numberOfLines = 9;
  float lineSpacing = graphHeight / (float)(numberOfLines+1);
  for(int i = 1; i < numberOfLines + 1; i++){
    line(offsetX, offsetY + (lineSpacing * i), offsetX + graphWidth, offsetY + (lineSpacing * i));
  }
  
  // vertical
  stroke(100, 50);
  strokeWeight(1);
  lineSpacing = graphWidth / (float)(numberOfLines+1);
  for(int i = 1; i < numberOfLines + 1; i++){
    line(offsetX + (lineSpacing * i), offsetY, offsetX + (lineSpacing * i), offsetY + graphHeight);
  }
  
  // draw curve
  stroke(0, 0, 0);
  bezier(offsetX, offsetY + graphHeight, cp1.x, cp1.y, cp2.x, cp2.y, offsetX + graphWidth, offsetY);
  
  // draw cp's
  cp1.draw();
  cp2.draw();
  
  normalizedX1 = truncate((cp1.x - offsetX) / graphWidth);
  normalizedY1 = truncate(1.0 - ((cp1.y - offsetY) / graphHeight));
  normalizedX2 = truncate((cp2.x - offsetX) / graphWidth);
  normalizedY2 = truncate(1.0 - ((cp2.y - offsetY) / graphHeight));

  // draw text
  // header
  fill(0, 50, 50);
  textFont(font, 23);
  text("Touchwonders BezierTool", width/2 - 160, 40);
  textFont(font, 15);  
  text("http://www.touchwonders.com", width/2 - 125, 65);
  
  // legenda
  textFont(font, 11);
  text("c: copy to clipboard", width - 200, height - 40);
  text("r: reset controlpoints", width - 200, height - 20);
  
  // current data
  text("functionWithControlPoints:" + normalizedX1 +" :" + normalizedY1 +" :" + normalizedX2 +" :" + normalizedY2, 10, height-20);
}


void mousePressed(){
  // check if we're inside controlpoint 1
  float distToFirst = dist(mouseX, mouseY, cp1.x, cp1.y);
  if(distToFirst < cp1.radius){
    cp1.drag = true;
    return;
  }
  // check if we're inside controlpoint 2
  float distToSecond = dist(mouseX, mouseY, cp2.x, cp2.y);
  if(distToSecond < cp2.radius){
    cp2.drag = true;
    return;
  }
  
  // we're not inside controlpoint 1 or 2, drag the closest one (this comes in handy when a control point is outside of the screen)  
  if(distToFirst < distToSecond)
    cp1.drag = true;
  else
    cp2.drag = true;
}

void mouseDragged(){  
  // update the position of the controlpoint being dragged
  if(cp1.drag == true){
    cp1.setPosition(mouseX, mouseY);
  }
  if(cp2.drag == true){
    cp2.setPosition(mouseX, mouseY);
  }
}

void mouseReleased(){
  // stop dragging any controlpoint
  cp1.drag = false;
  cp2.drag = false;
}

float truncate(float x){
  // truncate a float to have <= 2 decimals
 if ( x > 0 )
   return float(floor(x * 100))/100;
 else
   return float(ceil(x * 100))/100;
}

void keyPressed(){
  // key handling
  switch(key){
    case 'r':  // reset
      cp1.setup(offsetX + 125, offsetY + 50, 20);
      cp2.setup(offsetX + 375, offsetY + 450, 20);
      break;
    case 'c':  // copy the method call to the clipboard 
      clipBoard.copyString("[CAMediaTimingFunction functionWithControlPoints:" + normalizedX1 +" :" + normalizedY1 +" :" + normalizedX2 +" :" + normalizedY2 +"];");
      break;
  }
}
