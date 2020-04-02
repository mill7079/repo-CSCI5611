public class CrowdAgent extends Agent {
  
  float stick_rad = 0.5;
  float align_rad = 0.5;
  Vector vel;
  
  public CrowdAgent(float r, color c, Point o, Point g) {
    super(r, c, o, g);
    
    sep_force = 1.5;
    goal.pos = user.pos;
    vel = g.pos.sub(o.pos).normalize();
    
  }
/*  
  PVector cohesion (ArrayList<Boid> boids) {
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float neighbordist = (2*this.r+other.r)*mag;
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
}*/

  public Vector cohesion() {
    Vector pull = new Vector(0,0,0);
    float stick_count = 0;
    
    for (Agent a : agents) {
      if (a == this) continue;
      float dist = pos.sub(a.pos).mag();
      if (dist < (rad + stick_rad)) {
        pull = pull.add(a.pos);
        stick_count++;
      }
    }
    
    if (stick_count > 0) {
      pull = pull.div(stick_count);
      //seek?
      //return pull.normalize();
      if (agents.contains(user)) return pull.add(goal.pos.sub(pos));
      return pull.add(goal());
      //return pull.add(goal().normalize());
    }
    return new Vector(0,0,0);
  }

  //public Vector cohesion() {
  //  int stick_count = 0;
  //  Vector pull = new Vector(0,0,0);
  //  /*for (Agent a : agents) {
  //    if (this == a) continue;
  //    if (a.pos.sub(pos).mag() <= a.rad + stick_rad) {
  //      stick_count++;
  //      pull = pull.add(a.pos.sub(pos).mult(dt));
  //    }
  //  }
  //  //if (stick_count > 0) vel = vel.add(pull.div(stick_count));
  //  if (stick_count > 0) f = f.add(pull.div(stick_count));*/
    
  //  for (Agent a : agents) {
  //    if (a.pos.sub(pos).mag() <= a.rad + stick_rad) {
  //      stick_count++;
  //      pull = pull.add(a.pos);
  //    }
  //  }
  //  //if (stick_count > 0) f = f.add(pull.div(stick_count)).normalize();
  //  if (stick_count > 0) pull = pull.div(stick_count).normalize();
  //  return pull;
  //}
  
  public Vector align() {
    Vector vel_sum = new Vector(0,0,0);
    float align_count = 0;
    for (Agent a : agents) {
      float dist = pos.sub(a.pos).mag();
      if (dist < (rad + align_rad)) {
        if (a == user) vel_sum.add(user.vel);
        else vel_sum.add(((CrowdAgent)a).vel);
        align_count++;
      }
    }
    
    if (align_count > 0) {
      vel_sum = vel_sum.div(align_count);
      //return vel_sum.normalize();
      if (agents.contains(user)) return vel_sum.add(goal.pos.sub(pos));//.normalize();
      return vel_sum.add(goal());
    }
    return new Vector(0,0,0);
  }
  
  //public Vector align() {
  //  int align_count = 0;
  //  Vector vel_sum = new Vector(0,0,0);
  //  for (Agent a : agents) {
  //    /*if (a == user) {
  //      if (user.pos.sub(pos).mag() <= user.rad + align_rad) {
  //        align_count++;
  //        vel_sum = vel_sum.add(user.vel).mult(dt);
  //      }
  //    } else {*/
  //      CrowdAgent b = (CrowdAgent) a;
  //      if (b.pos.sub(pos).mag() <= (b.rad + align_rad)) {
  //        align_count++;
  //        //vel_sum = vel_sum.add(b.vel).mult(dt);
  //        vel_sum = vel_sum.add(b.vel);
  //      }
  //    }
  //    println("align_count",align_count);
  //  //}
  //  //if (align_count > 0) vel = vel.add(vel_sum.div(align_count));
  //  //if (align_count > 0) f = f.add(vel_sum.div(align_count)).normalize();
  //  if (align_count > 0) vel_sum = vel_sum.div(align_count).normalize();
  //  println("velsum",vel_sum);
  //  return vel_sum;
  //}
  
  public Vector separate() {
    Vector push = new Vector(0,0,0);
    int count = 0;
    
    for (Agent a : agents) {
      if (this == a) continue;
      float overlap = near(a);
      if (overlap > 0) {
        push = push.add(pos.sub(a.pos).normalize().mult(overlap*(this.sep_force/2)));
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
    //if (count > 0) vel = vel.add(push.div(count));
    //if (count > 0) push = push.div(count).normalize();
    if (count > 0) push = push.div(count);
    return push;
  }
  
  public Vector goal() {
    for (int i = path.size() - 1; i >= 0; i--) {
        if (goodPath(pos, path.get(i))) {
          //pos = pos.add(path.get(i).sub(pos).normalize().mult(dt));
          return path.get(i).sub(pos).normalize();
      }
    }
    return new Vector(0,0,0);
  }

  public void update() {
    if (agents.contains(user)) goal.pos = user.pos;
    Vector f = new Vector(0,0,0);
    
    // boids cohesion
    f = f.add(cohesion());
    println("f after cohesion",f);
    
    // boids alignment
    f = f.add(align());
    println("f after align",f);
    
    // boids separation
    f = f.add(separate().mult(2));
    println("f after separate",f);
    
    // goal force
    f = f.add(goal());
    //println("f after goal",f);
    
    // avoid overlapping obstacles and other agents
    for (int i = path.size() - 1; i >= 0; i--) {
      for (Obstacle o : obstacles) {
        Sphere s = (Sphere) o;
        if (rad + s.rad + 0.01 >= s.pos.sub(pos).mag()) {
          Vector normal = s.pos.sub(pos).mult(-1).normalize();
          pos = pos.add(normal.mult(0.01 + (s.rad + rad) - (s.pos.sub(pos).mag())));
        }
      }
      
      for (Agent a : agents) {
        if (this == a) continue;
        if (rad + a.rad + 0.01 >= a.pos.sub(pos).mag()) {
          Vector normal = a.pos.sub(pos).mult(-1).normalize();
          pos = pos.add(normal.mult(0.01 + (a.rad + rad) - (a.pos.sub(pos).mag())));
        }
      }
    }
    
    if (f.mag() > 1) f = f.normalize();
    //f = f.add(goal());
    println("f: ",f);
    vel = vel.add(f.mult(dt));
    if (vel.mag() > 1) vel = vel.normalize();
    pos = pos.add(vel.mult(dt));
  }
  
}
