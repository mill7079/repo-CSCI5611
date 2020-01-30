int radius = 50;
// wanted to dynamically change the color of the ball
int red = 255, green = 255, blue = 255;
// x, y, z positions
float x, y, z = 0, zWall;
float change = -1;
float xvel, yvel, zvel;
float grav = 9.8; // gravity (acceleration)
float cor = 0.9;  // thought this looked more realistic than 0.95? idk
float dt = 0.15;

// float rx=0, ry=0, rz = 45;
float elapsedTime, startTime;

void setup() {
  size(600,600,P3D);
  x = width/2;
  y = height/2;
  zWall = -width;
  
  // set random initial velocities
  xvel = random(-50, 50);
  yvel = random(-50, 50);
  zvel = random(-75, -25);
  
  background(0,0,0);
  
  startTime = millis(); //how many seconds have passed since program started
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
  
  // time between frames
  elapsedTime = millis() - startTime;
  startTime = millis();
  
  fill(x/2, y, -z/2); // hehe
  lights();
  translate(x, y, z);
  noStroke();
  sphere(radius);
  
  
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
  
  // collisions with side walls
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
  
  // y += change;
  /*println("KeyCode: "+keyCode);
   if (y - radius <= 300) {
     change = 1; 
  } else 
   if (keyPressed && keyCode == UP) {
     z += 10;
   } else if (keyPressed){
     z -= 10;
   }
  background(0,0,0);
  fill(0,0,0);
  beginShape();
  vertex(50,50,z);
  vertex(100,150,z);
  //change the color here to make a GRADIENT WHAT THE FUCK AWESOME
  fill(255,255,255);
  vertex(200,200,z);
  endShape();
  
  noStroke();
  lights();
  translate(300,300);
  shininess(10);
  fill(255,255,255,50);
  sphereDetail(400); //level of triangulation
  sphere(radius);
  
  fill(255,255,255);
  beginShape();
  vertex(300,300);
  vertex(350,350);
  fill(0,0,0);
  vertex(300,350);
  vertex(350,300);
  endShape();*/
  
  /*if (blue == 255) {
    change = -1;
  } else if (blue == 0) {
     change = 1; 
  }*/
  /*blue += change;
  red -= change/2;
  if (y + radius > 300) {
     green += change*2; 
  }*/
}
