import java.util.ArrayDeque;
import java.util.PriorityQueue;
import java.util.Comparator;

class UCSComparator implements Comparator<Node>{ 
  public int compare(Node a, Node b) { 
    if (a.pathCost < b.pathCost) {
      return -1; 
    }
    else if (a.pathCost > b.pathCost) {
      return 1;
    }
    return 0; 
  } 
}


class AStarComparator implements Comparator<Node>{ 
  public int compare(Node a, Node b) { 
    if (a.total < b.total) {
      return -1; 
    }
    else if (a.total > b.total) {
      return 1;
    }
    return 0; 
  } 
}

class GreedyComparator implements Comparator<Node>{ 
  public int compare(Node a, Node b) { 
    if (a.heuristic < b.heuristic) {
      return -1; 
    }
    else if (a.heuristic > b.heuristic) {
      return 1;
    }
    return 0; 
  } 
}

class Search {
  Grid map;
  boolean started;
  boolean finished;
  Node curr;
  PriorityQueue<Node> q;
  String algorithm;
  boolean paused;

  Search(Grid map, String algorithm){
    this.map = map;
    started = false;
    finished = false;
    paused = false;
    this.algorithm = algorithm;
  }

  void start(){

    if (algorithm == "Dijkstra's"){
      q = new PriorityQueue<Node>(new UCSComparator());
    } else if (algorithm == "Greedy"){
      q = new PriorityQueue<Node>(new GreedyComparator());
    } else {
      q = new PriorityQueue<Node>(new AStarComparator());
    }

    started = true;
    curr = new Node(map.start, 0);
    map.markVisited(curr.location);
    if (map.atEnd(curr.location)) {
      finished = true;
    }
    q.add(curr);
  }

  void update() {

    if (finished || paused){
      return;
    }

    if (!started){
      start();
      return;
    }

    if (q.isEmpty()){
      finished = true;
      return;
    }

    curr = q.remove();
    map.removeFringe(curr.location);

    for (int[] neighbour : map.getNeighbours(curr.location)){
      Node child = new Node(neighbour, curr.pathCost + 1, map.manhattan(neighbour));
      map.markVisited(child.location);
      child.parent = curr;

      if (map.atEnd(child.location)) {
        finished = true;

        addPath(child);
        return;
      }
      map.markFringe(child.location);
      q.add(child);
    }
  }

  void addPath(Node lastNode){
    while (lastNode != null){
      map.markPath(lastNode.location);
      lastNode = lastNode.parent;
    }
  }

  void pause(){
    paused = !paused;
  }
}