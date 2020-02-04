//Rectangle[] rects = new Rectangle[0];
// Point[] rects = new Point[0];
ArrayList<Point> points = new ArrayList<Point>();

void setup() {
  size(600,600,P3D);
  background(0);
}

void draw() {
  background(0);
  /*fill(0,255,0);
  //rect(mouseX, mouseY, 50,50);
  pushMatrix();
  translate(mouseX, mouseY);
  //box(50);
  strokeWeight(5);
  point(mouseX, mouseY, 0);
  popMatrix();*/
  
  
  
  /*for (int i = 0; i < rects.length; i++) {
    rects[i].update();
  }*/
  
  for (Point p : points) {
    p.update();
  }
}

void mouseClicked() {
  //rects = (Rectangle[]) append(rects, new Rectangle(mouseX, mouseY, 50, 50));
  // rects = (Point[]) append(rects, new Point(mouseX, mouseY));
  points.add(new Point(mouseX, mouseY));
}

void clean() {
  for (int i = points.size(); i >= 0; i--) {
    if (points.get(i).isDead()) points.remove(points.get(i));
  }
}
