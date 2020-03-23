Camera cam;
Agent agent;
Obstacle obs;

Vector start_pos = new Vector(-9, 9, 0);
Point start = new Point(start_pos);
Vector end_pos = new Vector(9, -9, 0);
Point end = new Point(end_pos);

ArrayList<Point> points;

int num_points = 50;
int board_size = 20;

int rcount = 0;

void setup() {
  cam = new Camera();
  agent = new Agent(0.5, color(168, 212, 122));
  obs = new Sphere(new Vector(0,0,0), color(50,100,255), 2);
  
  points = samplePoints();
  points.add(start);
  points.add(end);
  //buildGraph(start);
  buildGraph();
  //bfs(start, end);
  ucs(start, end);
  
  agent.createPath(end);
  
  size(600,600,P3D);
  background(255);
}

void draw() {
  background(255);
  cam.Update( 1.0/frameRate );
  
  drawBoard();
  
  agent.update();
  agent.drawAgent();
  
  drawGraph();
}

void drawBoard() {
  pushMatrix();
  pushStyle();
  stroke(0);
  strokeWeight(6);
  fill(125,125,125);
  box(board_size,board_size,0.00001);
  popStyle();
  popMatrix();
  
  // draw start/goal
  pushStyle();
  noStroke();
  
  //start
  pushMatrix();
  fill(90,220,90);
  translate(start_pos.x,start_pos.y,start_pos.z);
  sphere(0.3);
  popMatrix();
  
  // goal
  pushMatrix();
  fill(220,90,90);
  translate(end_pos.x,end_pos.y,end_pos.z);
  sphere(0.3);
  popMatrix();
  
  popStyle();
  
  obs.draw_obs();
}

void drawGraph() {
  // draw milestones and graph1
  for (Point p : points) {
    strokeWeight(5);
    stroke(0);
    point(p.pos.x, p.pos.y, p.pos.z);
    
    // draw lines to children in different color
    stroke(129, 0, 129);
    strokeWeight(1);
    for (Point n : p.neighbors) line(p.pos.x, p.pos.y, p.pos.z, n.pos.x, n.pos.y, n.pos.z);
    
    // debugging CCD - draw white line for invalid path
    /*
    if (p.parent!=null && !validPath(p.parent.pos, p.pos)) {
      println(p.parent.pos);
      println(p.pos);
      strokeWeight(6);
      stroke(255);
      line(p.pos.x, p.pos.y, p.pos.z, p.parent.pos.x, p.parent.pos.y, p.parent.pos.z);
      strokeWeight(10);
      stroke(0,255,0);
      point(p.parent.pos.x, p.parent.pos.y, p.parent.pos.z);
      stroke(0,0,255);
      point(p.pos.x, p.pos.y, p.pos.z);
    }
    */
    
    // debugging graph build - draw sphere for neighbor range
    /*
    pushMatrix();
    translate(p.pos.x, p.pos.y, p.pos.z);
    sphere(board_size/5);
    popMatrix();
    */
  }
  
  // draw BFS path
  stroke(58, 166, 63);
  strokeWeight(3);
  Point mid = end;
  while (mid != start && mid.parent != null) {
    Point par = mid.parent;
    line(mid.pos.x, mid.pos.y, mid.pos.z, par.pos.x, par.pos.y, par.pos.z);
    mid = par;
  }
}

ArrayList<Point> samplePoints() {
  ArrayList<Point> points = new ArrayList<Point>();
  
  while(points.size() < num_points) {
    Point point = new Point(new Vector(random(-9.5,9.5), random(-9.5,9.5), 0));
    if (!points.contains(point) && obs.check_point(point)) points.add(point);
  }
  
  return points;
}

void buildGraph() {
  for (Point cur : points) {
    float n_rad = board_size/3.0;
  
    // if a point is close enough to the previous level it is a neighbor
    for (Point p : points) {
      // avoid adding self to neighbors
      if (p == cur) continue;
      
      //if (p.pos.sub(cur.pos).mag() <= n_rad && ((validPath(cur.pos,p.pos) || (validPath(p.pos,cur.pos))))) { // with CCD
      if (p.pos.sub(cur.pos).mag() <= n_rad && goodPath(cur.pos,p.pos)) {
        cur.addNeighbor(p);
      }
    }
  }
}

