//using System.Collections;
//using System.Collections.Generic;

//public class PriorityQueue<T>
//{
//    private Node head;
//    private int size;

//    public PriorityQueue()
//    {
//        head = null;
//        size = 0;
//    }

//    public int Size() { return size; }

//    public void Push(T k, float val)
//    {
//        Node add = new Node(k, val);
//        size++;

//        if (head == null) head = add;
//        else
//        {
//            Node cur = head;
//            //while (cur.GetNext() != null && cur.GetNext().GetData() < val)
//            //{
//            //    cur = cur.GetNext();
//            //}
//            //add.SetNext(cur.GetNext());
//            //cur.SetNext(add);
//            while (cur.next != null && cur.next.GetData() < val)
//            {
//                cur = cur.next;
//            }
//            add.next = cur.next;
//            cur.next = add;
//        }
//    }

//    public Node Pop()
//    {
//        if (head == null) return null;

//        Node ret = head;
//        //head = head.GetNext();
//        head = head.next;
//        size--;

//        return ret;
//    }

//    public bool Contains(T k)
//    {
//        if (head == null) return false;

//        Node cur = head;
//        while (cur != null)
//        {
//            //if (cur.GetKey().Equals(k)) return true;
//            //if (cur.k.Equals(k)) return true;
//            if (cur.k as Point == k as Point) return true;
//            //cur = cur.GetNext();
//            cur = cur.next;
//        }

//        return false;
//    }

//    public bool UpdateCost(T k, float val, T parent)
//    {
//        if (head == null) return false;
//        Node cur = head;

//        while (cur != null)
//        {
//            //if (cur.GetKey().Equals(k) && val < cur.GetData())
//            //if (cur.k.Equals(k) && val < cur.GetData())
//            if ((cur.k as Point) == (k as Point) && val < cur.GetData())
//            {
//                //if (cur.GetKey() is Point)
//                if (cur.k is Point)
//                {
//                    //Point c = cur.GetKey() as Point;
//                    Point c = cur.k as Point;
//                    c.SetParent(parent as Point);
//                }
//                cur.SetData(val);
//                return true;
//            }

//            //cur = cur.GetNext();
//            cur = cur.next;
//        }

//        return false;
//    }

//    public override string ToString()
//    {
//        string ret = "";
//        Node cur = head;

//        while (cur != null)
//        {
//            //ret += cur.GetKey() + " : cost " + cur.GetData() + "\n";
//            ret += cur.k + " : cost " + cur.GetData() + "\n";
//            //cur = cur.GetNext();
//            cur = cur.next;
//        }

//        return ret + "\n";
//    }



//    public class Node
//    {
//        public T k;
//        private float v;
//        //private Node next;
//        public Node next;

//        public Node(T k, float val)
//        {
//            this.k = k;
//            this.v = val;
//            next = null;
//        }

//        //public Node GetNext() { return next; }
//        //public void SetNext(Node node) { next = node; }
//        public float GetData() { return v; }
//        public void SetData(float val) { v = val; }
//        //public T GetKey() { return k; }
//    }

//}
