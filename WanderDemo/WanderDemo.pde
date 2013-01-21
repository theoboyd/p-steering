/*
 *
 * The WanderDemo sketch
 *
 */

Agent wanderer; // A Wander-based agent
Wander wander; // The wanderer's steering behaviour
boolean pause; // Are we paused?
boolean showInfo; // Is this information panel being displayed?

// Initialisation
void setup() {
  size(1000, 600); // Large display window
  pause = false;
  showInfo = true;
  
  // Create the agent
  wanderer = new Agent(10, 10, randomPoint());
  
  // Create its behaviour
  wander = new Wander(wanderer, randomPoint(), 10);
  // Add the behaviour to the agent
  wanderer.behaviours.add(wander);
 
  smooth(); // Anti-aliasing on
}

// Pick a random point in the display window
PVector randomPoint() {
  return new PVector(random(width), random(height));
}

// The draw loop
void draw() {
  // Clear the display
  background(255);
  
  // Move forward one step in steering simulation
  if (!pause) {
    wanderer.update();
  }
  
  // Wrap around if agent near edge
  float r = wanderer.wanderDistance + wanderer.wanderRadius;
  if (wanderer.position.x <= 0 - r) {
    wanderer.position.x = width + r;
  } else if (wanderer.position.x >= width + r) {
    wanderer.position.x = 0 - r;
  }
  if (wanderer.position.y <= 0 - r) {
    wanderer.position.y = height + r;
  } else if (wanderer.position.y >= height + r) {
    wanderer.position.y = 0 - r;
  }
  
  // Draw the agent
  color c1 = #CCFF00;
  color cLine = #000000;
  wanderer.draw(cLine, c1);
  
  // Draw the information panel
  if (showInfo) drawInfoPanel();
}
  
// Draw the information panel!
void drawInfoPanel() {
  pushStyle(); // Push current drawing style onto stack
  fill(0);
  text("1 - toggle display", 10, 20);
  text("2 - toggle annotation", 10, 35);
  text("Space - play/pause", 10, 50);
  text("Mass (q/a) = " + wanderer.mass, 10, 65);
  text("Max. Force (w/s) = " + wanderer.maxForce, 10, 80);
  text("Max. Speed (e/d) = " + wanderer.maxSpeed, 10, 95);
  text("Target Jitter (r/f) = " + wanderer.targetJitter, 10, 110);
  text("Wander Radius (t/g) = " + wanderer.wanderRadius, 10, 125);
  text("Wander Distance (y/h) = " + wanderer.wanderDistance, 10, 140);
  popStyle(); // Retrieve previous drawing style
}

/*
 * Input handlers
 */

// Key pressed
void keyPressed() {
  if (key == ' ') {
    pause = !pause;
  } else if (key == '1' || key == '!') {
    showInfo = !showInfo;

  } else if (key == '2' || key == '@') {
    wanderer.toggleAnnotate();

  // Vary the agent's mass
  } else if (key == 'q' || key == 'Q') {
    wanderer.incMass();
  } else if (key == 'a' || key == 'A') {
    wanderer.decMass();

  // Vary the agent's maximum force
  } else if (key == 'w' || key == 'W') {
    wanderer.incMaxForce();
  } else if (key == 's' || key == 'S') {
    wanderer.decMaxForce();

  // Vary the agent's maximum speed
  } else if (key == 'e' || key == 'E') {
    wanderer.incMaxSpeed();
  } else if (key == 'd' || key == 'D') {
    wanderer.decMaxSpeed();
    
  // Vary the agent's target jitter
  } else if (key == 'r' || key == 'R') {
    wanderer.incTargetJitter();
  } else if (key == 'f' || key == 'F') {
    wanderer.decTargetJitter();
    
  // Vary the agent's wander radius
  } else if (key == 't' || key == 'T') {
    wanderer.incWanderRadius();
  } else if (key == 'g' || key == 'G') {
    wanderer.decWanderRadius();
    
  // Vary the agent's wander distance
  } else if (key == 'y' || key == 'Y') {
    wanderer.incWanderDistance();
  } else if (key == 'h' || key == 'H') {
    wanderer.decWanderDistance();
  }
}