// implement BFS search
// returns null if goal not found
// path is backtraced through parent in Agent.createPath
Point bfs(Point root, Point goal) {
  ArrayList<Point> q = new ArrayList<Point>();
  root.discovered = true;
  q.add(root);
  
  while(q.size() > 0) {
    Point v = q.get(0);
    //println("v:",v);
    q.remove(0);
    
    //if (v == end) return v;
    if (v == goal) return v;
    
    for(Point p : v.neighbors) {
      if (!p.discovered) {
        p.discovered = true;
        p.parent = v;
        q.add(p);
      }
    }
  }
  
  return null;
}

// uniform cost search - returns null if no path is found
Point ucs(Point root, Point goal) {
  Point node = null;
  PriorityQueue<Point> frontier = new PriorityQueue<Point>();
  frontier.push(root, 0);
  //.Point prev;
  while(frontier.size() > 0) {
    //.prev = node;
    PriorityQueue.Node temp = frontier.pop();
    node = (Point)temp.k;
    float curr_cost = temp.v;
    //.node.parent = prev;
    
    if (node == goal) return goal;
    
    node.discovered = true;
    for(Point n : node.neighbors) {
      float cost = n.pos.sub(node.pos).mag();
      if (!n.discovered && !frontier.contains(n)) {
        frontier.push(n, curr_cost + cost);
        n.parent = node;
      } else if (frontier.contains(n) && !n.discovered){
        frontier.updateCost(n, curr_cost + cost, node);
        //n.parent = node;
      }
    }
  }
  
  return null;
}

/*
// check if path between vectors intersects the obstacle
boolean validPath(Vector a, Vector b) {
  Vector v = b.sub(a);
  v = v.normalize();
  
  Sphere o = null;
  if (obs instanceof Sphere) o = (Sphere)obs;
  
  Vector toSphere = obs.pos.sub(a);
  float A = 1;
  float B = 2*v.dot(toSphere);
  float C = toSphere.dot(toSphere) - (o.c_rad*o.c_rad);
  
  float det = (B*B) - (4*A*C);
  
  // use discriminant to determine intersection
  if (det >= 0) {
    return false;
  }
  return true;
}
*/

//ccd but working
boolean goodPath(Vector start, Vector end) {
  Vector v = end.sub(start).normalize();
  
  Sphere o = null;
  if (obs instanceof Sphere) o = (Sphere)obs;
  Vector w = o.pos.sub(start);
  
  float a = 1;
  float b = -2*v.dot(w);
  float c = w.dot(w) - sq(o.c_rad);
  
  float d = (b*b) - (4*a*c); // discriminant
  
  if (d >= 0) {
    float t = (-b - sqrt(d))/(2*a);
    if (t > 0 && t < end.sub(start).mag()) {
      return false;
    }
  }
  
  return true;
}

void clear() {
  points = new ArrayList<Point>();
}


void keyPressed() {
  cam.HandleKeyPressed();
}
void keyReleased() {
  cam.HandleKeyReleased();
}

void mouseClicked() {
  //println("mouse clicked");
  Vector mouse = new Vector(mouseX, mouseY, 0);
  if (!obs.check_point(new Point(mouse))) return;
  clear();
  
  //float boardX = (mouseX/width) * (board_size) - board_size/2;
  //float boardY = (mouseY/height) * (board_size) - board_size/2;
  float boardX = -(board_size/2.0) + board_size * (mouseX/((float)(width-1)));
  float boardY = -(board_size/2.0) + board_size * (mouseY/((float)(height-1)));
  Vector board = new Vector(boardX, boardY, 0);
  println("mouse:",mouse,"board:",board);
  
  end_pos = board;
  start_pos = agent.pos;
  start = new Point(start_pos);
  end = new Point(end_pos);
  //start.pos = agent.pos;
  //end.pos = mouse;
  
  points = samplePoints();
  points.add(start);
  points.add(end);
  
  //buildGraph(start);
  buildGraph();
  //println(bfs(start, end));
  println(ucs(start,end));
  
  agent.reset(end);
  //agent.createPath(end);
  
}
