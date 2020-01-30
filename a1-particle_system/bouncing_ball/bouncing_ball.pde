int radius = 50;
// change the color of the ball as it moves
int red = 255, green = 255, blue = 255;

// x, y, z positions
float x, y, z, zWall;
float xvel, yvel, zvel;
float grav = 9.8; // gravity (acceleration)
float cor = 0.9;  // thought this looked more realistic than 0.95
float dt = 0.15;

void setup() {
  size(600,600,P3D);
  x = width/2;
  y = height/2;
  z = -width/2;
  zWall = -width;
  
  // set random initial velocities
  xvel = random(-50, 50);
  yvel = random(-50, 50);
  zvel = random(-75, -25);
  
  background(0,0,0);
}

void draw() {
  // erase previous sphere draws
  background(0,0,0);
  
  // draw lines to outline walls
  stroke(-z/2,x/2,y);
  
  // top/bottom
  line(0, height, zWall, width, height, zWall);
  line(0, 0, zWall, width, 0, zWall);
  
  // left/right vertical
  line(0, height, zWall, 0, 0, zWall);
  line(width, height, zWall, width, 0, zWall);
  
  // flat bottom left/right
  line(0, height, 0, 0, height, zWall);
  line(width, height, 0, width, height, zWall);
  
  // flat top left/right
  line(0, 0, 0, 0, 0, zWall);
  line(width, 0, 0, width, 0, zWall);
  
  // draw sphere
  fill(x/2, y, -z/2);
  lights();
  translate(x, y, z);
  noStroke();
  sphere(radius);
  
  // update positions
  y += yvel * dt;
  yvel += grav * dt; 
  
  x += xvel * dt;
  z += zvel * dt;
  
  // collision with ground/ceiling
  if (y + radius >= height) {
    y = height - radius;
    yvel *= -cor;
  } else if (y - radius <= 0) {
    y = radius;
    yvel += -cor;
  }
  
  // collision with side walls
  if (x + radius >= width) {
    x = width - radius;
    xvel *= -cor;
  } else if (x - radius <= 0) {
    x = radius;
    xvel *= -cor;
  }
  
  // collision with front/back walls
  if (z + radius >= 0) {
    z = -radius;
    zvel *= -cor;
  } else if (z - radius <= zWall) {
    z = zWall + radius;
    zvel *= -cor;
  }
  
}
