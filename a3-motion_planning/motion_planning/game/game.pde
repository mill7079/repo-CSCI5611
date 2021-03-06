Camera cam;
//Agent agent;

User user;
int start_health = 100, start_atk = 10, start_def = 5;

Vector start_pos = new Vector(-9, 9, 0);
//Point start = new Point(start_pos);
Vector end_pos = new Vector(9, -9, 0);
//Point end = new Point(end_pos);

ArrayList<Point> points;
ArrayList<Obstacle> obstacles;
ArrayList<Agent> agents;
ArrayList<Ammo> shots;
//ArrayList<Ammo> enemyShots;

int num_points = 100;
int board_size = 40;//20;
float n_rad = board_size/3.0;
float a_rad = 0.5;//, crowd_a_rad = 0.3;

Vector new_obs_pos;
int new_obs_rad = 0;

boolean draw = false;
float num_enemies = 1;
int game_level = 1;

void setup() {
  noLoop();
  cam = new Camera();
  cam.position = new PVector( 0, 0, 50 );
  
  //agent = new Agent(0.5, color(168, 212, 122));
  //user = new User(new Vector(-8,-8,0), a_rad);
  user = new User(new Vector(0,0,0), a_rad);
  
  agents = new ArrayList<Agent>();
  agents.add(user);
  agents.add(new Agent(0.5, color(168, 212, 122), new Point(start_pos), new Point(end_pos)));
  
  //obs = new Sphere(new Vector(0,0,0), color(50,100,255), 2);
  obstacles = new ArrayList<Obstacle>();
  //obstacles.add(new Sphere(new Vector(0,0,0), color(50,100,255), 2));
  //obstacles.add(new Sphere(new Vector(2,2,0), color(255,100,50), 1));
  //obstacles.add(new Sphere(new Vector(-4,5,0), color(125, 125, 12), 1.25));
  
  points = samplePoints();
  //points.add(start);
  //points.add(end);
  for (Agent a : agents) {
    if (a == user) continue;
    points.add(a.origin);
    points.add(a.goal);
  }
  buildGraph();
  
  //bfs(start, end);
  //ucs(start, end);
  for (Agent a : agents) {
    if (a == user) continue;
    ucs(a.origin, a.goal);
    //a.createPath(ucs(a.origin, a.goal));
    a.createPath();
  }
  
  shots = new ArrayList<Ammo>();
  //enemyShots = new ArrayList<Ammo>();
  size(600,600,P3D);
  background(255);
}

void draw() {
  background(255);
  cam.Update( 1.0/frameRate );
  
  drawBoard();
  
  //agent.update();
  //agent.drawAgent();
  for (int i = agents.size()-1; i >= 0; i--) {
    if (agents.get(i).isDead()) {
      if (agents.get(i) == user) println("You reached game level", game_level, "at user level", user.level);
      else num_enemies--;
      
      agents.remove(i);
    }
  }
  for (Agent a : agents) {
    a.update();
    a.drawAgent();
  }
  
  //drawGraph();
  
  // draw mouse - debugging
  Vector mouse = new Vector(mouseX, mouseY, 0);
  if (mouse.x > 500) mouse.x = 500;
  
  else if (mouse.y > 500) mouse.y = 500;
  
  float boardX = -(board_size/2.0) + board_size * (mouse.x/(500.0));
  float boardY = -(board_size/2.0) + board_size * (mouse.y/(500.0));
  
  pushMatrix();
  translate(boardX, boardY, mouse.z);
  sphere(0.2);
  popMatrix();
  
  //user.update();
  //user.drawUser();
  
  if (frameCount % 10 == 0) changeGoal(user.pos);
  
  if (num_enemies == 0) {
    game_level++;
    num_enemies = game_level;
    for (int i = 0; i < num_enemies; i++) {
      boolean valid = false;
      Vector start = new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0);
      while(!valid) {
        valid = true;
        for (Obstacle o : obstacles) {
          if (!o.check_point(start)) valid = false;
        }
        if (!valid) start = new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0);
      }
      
      //Vector end = new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0);

      agents.add(new Agent(0.5, color(168, 212, 122), new Point(start), new Point(user.pos)));
    }
    
    changeGoal(user.pos);
  }
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
  /*pushStyle();
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
  
  popStyle();*/
  
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
  
  // draw paths
  stroke(58, 166, 63);
  strokeWeight(3);

  for (Agent a : agents) {
    for (int i = 0; i < a.path.size() - 1; i++) {
      line(a.path.get(i).x, a.path.get(i).y, a.path.get(i).z, a.path.get(i+1).x, a.path.get(i+1).y, a.path.get(i+1).z);
    }
  }
}

