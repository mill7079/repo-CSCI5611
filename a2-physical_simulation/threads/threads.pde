import queasycam.*;

float gravity = 10, rest = 20;
float k = 40, kv = 140; //changing k changes rest length, changing kv changes stiffness

ArrayList<Ball> balls = new ArrayList<Ball>();
float dt = 0.015; // need small dt
int numBalls = 5;

float initX = 300;

QueasyCam cam;

void setup() {
  size(600, 600, P3D);
  //cam = new QueasyCam(this);
  
  for (int i = 0; i < numBalls; i++) {
    balls.add(new Ball(initX + (10*i),i+10,0,i)); 
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
  
  println("\n*************NEW UPDATE CALL**************\n");
  
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
    float string1, damp1, stringLength;
    float stringx, stringy;
    
    println("cur pos: "+cur.pos);
    if (other == null) { // deal with first ball
      println("other null");
      //string1 = -k * ((cur.pos.y) - rest);
      //damp1 = -kv * cur.vel.y;
      
      stringx = cur.pos.x - initX;
      stringy = cur.pos.y;
      stringLength = sqrt(sq(stringx) + sq(stringy));
    } else {
      //string1 = -k * ((cur.pos.y - other.pos.y) - rest);
      //damp1 = -kv * (cur.vel.y - other.vel.y);
      
      stringx = cur.pos.x - other.pos.x;
      stringy = cur.pos.y - other.pos.y;
      stringLength = sqrt(sq(stringx) + sq(stringy));
    }
    println("stringx: "+stringx);
    println("stringy: "+stringy);
    println("stringLength: "+stringLength);
    println("curr pos: " + cur.pos);
    //force1 = string1 + damp1;
    string1 = -k * (stringLength - rest);
    println("string1:",string1);
    
    float dirX = stringx/stringLength;
    float dirY = stringy/stringLength;
    println("dirX:",dirX,"dirY:",dirY);
    float vel = (cur.vel.x * dirX) + (cur.vel.y * dirY);
    println("vel:",vel);
    cur.projVel = vel;
    
    if (other == null) {
      damp1 = -kv * vel;
    } else {
      damp1 = -kv * (vel - other.projVel);
    }
    
    float springX1 = (string1 + damp1) * dirX;
    float springY1 = (string1 + damp1) * dirY;
    
    
    
    // calculate force for next spring to properly update ball
    //float force2 = 0;  // deal with last ball
    float springX2 = 0;
    float springY2 = 0; 
    if (next != null) {
        //float string2 = -k * ((next.pos.y - cur.pos.y) - rest);
        //float damp2 = -kv * (next.vel.y - cur.vel.y);
        //force2 = string2 + damp2;
      stringx = next.pos.x - cur.pos.x;
      stringy = next.pos.y - cur.pos.y;
      stringLength = sqrt(sq(stringx) + sq(stringy));
      
      float string2 = -k * (stringLength - rest);
      
      dirX = stringx/stringLength;
      dirY = stringy/stringLength;
      vel = (next.vel.x * dirX) + (next.vel.y * dirY);
      next.projVel = vel;
      
      float damp2 = -kv * (vel - cur.projVel);
      
      springX2 = (string2 + damp2) * dirX;
      springY2 = (string2 + damp2) * dirY;
    }
    
    //balls.get(i).update(force1, force2);
    balls.get(i).update(springX1, springY1, springX2, springY2);
    
    println();
    
    //noLoop();
  }
}
