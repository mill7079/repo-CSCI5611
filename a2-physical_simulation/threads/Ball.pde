public class Ball {
  Vector pos;
  Vector vel = new Vector(0,0,0);
  float accel;
  
  float rad = 1, mass = 30;
  
  int index; // unsure if i need this anymore
  
  float projVel = 0;
  
  public Ball(float x, float y, float z, int i) {
    pos = new Vector(x,y,z);
    index = i;
  }
  
  // draw spring from other ball to current ball (plus the ball itself)
  void drawFrom(Ball other) {
    //println(pos);
    pushMatrix();
    
    if (other == null) { // first ball case
      line(initX, 0, 0, pos.x, pos.y, pos.z);
    } else {
      Vector oPos = other.pos;
      line(oPos.x, oPos.y, oPos.z, pos.x, pos.y, pos.z);
    }
    
    translate(pos.x, pos.y, pos.z);
    sphere(rad);
    
    popMatrix();
  }
  
  void update(float xforce1, float yforce1, float xforce2, float yforce2) {
    //println("vel x before: " + vel.x);
    println("xforce1: " + xforce1 + " xforce2: "+xforce2);
    vel.x += ((xforce1 / mass) - (xforce2 / mass)) * dt;
    vel.y += (gravity + ((yforce1 / mass) - (yforce2 / mass))) * dt;
    //println("vel x after: " + vel.x);
    
    pos.x += (vel.x * dt);
    pos.y += (vel.y * dt);
  }

}
