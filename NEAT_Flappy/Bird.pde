class Bird {

  float y;
  float x = 64.0;

  float vel = -10;
  float acc = .6;

  boolean dead = false;
  NeuralNet brain;

  float fitness;
  float score = 0;

  boolean best = false;

  Bird() {
    y = height/2;
    brain = new NeuralNet(5, 8, 1);
  }

  Bird(NeuralNet brain) {
    y = height/2;
    this.brain = brain;
  }

  void goUp(ArrayList<Pipe> pipes) {
    Pipe closest = pipes.get(0);
    for (Pipe p : pipes) {
      if (closest.x > p.x && p.x - 50 > x) {
        closest = p;
      }
    }

    float[][] inputs = {{(closest.x - x)/width}, {y/height}, {vel/10}, {closest.top/height}, {closest.spacing/height}};
    Matrix out = brain.feedforward(new Matrix(1, 1).fromArray(inputs));
    //println(out.table[0][0]);
    if (out.table[0][0] > .5)
      vel = -8;
  }

  void kill(Pipe p) {
    if (x > p.x && x < p.x + 50) {
      if (y < p.top || y > p.top + p.spacing) {
        dead = true;
      }
    }
  }

  void calcFitness() {
    fitness = (score > 0) ? 10*score*score + counter/100.0 : 0.0001;
  }

  void show(boolean isBest) {
    // draw beak
    fill(255, 0, 0);
    triangle(x + 10, y - 10, x + 10, y + 10, x + 20, y);
    // draw bird
    if (isBest) {
      fill(0, 255, 0);
      noStroke();
      ellipse(x, y, 25, 25);
      fill(255, 255, 0);
      ellipse(x, y, 15, 15);
    } else {
      fill(255, 255, 0, 150);
      noStroke();
      ellipse(x, y, 25, 25);
    }
    fill(0, 0, 0);
    textSize(20);
    text(int(score) + "", x, y);
  }

  void update(boolean isBest) {
    if (!dead) {
      vel += acc;
      y += vel;

      dead = y > height - 25 || y < 25;

      show(isBest);
      goUp(pipes);
      for (Pipe p : pipes)
        kill(p);
    } else {
    }
  }
}