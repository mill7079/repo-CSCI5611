Camera cam;
Agent agent;
//Obstacle obs;

User user;
int start_health = 100, start_atk = 10, start_def = 5;
boolean user_moved = false;

Vector start_pos = new Vector(-9, 9, 0);
Point start = new Point(start_pos);
Vector end_pos = new Vector(9, -9, 0);
Point end = new Point(end_pos);

ArrayList<Point> points;
ArrayList<Obstacle> obstacles;

int num_points = 500;
int board_size = 20;
float n_rad = board_size/3.0;

//int rcount = 0;

void setup() {
  cam = new Camera();
  cam.position = new PVector( 0, 0, 30 );
  agent = new Agent(0.5, color(168, 212, 122));
  user = new User(new Vector(-8,-8,0),0.5,color(0));
  
  //obs = new Sphere(new Vector(0,0,0), color(50,100,255), 2);
  obstacles = new ArrayList<Obstacle>();
  obstacles.add(new Sphere(new Vector(0,0,0), color(50,100,255), 2));
  obstacles.add(new Sphere(new Vector(2,2,0), color(255,100,50), 1));
  obstacles.add(new Sphere(new Vector(-4,5,0), color(125, 125, 12), 1.25));
  
  points = samplePoints();
  points.add(start);
  points.add(end);
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
  
  // draw mouse - debugging
  Vector mouse = new Vector(mouseX, mouseY, 0);
  //if (mouse.x < 20) mouse.x = 20;
  if (mouse.x > 500) mouse.x = 500;
  
  //if (mouse.y < 20) mouse.y = 20;
  else if (mouse.y > 500) mouse.y = 500;
  
  float boardX = -(board_size/2.0) + board_size * (mouse.x/(500.0));
  float boardY = -(board_size/2.0) + board_size * (mouse.y/(500.0));
  
  pushMatrix();
  translate(boardX, boardY, mouse.z);
  sphere(1);
  popMatrix();
  
  user.update();
  user.drawUser();
  
  if (frameCount % 10 == 0) changeBoard(user.pos);
}

void drawBoard() {
  //draw board
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
  
  //obs.draw_obs();
  for (Obstacle o : obstacles) o.draw_obs();
}

void drawGraph() {
  // draw milestones and graph
  for (Point p : points) {
    strokeWeight(5);
    stroke(0);
    point(p.pos.x, p.pos.y, p.pos.z);
    
    // draw lines to neighbors in different color
    stroke(129, 0, 129);
    strokeWeight(1);
    for (Point n : p.neighbors) line(p.pos.x, p.pos.y, p.pos.z, n.pos.x, n.pos.y, n.pos.z);  
    
  }
  
  // draw path
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
    //Point point = new Point(new Vector(random(-9.5,9.5), random(-9.5,9.5), 0));
    Point point = new Point(new Vector(random(-board_size/2, board_size/2), random(-board_size/2, board_size/2), 0));
    //if (!points.contains(point) && obs.check_point(point)) points.add(point);
    boolean valid = true;
    for (Obstacle o : obstacles) {
      //if (points.contains(point) || !o.check_point(point)) valid = false;
      if (!o.check_point(point)) {
        //println("here we be");
        Vector v = point.pos.sub(o.pos).mult(2);
        v.normalize().mult(((Sphere)o).c_rad * 1.1);
        //println(point.pos);
        v = o.pos.add(v);
        //println(v);
        point.pos = v;
        //println(point.pos);
        for (Obstacle check : obstacles) {
          if (!check.check_point(point)) valid = false;
        }
        //println("here we be",valid);
      }
    }
    
    if (valid) points.add(point);
  }
  
  return points;
}

