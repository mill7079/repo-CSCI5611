public class Cloth {
  
  Point[][] cloth;
  ArrayList<Point> burns; // hold points that are burning
  ArrayList<Spring> broken; // keep track of which springs have been cut/burned
  
  float topX, topY, topZ;
  float ks, kd, restLen;
  
  float mass = 1.5;
  
  boolean dragOn = false;
  Vector di;
  
  float ap, cd;
  Vector airV = new Vector(0,0,0);
  
  // gravity
  Vector g = new Vector(0, 9.8, 0);
  
  public Cloth() {
    ks = 1000;
    kd = 1050;
    restLen = 1;
    
    topX = 10;
    topY = 10;
    topZ = -120;
    
    cd = 1001;
    ap = 1001;
    
    cloth = new Point[30][30];
    for (int i = 0; i < cloth.length; i++) {
      for (int j = 0; j < cloth[i].length; j++) {
        cloth[i][j] = new Point(new Vector(topX + j*restLen, topY + i*restLen, 0), new Vector(0,0,0));
      }
    }
    
    burns = new ArrayList<Point>();
  }
  
  void handleCollisions() {
    for (int i = 0; i < cloth.length; i++) {
      for (int j = 0; j < cloth[0].length; j++) {
        Point p = cloth[i][j];
        
        // obstacle collisions
        for (Obstacle o : obstacles) {
          if (!(o instanceof Sphere)) continue;
          
          Sphere s = (Sphere)o;
          float dist = o.pos.sub(p.pos).mag();
          
          if (dist < s.radius + 0.1) {
            Vector normal = s.pos.sub(p.pos).mult(-1).normalize();
            Vector bounce = normal.mult(p.vel.dot(normal));
            p.vel = p.vel.sub(bounce.mult(1.5));
            p.pos = p.pos.add(normal.mult(0.1 + s.radius - dist));
            
            if (o instanceof HeatSource) {
              burns.add(p);
              p.burning = true;
            } else if (o instanceof CutSource) {
              p.link_neighbors.clear();
            }
          }
        }
        
        // doesn't quite look right, mostly because it's kind of hard to see the points
        if (p.pos.y >= (floor - 10)) {
          // normal is straight up negative y axis when flat
          Vector normal = new Vector(0, -1, 0);
          Vector bounce = normal.mult(p.vel.dot(normal));
          p.vel = p.vel.sub(bounce.mult(1.5));
          p.pos.y = floor - 11;
        }
        
      }
    }
  } // collisions
  
  void updatePhysics() {
    for (int i = 0; i < cloth.length; i++) {
      for (int j = 0; j < cloth[i].length; j++) {
        cloth[i][j].vn = cloth[i][j].vel;
      }
    }
    
    // vertical
    for (int i = 0; i < cloth.length; i++) {
      for (int j = 0; j < cloth[i].length; j++) {
        Point p0 = cloth[i][j];
        // Vector half_pos1 = p0.pos.add(p0.vn.mult(dt).add(g.mult(0.5*dt*dt)));
        // midpoint: move forward 1/2 time step
        p0.pos = p0.pos.add(p0.vn.mult(dt).add(g.mult(0.5*dt*dt)));
        p0.vn = p0.vn.add(g.mult(dt));
        
        if (i != cloth.length-1 && p0.link_neighbors.contains(cloth[i+1][j])) {
          Point p = cloth[i+1][j];
          
          // calculate force at the 1/2 step position
          Vector e = p.pos.sub(p0.pos);
          float l = e.mag();
          e = e.normalize();
          
          float v1 = e.dot(p0.vn);
          float v2 = e.dot(p.vn);
          
          float f = -ks * (restLen - l) - kd * (v1 - v2);
          
          // apply force from 1/2 step to position from 1st step
          // technically part of the position change was applied earlier
          // but it doesn't seem to matter if you just update the position first and only add the force here
          Vector forceDir = e.mult(f/mass);
          p0.pos = p0.pos.add(forceDir.mult(0.5*dt*dt));
          p0.vn = p0.vn.add(forceDir.mult(dt));
          
          p.pos = p.pos.sub(forceDir.mult(0.5*dt*dt));
          p.vn = p.vn.sub(forceDir.mult(dt));
        }
        
      }
    } // vertical
    
    // horizontal
    for (int i = 0; i < cloth.length; i++) {
      for (int j = 0; j < cloth[i].length; j++) {
        Point p0 = cloth[i][j];
        p0.pos = p0.pos.add(p0.vn.mult(dt).add(g.mult(0.5*dt*dt)));
        p0.vn = p0.vn.add(g.mult(dt));
        
        if (j != cloth[i].length-1 && p0.link_neighbors.contains(cloth[i][j+1])) {
          Point p = cloth[i][j+1];
          
          Vector e = p.pos.sub(p0.pos);
          float l = e.mag();
          e = e.normalize();
          
          float v1 = e.dot(p0.vn);
          float v2 = e.dot(p.vn);
          
          float f = -ks * (restLen - l) - kd * (v1 - v2);
          
          Vector forceDir = e.mult(f/mass);
          p0.pos = p0.pos.add(forceDir.mult(0.5*dt*dt));
          p0.vn = p0.vn.add(forceDir.mult(dt));
          
          p.pos = p.pos.sub(forceDir.mult(0.5*dt*dt));
          p.vn = p.vn.sub(forceDir.mult(dt));
        }
      }
    } // horiz
    
    //drag
    for (int i = 0; i < cloth.length-1 && dragOn; i++) {
      for (int j = 0; j < cloth[i].length-1 && dragOn; j++) {
        Vector drag = findDrag(i,j);
        Vector div = drag.div(4);
        
        // use midpoint equations to add to vel and pos?
        // or maybe just vel
        Point p = cloth[i][j];
        Point p2 = cloth[i][j+1];
        Point p3 = cloth[i+1][j];
        Point p4 = cloth[i+1][j+1];
        
        p.vel = p.vel.add(div.mult(dt));
        p2.vel = p2.vel.add(div.mult(dt));
        p3.vel = p3.vel.add(div.mult(dt));
        p4.vel = p4.vel.add(div.mult(dt));
      }
    }
    
    // fix top
    for (int i = 0; i < cloth.length; i++) {
      for (int j = 0; j < cloth[i].length; j++) {
        Point p = cloth[i][j];
        //p.vn = p.vn.add(g);
        //p.vn = p.vn.add(new Vector(0, 0.1, 0));
        if (i == 0) {
          p.vn = new Vector(0,0,0);
          //p.pos = new Vector(topX + i*restLen,topY, topZ-j* restLen);
          p.pos = new Vector(topX + j*restLen, topY + i*restLen, 0);
        }
        p.vel = p.vn;
        p.pos = p.pos.add(p.vel.mult(dt));
      }
    } // fix top
    
  } // update physics
  
  // find drag on quads
  Vector findDrag(int i, int j) {
    Point p = cloth[i][j];
    Point p2 = cloth[i][j+1];
    Point p3 = cloth[i+1][j];
    Point p4 = cloth[i+1][j+1];
    
    Vector vert = p3.pos.sub(p.pos);
    Vector horiz = p2.pos.sub(p.pos);
    Vector cross = horiz.cross(vert);
    
    // slide 22
    //Vector sum = p.vel.add(p2.vel.add(p3.vel.add(p4.vel)));
    Vector sum = p.vn.add(p2.vn.add(p3.vn.add(p4.vn)));
    Vector v = sum.div(4).sub(airV);
    
    //Vector n = p.pos.sub(p2.pos).cross(p.pos.sub(p3.pos)).normalize();
    Vector n = cross.normalize();
    
    float a = cross.mag() * (v.dot(n)/v.mag());
    
    di = n.mult(sq(v.mag()) * -0.5 * ap * cd * a);
    return n.mult(sq(v.mag()) * -0.5 * ap * cd * a);
  } // find drag


  void setNeighbors() {
    for (int i = 0; i < cloth.length; i++) {
      for (int j = 0; j < cloth[i].length; j++) {
        Point p = cloth[i][j];
        if (i != 0) p.neighbors.add(cloth[i-1][j]);
        if (j != 0) p.neighbors.add(cloth[i][j-1]);
        if (i != cloth.length - 1) {
          p.neighbors.add(cloth[i+1][j]);
          p.link_neighbors.add(cloth[i+1][j]);
        }
        if (j != cloth[i].length - 1) {
          p.neighbors.add(cloth[i][j+1]);
          p.link_neighbors.add(cloth[i][j+1]);
        }
      }
    }
  } // set neighbors
  
  void incFrames() {
    for (Point p : burns) {
      p.frames++;
    }
  } // increment frames
  
  void spreadBurn() {
    if (burns.size() == cloth.length*cloth[0].length) return;
    
    ArrayList<Point> newburns = new ArrayList<Point>();
    for (Point p : burns) {
      //if ((p.frames % 30) != 0 || p.neighbors.size() == 0) continue;
      if ((p.frames % 20) != 0 || p.neighbors.size() == 0) continue;
      
      ArrayList<Point> removes = new ArrayList<Point>();
      for (Point pn : p.neighbors) {
        if (!burns.contains(pn)) {
          //burns.add(pn);
          newburns.add(pn);
          removes.add(pn);
          pn.burning = true;
        }
      }
      p.neighbors.removeAll(removes);
    }
    
    burns.addAll(newburns);
  } // spread burn
  
  void doneBurn() {
    for (int i = burns.size()-1; i >= 0; i--) {
      if (burns.get(i).frames >= (360 + random(21))) { 
        burns.get(i).burning = false;
        burns.get(i).link_neighbors.clear();
        burns.remove(i);
      }
    }
  }
  
}
