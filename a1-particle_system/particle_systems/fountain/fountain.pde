import queasycam.*;

QueasyCam cam;
ArrayList<Drop> water = new ArrayList<Drop>();

float genRate = 1500, dt = 0.05, numParticles = 1500*dt;

float[] box, waterbox; // center model coords of bucket and center blue box in bucket representing water
float wDiff = 40, bDiff = 50; // difference between center and edge of box for water/box coords

PImage blur;

void setup() {
  size(600,600,P3D);
  cam = new QueasyCam(this);
  drawContext();
  blur = loadImage("blur.png");
}

void draw() {
  drawContext();
  generateParticles(0);
  
  for (int i = 0; i < water.size(); i++) {
    water.get(i).update();
  }
  
  clean();
  println("particles:", water.size(), "frame rate:", frameRate);
}



void drawContext() {
  background(255);
  
  // draw fountain body
  pushMatrix();
  stroke(0);
  translate(2*width/3, 2*height/3);
  fill(125, 125, 125);
  box(200,200,100);
  
  // box to catch water
  pushMatrix();
  stroke(0);
  fill(175,175,175);
  translate(-200,-10);
  box = new float[]{modelX(-200,-10,0), modelY(-200,-10,0), modelZ(-200,-10,0)};
  // translate(0, 0);  // why is this here?? hmm
  box(bDiff*2);
  
  // water
  pushMatrix();
  noStroke();
  fill(100,150,240);
  translate(0, -11, 0);
  waterbox = new float[]{modelX(0,-11,0), modelY(0,-11,0), modelZ(0,-11,0)};
  box(wDiff*2);
  popMatrix();
  
  popMatrix();
  
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
  popMatrix();
  
  popMatrix();
  
  popMatrix();
  
  /*pushMatrix();
  fill(255,0,0);
  translate(waterbox[0], waterbox[1], waterbox[2]);
  box(80);
  //circle(water[0], water[1],50);
  popMatrix();*/
}

// sample a sphere
void generateParticles(float y) {
  for (int i = 0; i < numParticles; i++) {
    float[] pos = rndSphere(5, y);
    //water.add(new Drop(pos[0], pos[1], pos[2]));
    water.add(new Drop(pos[0]+475, pos[1]+260, pos[2]));
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
