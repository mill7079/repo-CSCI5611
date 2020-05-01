using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{

    public static GameManager instance = null;
    public Dungeon dungeon;

    // unity whyyyyy
    public GameObject[] walls;
    public GameObject[] floors;
    public GameObject[] doors;

    public GameObject[] testEnemies;

    public int numObstacles = 10;

    // Start is called before the first frame update
    void Awake()
    {
        if (instance == null)
        {
            instance = this;
        } else if (instance != this)
        {
            Destroy(gameObject);
        }

        DontDestroyOnLoad(gameObject);

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
    void Update()
    {
        
    }

    // uniform cost search for motion planning
    // didn't know where would be best to put it so it's going in GameManager
    public static Point UCS(List<Point> points, Point root, Point goal)
    {
        foreach (Point p in points) p.Discover(false);

        Point node = null;
        PriorityQueue<Point> frontier = new PriorityQueue<Point>();
        frontier.Push(root, 0);

        while(frontier.Size() > 0)
        {
            PriorityQueue<Point>.Node temp = frontier.Pop();
            node = temp.GetKey() as Point;
            float curr_cost = temp.GetData();

            if (node == goal) return goal;

            node.Discover(true);
            foreach (Point n in node.GetNeighbors())
            {
                float cost = Vector2.Distance(n.GetPos(), node.GetPos());
                if (!n.IsDiscovered() && !frontier.Contains(n))
                {
                    frontier.Push(n, curr_cost + cost);
                    n.SetParent(node);
                }
                else if (frontier.Contains(n) && !n.IsDiscovered())
                {
                    frontier.UpdateCost(n, curr_cost + cost, node);
                }
            }
        }

        return null;
    }
}
