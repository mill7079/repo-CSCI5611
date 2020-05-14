using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PQ<T>
{
    //private Node head;
    private List<Node> nodes;
    private int size;
    private int low; // keeps track of lowest index with elements

    public PQ()
    {
        nodes = new List<Node>();
        size = 0;
        low = 0;
    }

    public int Size() { return size; }

    public void Push(T k, float val)
    {
        //int v = Mathf.RoundToInt(val);
        int v = (int)val;
        Node add = new Node(k, v);
        size++;

        while (v >= nodes.Count) nodes.Add(null);

        if (nodes[v] == null) nodes[v] = add;
        else
        {
            add.next = nodes[v];
            nodes[v] = add;
            if (v < low) low = v;
        }
    }

    public Node Pop()
    {
        Node ret = nodes[low];
        nodes[low] = ret.next;
        size--;
        if (nodes[low] == null)
        {
            for (int i = low; i < nodes.Count; i++)
            {
                if (nodes[i] != null)
                {
                    low = i;
                    break;
                }
            }
        }
        return ret;
    }

    public bool Contains(T k)
    {
        //if (head == null) return false;

        //Node cur = head;
        //while (cur != null)
        //{
        //    if (cur.k as Point == k as Point) return true;
        //    cur = cur.next;
        //}

        //return false;
        for (int i = 0; i < nodes.Count; i++)
        {
            Node cur = nodes[i];
            while (cur != null)
            {
                if (cur.k as Point == k as Point) return true;
                cur = cur.next;
            }
        }
        return false;
    }

    public bool UpdateCost(T k, float val, T parent)
    {
        if (val > nodes.Count) return false;

        //int v = Mathf.RoundToInt(val);
        int v = (int)val;
        for (int i = 0; i < nodes.Count; i++)
        {
            Node cur = nodes[i];
            Node trail = cur;
            while (cur != null)
            {
                if (cur.k as Point == k as Point)
                {
                    if (v >= i) return false; // don't update cost if new cost is greater than old

                    // since priority is updated, push new and remove old
                    (cur.k as Point).SetParent(parent as Point);
                    Push(cur.k, v);
                    if (cur == nodes[i]) nodes[i] = cur.next;
                    else trail.next = cur.next;

                    return true;
                }

                trail = cur;
                cur = cur.next;
            }
        }

        return false;
    }

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
        private int v;
        //private Node next;
        public Node next;

        public Node(T k, int val)
        {
            this.k = k;
            this.v = val;
            next = null;
        }

        public float GetData() { return v; }
        public void SetData(int val) { v = val; }
    }

}
