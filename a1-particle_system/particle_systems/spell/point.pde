public class Point {
  
  int trailCount = 1, maxTrails = 20, move = 50;
  int w = 1;
  float x, y, z = 0; // xpos, ypos, zpos
  
  int change = 1;
  float r, b, a; // alpha value for twinkle/death
  boolean idle;
  
  public Point(float x, float y, boolean i) {
    this.x = x;
    this.y = y;
    this.a = random(255);
    if (floor(a) % 15 == 0) {
      r = 50;
      b = 255;
    } else if (floor(a) % 20 == 0) {
      r = 255;
      b = 50;
    } else {
      r = 125;
      b = 240;
    }
    
    idle = i;
  }
  
  void update() {
    if (idle) {
      twinkle();
    } else {
      move(); 
    }
  }
  
  void move() {
    strokeWeight(w);
    point(x, y, z);
    z -= move;
    for (int i = 1; i < trailCount; i++) {
      stroke(125+i*4.5, i*10, 200+random(55), 256-(i*(256/(trailCount)))); // random adds a bit of sparkle, maybe
      strokeWeight(w*(0.1*(trailCount-i)));
      point(x, y, z+i*move*3);
    }
    if (trailCount < maxTrails) trailCount ++;
    if (z <= -3750) a -= 50; // TEMPORARY UNTIL SHIELD COLLISION
  }
  
  void twinkle() {
    a += change * 8.5;
    if (a >= 255) change = -1;
    strokeWeight(w);
    stroke(r, 0, b, a);
    point(x, y, z);
  }
  
  boolean isDead() {
    return a <= 0;
  }
  
}
