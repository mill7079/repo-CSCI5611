public class Point {
  
  Vector pos, vel, vn;
  
  public Point(Vector pos, Vector vel) {
    this.pos = pos;
    this.vel = vel;
    vn = vel;
  }
  
  String toString() {
    return pos.toString();
  }
    
  
}
