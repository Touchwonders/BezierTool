class ControlPoint{
  float x, y, radius;
  boolean drag;
  
  void setup(float _x, float _y, float _radius){
    radius  = _radius;
    x       = _x;
    y       = _y;
    drag    = false;
  }
  
  void draw(){
    stroke(80,150);
    fill(240, 240, 240);
    ellipse(x, y, radius, radius);
  }
  
  void setPosition(float _x, float _y){
//    if(_x > 0 && _x < width)
      x = _x;
//    if(_y > 0 && _y < height)
      y = _y;
  }
};
