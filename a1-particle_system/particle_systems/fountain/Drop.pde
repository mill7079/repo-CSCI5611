public class Drop {
  
  Vector pos, vel, col;
  int life, maxLife = 240;
  float grav = 9.8;
  
  boolean splash = false;
  
  public Drop(float x, float y, float z) {
    pos = new Vector(x, y, z);
    vel = new Vector(0, 1, 0);
    //vel.add(new Vector(0.2*random(1), 0, 0.1*random(1)));
    vel = vel.add(new Vector(-25*random(0.9,1), -50, 0.5*random(1)));
    //col = new Vector(0,0,230+random(25));
    col = new Vector(100,125,200 + random(55));
    life = 0;
  }
  
  boolean isDead() {
    return life >= maxLife;
  }
  
  void update() {
    stroke(col.x, col.y, col.z);
    point(pos.x, pos.y, pos.z);
    
    pos = pos.add(vel.mult(dt));
    vel = vel.add(new Vector(0, grav, 0).mult(dt));
    
    if (pos.y >= waterbox[1]+wDiff || pos.y >= waterbox[1]-wDiff) {
      if (pos.x >= waterbox[0]-wDiff && 
          pos.x <= waterbox[0]+wDiff && 
          pos.z >= waterbox[2]-wDiff &&
          pos.z <= waterbox[2]+wDiff) {
            pos.y = waterbox[1]-1.01*wDiff;
            vel = vel.mult(0.25);
            vel.y *= -1;
            splash = true;
      }
    }
    //point(pos.x, pos.y - 5*life, pos.z);
    life ++;
  }
}
