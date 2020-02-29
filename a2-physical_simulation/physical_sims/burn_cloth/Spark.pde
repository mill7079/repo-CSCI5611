public class Spark {
  
  Vector pos, col, vel;
  
  Vector end_col;
  
  int life, maxLife;
  
  public Spark(Vector pos) {
    this.pos = pos;
    col = new Vector(255, 235, 0);
    end_col = new Vector(150,0,0);
    vel = new Vector(random(-3,3),-1000,random(-3,3));
    
    life = 0;
    maxLife = 50;
  }
  
  boolean isDead() {
    return life + random(5) >= maxLife + random(10);
  }
  
  void update() {
    pushStyle();
    stroke(col.x, col.y, col.z);
    strokeWeight(random(6));
    point(pos.x, pos.y, pos.z);
    popStyle();
    
    pos = pos.add(vel.mult(dt));
    vel.x *= 0.5;
    vel.z *= 0.5;
    //vel = vel.add(new Vector(0, grav, 0).mult(dt));
    
    life ++;
    updateColor();
  }
  
  void updateColor() {
    col.x -= 0.5;
    col.y -= 6;
    
    if (col.y < 50) col.x -= 8;
  }
  
}
