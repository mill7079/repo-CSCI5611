public class Ammo {
  
  Vector pos;
  Vector dir;
  float dt = 0.08;
  float frame;
  public Ammo(Vector pos, Vector dir) {
    this.dir = dir;
    this.pos = pos;
    frame = frameCount;
  }
  
  void update() {
    pos = pos.add(dir.normalize().mult(10*dt));
  }
  
  void drawAmmo() {
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    fill(0);
    sphere(0.1);
    popMatrix();
  }
  
  boolean isDead() {
    return ((frameCount - frame) > 60);
  }
  
  Agent checkHit() {
    Vector prev_pos = pos.sub(dir.normalize().mult(10*dt));
    Vector v = pos.sub(prev_pos).normalize();
    
    for (Agent ag : agents) {
      //if (ag == user) continue;
      Vector w = ag.pos.sub(pos);
      
      float a = 1;
      float b = -2*v.dot(w);
      float c = w.dot(w) - sq(a_rad);
      
      float d = (b*b) - (4*a*c); // discriminant
      
      if (d >= 0) {
        float t = (-b - sqrt(d))/(2*a);
        if (t > 0 && t < prev_pos.sub(pos).mag()) {
          return ag;
        }
      }
    }
    
    return null;
  }
}
