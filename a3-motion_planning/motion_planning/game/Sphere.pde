public class Sphere extends Obstacle {
  
  float rad;
  float c_rad;
  
  public Sphere(Vector p, color c, float r) {
    super(p, c);
    rad = r;
    c_rad = rad + a_rad;
  }
  
  public void draw_obs() {
    pushMatrix();
    pushStyle();
    noStroke();
    translate(pos.x, pos.y, pos.z);
    fill(col);
    sphere(rad);
    popStyle();
    popMatrix();
  }
  
  public boolean check_point(Point p) {
    if (pos.sub(p.pos).mag() <= c_rad) return false;
    else return true;
  }
  
  public boolean check_point(Vector p) {
    if (pos.sub(p).mag() <= c_rad) return false;
    else return true;
  }
  
}
