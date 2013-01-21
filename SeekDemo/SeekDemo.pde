/*
 *
 * The SeekDemo sketch
 *
 */

Agent seeker; // A Seek-based agent
Agent arriver; // An Arrive-based agent
Seek seek; // The seeker's steering behaviour
Arrive arrive; // The arriver's steering behaviour
boolean pause; // Are we paused?
boolean showInfo; // Is this information panel being displayed?
boolean controlSeek = true; // Are we controlling the Seek agent? (Otherwise the Arrive agent)

// Initialisation
void setup() {
  size(1000, 600); // Large display window
  pause = false;
  showInfo = true;
  
  // Create the agents
  seeker = new Agent(10, 10, randomPoint());
  arriver = new Agent(10, 10, randomPoint());
  
  // Create their behaviours
  PVector agentTarget = randomPoint(); // Ensure they target the same point
  seek = new Seek(seeker, agentTarget, 10);
  arrive = new Arrive(arriver, agentTarget, 10);
  // Add the behaviours to the agents
  seeker.behaviours.add(seek);
  arriver.behaviours.add(arrive);

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
    seeker.update();
    arriver.update();
  }
  
  // Draw the agents, with different colours
  color c1 = #00CCFF;
  color c2 = #FF00CC;
  color cLine = #000000;
  if (controlSeek) {
    seeker.draw(cLine, c1);
    arriver.draw(c2, c2);
  } else {
    seeker.draw(c1, c1);
    arriver.draw(cLine, c2);
  }
  
  // Draw the information panel
  if (showInfo) drawInfoPanel();
}
  
// Draw the information panel!
void drawInfoPanel() {
  pushStyle(); // Push current drawing style onto stack
  fill(0);
  text("1 - toggle display", 10, 20);
  text("2 - toggle annotation", 10, 35);
  if (controlSeek) {
    text("3 - toggle agent  [Seek (blue)] |  Arrive (pink) ", 10, 50);
    text("Space - play/pause", 10, 65);
    text("Mass (q/a) = " + seeker.mass, 10, 80);
    text("Max. Force (w/s) = " + seeker.maxForce, 10, 95);
    text("Max. Speed (e/d) = " + seeker.maxSpeed, 10, 110);
    text("Click to move the target", 10, 125);
  } else {
    text("3 - toggle agent   Seek (blue)  | [Arrive (pink)]", 10, 50);
    text("Space - play/pause", 10, 65);
    text("Mass (q/a) = " + arriver.mass, 10, 80);
    text("Max. Force (w/s) = " + arriver.maxForce, 10, 95);
    text("Max. Speed (e/d) = " + arriver.maxSpeed, 10, 110);
    text("Stopping Distance (r/f) = " + arriver.stoppingDistance, 10, 125);
    text("Click to move the target", 10, 140);
  }
  popStyle(); // Retrieve previous drawing style
}

/*
 * Input handlers
 */

// Mouse clicked, so move the target
void mouseClicked() {
  seek.target = new PVector(mouseX, mouseY);
  arrive.target = new PVector(mouseX, mouseY); 
}

// Key pressed
void keyPressed() {
  if (key == ' ') {
    pause = !pause;
  } else if (key == '1' || key == '!') {
    showInfo = !showInfo;

  } else if (key == '2' || key == '@') {
    if (controlSeek) {
      seeker.toggleAnnotate();
    } else {
      arriver.toggleAnnotate();
    }

  } else if (key == '3' || key == '£') {
    controlSeek = !controlSeek;
  
  // Vary the agent's mass
  } else if (key == 'q' || key == 'Q') {
    if (controlSeek) {
      seeker.incMass();
    } else {
      arriver.incMass();
    }
  } else if (key == 'a' || key == 'A') {
    if (controlSeek) {
      seeker.decMass();
    } else {
      arriver.decMass();
    }

  // Vary the agent's maximum force
  } else if (key == 'w' || key == 'W') {
    if (controlSeek) {
      seeker.incMaxForce();
    } else {
      arriver.incMaxForce();
    }
  } else if (key == 's' || key == 'S') {
    if (controlSeek) {
      seeker.decMaxForce();
    } else {
      arriver.decMaxForce();
    }

  // Vary the agent's maximum speed
  } else if (key == 'e' || key == 'E') {
    if (controlSeek) {
      seeker.incMaxSpeed();
    } else {
      arriver.incMaxSpeed();
    }
  } else if (key == 'd' || key == 'D') {
    if (controlSeek) {
      seeker.decMaxSpeed();
    } else {
      arriver.decMaxSpeed();
    }
  
  // Vary the Arrive-based agent's stopping distance
  } else if ((key == 'r' || key == 'R') && !controlSeek) {
    arriver.incStoppingDistance();
  } else if ((key == 'f' || key == 'F') && !controlSeek) {
    arriver.decStoppingDistance();
  }
}
