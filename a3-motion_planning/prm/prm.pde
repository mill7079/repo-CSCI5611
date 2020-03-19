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

void setup() {
  cam = new Camera();
  agent = new Agent(0.5, color(90,205,90));
  obs = new Sphere(new Vector(0,0,0), color(50,100,255), 2);
  
  points = samplePoints();
  points.add(start);
  points.add(end);
  buildGraph(start);
  bfs(start, end);
  
  agent.createPath(end);
  
  size(600,600,P3D);
  background(255);
  
  validPath(start_pos, end_pos);
}

void draw() {
  background(255);
  cam.Update( 1.0/frameRate );
  
  drawBoard();
}

void drawBoard() {
  pushMatrix();
  pushStyle();
  //translate(-9,9,0);
  fill(125,125,125);
  box(board_size,board_size,0.00001);
  popStyle();
  popMatrix();
  
  //draw goal
  pushMatrix();
  pushStyle();
  translate(9,-9,0);
  noStroke();
  fill(220,90,90);
  sphere(0.3);
  popStyle();
  popMatrix();
  
  obs.draw_obs();
  
  agent.update();
  agent.drawAgent();
  
  // draw milestones and graph
  for (Point p : points) {
    strokeWeight(5);
    stroke(0);
    point(p.pos.x, p.pos.y, p.pos.z);
    
    
    // draw line to parent
    strokeWeight(1);
    if (p.parent != null) line(p.pos.x, p.pos.y, p.pos.z, p.parent.pos.x, p.parent.pos.y, p.parent.pos.z);
    
    // draw lines to children in different color
    stroke(129, 0, 129);
    for (Point n : p.neighbors) line(p.pos.x, p.pos.y, p.pos.z, n.pos.x, n.pos.y, n.pos.z);
    
    
    if (p.parent!=null && !validPath(p.parent.pos, p.pos)) {
      println("fuck this shit");
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
    
    // debug
    /*
    pushMatrix();
    translate(p.pos.x, p.pos.y, p.pos.z);
    sphere(board_size/5);
    popMatrix();
    */
  }
  
  // draw BFS path
  stroke(255,0,0);
  strokeWeight(3);
  Point mid = end;
  while (mid != start) {
    if (mid.parent != null) {
      Point par = mid.parent;
      line(mid.pos.x, mid.pos.y, mid.pos.z, par.pos.x, par.pos.y, par.pos.z);
      mid = par;
    }
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

// builds graph of neighbors - first called using root = start
void buildGraph(Point root) {
  //println("graph");
  
  // base case - end doesn't need neighbors
  // use == to check if same object
  if (root == end) return;
  //if (root.equals(end)) return; //<>//
  
  float n_rad = board_size/3.0;
  
  // if a point is close enough to the previous level and isn't the parent of that level it is a neighbor
  for (Point p : points) {
    // avoid adding self to neighbors
    if (p == root) continue;
    
    //if (p.pos.sub(root.pos).mag() <= n_rad && root.parent != null && !root.parent.equals(p)) {
    //if (p.pos.sub(root.pos).mag() <= n_rad && root.parent != p) { // without CCD
    if (p.pos.sub(root.pos).mag() <= n_rad && root.parent != p && ((validPath(root.pos,p.pos) || (validPath(p.pos,root.pos))))) { // with CCd
      //println("neighbor added");
      root.addNeighbor(p);
    }
  }
  
  // recursively find neighbors of all children
  for (Point p : root.neighbors) if (p.neighbors.size() == 0) buildGraph(p);
}

// implement BFS search
// returns null if goal not found
// path is backtraced through parent
Point bfs(Point root, Point goal) {
  ArrayList<Point> q = new ArrayList<Point>();
  root.discovered = true;
  q.add(root);
  
  while(q.size() > 0) {
    Point v = q.get(0);
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

boolean validPath(Vector a, Vector b) {
  Vector v = b.sub(a);
  v = v.normalize();
  //Vector v = a.sub(b).normalize();
  //Vector v = b.sub(a);
  
  Sphere o = null;
  if (obs instanceof Sphere) o = (Sphere)obs;
  //Vector toSphere = a.sub(obs.pos);
  Vector toSphere = obs.pos.sub(a);
  float A = 1;
  //float A = sq(b.x-a.x)+sq(b.y-a.y)+sq(b.z-a.z);
  //float B = v.mult(2).dot(a.sub(obs.pos));
  //float B = v.mult(2).dot(toSphere);
  float B = 2*v.dot(toSphere);
  //float B = 2*((b.x-a.x)*(a.x-obs.pos.x) + (b.y-a.y)*(a.y-obs.pos.y) + (b.z-a.z)*(a.z-obs.pos.z));
  //float C = sq((a.sub(obs.pos).mag())) - (o.c_rad*o.c_rad);
  float C = toSphere.dot(toSphere) - (o.c_rad*o.c_rad);
  //float C = sq(obs.pos.x) + sq(obs.pos.y) + sq(obs.pos.z) + sq(a.x) + sq(a.y) + sq(a.z) - 2*(obs.pos.x*a.x + obs.pos.y*a.y + obs.pos.z*a.z) - sq(o.c_rad);
  
  float det = (B*B) - (4*A*C);
  //println(det);
  // use discriminant to determine intersection
  //if (det >= 0 && det <= 1) {
  if (det >= 0) {
    println("invalid");
    return false;
  }
  return true;
}


void keyPressed() {
  cam.HandleKeyPressed();
}
void keyReleased() {
  cam.HandleKeyReleased();
}