ArrayList<Point> samplePoints() {
  ArrayList<Point> points = new ArrayList<Point>();
  
  while(points.size() < num_points) {
    Point point = new Point(new Vector(random(-board_size/2, board_size/2), random(-board_size/2, board_size/2), 0));
    //if (!points.contains(point) && obs.check_point(point)) points.add(point);
    boolean valid = true;
    for (Obstacle o : obstacles) {
      //if (points.contains(point) || !o.check_point(point)) valid = false;
      if (!o.check_point(point)) {
        Vector v = point.pos.sub(o.pos).mult(2);
        v.normalize().mult(((Sphere)o).c_rad * 1.1);
        v = o.pos.add(v);
        point.pos = v;
        for (Obstacle check : obstacles) {
          if (!check.check_point(point)) valid = false;
        }
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
  for (Point p : points) p.discovered = false;
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
/*
void changeGoal(Vector point) {
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
*/
void changeGoal(Vector goal) {
  Point new_goal = new Point(goal);
  for (Agent a : agents) {
    if (a == user) continue;
    a.goal = new_goal;
  }
  
  points = samplePoints();
  points.add(new_goal);
  for (Agent a : agents) {
    a.origin = new Point(a.pos);
    points.add(a.origin);
  }
  
  buildGraph();
  
  for (Agent a : agents) {
    a.reset();
    ucs(a.origin, a.goal);
    a.createPath();
  }
}

void keyPressed() {
  cam.HandleKeyPressed();
  if (key == ' ') {
    draw = !draw;
    if (draw) loop();
    else noLoop();
  }
  
  if (user == null) return;
  if (key == 'i' || key == 'I') {
    //user.vel = new Vector(0,-1,0);
    user.vel = user.vel.add(new Vector(0,-1,0));
  } else if (key == 'k' || key == 'K') {
    //user.vel = new Vector(0,1,0);
    user.vel = user.vel.add(new Vector(0,1,0));
  } else if (key == 'j' || key == 'J') {
    //user.vel = new Vector(-1,0,0);
    user.vel = user.vel.add(new Vector(-1,0,0));
  } else if (key == 'l' || key == 'L') {
    //user.vel = new Vector(1,0,0);
    user.vel = user.vel.add(new Vector(1,0,0));
  } else if (key == 'f' || key == 'F') {
    user.fire();
  }
}
void keyReleased() {
  cam.HandleKeyReleased();
}


void mouseClicked() {
  Vector mouse = new Vector(mouseX, mouseY, 0);
  
  if (mouse.x > 500) mouse.x = 500;
  if (mouse.y > 500) mouse.y = 500;
  
  float boardX = -(board_size/2.0) + board_size * (mouse.x/(500.0));
  float boardY = -(board_size/2.0) + board_size * (mouse.y/(500.0));
  Vector board = new Vector(boardX, boardY, 0);
  
  Sphere s = new Sphere(board, color(random(255), random(255), random(255)), 1);
  obstacles.add(s);
  
  //updateGraph(agents.get(0).goal.pos, agents.get(0));
  changeGoal(user.pos);
  redraw();
}

void mousePressed() {
  Vector mouse = new Vector(mouseX, mouseY, 0);
  
  if (mouse.x > 500) mouse.x = 500;
  if (mouse.y > 500) mouse.y = 500;
  
  float boardX = -(board_size/2.0) + board_size * (mouse.x/(500.0));
  float boardY = -(board_size/2.0) + board_size * (mouse.y/(500.0));
  new_obs_pos = new Vector(boardX, boardY, 0);
}

void mouseReleased() {
  Vector mouse = new Vector(mouseX, mouseY, 0);
  
  if (mouse.x > 500) mouse.x = 500;
  if (mouse.y > 500) mouse.y = 500;
  
  float boardX = -(board_size/2.0) + board_size * (mouse.x/(500.0));
  float boardY = -(board_size/2.0) + board_size * (mouse.y/(500.0));
  Vector rad_pos = new Vector(boardX, boardY, 0);
  
  Sphere s = new Sphere(new_obs_pos, color(random(255), random(255), random(255)), new_obs_pos.sub(rad_pos).mag());
  obstacles.add(s);
  changeGoal(user.pos);
  redraw();
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
