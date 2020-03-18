public abstract class Obstacle {
  
  Vector pos;
  color col;
  
  public Obstacle(Vector p, color c) {
    pos = p;
    col = c;
  }
  
  abstract void draw_obs();
  abstract boolean check_point(Vector p);
  
}
