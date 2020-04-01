public class CrowdAgent extends Agent {
  
  float stick_rad = 3.5;
  float align_rad = 3.5;
  Vector vel;
  
  public CrowdAgent(float r, color c, Point o, Point g) {
    super(r, c, o, g);
    
    sep_force = 1.5;
    vel = new Vector(0,0,0);
    
  }
  
  public void update() {
    vel = new Vector(0,0,0);
    
    // boids cohesion
    int stick_count = 0;
    Vector pull = new Vector(0,0,0);
    for (Agent a : agents) {
      if (this == a) continue;
      if (a.pos.sub(pos).mag() <= a.rad + stick_rad) {
        stick_count++;
        pull = pull.add(a.pos.sub(pos).mult(dt));
      }
    }
    if (stick_count > 0) vel = vel.add(pull.div(stick_count));
    
    // boids alignment
    int align_count = 0;
    Vector vel_sum = new Vector(0,0,0);
    for (Agent a : agents) {
      if (a == user) {
        if (user.pos.sub(pos).mag() <= user.rad + align_rad) {
          align_count++;
          vel_sum = vel_sum.add(user.vel).mult(dt);
        }
      } else {
        CrowdAgent b = (CrowdAgent) a;
        if (b.pos.sub(pos).mag() <= b.rad + align_rad) {
          align_count++;
          vel_sum = vel_sum.add(b.vel).mult(dt);
        }
      }
    }
    if (align_count > 0) vel = vel.add(vel_sum.div(align_count));
    
    // boids separation
    Vector push = new Vector(0,0,0);
    int count = 0;
    for (Agent a : agents) {
      if (this == a) continue;
      float overlap = near(a);
      if (overlap > 0) {
        push = push.add(pos.sub(a.pos).normalize().mult(overlap*(sep_force/2)));
        count++;
      }
    }
    
    for (Obstacle o : obstacles) {
      float overlap = near(o);
      if (overlap > 0) {
        push = push.add(pos.sub(o.pos).normalize().mult(overlap*(obs_sep_force/2)));
        count++;
      }
    }
    
    //if (count > 0) vel = vel.add(push.div(count).mult(dt));
    if (count > 0) vel = vel.add(push.div(count));
    
    // avoid overlapping obstacles and other agents
    for (int i = path.size() - 1; i >= 0; i--) {
      for (Obstacle o : obstacles) {
        Sphere s = (Sphere) o;
        if (rad + s.rad + 0.05 >= s.pos.sub(pos).mag()) {
          Vector normal = s.pos.sub(pos).mult(-1).normalize();
          pos = pos.add(normal.mult(0.05 + (s.rad + rad) - (s.pos.sub(pos).mag())));
        }
      }
      
      for (Agent a : agents) {
        if (this == a) continue;
        if (rad + a.rad + 0.05 >= a.pos.sub(pos).mag()) {
          Vector normal = a.pos.sub(pos).mult(-1).normalize();
          pos = pos.add(normal.mult(0.05 + (a.rad + rad) - (a.pos.sub(pos).mag())));
        }
      }
      /*
      // goal force
      if (goodPath(pos, path.get(i))) {
        pos = pos.add(path.get(i).sub(pos).normalize().mult(dt));
        break;
      }
      */
      pos = pos.add(vel.mult(dt));
    }
  }
  
}
