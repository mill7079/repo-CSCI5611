public class CrowdAgent extends Agent {
  
  float stick_force = 4; // lower is more powerful
  float align_force = 20; // lower is more powerful, lower values tend to leave things behind the obstacle
  float sep_rad = 0.5; // higher is more powerful
  float goal_force = 2; //higher is more powerful
  Vector vel;
  float target_speed = 3;
  
  public CrowdAgent(float r, color c, Point o, Point g) {
    super(r, c, o, g);
    
    sep_force = 2.5;
    //goal.pos = user.pos;
    vel = g.pos.sub(o.pos).normalize();
    
  }

  public Vector cohesion() {
    Vector pull = new Vector(0,0,0);
    float stick_count = 0;
    for (Agent a : agents) {
      if (a == this) continue;
      pull = pull.add(a.pos);
      stick_count++;
    }
    
    //if (agents.size() != 1) pull = pull.div(agents.size()-1);
    if (stick_count > 0) pull = pull.div(stick_count);
    return (pull.sub(pos)).mult(1/stick_force);
  }
  //public Vector cohesion() {
  //  Vector pull = new Vector(0,0,0);
  //  float stick_count = 0;
    
  //  for (Agent a : agents) {
  //    if (a == this) continue;
  //    float dist = pos.sub(a.pos).mag();
  //    if (dist < (rad + stick_rad)) {
  //      pull = pull.add(a.pos);
  //      stick_count++;
  //    }
  //  }
    
  //  if (stick_count > 0) {
  //    pull = pull.div(stick_count);
  //    //return pull.normalize();
  //    if (agents.contains(user)) return pull.add(goal.pos.sub(pos));
  //    return pull.add(goal());
  //  }
  //  return new Vector(0,0,0);
  //}
  
  public Vector align() {
    Vector vel_sum = new Vector(0,0,0);
    float align_count = 0;
    for (Agent a : agents) {
      if (a == this) continue;
      if (a == user) vel_sum = vel_sum.add(user.vel); 
      else vel_sum = vel_sum.add(((CrowdAgent)a).vel);
      align_count++;
    }
    
    if (align_count > 0) vel_sum = vel_sum.div(agents.size() - 1);
    //if (agents.size() != 1) vel_sum = vel_sum.div(agents.size() - 1);
    return (vel_sum.sub(vel)).mult(1/align_force);
  }
  //public Vector align() {
  //  Vector vel_sum = new Vector(0,0,0);
  //  float align_count = 0;
  //  for (Agent a : agents) {
  //    float dist = pos.sub(a.pos).mag();
  //    if (dist < (rad + align_rad)) {
  //      if (a == user) vel_sum.add(user.vel);
  //      else vel_sum.add(((CrowdAgent)a).vel);
  //      align_count++;
  //    }
  //  }
    
  //  if (align_count > 0) {
  //    vel_sum = vel_sum.div(align_count);
  //    //return vel_sum.normalize();
  //    if (agents.contains(user)) return vel_sum.add(goal.pos.sub(pos));//.normalize();
  //    return vel_sum.add(goal());
  //  }
  //  return new Vector(0,0,0);
  //}
  
  public Vector separate() {
    Vector push = new Vector(0,0,0);
    for (Agent a : agents) {
      if (a != this) {
        //if (a.pos.sub(pos).mag() < (a.rad+rad)) {
        if (a.pos.sub(pos).mag() < (sep_rad+a.rad)) {
          push = push.sub(a.pos.sub(pos));
        }
      }
    }
    
    for (Obstacle o : obstacles) {
      if (o.pos.sub(pos).mag() < (((Sphere)o).rad + rad)) {
        push = push.sub(o.pos.sub(pos));
      }
    }
    return push;
  }
  //public Vector separate() {
  //  Vector push = new Vector(0,0,0);
  //  int count = 0;
    
  //  for (Agent a : agents) {
  //    if (this == a) continue;
  //    float overlap = near(a);
  //    if (overlap > 0) {
  //      push = push.add(pos.sub(a.pos).normalize().mult(overlap*(this.sep_force/2)));
  //      count++;
  //    }
  //  }
    
  //  for (Obstacle o : obstacles) {
  //    float overlap = near(o);
  //    if (overlap > 0) {
  //      push = push.add(pos.sub(o.pos).normalize().mult(overlap*(obs_sep_force/2)));
  //      count++;
  //    }
  //  }
    
  //  if (count > 0) push = push.div(count);
  //  return push;
  //}
  
  public Vector goal() {
    Vector t_vel = new Vector(0,0,0);
    for (int i = path.size() - 1; i >= 0; i--) {
      if (goodPath(pos, path.get(i))) {
        t_vel = path.get(i).sub(pos).normalize().mult(target_speed);
        break;
      }
    }
    return t_vel.sub(vel).mult(goal_force);
    
  }
  
  //public Vector goal() {
  //  for (int i = path.size() - 1; i >= 0; i--) {
  //      if (goodPath(pos, path.get(i))) {
  //        //pos = pos.add(path.get(i).sub(pos).normalize().mult(dt));
  //        return path.get(i).sub(pos).normalize();
  //    }
  //  }
  //  return new Vector(0,0,0);
  //}

  public void update() {
    if (agents.contains(user)) goal.pos = user.pos;
    Vector f = new Vector(0,0,0);
    
    // boids cohesion
    f = f.add(cohesion());
    //println("f after cohesion",f);
    
    // boids alignment
    f = f.add(align());
    //println("f after align",f);
    
    // boids separation
    f = f.add(separate());
    //f = f.add(separate().mult(2));
    //println("f after separate",f);
    
    // goal force
    f = f.add(goal());
    //println("f after goal",f);
    
    //if (f.mag() > 1) f = f.normalize();
    //f = f.add(goal());
    //println("f: ",f);
    // vel = vel.add(f.mult(dt));
    vel = vel.add(f.mult(dt));
    //if (vel.mag() > 1) vel = vel.normalize();
    pos = pos.add(vel.mult(dt));
    
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
  }
  
}
