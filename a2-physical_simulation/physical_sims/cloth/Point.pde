public class Point {
  
  Vector pos, vel, vn;
  
  ArrayList<Point> neighbors;
  
  public Point(Vector pos, Vector vel) {
    this.pos = pos;
    this.vel = vel;
    vn = vel;
    
    neighbors = new ArrayList<Point>();
  }
  
  String toString() {
    return pos.toString();
  }
    
  
}
