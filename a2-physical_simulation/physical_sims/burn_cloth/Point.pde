public class Point {
  
  Vector pos, vel, vn;
  
  ArrayList<Point> neighbors;
  ArrayList<Spark> fire;
  int frames;
  boolean burning = false;
  
  public Point(Vector pos, Vector vel) {
    this.pos = pos;
    this.vel = vel;
    vn = vel;
    frames = 0;
    
    neighbors = new ArrayList<Point>();
    fire = new ArrayList<Spark>();
  }
  
  String toString() {
    return pos.toString();
  }
    
  float[] rndSphere(float rad, float y) {
    // sample disk
    float r = rad*sqrt(random(1));
    float theta = 2*PI*random(1);
    float[] xz = new float[]{r*sin(theta), r*cos(theta)};
    
    // extrude y
    int sign = 1;
    if (random(1)%2 == 0) sign = -1;
    return new float[]{xz[0], y + sign*sqrt(rad*rad - xz[0]*xz[0] - xz[1]*xz[1]), xz[1]};
  }
  
  void generateParticles(float y) {
    for (int i = 0; i < numParticles; i++) {
      float[] pt_pos = rndSphere(10, y);
      fire.add(new Spark(new Vector(pos.x+pt_pos[0], pos.y+pt_pos[1], pos.z+pt_pos[2])));
    }
  }
  
  void clean() {
    for (int i = fire.size()-1; i >= 0; i--) {
      if (fire.get(i).isDead()) fire.remove(i);
    }
  }
  
}
