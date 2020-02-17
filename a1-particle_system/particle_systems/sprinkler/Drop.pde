public class Drop {
  
  Vector pos, vel, col;
  int life, maxLife = 120;
  float grav = 9.8*4;
  
  public Drop(Vector pos, Vector vel_) {
    this.pos = pos;
    //vel = new Vector(0, 1, 0);
    vel = vel_;
    //vel = vel.add(new Vector(-50*random(0.9,1), -25*random(0.8,1), random(5)));
    vel = vel.mult(-random(20,50));    
    vel = vel.add(new Vector(random(1), 0, random(1)));
    col = new Vector(100,125,255);
    life = 0;
  }
  
  boolean isDead() {
    return life >= maxLife;
  }
  
  void update() {
    stroke(col.x, col.y, col.z);
    point(pos.x, pos.y, pos.z);
    
    //pos.add(vel.mult(vel,dt));
    pos = pos.add(vel.mult(dt));
    vel = vel.add(new Vector(0, grav, 0).mult(dt));
    
    if (pos.y <= genPos.y) {
      vel.y *= -0.4;
    }
    
    vel.add(new Vector(-1,-1,-1));
    
    //point(pos.x, pos.y - 5*life, pos.z);
    life ++;
  }
}
