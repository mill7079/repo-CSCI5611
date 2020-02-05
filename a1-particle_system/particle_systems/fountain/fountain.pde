import queasycam.*;

QueasyCam cam;
ArrayList<Drop> water = new ArrayList<Drop>();

int numParticles = 10;
static float dt = 0.15;

void setup() {
  size(600,600,P3D);
  cam = new QueasyCam(this);
}

void draw() {
  drawContext();
  generateParticles(0);
  
  for (int i = 0; i < water.size(); i++) {
    water.get(i).update();
  }
  
  clean();
}



void drawContext() {
  background(255);
  
  // draw fountain body
  pushMatrix();
  stroke(0);
  translate(2*width/3, 2*height/3);
  fill(125, 125, 125);
  box(200,200,100);
  
  // draw sphere stack for water to come out of
  pushMatrix();
  noStroke();
  translate(75,-100);
  fill(255,240,240);
  sphere(25);
  
  pushMatrix();
  translate(0,-25);
  fill(0);
  sphere(10);
  //generateParticles(0);
  /*for (int i = 0; i < numParticles; i++) {
    float[] pos = rndSphere(5, 0);
    water.add(new Drop(pos[0]+475, pos[1]+260, pos[2]));
    println(pos);
  }*/
  popMatrix();
  
  popMatrix();
  
  popMatrix();
}

// sample a sphere
void generateParticles(float y) {
  for (int i = 0; i < numParticles; i++) {
    float[] pos = rndSphere(5, y);
    //water.add(new Drop(pos[0], pos[1], pos[2]));
    water.add(new Drop(pos[0]+475, pos[1]+260, pos[2]));
    println(pos);
  }
}

float[] rndSphere(float rad, float y) {
  // sample disk
  float r = rad*sqrt(random(1));
  float theta = 2*PI*random(1);
  float[] xz = new float[]{r*sin(theta), r*cos(theta)};
  
  // extrude y
  return new float[]{xz[0], y + sqrt(rad*rad - xz[0]*xz[0] - xz[1]*xz[1]), xz[1]};
}

void clean() {
  for (int i = water.size()-1; i >= 0; i--) {
    if (water.get(i).isDead()) water.remove(water.get(i));
  }
}
