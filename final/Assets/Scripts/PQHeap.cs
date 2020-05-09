using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PQHeap<T>
{
    //private Node head;
    private List<Node> heap;
    private Dictionary<Node, float> nodes;
    private Dictionary<Point, Node> points;

    private int size;

    public PQHeap(T init)
    {
        heap = new List<Node>();
        nodes = new Dictionary<Node, float>();
        points = new Dictionary<Point, Node>();
        heap.Add(new Node(init, -1)); // initialize null space in 0th index for heap (1st element goes in index 1)
        size = 1;
    }

    // size - 1 accounts for null element at beginning of list
    public int Size() { return size - 1; }

    // insert a value into the queue
    // don't ask me why it's called push
    public void Push(T k, float v)
    {
        Node add = new Node(k, v);
        //heap.Add(add);
        if (size >= heap.Count) heap.Add(add);
        else heap[size] = add;
        size++;
        //Debug.Log("push! heap count: " + heap.Count + " heap size: " + size);
        RestoreOrder(true);

        //string debug = "";
        //for (int i = 0; i < heap.Count; i++)
        //{
        //    debug += (i + ": " + heap[i] + ";;; ");
        //}
        //Debug.Log(debug);

        nodes.Add(add, v);
        points.Add((k as Point), add);

    }

    // restores order property of heap
    public void RestoreOrder(bool fromLeaf)
    {
        //int index = heap.Count - 1;
        int index = size - 1;

        //Debug.Log("****************HEAP (restore order " + fromLeaf + ")****************");
        //string debug = "";
        //for (int i = 0; i < heap.Count; i++)
        //{
        //    debug += (i + ": " + heap[i] + ";;; ");
        //}
        //Debug.Log(debug);

        //Debug.Log("index: " + index + " index/2: " + (index / 2));
        //Debug.Log("fromLeaf: " + fromLeaf + " index > 1: " + (index > 1) + " heap[index]: " + heap[index].GetData() + " heap[index/2]: " + heap[index / 2].GetData());
        while (fromLeaf && index > 1 && heap[index].GetData() < heap[index/2].GetData())
        {
            //Debug.Log("index, true loop: " + index);
            Node temp = heap[index];
            heap[index] = heap[index / 2];
            heap[index / 2] = temp;

            index /= 2;
        }

        index = 1;
        //while(!fromLeaf && index < heap.Count/2)
        while(!fromLeaf && index < size/2)
        {
            //Debug.Log("index, false loop: " + index);
            //Debug.Log("restore reverse, index = " + index + " size = " + size);
            float data = heap[index].GetData();
            if (data > heap[index * 2].GetData())
            {
                Node temp = heap[index];
                heap[index] = heap[index * 2];
                index *= 2;
                heap[index] = temp;
            } else if (data > heap[(index * 2) + 1].GetData())
            {
                Node temp = heap[index];
                heap[index] = heap[(index * 2) + 1];
                index = (index * 2) + 1;
                heap[index] = temp;
            } else
            {
                break;
            }
        }
    }

    // aka ReturnMax
    public Node Pop()
    {
        //Debug.Log("POP");
        Node ret = heap[1];
        //heap[1] = heap[heap.Count - 1];
        heap[1] = heap[size - 1];
        //heap[heap.Count - 1] = null;
        heap[size-1] = null;
        size--;

        RestoreOrder(false);

        nodes.Remove(ret);
        points.Remove(ret.k as Point);
        return ret;
    }

    public bool Contains(T k)
    {
        return points.ContainsKey(k as Point);
    }

    // T = POINT
    public void UpdateCost(T k, float val, T parent)
    {
        //if (!(val < nodes[k])) return;
        //if (!(val < points[k as Point])) return;
        Node toUpdate = points[k as Point];
        if (val >= nodes[toUpdate]) return;

        nodes[toUpdate] = val;
        (k as Point).SetParent(parent as Point);

        /*
        heap.Remove(toUpdate);
        
        //heap.Add(toUpdate);
        if (size > heap.Count)
        {
            //Debug.Log("Using add. Size: " + size + " heap count: " + heap.Count);
            heap.Add(toUpdate);
        } else if (heap[size-1] == null)
        {
            //Debug.Log("Null case. ");
            heap[size - 1] = toUpdate;
        } else
        {
            //Debug.Log("Using size.");
            heap[size] = toUpdate;
        }
        //Debug.Log("Restoring order from Update Cost. Heap: ");
        //string debug = "";
        //for (int i = 0; i < heap.Count; i++)
        //{
        //    debug += (i + ": " + heap[i] + ";;; ");
        //}
        //Debug.Log(debug);

        RestoreOrder(true);
        */

        int x = heap.IndexOf(toUpdate);
        heap[x].SetData(val);
        Node temp;
        while (x > 0 && heap[x-1].GetData() > val)
        {
            temp = heap[x - 1];
            heap[x - 1] = heap[x];
            heap[x] = temp;
        }
    }

    //public void Push(T k, float val)
    //{
    //    //int v = Mathf.RoundToInt(val);
    //    int v = (int)val;
    //    Node add = new Node(k, v);
    //    size++;

    //    while (v >= nodes.Count) nodes.Add(null);

    //    if (nodes[v] == null) nodes[v] = add;
    //    else
    //    {
    //        add.next = nodes[v];
    //        nodes[v] = add;
    //        if (v < low) low = v;
    //    }
    //}

    //public Node Pop()
    //{
    //    Node ret = nodes[low];
    //    nodes[low] = ret.next;
    //    size--;
    //    if (nodes[low] == null)
    //    {
    //        for (int i = low; i < nodes.Count; i++)
    //        {
    //            if (nodes[i] != null)
    //            {
    //                low = i;
    //                break;
    //            }
    //        }
    //    }
    //    return ret;
    //}

    //public bool Contains(T k)
    //{
    //    //if (head == null) return false;

    //    //Node cur = head;
    //    //while (cur != null)
    //    //{
    //    //    if (cur.k as Point == k as Point) return true;
    //    //    cur = cur.next;
    //    //}

    //    //return false;
    //    for (int i = 0; i < nodes.Count; i++)
    //    {
    //        Node cur = nodes[i];
    //        while (cur != null)
    //        {
    //            if (cur.k as Point == k as Point) return true;
    //            cur = cur.next;
    //        }
    //    }
    //    return false;
    //}

    //public bool UpdateCost(T k, float val, T parent)
    //{
    //    if (val > nodes.Count) return false;

    //    //int v = Mathf.RoundToInt(val);
    //    int v = (int)val;
    //    for (int i = 0; i < nodes.Count; i++)
    //    {
    //        Node cur = nodes[i];
    //        Node trail = cur;
    //        while (cur != null)
    //        {
    //            if (cur.k as Point == k as Point)
    //            {
    //                if (v >= i) return false; // don't update cost if new cost is greater than old

    //                // since priority is updated, push new and remove old
    //                (cur.k as Point).SetParent(parent as Point);
    //                Push(cur.k, v);
    //                if (cur == nodes[i]) nodes[i] = cur.next;
    //                else trail.next = cur.next;

    //                return true;
    //            }

    //            trail = cur;
    //            cur = cur.next;
    //        }
    //    }

    //    return false;
    //}

    //public override string ToString()
    //{
    //    string ret = "";
    //    Node cur = head;

    //    while (cur != null)
    //    {
    //        //ret += cur.GetKey() + " : cost " + cur.GetData() + "\n";
    //        ret += cur.k + " : cost " + cur.GetData() + "\n";
    //        //cur = cur.GetNext();
    //        cur = cur.next;
    //    }

    //    return ret + "\n";
    //}



    public class Node
    {
        public T k;
        private float v;
        //private Node next;
        public Node next;

        public Node(T k, float val)
        {
            this.k = k;
            this.v = val;
            next = null;
        }

        public float GetData() { return v; }
        public void SetData(float val) { v = val; }
    }

}
