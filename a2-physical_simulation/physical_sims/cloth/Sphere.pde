public class Sphere extends Obstacle {
  
  float radius;
  
  public Sphere(Vector p, float rad, Vector c) {
    super(p, c);
    radius = rad;
  }
  
  void draw_shape() {
    pushMatrix();
    pushStyle();
    
    noStroke();
    fill(col.x, col.y, col.z);
    translate(pos.x, pos.y, pos.z);
    sphere(radius);
    
    popStyle();
    popMatrix();
  }
  
}
