using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager instance = null;
    [HideInInspector] public static bool isPaused = false;
    public Dungeon dungeon;

    // unity whyyyyy
    public GameObject[] walls;
    public GameObject[] floors;
    public GameObject[] doors;

    public GameObject[] testEnemies;
    public GameObject[] students;

    public int numObstacles = 10;

    // Start is called before the first frame update
    void Awake()
    {
        Debug.Log("Awake GM");
        if (instance == null)
        {
            instance = this;
        } else if (instance != this)
        {
            Destroy(gameObject);
        }

        //DontDestroyOnLoad(gameObject);
        Physics2D.IgnoreLayerCollision(8, 10);

        dungeon = GetComponent<Dungeon>();
        dungeon.StartDungeon();

    }

    public void MoveRoom(Room next)
    {
        //dungeon.MoveRoom(next.GetTiles());
        dungeon.MoveRoom(next);
    }

    public GameObject[] GetWalls() { return walls; }
    public GameObject[] GetDoors() { return doors; }
    public GameObject[] GetFloors() { return floors; }
    public GameObject[] GetTestEnemies() { return testEnemies; }
    //public GameObject GetPlayer() { return player; }

    // Update is called once per frame
    //void Update()
    //{
        
    //}

    // uniform cost search for motion planning
    // didn't know where would be best to put it so it's going in GameManager
    public static Point UCS(List<Point> points, Point root, Point goal)
    {
        //foreach (Point p in points) p.Discover(false);
        for (int i = 0; i < points.Count; i++)
        {
            points[i].Discover(false);
        }

        Point node = null;
        //PriorityQueue<Point> frontier = new PriorityQueue<Point>();
        //PQ<Point> frontier = new PQ<Point>();
        PQHeap<Point> frontier = new PQHeap<Point>(null);
        frontier.Push(root, 0);

        while(frontier.Size() > 0)
        {
            //PriorityQueue<Point>.Node temp = frontier.Pop();
            //PQ<Point>.Node temp = frontier.Pop();
            PQHeap<Point>.Node temp = frontier.Pop();
            //node = temp.GetKey() as Point;
            node = temp.k as Point;
            float curr_cost = temp.GetData();

            if (node == goal)
            {
                //Debug.Log("found goal");
                return goal;
            }

            node.Discover(true);
            //foreach (Point n in node.GetNeighbors())
            //{
            //    float cost = Vector2.Distance(n.GetPos(), node.GetPos());
            //    if (!n.IsDiscovered() && !frontier.Contains(n))
            //    {
            //        frontier.Push(n, curr_cost + cost);
            //        n.SetParent(node);
            //    }
            //    else if (frontier.Contains(n) && !n.IsDiscovered())
            //    {
            //        frontier.UpdateCost(n, curr_cost + cost, node);
            //    }
            //}
            List<Point> neighbors = node.GetNeighbors();
            for (int i = 0; i < neighbors.Count; i++)
            {
                float cost = Vector2.Distance(neighbors[i].GetPos(), node.GetPos());
                //if (!neighbors[i].IsDiscovered() && !frontier.Contains(neighbors[i]))

                //if (!neighbors[i].discovered && !frontier.Contains(neighbors[i]))
                //{
                //    frontier.Push(neighbors[i], curr_cost + cost);
                //    neighbors[i].SetParent(node);
                //}
                //else if (frontier.Contains(neighbors[i]) && !neighbors[i].discovered)
                ////else if (frontier.Contains(neighbors[i]) && !neighbors[i].IsDiscovered())
                //{
                //    frontier.UpdateCost(neighbors[i], curr_cost + cost, node);
                //}
                if (!neighbors[i].discovered)
                {
                    if (!frontier.Contains(neighbors[i]))
                    {
                        frontier.Push(neighbors[i], curr_cost + cost);
                        neighbors[i].SetParent(node);
                    } else
                    {
                        frontier.UpdateCost(neighbors[i], curr_cost + cost, node);
                    }
                }
            }

        }

        return null;
    }
}