void buildGraph() {
  for (Point cur : points) {
  
    // if a point is close enough to the previous level it is a neighbor
    for (Point p : points) {
      // avoid adding self to neighbors
      if (p == cur) continue;
      
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
    q.remove(0);
    
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
  while(frontier.size() > 0) {
    PriorityQueue.Node temp = frontier.pop();
    node = (Point)temp.k;
    float curr_cost = temp.v;
    
    if (node == goal) return goal;
    
    node.discovered = true;
    for(Point n : node.neighbors) {
      float cost = n.pos.sub(node.pos).mag();
      if (!n.discovered && !frontier.contains(n)) {
        frontier.push(n, curr_cost + cost);
        n.parent = node;
      } else if (frontier.contains(n) && !n.discovered){
        frontier.updateCost(n, curr_cost + cost, node);
      }
    }
  }
  
  return null;
}

//ccd but working
boolean goodPath(Vector start, Vector end) {
  Vector v = end.sub(start).normalize();
  
  for (Obstacle obs : obstacles) {
    Sphere o = null;
    if (obs instanceof Sphere) o = (Sphere)obs;
    //else continue;
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
  }
  
  return true;
}

void clear() {
  points = new ArrayList<Point>();
}

void changeBoard(Vector point) {
  start_pos = agent.pos;
  end_pos = point;
  start = new Point(start_pos);
  end = new Point(end_pos);
  
  points = samplePoints();
  points.add(start);
  points.add(end);
  
  buildGraph();
  
  //println(bfs(start, end));
  println(ucs(start,end));
  
  agent.reset(end);
}


void keyPressed() {
  cam.HandleKeyPressed();
  if (key == 'i' || key == 'I') {
    user.col = color(255);
    user.vel = new Vector(0,-1,0);
  } else if (key == 'k' || key == 'K') {
    user.col = color(42,42,0);
    user.vel = new Vector(0,1,0);
  } else if (key == 'j' || key == 'J') {
    user.col = color(255, 192, 35);
    user.vel = new Vector(-1,0,0);
  } else if (key == 'l' || key == 'L') {
    user.col = color(0,255,0);
    user.vel = new Vector(1,0,0);
  }
}
void keyReleased() {
  cam.HandleKeyReleased();
}


void mouseClicked() {
  Vector mouse = new Vector(mouseX, mouseY, 0);
  for (Obstacle obs : obstacles) if (!obs.check_point(new Point(mouse))) return;
  clear();
  
  if (mouse.x > 500) mouse.x = 500;
  if (mouse.y > 500) mouse.y = 500;
  
  //float boardX = -(board_size/2.0) + board_size * (mouse.x/((float)(width-1)));
  //float boardY = -(board_size/2.0) + board_size * (mouse.y/((float)(height-1)));
  float boardX = -(board_size/2.0) + board_size * (mouse.x/(500.0));
  float boardY = -(board_size/2.0) + board_size * (mouse.y/(500.0));
  Vector board = new Vector(boardX, boardY, 0);
  println("mouse:",mouse,"board:",board);
  
  changeBoard(board);
  /*
  start_pos = agent.pos;
  end_pos = board;
  start = new Point(start_pos);
  end = new Point(end_pos);
  
  points = samplePoints();
  points.add(start);
  points.add(end);
  
  buildGraph();
  
  //println(bfs(start, end));
  println(ucs(start,end));
  
  agent.reset(end);
  */
}

  
/*
void mouseClicked() {
  Vector mouse = new Vector(mouseX, mouseY, 0);
  for (Obstacle obs : obstacles) if (!obs.check_point(new Point(mouse))) return;
  
  float boardX = -(board_size/2.0) + board_size * (mouseX/((float)(width-1)));
  float boardY = -(board_size/2.0) + board_size * (mouseY/((float)(height-1)));
  Vector board = new Vector(boardX, boardY, 0);
  //println("mouse:",mouse,"board:",board);
  
  start_pos = agent.pos;
  end_pos = board;
  start = new Point(start_pos);
  end = new Point(end_pos);
  //start.pos = start_pos;
  //end.pos = end_pos;
  
  //points = samplePoints();
  points.add(start);
  points.add(end);
  
  points.add(new Point(board));
  buildGraph();
  
  //println(bfs(start, end));
  ucs(start,end);
  
  agent.reset(end);
  
}
*/
