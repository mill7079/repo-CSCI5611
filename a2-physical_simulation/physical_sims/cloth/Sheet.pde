public class Cloth {
  
  Point[][] cloth;
  
  float topX, topY, topZ;
  float ks, kd, restLen;
  
  float mass = 1.5;
  
  // gravity
  Vector g = new Vector(0, 9.8, 0);
  
  public Cloth() {
    ks = 600;
    kd = 400;
    restLen = 5;
    
    topX = 10;
    topY = 10;
    topZ = -120;
    
    cloth = new Point[20][20];
    for (int i = 0; i < cloth.length; i++) {
      for (int j = 0; j < cloth[i].length; j++) {
        cloth[i][j] = new Point(new Vector(topX + i*restLen,topY, topZ-j* restLen), new Vector(0,0,0));
      }
    }
  }
  
  void handleCollisions() {
    for (int i = 0; i < cloth.length; i++) {
      for (int j = 0; j < cloth[0].length; j++) {
        Point p = cloth[i][j];
        
        for (Obstacle o : obstacles) {
          if (!(o instanceof Sphere)) continue;
          
          Sphere s = (Sphere)o;
          float dist = o.pos.sub(p.pos).mag();
          
          if (dist <= s.radius + 0.09) {
            Vector normal = s.pos.sub(p.pos).mult(-1).normalize();
            Vector bounce = normal.mult(p.vel.dot(normal));
            //this.ClothParticle[i][j].vel.sub(PVector.mult(bounce,1+e_ball));
            p.vel = p.vel.sub(bounce.mult(1.5));
            //this.ClothParticle[i][j].pos.add(PVector.mult(n,.1+radius-d));// move out
            p.pos = p.pos.add(normal.mult(0.1 + s.radius - dist));
          }
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
        p0.pos = p0.pos.add(p0.vn.mult(dt).add(g.mult(0.5*dt*dt)));
        p0.vn = p0.vn.add(g.mult(dt));
        
        if (i != cloth.length-1) {
          Point p = cloth[i+1][j];
          
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
    } // vertical
    
    // horizontal
    for (int i = 0; i < cloth.length; i++) {
      for (int j = 0; j < cloth[i].length; j++) {
        Point p0 = cloth[i][j];
        p0.pos = p0.pos.add(p0.vn.mult(dt).add(g.mult(0.5*dt*dt)));
        p0.vn = p0.vn.add(g.mult(dt));
        
        if (j != cloth[i].length-1) {
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
    
    // fix top
    for (int i = 0; i < cloth.length; i++) {
      for (int j = 0; j < cloth[i].length; j++) {
        Point p = cloth[i][j];
        //p.vn = p.vn.add(g);
        p.vn = p.vn.add(new Vector(0, 0.1, 0));
        if (i == 0) {
          p.vn = new Vector(0,0,0);
          p.pos = new Vector(topX + i*restLen,topY, topZ-j* restLen);
        }
        p.vel = p.vn;
        p.pos = p.pos.add(p.vel.mult(dt));
      }
    } // fix top
    
  }
  
}
