import uibooster.*;
import uibooster.model.*;

Grid map;
Search searcher;
String searchAlgorithm = "Dijkstra's";

UiBooster booster;


void setup() {
  size(1080,720);
  map = new Grid(36,24);

  new UiBooster()
    .createForm("Settings")
    .addSelection("Search Algorithm", "Dijkstra's", "Greedy", "A*")
    .addButton("Clear", new Runnable(){
      public void run(){
        clear();
      }
    })
    .setChangeListener(new FormElementChangeListener() {
      public void onChange(FormElement element, Object value) {
        searchAlgorithm = element.asString();
      }
    })

    .run();
}

void clear(){
  map.hardClear();
}


void draw() {
  background(255);


  map.draw();

  if (map.ready() && searcher == null){
    searcher = new Search(map, searchAlgorithm);
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
    return;
  }

  if (searcher.started) {
    searcher.pause();
  }

  if (searcher != null && searcher.finished){
    map.softClear();
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