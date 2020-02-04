public class Vector{
  
  float x, y, z;
  public Vector(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  Vector add(Vector v1, Vector v2) {
    return new Vector(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
  }
  
  Vector mult(Vector v1, float s) {
    return new Vector(v1.x * s, v1.y * s, v1.z * s);
  }
  
  Vector div(Vector v1, float s) {
    return mult(v1, 1/s);
  }
  
  float dot(Vector v1, Vector v2) {
    return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z;
  }
  
  Vector cross(Vector v1, Vector v2) {
    return new Vector(v1.y*v2.z - v1.z*v2.y, v1.z*v2.x - v1.x*v2.z, v1.x*v2.y - v1.y*v2.x);
  }
  
  float mag() {
    return sqrt(x*x + y*y + z*z);
  }
  
}
