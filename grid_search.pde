import uibooster.*;
import uibooster.model.*;

Grid map;
Search searcher;
String searchAlgorithm = "Dijkstra's";

UiBooster booster;


void setup() {
  size(1080,720);
  map = new Grid(54,36);

  new UiBooster()
    .createForm("Your settings")
    .addSelection("Search Algorithm", "Dijkstra's", "Greedy", "A*")
    .setChangeListener(new FormElementChangeListener() {
      public void onChange(FormElement element, Object value) {
        searchAlgorithm = element.asString();
        println("Algorthm " + searchAlgorithm);
      }
    })
    .run();
}

void clear(){
  println("clear");
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
  println(frameRate);
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