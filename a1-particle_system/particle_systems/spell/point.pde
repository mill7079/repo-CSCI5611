public class Point {
  
  int trailCount = 1, maxTrails = 20, move = 5;
  int w = 5;
  float x, y, z=0;
  
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void update() {
    //pushMatrix();
    z -= move;
    //x += move;
    for (int i = 1; i <= trailCount; i++) {
      //pushMatrix();
      //stroke(0, 255, 0, 256-(i*(256/(trailCount))));
      //stroke(0+i*10, 255-(i*(256/(trailCount))), 0, 256-(i*(256/(trailCount))));
      //stroke(125+i*4.5, i*10, 245, 256-(i*(256/(trailCount))));
      stroke(125+i*4.5, i*10, 200+random(55), 256-(i*(256/(trailCount)))); // random adds a bit of sparkle, maybe
      //translate(x, y, z+i*move*3);
      //translate(x-i*move*3, y, z);
      strokeWeight(w*(0.1*(trailCount-i)));
      point(x, y, z+i*move*3);
      //popMatrix();
    }
    //println("");
    //translate(x, y, z);
    strokeWeight(w);
    point(x, y, z);
    if (trailCount < maxTrails) trailCount ++;
    //popMatrix();
  }
  
}
