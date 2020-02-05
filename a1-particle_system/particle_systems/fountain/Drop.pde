public class Drop {
  
  Vector pos, vel, col;
  int life;
  float grav = 9.8;
  
  public Drop(float x, float y, float z) {
    pos = new Vector(x, y, z);
    vel = new Vector(0, 1, 0);
    //vel.add(new Vector(0.2*random(1), 0, 0.1*random(1)));
    vel = vel.add(new Vector(-25*random(0.9,1), -50, 0.5*random(1)));
    col = new Vector(0,0,255);
    life = 0;
  }
  
  boolean isDead() {
    return life >= 120;
  }
  
  void update() {
    stroke(0,0,255);
    //pos.add(vel.mult(vel,dt));
    pos = pos.add(vel.mult(dt));
    vel = vel.add(new Vector(0, grav, 0).mult(dt));
    //point(pos.x, pos.y - 5*life, pos.z);
    point(pos.x, pos.y, pos.z);
    life ++;
  }
}
