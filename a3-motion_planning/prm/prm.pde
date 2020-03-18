Camera cam;
Agent agent;
Obstacle obs;

Vector start_pos = new Vector(-9, 9, 0);
Vector end_pos = new Vector(9, -9, 0);

ArrayList<Vector> points;

int num_points = 20;

void setup() {
  cam = new Camera();
  agent = new Agent(0.5, color(90,205,90));
  obs = new Sphere(new Vector(0,0,0), color(50,100,255), 2);
  
  points = samplePoints();
  
  size(600,600,P3D);
  background(255);
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
  box(20,20,0.00001);
  popStyle();
  popMatrix();
  
  obs.draw_obs();
  
  agent.update();
  agent.drawAgent();
  
  //draw goal
  pushMatrix();
  pushStyle();
  translate(9,-9,0);
  noStroke();
  fill(220,90,90);
  sphere(0.5);
  popStyle();
  popMatrix();
  
  for (Vector v : points) {
    strokeWeight(5);
    point(v.x, v.y, v.z);
    /*pushMatrix();
    translate(v.x, v.y, v.z);
    //sphere(1);
    point(1);
    popMatrix();*/
  }
}

ArrayList<Vector> samplePoints() {
  ArrayList<Vector> points = new ArrayList<Vector>();
  
  while(points.size() < num_points) {
    Vector point = new Vector(random(-9,9), random(-9,9), 0);
    if (!points.contains(point) && obs.check_point(point)) points.add(point);
  }
  
  return points;
}


void keyPressed() {
  cam.HandleKeyPressed();
}
void keyReleased() {
  cam.HandleKeyReleased();
}
