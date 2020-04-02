Camera cam;
//Agent agent;

Vector start_pos = new Vector(-9, 9, 0);
//Point start = new Point(start_pos);
Vector end_pos = new Vector(9, -9, 0);
//Point end = new Point(end_pos);


User user;

ArrayList<Agent> agents;
ArrayList<Point> points;
ArrayList<Obstacle> obstacles;

int num_points = 500;
int board_size = 40;//20;
float n_rad = board_size/3.0;
float a_rad = 0.5, crowd_a_rad = 0.3;

Vector new_obs_pos;
int new_obs_rad = 0;

boolean draw = false;
Vector crowd_goal = new Vector(board_size/2-5, -(board_size/2-5), 0);

void setup() {
  noLoop();
  cam = new Camera();
  cam.position = new PVector( 0, 0, 50 );
  
  user = new User(new Vector(0,0,0), a_rad+0.2);
  
  agents = new ArrayList<Agent>();
  /*SCENARIO 1 AGENTS*/
  //agents.add(new Agent(a_rad, color(168, 212, 122), new Point(start_pos), new Point(end_pos)));
  //agents.add(new Agent(a_rad, color(50,50,229), new Point(new Vector(-9,-9,0)), new Point(new Vector(9,9,0))));
  /*SCENARIO 2 AGENTS*/
  //agents.add(new Agent(a_rad, color(255,0,0), new Point(new Vector(-1, -9.5, 0)), new Point(new Vector(-1, 9., 0)))); // top of board
  //agents.add(new Agent(a_rad, color(200,75,0), new Point(new Vector(1, -9.5, 0)), new Point(new Vector(1, 9.5, 0))));
  //agents.add(new Agent(a_rad, color(125,125,0), new Point(new Vector(9.5, -1, 0)), new Point(new Vector(-9.5, -1, 0)))); // right of board
  //agents.add(new Agent(a_rad, color(200,75,0), new Point(new Vector(9.5, 1, 0)), new Point(new Vector(-9.5, 1, 0))));
  //agents.add(new Agent(a_rad, color(255,0,0), new Point(new Vector(-1, 9.5, 0)), new Point(new Vector(-1, -9.5, 0)))); // bottom of board
  //agents.add(new Agent(a_rad, color(200,75,0), new Point(new Vector(1, 9.5, 0)), new Point(new Vector(1, -9.5, 0))));
  //agents.add(new Agent(a_rad, color(125,125,0), new Point(new Vector(-9.5, -1, 0)), new Point(new Vector(9.5, -1, 0)))); // left of board
  //agents.add(new Agent(a_rad, color(200,75,0), new Point(new Vector(-9.5, 1, 0)), new Point(new Vector(9.5, 1, 0))));
  /*SCENARIO 3 AGENTS*/
  //agents.add(new Agent(a_rad, color(random(255),random(255),random(255)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0))));
  //agents.add(new Agent(a_rad, color(random(255),random(255),random(255)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0))));
  //agents.add(new Agent(a_rad, color(random(255),random(255),random(255)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0))));
  //agents.add(new Agent(a_rad, color(random(255),random(255),random(255)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0))));
  //agents.add(new Agent(a_rad, color(random(255),random(255),random(255)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0))));
  //agents.add(new Agent(a_rad, color(random(255),random(255),random(255)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0))));
  //agents.add(new Agent(a_rad, color(random(255),random(255),random(255)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0))));
  //agents.add(new Agent(a_rad, color(random(255),random(255),random(255)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0))));
  //agents.add(new Agent(a_rad, color(random(255),random(255),random(255)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0))));
  //agents.add(new Agent(a_rad, color(random(255),random(255),random(255)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0)), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0))));
  //agents.add(user);
  /*SCENARIO 4 AGENTS*/
  //agents.add(user);
  //for (int i = 0; i < 60; i++)  agents.add(new CrowdAgent(crowd_a_rad, color(random(255),0,0), new Point(new Vector(random(-board_size/2,board_size/2), random(-board_size/2,board_size/2), 0)), new Point(user.pos)));
  /*SCENARIO 5 AGENTS*/
  for (int i = 0; i < 40; i++)  agents.add(new CrowdAgent(crowd_a_rad, color(0,0,random(255)), new Point(new Vector(random(-20,-8), random(20), 0)), new Point(crowd_goal)));
  /*SCENARIO 6 AGENTS*/
  //for (int i = 0; i < 20; i++)  agents.add(new CrowdAgent(crowd_a_rad, color(0,0,random(255)), new Point(new Vector(random(-20,-10), random(10,20), 0)), new Point(crowd_goal)));
  
  obstacles = new ArrayList<Obstacle>();
  /*SCENARIO 4 OBSTACLES*/
  /*SCENARIO 5 OBSTACLES*/
  for (int i = 0; i < 30; i++) {
    obstacles.add(new Sphere(new Vector(-7, 20-i, 0), color(0), 1));
    obstacles.add(new Sphere(new Vector(7, -20+i, 0), color(0), 1));
  }
  /*SCENARIO 6 OBSTACLES*/
  //obstacles.add(new Sphere(new Vector(-5,5,0), color(50,100,255), 5));
  
  /*old stuff*/
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
  
  //ucs(start, end);
  for (Agent a : agents) {
    if (a == user) continue;
    //println("ucs",ucs(a.origin, a.goal));
    //a.createPath(ucs(a.origin, a.goal));
    ucs(a.origin, a.goal);
    a.createPath();
  }
  
  //for (Agent a : agents) println(a.path);
  
  //agent.createPath(end);
  //for (Agent a : agents) a.createPath(end);
  //for (Agent a : agents) a.createPath();
  
  size(600,600,P3D);
  background(255);
}

void draw() {
  background(255);
  cam.Update( 1.0/frameRate );
  
  drawBoard();
  //agent.update();
  //agent.drawAgent();
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
  
  //if (frameCount % 10 == 0) changeGoal(user.pos);
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
  /*
  // draw start/goal
  pushStyle();
  noStroke();
  for (Agent a : agents) {
    //start
    pushMatrix();
    fill(90,220,90);
    translate(a.origin.pos.x,a.origin.pos.y,a.origin.pos.z);
    sphere(0.3);
    popMatrix();
    
    // goal
    pushMatrix();
    fill(220,90,90);
    translate(a.goal.pos.x,a.goal.pos.y,a.goal.pos.z);
    sphere(0.3);
    popMatrix();
  }
  popStyle();
  */
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
void changeGoal(Vector point, Agent agent) {
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

void updateGraph(Vector new_goal, Agent agent) {
  points = samplePoints();
  agent.goal = new Point(new_goal);
  for (Agent a : agents) {
    a.origin = new Point(a.pos);
    points.add(a.origin);
    points.add(a.goal);
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
  
  if (user == null);
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
  //changeGoal(end.pos);
 // changeGoal(end.pos, agents.get(0));
  updateGraph(agents.get(0).goal.pos, agents.get(0));
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
  //changeGoal(end.pos);
 // changeGoal(end.pos, agents.get(0));
  updateGraph(agents.get(0).goal.pos, agents.get(0));
  redraw();
}
