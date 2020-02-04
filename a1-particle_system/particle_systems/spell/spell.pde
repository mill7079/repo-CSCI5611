Rectangle[] rects = new Rectangle[0];

void setup() {
  size(600,600,P3D);
  background(0);
}

void draw() {
  background(0);
  fill(0,255,0);
  //rect(mouseX, mouseY, 50,50);
  pushMatrix();
  translate(mouseX, mouseY);
  box(50);
  popMatrix();
  
  for (int i = 0; i < rects.length; i++) {
    rects[i].update();
  }
}

void mouseClicked() {
  rects = (Rectangle[]) append(rects, new Rectangle(mouseX, mouseY, 50, 50));
  
}
