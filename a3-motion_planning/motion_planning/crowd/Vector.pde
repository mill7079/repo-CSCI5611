public class Vector{
  
  float x, y, z;
  public Vector(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  Vector add(Vector v) {
    return new Vector(this.x + v.x, this.y + v.y, this.z + v.z);
  }
  
  Vector sub(Vector v) {
    return new Vector(this.x - v.x, this.y - v.y, this.z - v.z);
  }
  
  Vector mult(float s) {
    return new Vector(x * s, y * s, z * s);
  }
  
  Vector div(float s) {
    return mult(1/s);
  }
  
  float dot(Vector other) {
    return x*other.x + y*other.y + z*other.z;
  }
  
  Vector cross(Vector v) {
    return new Vector(y*v.z - z*v.y, z*v.x - x*v.z, x*v.y - y*v.x);
  }
  
  float mag() {
    return sqrt(this.dot(this));
  }
  
  Vector normalize() {
    float m = this.mag();
    if (m > 0) return new Vector(x/m, y/m, z/m);
    return this;
  }
  
  String toString() {
    return "x: " + x + " y: " + y + " z: " + z;
  }
  
  boolean closeTo(Vector other) {
    return (abs(x-other.x) <= 0.04) && (abs(y-other.y) <= 0.04) && (abs(z-other.z) <= 0.04);
  }
}
