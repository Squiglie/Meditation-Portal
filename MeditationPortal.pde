import processing.sound.*;

SinOsc sine;
SinOsc sine2;

float xFreq;
float yDif;

int dim;
float globalHue = 0;  // Global hue that slowly shifts over time

SoundFile soundfile;
boolean started = false; // Flag to control when the sketch starts
float volume = 0.0; // Smooth start volume control

void setup() {
  size(360, 640);
  background(255);
  textAlign(CENTER, CENTER);
  textSize(20);
  fill(0);
  text("Press 'S' to start/stop", width / 2, height / 2);
  
  // Create sine oscillators
  sine = new SinOsc(this);
  sine2 = new SinOsc(this);
  
  sine.set(80, 0, 0.0, 1);
  sine2.set(86, 0, 0.0, -1);
  
  dim = 800;
  colorMode(HSB, 360, 100, 100, 255); // Enable alpha transparency
  noStroke();
  ellipseMode(RADIUS);
  frameRate(30);
  
  // Load sound file
  soundfile = new SoundFile(this, "vibraphon.aiff");
}

void draw(){
  if (!started) return; // Only run when 'S' is pressed
  
  background(0, 0, 10); // Dark background for a relaxing feel

  float playbackSpeed = 0.75;
  soundfile.rate(playbackSpeed);
  
  //float panning = map(mouseY, 0, height, -1.0, 1.0);
  //soundfile.pan(panning);
  
  drawGradient(width / 2, height / 2); // Draw gradient in center

  // Smooth volume transition
  if (volume < 0.5) {
    volume += 0.01;
  }

  sine.set(80, volume, 0.0, 1);
  sine2.set(86, volume, 0.0, -1);

  // Slowly shift hue over time
  globalHue = (globalHue + 0.2) % 360;
}

void keyPressed() {
  if (key == 'S' || key == 's') {
    started = !started;
    if (started) {
      volume = 0.0; // Start from zero volume for a smooth fade-in
      sine.play();
      sine2.play();
      soundfile.loop(); // Start sound
    } else {
      sine.stop();
      sine2.stop();
      soundfile.stop(); // Stop sound
      background(255);
      text("Press 'S' to start/stop", width / 2, height / 2);
    }
  }
}

void drawGradient(float x, float y) {
  int radius = dim / 2;
  float h = globalHue; // Use evolving global hue

  for (int r = radius; r > 0; --r) {
    fill(h, 90, 90, map(r, 0, radius, 0, 255)); // Soft fading gradient
    ellipse(x, y, r, r);
    h = (h + 0.05) % 360; // Very slow color shift per ring
  }
}
