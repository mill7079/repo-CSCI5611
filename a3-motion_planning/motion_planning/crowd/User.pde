public class User extends Agent {
  
  Vector vel;
  
  public User(Vector pos, float r) {
    super(r,color(0,100,0), new Point(pos), new Point(new Vector(0,0,0)));
    this.pos = pos;
    vel = new Vector(0,0,0);
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
  }
  
}
