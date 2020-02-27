public abstract class Obstacle {
  
  Vector pos, col; // position and color
  
  public Obstacle(Vector p, Vector c) {
    pos = p;
    col = c;
  }
  
  abstract void draw_shape();
  void move_shape(Vector new_pos) { // user input, click to move? activate move with mouse movement? idk
    pos = new_pos;
  }
  
  // was planning on supporting more than just spheres but I ran out of time
}
