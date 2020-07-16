class Node {
  int[] location;
  int pathCost; // g
  int heuristic;  // h
  int total;  // f = g + h

  Node parent;


  Node(int[] location, int pathCost){
    this.location = new int[2];
    this.location[0] = location[0];
    this.location[1] = location[1];

    this.pathCost = pathCost;
  }

  Node(int[] location, int pathCost, int heuristic){
    this.location = new int[2];
    this.location[0] = location[0];
    this.location[1] = location[1];

    this.pathCost = pathCost;
    this.heuristic = heuristic;
    this.total = pathCost + heuristic;
  }
}