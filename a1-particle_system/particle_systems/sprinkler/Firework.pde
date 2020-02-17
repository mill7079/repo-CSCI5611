public class Firework {
  
  Vector pos, vel;
  color col;
  boolean stage = false; //false = rising
  ArrayList<Boom> particles = new ArrayList<Boom>();
  float sRad = 10;
  float layers = 100;
  int boomFrame;
  
  public Firework() {
    pos = genPos;
    vel = new Vector(0,25,0);
    col = color(0);
  }
  
  void update() {
    if (!stage) {
      pushMatrix();
      translate(pos.x, pos.y, pos.z);
      fill(col);
      sphere(sRad);
      
      popMatrix();
      
      pos = pos.add(new Vector(0,-10,0));
      println(genPos.sub(pos).y);
      if (genPos.sub(pos).y >= 400) { 
        println("boom");
        stage = true;
        genBoom();
        boomFrame = frameCount;
      }
    } else {
      for (Boom b : particles) {
         b.update(); 
      }
    }
  }
  
  // generates particles in sphere layers
  void genBoom() {
    float boomRad = 10; // r
    for (float i = layers; i >= 0; i--) {
      angle = 0;
      int c = 0;
      while (angle < 2*PI) {
        // gets dots in a circumference
        float r = boomRad * i / layers;
        float theta = angle;
        float x = r * sin(theta);
        float z = r * cos(theta);
        
        // form circumferi into sphere
        float yp = sqrt(sq(boomRad) - sq(x) - sq(z));
        float yn = -sqrt(sq(boomRad) - sq(x) - sq(z));
        
        color col;
        if (c == 0) {
          col = color(129, 0, 129);
        } else if (c == 1) {
          col = color(0);
        } else if (c == 2) {
          col = color(164);
        } else {
          col = color(58, 166, 63);
        }
        c = (c+1) % 4;
        particles.add(new Boom(pos.add(new Vector(x, yp, z)), pos,col));
        particles.add(new Boom(pos.add(new Vector(x, yn, z)), pos,col));
        
        angle += (PI/32);
      }
    }
  }
}
