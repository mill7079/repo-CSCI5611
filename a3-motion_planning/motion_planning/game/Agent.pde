public class Agent {
  
  private float rad;
  private color col;
  private Vector pos;
  private ArrayList<Vector> path = new ArrayList<Vector>();
  
  private int nextPoint = 1;
  private float pointRad = 0.000000000000001, dt = 0.08;
  private Vector curPath = new Vector(0,0,0);
 
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
  // (backtrace of parent nodes set with BFS)
  public void createPath(Point end) {
    Point e = end;
    Vector endPos = end.pos;
    //while (endPos != start_pos) {
    while (endPos != start.pos) {
      path.add(0, endPos);
      e = e.parent;
      //println("endPos:",endPos, "e:",e);
      endPos = e.pos;
    }
    path.add(0,endPos);
    //println(path);
    
    curPath = path.get(1).sub(path.get(0));
  }
  
  public void update() {
    if (nextPoint >= path.size()) return;
    Sphere goalPoint = new Sphere(path.get(nextPoint), color(0), pointRad);
    //if (!goalPoint.check_point(new Point(pos))) { // agent ready to switch path parts
    if (!goalPoint.check_point(new Point(pos)) && goalPoint.pos.sub(pos).mag() < curPath.normalize().mult(dt).mag()) { // agent ready to switch path parts
      pos = goalPoint.pos;
      nextPoint++;
      if (nextPoint >= path.size()) return;
      curPath = path.get(nextPoint).sub(path.get(nextPoint - 1));
    } else {
      //pos = pos.add(curPath.mult(dt));
      pos = pos.add(curPath.normalize().mult(dt));
    }
    
    
  }
  
  public void reset(Point end) {
    nextPoint = 1;
    path = new ArrayList<Vector>();
    
    createPath(end);
  }
  
}
