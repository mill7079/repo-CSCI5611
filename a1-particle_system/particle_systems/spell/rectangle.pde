public class Rectangle {
  
  float x, y, w, h, z = 0;
  int trailCount = 1;
  int move = 5;
  
  public Rectangle(float x, float y, float w, float h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void update() {
    pushMatrix();
    noStroke();
    z -= move;
    //x += move;
    for (int i = 1; i <= trailCount; i++) {
      pushMatrix();
      fill(0, 255, 0, 256-(i*(256/(trailCount))));
      translate(x, y, z+i*move*3);
      //translate(x-i*move*3, y, z);
      box(w*(0.1*(trailCount-i)));
      popMatrix();
    }
    println("");
    translate(x, y, z);
    box(w);
    if (trailCount < 9) trailCount ++;
    popMatrix();
  }
  
}
