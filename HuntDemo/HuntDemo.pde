/*
 *
 * The HuntDemo sketch
 *
 */

Agent hunter; // A Seek or Pursue-based agent
Agent prey; // A Flee or Evade-based agent
Seek seek; // One of the hunter's steering behaviours
Pursue pursue; // One of the hunter's steering behaviours
Flee flee; // One of the prey's steering behaviours
Evade evade; // One of the prey's steering behaviours
Wander wanderH; // Wander behaviour to add realism and edge detection
Wander wanderP;
boolean pause; // Are we paused?
boolean showInfo; // Is this information panel being displayed?
boolean controlHunter = true; // Are we controlling the hunter agent? (Otherwise the prey agent)
boolean hunterSeeking = true; // Is the hunter using Seek? (Otherwise Pursue)
boolean preyFleeing = true; // Is the hunter using Flee? (Otherwise Evade)
float timeToTargetK = 10; // Time to target K value for Pursue and Evade
static int preyCaught = 0;

// Initialisation
void setup() {
  size(1000, 600); // Large display window
  pause = false;
  showInfo = true;
  
  // Create the agents
  hunter = new Agent(10, 10, randomPoint());
  prey = new Agent(10, 10, randomPoint());
  
  setBehaviours();

  smooth(); // Anti-aliasing on
}

void setBehaviours() {
  hunter.behaviours.clear(); // Remove the old behaviour
  prey.behaviours.clear(); // Remove the old behaviour
  
  // Set and add the behaviours
  if (hunterSeeking) {
    seek = new Seek(hunter, prey.position, 10);
    hunter.behaviours.add(seek);
  } else {
    pursue = new Pursue(hunter, prey, 10, timeToTargetK);
    hunter.behaviours.add(pursue);
  }
  
  if (preyFleeing) {
    flee = new Flee(prey, hunter, 10);
    prey.behaviours.add(flee);
  } else {
    evade = new Evade(prey, hunter, 10, timeToTargetK);
    prey.behaviours.add(evade);
  }
  
  // Additionally add a wander behaviour to both
  // to assist with wall avoidance and to add realism
  wanderH = new Wander(hunter, randomPoint(), 10);
  wanderP = new Wander(prey, randomPoint(), 10);
  hunter.behaviours.add(wanderH);
  prey.behaviours.add(wanderP);
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
    hunter.update();
    prey.update();
  }
  
  // Draw the agents, with different colours
  color c1 = #00CCFF;
  color c2 = #FF00CC;
  color cLine = #000000;
  if (controlHunter) {
    hunter.draw(cLine, c1);
    prey.draw(c2, c2);
  } else {
    hunter.draw(c1, c1);
    prey.draw(cLine, c2);
  }
  
  if (PVector.dist(hunter.position, prey.position) <= 10) {
    // Prey was caught
    preyCaught++;
    
    // Move away now prey has been caught
    hunter.position = randomPoint();
    prey.position = randomPoint();
    setBehaviours();
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
  if (controlHunter) {
    text("3 - toggle agent  [Hunter (blue)] |  Prey (pink) ", 10, 50);
    if (hunterSeeking) {
      text("4 - toggle hunter behaviour  [Seek] |  Pursue ", 10, 65);
    } else {
      text("4 - toggle hunter behaviour   Seek  | [Pursue]", 10, 65);
    }
    text("Space - play/pause", 10, 80);
    text("Mass (q/a) = " + hunter.mass, 10, 95);
    text("Max. Force (w/s) = " + hunter.maxForce, 10, 110);
    text("Max. Speed (e/d) = " + hunter.maxSpeed, 10, 125);
  } else {
    text("3 - toggle agent   Hunter (blue)  | [Prey (pink)]", 10, 50);
    if (preyFleeing) {
      text("4 - toggle prey behaviour  [Flee] |  Evade ", 10, 65);
    } else {
      text("4 - toggle prey behaviour   Flee  | [Evade]", 10, 65);
    }
    text("Space - play/pause", 10, 80);
    text("Mass (q/a) = " + prey.mass, 10, 95);
    text("Max. Force (w/s) = " + prey.maxForce, 10, 110);
    text("Max. Speed (e/d) = " + prey.maxSpeed, 10, 125);
  }
  text("Time to target K value (r/f) = " + timeToTargetK, 10, 140);
  text("Prey caught " + preyCaught + " times", 10, 155);
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
    if (controlHunter) {
      hunter.toggleAnnotate();
    } else {
      prey.toggleAnnotate();
    }

  } else if (key == '3' || key == '£') {
    controlHunter = !controlHunter;

  } else if (key == '4' || key == '$') {
    // Depending on the selected agent, toggle its behaviour
    if (controlHunter) {
      hunterSeeking = !hunterSeeking;
    } else {
      preyFleeing = !preyFleeing;
    }
    setBehaviours();

  // Vary the agent's mass
  } else if (key == 'q' || key == 'Q') {
    if (controlHunter) {
      hunter.incMass();
    } else {
      prey.incMass();
    }
  } else if (key == 'a' || key == 'A') {
    if (controlHunter) {
      hunter.decMass();
    } else {
      prey.decMass();
    }

  // Vary the agent's maximum force
  } else if (key == 'w' || key == 'W') {
    if (controlHunter) {
      hunter.incMaxForce();
    } else {
      prey.incMaxForce();
    }
  } else if (key == 's' || key == 'S') {
    if (controlHunter) {
      hunter.decMaxForce();
    } else {
      prey.decMaxForce();
    }

  // Vary the agent's maximum speed
  } else if (key == 'e' || key == 'E') {
    if (controlHunter) {
      hunter.incMaxSpeed();
    } else {
      prey.incMaxSpeed();
    }
  } else if (key == 'd' || key == 'D') {
    if (controlHunter) {
      hunter.decMaxSpeed();
    } else {
      prey.decMaxSpeed();
    }
  
  // Vary the time to target K value
  } else if (key == 'r' || key == 'R') {
    timeToTargetK++;
  } else if (key == 'f' || key == 'F') {
    timeToTargetK--;
    if (timeToTargetK < 1) timeToTargetK = 1;
  }
}
