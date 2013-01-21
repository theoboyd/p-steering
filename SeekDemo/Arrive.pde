/*
 * The Arrive Steering Behaviour
 */
class Arrive extends Steering {
  
  // Position/size of target
  PVector target;
  float radius;
  
  // Initialisation
  Arrive(Agent a, PVector t, float r) {
      super(a);
      target = t;
      radius = r;
  }
  
  PVector calculateRawForce() {
    // Check that agent's centre is not over target
    if (PVector.dist(target, agent.position) > radius) {
      // Calculate Arrive Force
      
      // Calculate target distance
      float dStop = agent.stoppingDistance;
      PVector dOffDiff = PVector.sub(target, agent.position);
      float dOff = dOffDiff.mag();
      
      // Calculate ideal speed
      float idealSpeed;
      if (dOff > dStop) {
        idealSpeed = agent.maxSpeed;
      } else {
        idealSpeed = ((agent.maxSpeed) * (dOff / dStop));
      }
      
      PVector arrive = PVector.sub(target, agent.position);
      arrive.normalize();
      arrive.mult(idealSpeed);
      arrive.sub(agent.velocity);
      return arrive;
    } else  {
      // If agent's centre is over target stop arriving
      return new PVector(0,0); 
    }   
  }
  
  // Draw the target
  void draw() {
    pushStyle();
    fill(204, 153, 0);
    ellipse(target.x, target.y, radius, radius);
    popStyle();
  }
}
