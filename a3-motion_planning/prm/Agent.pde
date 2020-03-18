public class Agent {
  
  private float rad;
  private color col;
  private Vector pos;
  private ArrayList<Vector> path = new ArrayList<Vector>();
 
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
  
  // create path for agent to follow starting from end of path
  public void createPath(Point end) {
    Point e = end;
    Vector endPos = end.pos;
    while (endPos != start_pos) {
      path.add(0, endPos);
      e = e.parent;
      endPos = e.pos;
    }
    path.add(0,endPos);
    println(path);
  }
  
  public void update() {
    
  }
  
}
