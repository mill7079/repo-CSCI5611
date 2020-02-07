//import queasycam.*;

ArrayList<Point> points = new ArrayList<Point>();
// I know this technically isn't the way he said to do the generation rate in class but it works
int idleParticles = 50, idleDisk = 50;
int spellParticles = 150, spellDisk = 10;

boolean cast = false;
int spell = 0;
float spellX, spellY;
static int spellFlag = 0;

static float shieldX, shieldY, shieldZ, sRadius;
Vector shield;

// camera
/*boolean rotate = true;
float cenx, ceny, fov = PI/3.0;
float cameraZ = (height/2.0) / tan(fov/2.0);*/

//QueasyCam cam;
boolean active = true;

void setup() {
  size(600,600,P3D);
  background(0);
  /*cam = new QueasyCam(this);
  cam.controllable = true;*/
}

void draw() {
    background(0);
    
    // shield 
    pushMatrix();
    pushStyle();
    translate(height/2, width/2, -1500);
    shieldX = height/2;
    shieldY = width/2;
    shieldZ = -1500;
    shield = new Vector(shieldX, shieldY, shieldZ);
    sRadius = 100;
    noStroke();
    fill(125,125,255,75);
    //fill(255);
    sphere(100);
    popStyle();
    popMatrix();
    
    if (spell > 0) {
      drawParticles(spellParticles, spellDisk, false, spellX, spellY);
      spell --;
    }
    // always draw idle particles
    drawParticles(idleParticles, idleDisk, true, mouseX, mouseY);
    clean();
    println(points.size(), "framerate: ", frameRate);
}


void mouseClicked() {
  //if (active) {
    cast = true;
    spell = 50;
    spellX = mouseX;
    spellY = mouseY;
    // somehow this doesn't change the colors of subsequent spells?? not sure how but hallelujah
    spellFlag = floor(random(9));
    drawParticles(spellParticles, spellDisk, false, spellX, spellY);
  /*} else {
    //cam = new QueasyCam(this);
    cam.controllable = !cam.controllable;
  }*/
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

void keyPressed() {
  if (key == ' ') {
    active = !active;
    //if (cam == null) {
    if (!active) {
      //cam = new QueasyCam(this);
      noLoop();
    } else {
      //cam = null;
      loop();
    }
  }
}
