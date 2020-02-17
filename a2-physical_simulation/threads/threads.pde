import queasycam.*;

float gravity = 10, rest = 20;
float k = 40, kv = 40; //changing k changes rest length, changing kv changes stiffness

ArrayList<Ball> balls = new ArrayList<Ball>();
float dt = 0.015; // need small dt
int numBalls = 5;

float initY = 300;

QueasyCam cam;

void setup() {
  size(600, 600, P3D);
  //cam = new QueasyCam(this);
  
  for (int i = 0; i < numBalls; i++) {
    balls.add(new Ball(initY,i,0,i)); 
  }
}

void draw() {
  background(255);
  fill(0);
  
  for (int i = 0; i < 5; i++) {
    updateBalls();
  }
}

// need to call multiple times for small dt
void updateBalls() {
  
  for (int i = 0; i < balls.size(); i++) {
    Ball cur = balls.get(i);
    Ball other = null;
    if (i > 0) {
      other = balls.get(i-1);
    }
    Ball next = null;
    if (i < balls.size() - 1) {
      next = balls.get(i + 1);
    }
    
    cur.drawFrom(other);
    
    // all this code is really messy but at the moment I just want it to work
    
    //hooke's law
    float force1;
    
    if (other == null) { // deal with first ball
      float string1 = -k * ((cur.pos.y) - rest);
      float damp1 = -kv * cur.vel.y;
      force1 = string1 + damp1;
    } else {
      float string1 = -k * ((cur.pos.y - other.pos.y) - rest);
      float damp1 = -kv * (cur.vel.y - other.vel.y);
      force1 = string1 + damp1;
    }
 
    float force2 = 0; // deal with second ball
    if (next != null) {
      float string2 = -k * ((next.pos.y - cur.pos.y) - rest);
      float damp2 = -kv * (next.vel.y - cur.vel.y);
      force2 = string2 + damp2;
    }
    
    balls.get(i).update(force1, force2);
  }
}

/*
//find distance between ball and anchor
  float sx = (ballX - anchorX);
  float sy = (ballY - anchorY);
  float stringLen = sqrt(sx*sx + sy*sy);
  //println(stringLen, " ", restLen);
  
// part of hooke's (string2, string1, etc)
  float stringF = -k*(stringLen - restLen);
  float dirX = sx/stringLen;
  float dirY = sy/stringLen;
  float projVel = velX*dirX + velY*dirY;
  float dampF = -kv*(projVel - 0);
  
  float springForceX = (stringF+dampF)*dirX;
  float springForceY = (stringF+dampF)*dirY;
  
  velX += (springForceX/mass)*dt;
  velY += ((springForceY+grav)/mass)*dt;
  
  ballX += velX*dt;
  ballY += velY*dt;
  
  if (ballY+radius > floor){
    velY *= -.9;
    ballY = floor - radius;
  }
  */
