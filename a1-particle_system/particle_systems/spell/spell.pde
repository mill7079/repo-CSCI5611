//Rectangle[] rects = new Rectangle[0];
// Point[] rects = new Point[0];
ArrayList<Point> points = new ArrayList<Point>();
int idleParticles = 50, idleDisk = 50;
int spellParticles = 150, spellDisk = 10;

boolean cast = false;
int spell = 0;
float spellX, spellY;

void setup() {
  size(600,600,P3D);
  background(0);
}

void draw() {
  background(0);
  pushMatrix();
  pushStyle();
  translate(height/2, width/2, -1000);
  noStroke();
  fill(0,125,255,25);
  sphere(100);
  popStyle();
  popMatrix();
  /*fill(0,255,0);
  //rect(mouseX, mouseY, 50,50);
  pushMatrix();
  translate(mouseX, mouseY);
  //box(50);
  strokeWeight(5);
  point(mouseX, mouseY, 0);
  popMatrix();*/
  
  
  
  /*for (int i = 0; i < rects.length; i++) {
    rects[i].update();
  }*/
  
  /*for (int i = 0; i < numIdleParticles; i++) {
    float[] pos = rndDisk(50);
    points.add(new Point(pos[0]+mouseX, pos[1]+mouseY, true));
  }
  
  for (Point p : points) {
    p.update();
  }*/
  if (spell > 0) {
    drawParticles(spellParticles, spellDisk, false, spellX, spellY);
    spell --;
  } else {
    drawParticles(idleParticles, idleDisk, true, mouseX, mouseY);
  }
  clean();
  println(points.size(), "framerate: ", frameRate);
}

void mouseClicked() {
  //rects = (Rectangle[]) append(rects, new Rectangle(mouseX, mouseY, 50, 50));
  // rects = (Point[]) append(rects, new Point(mouseX, mouseY));
  //points.add(new Point(mouseX, mouseY, false)); // replace with spell cast
  cast = true;
  spell = 25;
  spellX = mouseX;
  spellY = mouseY;
  drawParticles(spellParticles, spellDisk, false, spellX, spellY);
}

void clean() {
  for (int i = points.size()-1; i >= 0; i--) {
    if (points.get(i).isDead()) points.remove(points.get(i));
  }
}

// uses non-uniform sampling because it looks cooler for my purposes
float[] rndDisk(float rad) {
  //float r = rad*sqrt(random(1));
  float r = rad*random(1);
  float theta = 2*PI*random(1);
  return new float[]{r*sin(theta), r*cos(theta)};
}

void drawParticles(int numParticles, float radius, boolean idle, float x, float y) {
  for (int i = 0; i < numParticles; i++) {
    float[] pos = rndDisk(radius);
    points.add(new Point(pos[0]+x, pos[1]+y, idle));
  }
  
  for (Point p : points) {
    p.update();
  }
}
