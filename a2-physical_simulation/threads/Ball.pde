public class Ball {
  Vector pos;
  Vector vel = new Vector(0,0,0);
  float accel;
  
  float rad = 1, mass = 30;
  
  int index; // unsure if i need this anymore
  
  public Ball(float x, float y, float z, int i) {
    pos = new Vector(x,y,z);
    index = i;
  }
  
  // draw spring from other ball to current ball (plus the ball itself)
  void drawFrom(Ball other) {
    pushMatrix();
    
    if (other == null) { // first ball case
      line(initY, 0, 0, pos.x, pos.y, pos.z);
    } else {
      Vector oPos = other.pos;
      line(oPos.x, oPos.y, oPos.z, pos.x, pos.y, pos.z);
    }
    
    translate(pos.x, pos.y, pos.z);
    sphere(rad);
    
    popMatrix();
  }
  
  void update(float force1, float force2) {
    accel = gravity + .5*force1/mass - .5*force2/mass; 
    vel.y += accel*dt;
    pos.y += vel.y*dt;
  }

}
