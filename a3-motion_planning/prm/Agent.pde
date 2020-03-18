public class Agent {
  
  private float rad;
  private color col;
  private Vector pos;
 
  public Agent(float r, color c) {
    rad = r;
    col = c;
    pos = start_pos;
  }
  
  public void drawAgent() {
    pushMatrix();
    pushStyle();
    translate(pos.x, pos.y, pos.z);
    noStroke();
    fill(col);
    sphere(rad);
    popStyle();
    popMatrix();
  }
  
  public void update() {
    println("update");
  }
  
}
