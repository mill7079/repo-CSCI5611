public class Rectangle {
  
  float x, y, w, h, z = 0;
  
  public Rectangle(float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void update() {
    pushMatrix();
    translate(x, y, z);
    z -= 10;
    box(w, h, w);
    popMatrix();
  }
  
}
