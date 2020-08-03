color startCol = #3cada3;
color endCol = #ed553b;
color obsCol = #626262;
color fringeCol = #173f5f;
color visCol = #21639b;
color pathCol = #009fbc;
color backCol = #292929;

class Grid {
  int[][] arr;
  boolean[][] visited;
  int w;  // number of columns
  int h;  // number of rows
  int boxWidth;
  int boxHeight;
  int[] start;  // the starting point
  int[] end;  // the destination
  boolean ready;
  int[] flag; // fix for mouseDragged


  Grid(int w, int h){
    this.w = w;
    this.h = h;
    boxWidth = width/w;
    boxHeight = height/h;

    flag = new int[2];
    flag[0] = -1;
    flag[1] = -1;

    arr = new int[h][w];
    visited = new boolean[h][w];
  }

  // draws the map
  void draw(){
    for (int i = 0; i < w; i++){
      for (int j = 0; j < h; j++){
        stroke(20);
        changeFill(j,i);
        rect(boxWidth * i, boxHeight * j, boxWidth, boxHeight);
      }
    }
  }

  // picks the rectangle fill based on the element value
  void changeFill(int row, int column){
    int val = arr[row][column];
    boolean vis = visited[row][column];

    if (val == 's') {
      fill(startCol);
    } else if (val == 'e') {
      fill(endCol);
    } else if (val == 'x') {
      fill(obsCol);
    } else if (val == 'f'){
      fill(fringeCol);
    } else if (val == 'p') {
      fill(pathCol);
    } else if (vis){
      fill(visCol);
    } else {
      fill(backCol);
    }
  }

  void placeMark(int x, int y){
    int column = x/boxWidth;
    int row = y/boxHeight;

    if (!withinGrid(row,column)) return;

    if (arr[row][column] == 's') {
      arr[row][column] = 0;
      start = null;
      return;
    }

    if (arr[row][column] == 'e') {
      arr[row][column] = 0;
      end = null;
      return;
    }

    if (start == null){
      placeStart(row, column);
    } else if (end == null){
      placeEnd(row, column);
    } else {
      ready = true;
    }

        

  }

  void placeStart(int row, int column){
    arr[row][column] = 's';

    start = new int[2];
    start[0] = row;
    start[1] = column;
  }

  void placeEnd(int row, int column){
    arr[row][column] = 'e';

    end = new int[2];
    end[0] = row;
    end[1] = column;
  }

  void placeBlock(int x, int y){
    int column = x/boxWidth;
    int row = y/boxHeight;

    if (!withinGrid(row, column)){
      return;
    }

    if (flag[0] == row && flag[1] == column) return;

    int selected = arr[row][column];
    if (selected == 's' || selected == 'e') return;

    if (selected == 'x'){
      arr[row][column] = 1;
    } else {
      arr[row][column] = 'x';
    }

    flag[0] = row;
    flag[1] = column;
  }

  void removeFlag(){
    flag[0] = -1;
    flag[1] = -1;
  }

  boolean ready(){
    return ready;
  }

  boolean withingGrid(int[] location){
    return withinGrid(location[0], location[1]);
  }

  boolean withinGrid(int row, int column){
    if (!(row >= 0 && row < h)) return false;
    if (!(column >= 0 && column < w)) return false;

    return true;
  }

  boolean isObstacle(int[] location){
    return isObstacle(location[0], location[1]);
  }

  boolean isObstacle(int row, int column){
    if (arr[row][column] == 'x') return true;

    return false;
  }

  ArrayList<int[]> getNeighbours(int[] location){
    return getNeighbours(location[0], location[1]);
  }

  ArrayList<int[]> getNeighbours(int row, int column){
    // returns the locations of neighbours which have not been visited, are not an obstacle, and are inside the grid

    ArrayList<int[]> children = new ArrayList<int[]>();

    if (!withinGrid(row,column)) return children;

    int[] rows = {-1, 1, 0, 0};
    int[] columns = {0, 0, -1, 1};
    int[] child = new int[2];

    for (int i = 0; i < 4; i++){
      child = new int[2];
      child[0] = rows[i] + row;
      child[1] = columns[i] + column;

      if (!withinGrid(child[0],child[1]) || isObstacle(child[0], child[1])) continue;

      if (!visited[child[0]][child[1]]){
        children.add(child);
      }
    }

    return children;
  }

  void markVisited(int[] location){
    markVisited(location[0], location[1]);
  }

  void markVisited(int row, int column){
    visited[row][column] = true;
  }

  boolean atEnd(int[] location){
    return atEnd(location[0], location[1]);
  }

  boolean atEnd(int row, int column){
    if (row == end[0] && column == end[1]) return true;

    return false;
  }

  void markPath(int[] location){
    markPath(location[0], location[1]);
  }

  void markPath(int row, int column){
    if (arr[row][column] != 's' && arr[row][column] != 'e'){
      arr[row][column] = 'p';
    }
  }

  void markFringe(int[] location){
    markFringe(location[0], location[1]);
  }

  void markFringe(int row, int column){
    if (arr[row][column] != 's' && arr[row][column] != 'e'){
      arr[row][column] = 'f';
    }
  }

  void removeFringe(int[] location){
    removeFringe(location[0], location[1]);
  }

  void removeFringe(int row, int column){
    if (arr[row][column] != 's' && arr[row][column] != 'e'){
      arr[row][column] = 1;
    }
  }

  int manhattan(int[] location){
    return (abs(location[0] - end[0]) + abs(location[1] - end[1]));
  }

  void hardClear(){
    ready = false;
    start = null;
    end = null;

    arr = new int[h][w];
    visited = new boolean[h][w];
  }

  void softClear(){
    // start = null;
    // end = null;
    ready = false;

    visited = new boolean[h][w];

    clear(arr);
  }

  void clear(int[][] arr){
    for (int i = 0; i < h; i++){
      for (int j = 0; j < w; j++){
        if (arr[i][j] != 's' && arr[i][j] != 'e' && arr[i][j] != 'x'){
          arr[i][j] = 0;
        }
      }
    }
  }
}