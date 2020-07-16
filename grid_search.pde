Grid map;
Search searcher;

void setup() {
  size(1080,720);
  map = new Grid(54,36);
}


void draw() {
  background(255);
  map.draw();

  if (map.ready() && searcher == null){
    searcher = new Search(map);
  }

  if (searcher != null){
    searcher.update();
  }
}

void mouseClicked() {
  if (!map.ready()){
    if (mouseButton == LEFT){
      map.placeMark(mouseX, mouseY);
    } else {
      map.placeBlock(mouseX,mouseY);
    }
  }

  if (searcher != null && searcher.finished){
    map.clear();
    searcher = null;
  }
}

void mouseDragged() {
  if (mouseButton == RIGHT){
    map.placeBlock(mouseX,mouseY);
  }
}

void mouseReleased() {
  if (mouseButton == RIGHT){
    map.removeFlag();
  }
}