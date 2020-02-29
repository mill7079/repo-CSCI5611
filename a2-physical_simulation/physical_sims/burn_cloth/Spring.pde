public class Spring {
  
  Point a, b;
  
  public Spring(Point a, Point b) {
    this.a = a;
    this.b = b;
  }
  
  boolean equals(Spring other) {
    return a.equals(other.a) && b.equals(other.b);
  }
  
}
