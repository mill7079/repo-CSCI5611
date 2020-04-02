public class User extends Agent {
  
  Vector stats; // health, attack, defense
  private int level = 1;
  private int exp = 0;
  Vector vel;
  
  public User(Vector pos, float r) {
    super(r,color(0,start_health,0), new Point(pos), new Point(new Vector(0,0,0)));
    this.pos = pos;
    stats = new Vector(start_health, start_atk, start_def);
    vel = new Vector(0,0,0);
  }
  
  public int levelUp() {
    if (exp >= level*10) {
      level++;
      
      stats.x += 10;
      stats.y += 5;
      stats.z += 3;
      
      health += 10;
      exp = 0;
    }
    return level;
  }
  
  public void update() {
    handleCollisions();
    pos = pos.add(vel.mult(dt));
    
    for (Ammo s : shots) {
      s.update();
      Agent hit = s.checkHit();
      if (hit != null) {
        for (Agent a : agents) {
          if (a == hit) hit.damage();
        }
      }
    }
    for (int i = shots.size()-1; i >= 0; i--) {
      if (shots.get(i).isDead() || !goodPath(shots.get(i).prev_pos, shots.get(i).pos)) shots.remove(i);
    }
  }
  
  public boolean handleCollisions() {
    for (Obstacle o : obstacles) {
      Sphere s = (Sphere) o;
      if (rad + s.rad + 0.1 >= s.pos.sub(pos).mag()) {
        Vector normal = s.pos.sub(pos).mult(-1).normalize();
        pos = pos.add(normal.mult(0.1 + (s.rad + rad) - (s.pos.sub(pos).mag())));
        return true;
      }
    }
    return false;
    
  }
  
  public void drawAgent() {
    pushMatrix();
    pushStyle();
    translate(pos.x, pos.y, pos.z);
    noStroke();
    fill(col);
    sphere(rad);
    
    Vector dir = vel.mult(rad);
    translate(dir.x, dir.y, dir.z);
    fill(0);
    sphere(rad/3.0);
    popStyle();
    popMatrix();
    
    for (Ammo s : shots) s.drawAmmo();
  }
  
  public void fire() {
    shots.add(new Ammo(pos, vel));
  }
  
  public void gainExp() {
    exp += 10;
  }
  
}
