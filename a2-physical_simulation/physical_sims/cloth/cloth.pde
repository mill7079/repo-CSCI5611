Camera cam;

PImage tex;

float floor, dt = 0.001;

ArrayList<Obstacle> obstacles;
Cloth sheet;
Obstacle cur;

boolean moveShape = false;

void settings() {
    size(1000, 1000, P3D);
}

void setup() {
  cam = new Camera(); //<>//
  
  cam.position = new PVector (170,50,100);
  cam.theta = PI/6;
  // credit for image goes to RoosterTeeth Animation
  tex = loadImage("qrow.jpg");
   //<>//
  floor = height/2;
   //<>//
  sheet = new Cloth(); //<>//
  
  obstacles = new ArrayList<Obstacle>();
  //obstacles.add(new Sphere(new Vector(75,125,-200), 50, new Vector(255,0,0)));
  obstacles.add(new Sphere(new Vector(105,65,-150), 50, new Vector(255,0,0)));
  //obstacles.add(new Sphere(new Vector(-80,145,-200), 50, new Vector(150,0,200)));
  obstacles.add(new Sphere(new Vector(-30,35,-130), 20, new Vector(150,0,200)));
  
  cur = obstacles.get(0);
}

// update the cloth
void update() {
  sheet.updatePhysics();
  sheet.handleCollisions();
}

// camera stuff (thanks, Liam!)
void keyPressed() {
  cam.HandleKeyPressed();
  
  if (key == '1') {
    if (obstacles.size() >= 2) {
      cur = obstacles.get(1);
    }
  } else if (key == '0') {
    if (obstacles.size() >= 1) {
      cur = obstacles.get(0);
    }
  }
  
  if (key == 'm' || key == 'M') {
    moveShape = !moveShape;
  }
}
void keyReleased() {
  cam.HandleKeyReleased();
}

void draw() {
  // this line from example camera usage code
  cam.Update( 1.0/frameRate );
  
  //println("frame rate:" ,frameRate);
  background(160);

  // have to update multiple times with small dt for fast cloth
  for(int i = 0; i < 35; i++) update();
  
  // draw a floor because I keep losing the simulation with the damn 3d camera
  pushMatrix();
  translate(0,floor);
  fill(0,0,255);
  box(width, 10, height);
  popMatrix();
  
  if (moveShape) {
    cur.move_shape(new Vector(mouseX, mouseY, cur.pos.z));
  }
  
  draw_cloth(); //<>//
  draw_obstacles();
} //<>//

void draw_cloth() {
  
  // texture, maybe HEY IT WORKS
  textureMode(NORMAL);
  for (int i = 0; i < sheet.cloth.length - 1; i++) {
    beginShape(TRIANGLE_STRIP);
    texture(tex);
    noStroke();
    for (int j = 0; j < sheet.cloth[0].length; j++) {
      Point p = sheet.cloth[i][j];
      Point p2 = sheet.cloth[i+1][j];
      
      /*float u = map(p.pos.x, 0, sheet.cloth.length, 0, 1);
      float v = map(p.pos.y, 0, sheet.cloth[0].length, 0, 1);*/
      float u = map(j, 0, sheet.cloth.length, 0, 1);
      float v = map(i, 0, sheet.cloth[0].length, 0, 1);
      
      vertex(p.pos.x, p.pos.y, p.pos.z, u, v);
      
      v = map(i+1, 0, sheet.cloth[0].length, 0, 1);
      
      vertex(p2.pos.x, p2.pos.y, p2.pos.z, u, v);
    }
    endShape();
  }
  
  // draw a border around the cloth
  pushStyle();
  stroke(0);
  strokeWeight(3);
  for (int i = 0; i < sheet.cloth.length; i++) {
    if (i == sheet.cloth.length-1) {
      for (int j = 0; j < sheet.cloth[i].length - 1; j++) {
        Point p1 = sheet.cloth[i][j];
        Point p2 = sheet.cloth[i][j+1];
        line(p1.pos.x, p1.pos.y, p1.pos.z, p2.pos.x, p2.pos.y, p2.pos.z);
      }
    } else {
        Point p1 = sheet.cloth[i][0];
        Point p2 = sheet.cloth[i+1][0];
        line(p1.pos.x, p1.pos.y, p1.pos.z, p2.pos.x, p2.pos.y, p2.pos.z);
        p1 = sheet.cloth[i][sheet.cloth[i].length-1];
        p2 = sheet.cloth[i+1][sheet.cloth[i].length-1];
        line(p1.pos.x, p1.pos.y, p1.pos.z, p2.pos.x, p2.pos.y, p2.pos.z);
    }
  }
  popStyle();
  
  surface.setTitle("Frame Rate: "+frameRate);
} //<>//

void draw_obstacles() {
  pushStyle();
  lights();
  for (Obstacle o : obstacles) {
    o.draw_shape();
  }
  popStyle();
}
