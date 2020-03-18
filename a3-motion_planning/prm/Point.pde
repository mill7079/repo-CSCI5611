public class Point {
  
  Vector pos;
  ArrayList<Point> neighbors;
  Point parent;
  
  public Point(Vector p) {
    pos = p;
    neighbors = new ArrayList<Point>();
    parent = null;
  }
  
  public void addNeighbor(Point p) {
    p.parent = this;
    neighbors.add(p);
  }
  
  public String toString() {
    return pos.toString();
  }
  
  public boolean equals(Point p) {
    return (pos.x-p.pos.x <= 0.001) && (pos.y-p.pos.y <= 0.001) && (pos.z-p.pos.z <= 0.001);
  }
}
