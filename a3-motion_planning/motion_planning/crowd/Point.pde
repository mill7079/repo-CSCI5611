public class Point {
  
  Vector pos;
  ArrayList<Point> neighbors;
  Point parent;
  boolean discovered = false;
  
  public Point(Vector p) {
    pos = p;
    neighbors = new ArrayList<Point>();
    parent = null;
  }
  
  public void addNeighbor(Point p) {
    neighbors.add(p);
  }
  
  public String toString() {
    return pos.toString();
  }
  
  public boolean equals(Point p) {
    return (abs(pos.x-p.pos.x) <= 0.001) && (abs(pos.y-p.pos.y) <= 0.001) && (abs(pos.z-p.pos.z) <= 0.001);
  }
}
