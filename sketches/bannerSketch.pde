/** 
 * File: bannerSketch.pde
 * ----------------------
 * This program generates an interactive banner for
 * http://akinoshi.github.io/
 *
 * Author: Akinori Kinoshita
 * E-mail: art.akinoshi -at- gmail.com
 * Date: Sat May  4 11:50:42 CST 2013
 */

Grid[] grids = new Grid[49*9];
int[] colorList = {
// a
49*3+2, 49*3+3, 49*3+4,
49*4+5,
49*5+2, 49*5+3, 49*5+4, 49*5+5,
49*6+1, 49*6+5,
49*7+2, 49*7+3, 49*7+4, 49*7+5,
// k
49*1+7,
49*2+7,
49*3+7, 49*3+10,
49*4+7, 49*4+9,
49*5+7, 49*5+8,
49*6+7, 49*6+9,
49*7+7, 49*7+10,
// i
49*1+14,
49*3+13, 49*3+14,
49*4+14,
49*5+14,
49*6+14,
49*7+13, 49*7+14, 49*7+15,
// n
49*3+17, 49*3+19, 49*3+20,
49*4+17, 49*4+18, 49*4+21,
49*5+17, 49*5+21,
49*6+17, 49*6+21,
49*7+17, 49*7+21,
// o
49*3+24, 49*3+25, 49*3+26,
49*4+23, 49*4+27,
49*5+23, 49*5+27,
49*6+23, 49*6+27,
49*7+24, 49*7+25, 49*7+26,
// s
49*3+30, 49*3+31, 49*3+32,
49*4+29,
49*5+30, 49*5+31, 49*5+32,
49*6+33,
49*7+29, 49*7+30, 49*7+31, 49*7+32,
// h
49*1+35,
49*2+35,
49*3+35, 49*3+37, 49*3+38,
49*4+35, 49*4+36, 49*4+39,
49*5+35, 49*5+39,
49*6+35, 49*6+39,
49*7+35, 49*7+39,
// i
49*1+43,
49*3+42, 49*3+43,
49*4+43,
49*5+43,
49*6+43,
49*7+42, 49*7+43, 49*7+44
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
