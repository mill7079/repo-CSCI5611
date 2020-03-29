public class User extends Agent {
  
  private Vector stats; // health, attack, defense
  private int level = 1;
  private int exp = 0;
  Vector vel;
  
  public User (Vector pos, float r, color c) {
    super(r,c);
    this.pos = pos;
    stats = new Vector(start_health, start_atk, start_def);
    vel = new Vector(0,0,0);
  }
  
  public int levelUp() {
    level++;
    
    stats.x += 10;
    stats.y += 5;
    stats.z += 3;
    
    return level;
  }
  
  public void update() {
    handleCollisions();
    pos = pos.add(vel.mult(dt));
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
  
  public void drawUser() {
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
  }
  
}
