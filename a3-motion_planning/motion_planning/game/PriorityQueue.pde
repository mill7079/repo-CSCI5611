public class PriorityQueue<T> {
  
  private Node head;
  private int size;
  
  public PriorityQueue() {
    head = null;
    size = 0;
  }
  
  public void push(T k, float val) {
    Node add = new Node(k, val);
    size++;
    
    if (head == null) head = add;
    else {
      Node cur = head;
      while(cur.next != null && cur.next.v < val) {
        cur = cur.next;
      }
      add.next = cur.next;
      cur.next = add;
    }
  }
  /*
  public void push(T k, float val, ArrayList<T> path) {
    Node add = new Node(k, val, path);
    size++;
    
    if (head == null) head = add;
    else {
      Node cur = head;
      while(cur.next != null && cur.next.v < val) {
        cur = cur.next;
      }
      add.next = cur.next;
      cur.next = add;
    }
  }
  */
  public Node pop() {
    if (head == null) return null;
    Node ret = head;
    head = head.next;
    size--;
    
    return ret;
  }
  
  public int size() {
    return size;
  }
  
  public boolean contains(T k) {
    if (head == null) return false;
     
    Node cur = head;
    while(cur != null) {
      if (cur.k == k) return true;
      cur = cur.next;
    }
    
    return false;
  }
  
  public boolean updateCost(T k, float val, T parent) {
    if (head == null) return false;
    Node cur = head;
    while(cur != null) {
      if (cur.k == k && val < cur.v) {
        if (cur.k instanceof Point) {
          Point c = (Point)cur.k;
          c.parent = (Point)parent;
        }
        cur.v = val; 
        return true;
      }
      
      cur = cur.next;
    }
    
    return false;
  }
  
  public String toString() {
    String ret = "";
    Node cur = head;
    while(cur != null) {
      ret += cur.k + " : cost " + cur.v + "\n"; 
      cur = cur.next;
    }
    return ret + "\n";
  }
  
  
  private class Node {
    
    private T k;
    private float v;
    private Node next;
    //private ArrayList<T> path;
    
    public Node(T k, float val) {
      this.k = k;
      this.v = val;
      next = null;
      //path = new ArrayList<T>();
    }
    
    public Node(T k, float val, ArrayList<T> p) {
      this.k = k;
      this.v = val;
      next = null;
      //path = p;
    }
    
    /*public ArrayList<T> getPath() {
      return path;
    }*/
    
  } // Node
  
} // PQ
