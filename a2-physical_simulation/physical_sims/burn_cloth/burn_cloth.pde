Camera cam;

PImage tex;

float floor, dt = 0.001;

ArrayList<Obstacle> obstacles;
Cloth sheet;
Obstacle cur;

boolean moveShape = false;

int numParticles = 5;

void settings() {
    size(1000, 1000, P3D);
}

void setup() {
  cam = new Camera(); //<>//
  // credit for image: https://picsart.com/hashtag/elmo/popular-stickers
  tex = loadImage("elmo.jpg");
   //<>//
  floor = height/2;
   //<>//
  sheet = new Cloth(); //<>//
  sheet.setNeighbors();
  
  obstacles = new ArrayList<Obstacle>();
  //obstacles.add(new Sphere(new Vector(75,125,-200), 50, new Vector(255,0,0)));
  //obstacles.add(new Sphere(new Vector(85,55,-170), 20, new Vector(255,0,0)));
  //obstacles.add(new Sphere(new Vector(-80,145,-200), 50, new Vector(150,0,200)));
  //obstacles.add(new Sphere(new Vector(-30,35,-130), 30, new Vector(150,0,200)));
  //obstacles.add(new Sphere(new Vector(0, floor, 0), 5, new Vector(0,0,0)));
  obstacles.add(new Sphere(new Vector(0, floor, 0), 5, new Vector(0,0,0)));
  obstacles.add(new HeatSource(new Vector(0, floor, 0), 5, new Vector(0,0,0)));
  obstacles.add(new CutSource(new Vector(0, floor, 0), 5, new Vector(255,255,0)));
  
  cur = obstacles.get(0);
}

// update the cloth
void update() {
  sheet.updatePhysics();
  sheet.handleCollisions();
}

void keyPressed() {
  cam.HandleKeyPressed();
  
  if (key == '1') {
    if (obstacles.size() >= 2) cur = obstacles.get(1);
  } else if (key == '0') {
    if (obstacles.size() >= 1) cur = obstacles.get(0);
  } else if (key == '2') {
    if (obstacles.size() >= 3) cur = obstacles.get(2);
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
  
  //println("div * dt: " + sheet.di.mult(dt));
  
  // draw a floor because i keep losing the simulation with the damn 3d camera
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
  
  sheet.incFrames();
  sheet.spreadBurn();
  sheet.doneBurn();
  
  clean();
} //<>//

void draw_cloth() {
  
  // texture. if used with burning cloth it looks like it's melting and it's absolutely hilarious
  /*textureMode(NORMAL);
  for (int i = 0; i < sheet.cloth.length - 1; i++) {
    beginShape(TRIANGLE_STRIP);
    texture(tex);
    noStroke();
    for (int j = 0; j < sheet.cloth[i].length; j++) {
      Point p = sheet.cloth[i][j];
      Point p2 = sheet.cloth[i+1][j];
      
      float u = map(j, 0, sheet.cloth.length, 0, 1);
      float v = map(i, 0, sheet.cloth[i].length, 0, 1);
      
      vertex(p.pos.x, p.pos.y, p.pos.z, u, v);
      
      v = map(i+1, 0, sheet.cloth[i].length, 0, 1);
      
      vertex(p2.pos.x, p2.pos.y, p2.pos.z, u, v);
      
    }
    endShape();
  }*/
  
  textureMode(NORMAL);
  for (int i = 0; i < sheet.cloth.length - 1; i++) {
    beginShape(TRIANGLE_STRIP);
    texture(tex);
    noStroke();
    for (int j = 0; j < sheet.cloth[i].length; j++) {
      Point p = sheet.cloth[i][j];
      Point p2 = sheet.cloth[i+1][j];
      if (p.link_neighbors.contains(p2)) {
      
        float u = map(j, 0, sheet.cloth.length, 0, 1);
        float v = map(i, 0, sheet.cloth[i].length, 0, 1);
        
        vertex(p.pos.x, p.pos.y, p.pos.z, u, v);
        
        v = map(i+1, 0, sheet.cloth[i].length, 0, 1);
        
        vertex(p2.pos.x, p2.pos.y, p2.pos.z, u, v);
      }
      
    }
    endShape();
  }
  
  
  draw_fire();
  
  // draw grid in parts where cloth isn't burned
  pushStyle();
  stroke(0);
  strokeWeight(2);
  for (int i = 0; i < sheet.cloth.length; i++) {
    for (int j = 0; j < sheet.cloth.length; j++) {
      Point p = sheet.cloth[i][j];
      if (i != sheet.cloth.length - 1 && p.link_neighbors.contains(sheet.cloth[i+1][j])) {
        Point p2 = sheet.cloth[i+1][j];
        line(p.pos.x, p.pos.y, p.pos.z, p2.pos.x, p2.pos.y, p2.pos.z);
      }
      if (j != sheet.cloth[i].length - 1 && p.link_neighbors.contains(sheet.cloth[i][j+1])) {
        Point p2 = sheet.cloth[i][j+1];
        line(p.pos.x, p.pos.y, p.pos.z, p2.pos.x, p2.pos.y, p2.pos.z);
      }
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

void draw_fire() {
  for (int i = 0; i < sheet.cloth.length; i++) {
    for (int j = 0; j < sheet.cloth.length; j++) {
      if (sheet.cloth[i][j].burning) {
        sheet.cloth[i][j].generateParticles(0);
        for (Spark s : sheet.cloth[i][j].fire) {
          s.update();
        }
      }
    }
  }
}

void clean() {
  int count = 0;
  for (Obstacle o : obstacles) {
    if (!(o instanceof HeatSource)) continue;
    
    HeatSource h = (HeatSource) o;
    h.clean();
    count += h.fire.size();
  }
  
  for (Point p : sheet.burns) {
    p.clean();
    count += p.fire.size();
  }
  //println(count);
}
