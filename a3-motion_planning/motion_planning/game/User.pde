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
    pos = pos.add(vel.mult(dt));
  }
  
  public void drawUser() {
    pushMatrix();
    pushStyle();
    translate(pos.x, pos.y, pos.z);
    noStroke();
    fill(col);
    sphere(rad);
    popStyle();
    popMatrix();
  }
  
}
