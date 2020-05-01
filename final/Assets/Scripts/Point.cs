using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Point
{
    Vector2 pos;
    List<Point> neighbors;
    Point parent;
    bool discovered = false;
    

    public Point(Vector2 p)
    {
        pos = p;
        neighbors = new List<Point>();
        parent = null;
    }

    public void AddNeighbor(Point p)
    {
        neighbors.Add(p);
    }

    public override string ToString()
    {
        return pos.ToString();
    }

    public void Discover(bool discover)
    {
        discovered = discover;
    }

    public void SetParent(Point p)
    {
        parent = p;
    }

    public Vector2 GetPos() { return pos; }
    public Point GetParent() { return parent; }
    public List<Point> GetNeighbors() { return neighbors; }
    public bool IsDiscovered() { return discovered; }

}
