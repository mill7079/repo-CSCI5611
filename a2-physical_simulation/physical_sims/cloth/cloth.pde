int numx = 15;
int numy = 15;

Vector[][] pos;
Vector[][] vels;

float restLen = 20;

void setup() {
  size(600,600,P3D);
  
  vels = new Vector[numy][numx];
  pos = new Vector[numy][numx];
  
  for (int i = 0; i < numy; i++) {
    for (int j = 0; j < numx; j++) {
      vels[i][j] = new Vector(0, 0, 0);
      pos[i][j] = new Vector(10+j*30, 50+i*30, 0);
    }
  }
}

void update() {
  // horizontal
  for (int i = 0; i < numy; i++) {
    for (int j = 0; j < numx-1; j++) {
      
    }
  }
}

void draw() {
  update();
  
  background(255);
  stroke(0);
  
  // horizontal
  for (int i = 0; i < numy; i++) {
    for (int j = 0; j < numx-1; j++) {
      line(pos[i][j].x, pos[i][j].y, pos[i][j].z, pos[i][j+1].x, pos[i][j+1].y, pos[i][j+1].z);
      pushMatrix();
      translate(pos[i][j].x, pos[i][j].y, pos[i][j].z);
      sphere(1);
      popMatrix();
    }
    pushMatrix();
    translate(pos[i][numx-1].x, pos[i][numx-1].y, pos[i][numx-1].z);
    sphere(1);
    popMatrix();
  }
  
  // vertical - only need to draw lines?
  for (int i = 0; i < numy-1; i++) {
    for (int j = 0; j < numx; j++) {
      line(pos[i][j].x, pos[i][j].y, pos[i][j].z, pos[i+1][j].x, pos[i+1][j].y, pos[i+1][j].z);
      /*pushMatrix();
      translate(pos[i][j].x, pos[i][j].y, pos[i][j].z);
      sphere(1);
      popMatrix();*/
    }
    /*pushMatrix();
    translate(pos[i][numx-1].x, pos[i][numx-1].y, pos[i][numx-1].z);
    sphere(1);
    popMatrix();*/
  }
}
