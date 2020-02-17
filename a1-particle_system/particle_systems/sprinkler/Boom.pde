public class Boom {
  
  Vector position;
  Vector vel;
  color col;
  float grav = 9.8, dt = 0.15;
  
  public Boom(Vector p, Vector fpos, color col) {
    position = p;
    this.vel = position.sub(fpos);
    this.col = col;
  }
  
  void update() {
    pushStyle();
    //stroke(255,0,0);
    stroke(col);
    /*if (col == color(129,0,129)) {
      strokeWeight(3);
    } else if (col == color(58, 166, 63)) {
      strokeWeight(2);
    } */
    color(col);
    point(position.x, position.y, position.z);
    popStyle();
    
    position = position.add(vel.mult(dt));
    //vel = vel.add(new Vector(0, grav, 0).mult(dt));
  }
}
