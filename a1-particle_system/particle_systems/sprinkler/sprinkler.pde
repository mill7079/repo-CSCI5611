import queasycam.*;

float genRate = 3000, dt = 0.05, toGen = genRate*dt;

QueasyCam cam;
Vector genPos, spherePos;
float genRad = 1;

float angle = 0;

ArrayList<Drop> water = new ArrayList<Drop>();

void setup() {
  size(600,600,P3D);
  background(100,175,255);
  cam = new QueasyCam(this);
  cam.speed = 1;
  cam.sensitivity = 3;
}

void draw() {
  context();
  
  if (frameCount % 5 == 0) generateParticles();
  
  for (Drop d : water) d.update();
  
  clean();
}

void context() {
  background(100,175,255);
  pushMatrix();
  
  pushStyle();
  fill(58, 166, 63);
  translate(300,300);
  box(500,100,500);
  popStyle();
  
  pushMatrix();
  pushStyle();
  fill(0);
  noStroke();
  translate(0, -50, 0);
  spherePos = new Vector(modelX(0, 0, 0), modelY(0, 0, 0), modelZ(0, 0, 0));
  genPos = new Vector(modelX(0, -5, 0), modelY(0, -5, 0), modelZ(0, -5, 0));
  sphere(5);
  popStyle();
  popMatrix();
  
  popMatrix();
}

void clean() {
  for (int i = water.size()-1; i >= 0; i--) {
    if (water.get(i).isDead()) water.remove(water.get(i));
  }
}

// generate sequentially around a disk
void generateParticles() {
  for (int i = 0; i < toGen; i++) {
    //water.add(new Drop(rndDisk(genRad, genPos)));
    //Vector genVel = new Vector(sin(angle), 1, cos(angle));
    //water.add(new Drop(genPos, genVel));
    //Vector pos = genPos.add(new Vector(sin(angle), 1, cos(angle)));
    Vector pos = spherePos.add(new Vector(sin(angle), 1, cos(angle)));
    Vector genVel = pos.sub(spherePos);
    water.add(new Drop(pos, genVel));
  }
  angle = (angle + PI/8) % (2*PI);  
}

Vector rndDisk(float rad, Vector center) {
  float r = rad*sqrt(random(1));
  //float r = rad*random(1);
  float theta = 2*PI*random(1);
  //return new float[]{r*sin(theta) + center.x, center.y, r*cos(theta) + center.z};
  return new Vector(r*sin(theta) + center.x, center.y, r*cos(theta) + center.z);
}

float[] rndSphere(float rad, float y) {
  // sample disk
  float r = rad*sqrt(random(1));
  float theta = 2*PI*random(1);
  float[] xz = new float[]{r*sin(theta), r*cos(theta)};
  
  // extrude y
  return new float[]{xz[0], y + sqrt(rad*rad - xz[0]*xz[0] - xz[1]*xz[1]), xz[1]};
}
