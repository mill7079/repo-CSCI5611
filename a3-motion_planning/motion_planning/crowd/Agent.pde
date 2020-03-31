public class Agent {
  
  protected float rad;
  protected color col;
  protected Vector pos;
  protected ArrayList<Vector> path = new ArrayList<Vector>();
  
  protected int nextPoint = 1;
  protected float dt = 0.058;
  protected Vector curPath = new Vector(0,0,0);
  protected float sep_force = 4, obs_sep_force = 1.1;
  
  protected Point goal;
  protected Point origin;
  
  Vector old_pos;
  int stuck = 0;
 
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
  /*
  public void update() {
    if (nextPoint >= path.size()) return;
    
    // apply boids separation force
    Vector push = new Vector(0,0,0);
    for (Agent a : agents) {
      if (this == a) continue;
      float overlap = near(a);
      push = push.add(pos.sub(a.pos).normalize().mult(overlap)).mult(dt);
    }
    
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
      pos = pos.add(curPath.normalize().mult(dt)).add(push);
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
  */
  
  public void update() {
    old_pos = pos;
    // check for forces from other things
    // find the furthest point on path to walk to from current position
    
    // apply boids separation force
    Vector push = new Vector(0,0,0);
    int count = 0;
    for (Agent a : agents) {
      if (this == a) continue;
      float overlap = near(a);
      if (overlap > 0) {
        push = push.add(pos.sub(a.pos).normalize().mult(overlap*(sep_force/2)));
        count++;
      }
    }
    
    for (Obstacle o : obstacles) {
      float overlap = near(o);
      if (overlap > 0) {
        push = push.add(pos.sub(o.pos).normalize().mult(overlap*(obs_sep_force/2)));
        count++;
      }
    }
    
    if (count > 0) pos = pos.add(push.div(count).mult(dt));
    
    for (int i = path.size() - 1; i >= 0; i--) {
      /*
      for (Obstacle o : obstacles) {
        Sphere s = (Sphere) o;
        if (!s.check_point(pos)) {
          println("yikes case");
          pos = pos.add(s.pos.mult(s.c_rad - (s.pos.sub(pos).mag())));
        }
      }
      */
      for (Obstacle o : obstacles) {
        Sphere s = (Sphere) o;
        if (rad + s.rad + 0.1 >= s.pos.sub(pos).mag()) {
          Vector normal = s.pos.sub(pos).mult(-1).normalize();
          pos = pos.add(normal.mult(0.1 + (s.rad + rad) - (s.pos.sub(pos).mag())));
        }
      }
      
      for (Agent a : agents) {
        if (this == a) continue;
        if (rad + a.rad + 0.05 >= a.pos.sub(pos).mag()) {
          Vector normal = a.pos.sub(pos).mult(-1).normalize();
          pos = pos.add(normal.mult(0.05 + (a.rad + rad) - (a.pos.sub(pos).mag())));
        }
      }
      
      if (goodPath(pos, path.get(i))) {
        pos = pos.add(path.get(i).sub(pos).normalize().mult(dt));
        break;
      }
    }
    /*
    if (pos.closeTo(old_pos)) {
      //stuck++;
      //println("stuck");
    }
    else stuck = 0;
    if (stuck >= 10) {
      stuck = 0;
      updateGraph(this.goal.pos, this);
    }*/
    //println(stuck);
  }
  
  public void reset() {
    nextPoint = 1;
    path = new ArrayList<Vector>();
  }
  
  public float near(Agent agent) {
    float sep_rad = sep_force*agent.rad;
    if (rad + sep_rad > agent.pos.sub(pos).mag()) {
      return ((rad+sep_rad) - agent.pos.sub(pos).mag())/2.0;
    } else return -1;
  }
  
  public float near(Obstacle obs) {
    Sphere s = (Sphere) obs;
    float sep_rad = obs_sep_force*s.rad;
    if (rad + sep_rad > s.pos.sub(pos).mag()) {
      return ((rad+sep_rad) - s.pos.sub(pos).mag())/2.0;
    } else return -1;
  }
}
