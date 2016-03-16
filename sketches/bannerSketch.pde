/** 
 * File: bannerSketch.pde
 * ----------------------
 * This program generates an interactive banner for
 * http://vaibhavsinghal87.github.io/
 *
 * Author: Vaibhav Singhal
 */

Grid[] grids = new Grid[49*9];
int[] colorList = {
// v
49*3+1, 49*3+10,
49*4+2, 49*4+9,
49*5+3, 49*5+8,
49*6+4, 49*6+7,
49*7+5, 49*7+6,
// a
49*3+12, 49*3+13, 49*3+14,
49*4+15,
49*5+12, 49*5+13, 49*5+14, 49*5+15,
49*6+11, 49*6+15,
49*7+12, 49*7+13, 49*7+14, 49*7+15,
// i
49*1+18,
49*3+17, 49*3+18,
49*4+18,
49*5+18,
49*6+18,
49*7+17, 49*7+18, 49*7+19,
// b
49*4+22, 49*4+23, 49*4+24,
49*1+21,
49*2+21,
49*3+21,
49*4+21, 
49*5+21, 49*5+25,
49*6+21, 49*6+25,
49*7+22, 49*7+23, 49*7+24,
// h
49*1+27,
49*2+27,
49*3+27, 49*3+29, 49*3+30,
49*4+27, 49*4+28, 49*4+31,
49*5+27, 49*5+31,
49*6+27, 49*6+31,
49*7+27, 49*7+31,
// a
49*3+34, 49*3+35, 49*3+36,
49*4+37,
49*5+34, 49*5+35, 49*5+36, 49*5+37,
49*6+33, 49*6+37,
49*7+34, 49*7+35, 49*7+36, 49*7+37,
// v
49*3+39, 49*3+48,
49*4+40, 49*4+47,
49*5+41, 49*5+46,
49*6+42, 49*6+45,
49*7+43, 49*7+44
};

void setup() {
  size(851, 315); 
  for (int i = 0; i < 49; i++) {
    for (int j = 0; j < 9; j++) {
      grids[j*49+i] = new Grid(184+i*10, 115.5+j*10);
    }
  }
}

void draw() {
  background(255);
  
  for (int i = 0; i < 49; i++) {
    for (int j = 0; j < 9; j++) {
      grids[j*49+i].resetForce();
      grids[j*49+i].addRepulsionForce(mouseX, mouseY, 800, 1.0f);
      PVector catchPt2 = new PVector(184+i*10, 115.5+j*10);
      PVector diff2 = PVector.sub(catchPt2, grids[j*49+i].pos);
      diff2.div(100.0f);
      grids[j*49+i].addForce(diff2.x, diff2.y);
      grids[j*49+i].addDampingForce();
      
      for (int k = 0; k < colorList.length; k++) {
        if (colorList[k] == j*49+i) {
          stroke(0, 0, 0);
          fill(0, 0, 0);
          grids[j*49+i].run();
        }
      }
    }
  }
}

class Grid {
  PVector pos;
  PVector vel;
  PVector acc;
  float damping;
  PVector originalPos;
	
  Grid(float px, float py) {
    pos = new PVector(px, py);
    vel = new PVector();
    acc = new PVector();
    damping = 0.05f;
    originalPos = pos;
  }
	
  void resetForce() {
    acc.set(0.0f, 0.0f, 0.0f);
  }
	
  void addRepulsionForce(float x, float y, float radius, float scale) {
    PVector posOfForce;	
    posOfForce = new PVector(x, y, 0);
		
    PVector diff = PVector.sub(pos, posOfForce);
    float length = diff.mag();
		
    boolean isCloseEnough = true;
    if (radius > 0) {
      if (length > radius) {
        isCloseEnough = false;
      }
    }
		
    if (isCloseEnough) {
      float pct = 1 - (length / radius);
      diff.normalize();
      acc.x = acc.x + diff.x * scale * pct;
      acc.y = acc.y + diff.y * scale * pct;
    }
  }
	
  void run() {
    update();
    render();
  }
	
  void update() {
    vel.add(acc);
    pos.add(vel);
  }
	
  void render() {
    stroke(0);
    fill(0);
    ellipse(pos.x, pos.y, 2, 2);
  }
	
  void addDampingForce() {
    acc.x = acc.x - vel.x * damping;
    acc.y = acc.y - vel.y * damping;
  }
	
  void addForce(float x, float y) {
    acc.x = acc.x + x;
    acc.y = acc.y + y;
  }
}
