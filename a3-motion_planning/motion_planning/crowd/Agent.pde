public class Agent {
  
  protected float rad;
  protected color col;
  protected Vector pos;
  protected ArrayList<Vector> path = new ArrayList<Vector>();
  
  protected int nextPoint = 1;
  //protected float pointRad = 0.000000000000001;
  protected float dt = 0.08;
  protected Vector curPath = new Vector(0,0,0);
  
  protected Point goal;
  protected Point origin;
 
  public Agent(float r, color c, Point o, Point g) {
    rad = r;
    col = c;
    //pos = start_pos;
    
    origin = o;
    goal = g;
    
    pos = origin.pos;
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
  
  /*
  // create path for agent to follow starting from end of path
  // (backtrace of parent nodes set with BFS)
  public void createPath(Point end) {
    if (start.equals(end)) return;
    Point e = end;
    Vector endPos = end.pos;
    while (endPos != start.pos) {
      path.add(0, endPos);
      e = e.parent;
      try {
        endPos = e.pos;
      } catch (Exception x) {
        println(x);
        return;
      }
    }
    path.add(0,endPos);
    
    curPath = path.get(1).sub(path.get(0));
  }
  */
  
  public void createPath() {
    if (origin.equals(goal)) return;
    Point e = goal;
    Vector endPos = goal.pos;
    while (endPos != origin.pos) {
      path.add(0, endPos);
      e = e.parent;
      try {
        endPos = e.pos;
      } catch (Exception x) {
        println("error in create path for agent with end",goal.pos,":",x);
        return;
      }
    }
    path.add(0,endPos);
    
    curPath = path.get(1).sub(path.get(0));
  }
  
  public void update() {
    if (nextPoint >= path.size()) return;
    
    //Sphere goalPoint = new Sphere(path.get(nextPoint), color(0), pointRad);
    //if (!goalPoint.check_point(new Point(pos))) { // agent ready to switch path parts
    //if (!goalPoint.check_point(new Point(pos)) && goalPoint.pos.sub(pos).mag() < curPath.normalize().mult(dt).mag()) { // agent ready to switch path parts
    if (path.get(nextPoint).sub(pos).mag() < curPath.normalize().mult(dt).mag()) { // agent ready to switch path parts
      //pos = goalPoint.pos;
      pos = path.get(nextPoint);
      nextPoint++;
      if (nextPoint >= path.size()) return;
      curPath = path.get(nextPoint).sub(path.get(nextPoint - 1));
    } else {
      //pos = pos.add(curPath.mult(dt));
      pos = pos.add(curPath.normalize().mult(dt));
    }
    
    // path smoothing
    if (nextPoint < path.size()-1 && goodPath(pos, path.get(nextPoint+1))) {
      nextPoint++;
      curPath = path.get(nextPoint).sub(pos);
    } 
    
    if (goodPath(pos,path.get(path.size()-1))) {
      nextPoint = path.size() - 1;
      curPath = path.get(nextPoint).sub(pos);
    }
  }
  
  public void reset(Point end) {
    nextPoint = 1;
    path = new ArrayList<Vector>();
    
    //createPath(end);
    createPath();
  }
  
}
