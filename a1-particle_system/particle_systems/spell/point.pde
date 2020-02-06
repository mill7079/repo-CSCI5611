public class Point {
  
  int trailCount = 1, maxTrails = 20, move = 100;
  int w = 1;
  ArrayList<Vector> trails = new ArrayList<Vector>();
  
  //float x, y, z = 0; // xpos, ypos, zpos
  Vector pos, vel;
  float dt = 0.15, grav = 9.8;
  
  int change = 1;
  float r, b, a; // alpha value for twinkle/death
  boolean idle, rebound = false;
  
  //colors hehe
  color[] ace = new color[]{color(129, 0, 129), color(0), color(164), color(255)};
  color[] ar = new color[]{color(58, 166, 63), color(168, 212, 122), color(255), color(170), color(0)};
  color[] gay = new color[]{color(255,0,24), color(255,165,44), color(255,255,65), color(0,128,24), color(0,0,249), color(134,0,125)};
  color[] nb = new color[]{color(255,255,0), color(255), color(127, 0, 255), color(0)};
  color[] les = new color[]{color(214,41,0), color(255, 155, 85), color(255), color(212, 97, 166), color(165, 0, 98)};
  color[] bi = new color[]{color(214,2,112), color(155,79,150), color(0,56,168)};
  color[] ag = new color[]{color(0), color(186), color(255), color(186, 245, 132), color(255), color(186), color(0)};
  color[] tr = new color[]{color(85, 205, 252), color(255), color(247, 168, 184)};
  color[] pan = new color[]{color(255, 27, 141), color(255, 218, 0), color(27, 179, 255)};
  color[][] colors = new color[][]{ace, ar, gay, nb, les, bi, ag, tr, pan};
  int current, flag, frames = 0, frameSwitch = 20;
  float lerpMod = 0.05;
  
  public Point(float x, float y, boolean i) {
    /*this.x = x;
    this.y = y;*/
    pos = new Vector(x, y, 0);
    vel = new Vector(0,0,-move);
    this.a = random(255);
    /*if (floor(a) % 35 == 0) {
      r = 50;
      b = 255;
    } else if (floor(a) % 40 == 0) {
      r = 255;
      b = 50;
    } else {
      r = 125;
      b = 240;
    }*/
    
    idle = i;
    
    //current = floor(random(colors.length));
    flag = spellFlag;
    current = 0;
  }
  
  void update() {
    frames+=5;
    if (idle) {
      twinkle();
    } else {
      move();
      trails.add(pos);
      if (trails.size() >= maxTrails) trails.remove(0);
    }
  }
  
  void move() {
    // update color of particles
    updateColor();
    
    // different particle movement if rebounding off shield
    if (rebound) {
      pos = pos.add(vel.mult(dt));
      vel = vel.add(new Vector(random(-10,10), grav, random(-10,10)).mult(dt));
      vel = vel.mult(random(0.5,1.2));
      point(pos.x, pos.y, pos.z);
      a -= random(50)*dt; // use alpha to judge lifetime
      return;
    }
    
    // move point
    strokeWeight(w);
    pos = pos.add(vel.mult(dt));
    vel = vel.add(new Vector(0.1*random(-2,2), 0.1*random(-2,2), -random(1)));
    point(pos.x, pos.y, pos.z);
    
    /*
    //point(x, y, z);
    point(pos.x, pos.y, pos.z);
    //z -= (move + random(10));
    pos.z -= (move + random(10));
    */
    
    // test for intersection with sphere; if within sphere, move out; find new particle velocity after rebound
    Vector intersect = new Vector(shieldX - pos.x, shieldY - pos.y, shieldZ - pos.z);
    if (intersect.mag() <= sRadius) {
      //z += (sRadius - intersect.mag() + 1);
      pos.z += (sRadius - intersect.mag() + 1);
      rebound = true;
      
      // r = d-2(d.n)n to find reflection vector
      Vector normal = new Vector(pos.x - shieldX, pos.y - shieldY, pos.z - shieldZ).normalize();
      float dot = vel.dot(normal); // d . n
      dot *= 2;
      Vector scaleNormal = normal.mult(dot);
      vel = vel.sub(scaleNormal);
    }
    
    //trails
    /*for (int i = 10; i < trailCount; i++) {
      //stroke(125+i*4.5, i*10, 200+random(55), 256-(i*(256/(trailCount)))); // random adds a bit of sparkle, maybe
      strokeWeight(w*(0.1*(trailCount-i)));
      //point(x, y, z+i*move*3);
      point(pos.x, pos.y, pos.z+i*move*3);
    }
    if (trailCount < maxTrails) trailCount++;*/
    /*pushStyle();
    for (int i = 0; i < trails.size(); i++) {
      Vector v = trails.get(i);
      strokeWeight(w*(0.1*(trailCount-i)));
      stroke(lerpColor(colors[flag][current], colors[flag][(current+1)%colors[flag].length], frames * lerpMod),i*0.1*255);
      point(v.x, v.y, v.z);
    }
    popStyle();*/
    
    // non-intersect death condition
    if (pos.z <= -5000) a -= 50; // if the particle never hits a sphere it'll go on forever so it must be killed manually
  }
  
  void twinkle() {
    a += change * 8.5;
    if (a >= 255) change = -1;
    strokeWeight(w);
    //stroke(r, 0, b, a);
    color[] c = colors[flag];
    stroke(c[floor(random(c.length))]);
    //point(x, y, z);
    if (floor(random(500))%60 == 0) pos = pos.add(new Vector(random(-50,50), random(-50,50),0));
    else pos = pos.add(new Vector(random(-3,3), random(-3,3),0));
    point(pos.x, pos.y, pos.z);
  }
  
  boolean isDead() {
    return a <= 0;
  }
  
  void updateColor() {
    //fill(lerpColor(colors[current], colors[(current+1)%colors.length], frames * lerpMod));
    //stroke(lerpColor(colors[current], colors[(current+1)%colors.length], frames * lerpMod));
    stroke(lerpColor(colors[flag][current], colors[flag][(current+1)%colors[flag].length], frames * lerpMod));
    if (frames >= frameSwitch) {
      frames = 0;
      current = (current+1)%colors[flag].length;
    }
  }
  
}
