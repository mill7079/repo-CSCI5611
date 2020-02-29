public class HeatSource extends Sphere {
  
  ArrayList<Spark> fire;
  
  public HeatSource(Vector p, float r, Vector c) {
    super(p, r, c);
    fire = new ArrayList<Spark>();
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
    float[] pt_pos = rndSphere(10, y);
    fire.add(new Spark(new Vector(pos.x+pt_pos[0], pos.y+pt_pos[1], pos.z+pt_pos[2])));
  }
  
  void draw_shape() {
    super.draw_shape();
    
    generateParticles(0);
    
    for (Spark s : fire) {
      s.update();
    }
    
  }
  
  void clean() {
    for (int i = fire.size()-1; i >= 0; i--) {
      if (fire.get(i).isDead()) fire.remove(i);
    }
  }
  
}
