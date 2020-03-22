public class PriorityQueue<T extends Comparable<T>> {
  
  private Node head;
  private int size;
  
  public PriorityQueue() {
    head = null;
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
  
  public T pop() {
    if (head == null) return null;
    Node ret = head;
    head = head.next;
    size--;
    
    return ret.k;
  }
  
  public int size() {
    return size;
  }
  
  
  
  
  private class Node {
    
    private T k;
    private float v;
    private Node next;
    
    public Node(T k, float val) {
      this.k = k;
      this.v = val;
      next = null;
    }
    
  } // Node
  
} // PQ
