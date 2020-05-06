using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    //public float move = 3.0f;
    public int radius = 5;
    private int direction = 1;
    Rigidbody2D body;
    Animator animator;
    Vector2 origin;
    public bool pathCreated = false;

    // motion planning
    Point start, goal;
    List<Vector2> path;
    float dt = 0.009f;

    // rpg mechanics
    public int health;
    public int attack;
    public int defense;

    void Awake()
    {
        body = GetComponent<Rigidbody2D>();
        origin = body.position;
        animator = GetComponent<Animator>();
        path = new List<Vector2>();
        Physics2D.IgnoreLayerCollision(8, 10);

        Dungeon.AddNewEnemy(this);
    }

    // Update is called once per frame
    void Update()
    {
        // motion planning but for now just random
        //Vector2 pos = body.position;

        ////pos.y = pos.y + move * Time.deltaTime * direction;
        //pos.y += move * Time.deltaTime * direction;
        //if (animator != null)
        //{
        //    animator.SetFloat("LookX", 0);
        //    animator.SetFloat("LookY", direction);
        //}

        //if (Mathf.Abs(origin.y - pos.y) >= radius) direction *= -1;

        //body.MovePosition(pos);


        // motion planning with path smoothing
        Vector2 pos = body.position;
        for (int i = path.Count - 1; i >= 0; i--)
        {
            if (Dungeon.GoodPath(pos, path[i]))
            {
                Vector2 move = (path[i] - pos).normalized * dt;
                body.MovePosition(body.position + move);
                break;
            }
        }

        if (animator != null)
        {
            float changeX = pos.x - body.position.x;
            float changeY = pos.y - body.position.y;

            if (changeX < 0) animator.SetFloat("LookX", -1);
            else animator.SetFloat("LookX", 1);

            if (changeY < 0) animator.SetFloat("LookY", -1);
            else animator.SetFloat("LookY", 1);
        }
    }

    public Point GetPos() { return new Point(body.position); }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        direction *= -1;
    }


    // motion planning code
    public void UpdateEndpoints(Point s, Point g)
    {
        start = s;
        goal = g;
    }

    // backtrace from goal to create path
    public void CreatePath()
    {
        pathCreated = true;
        //path = new List<Vector2>();
        List<Vector2> newPath = new List<Vector2>();
        bool okPath = true;
        //Debug.Log("start: " + start.GetPos() + " end: " + goal.GetPos());
        if (start == goal) return;

        Point g = goal;
        Vector2 endPos = goal.GetPos();
        int x = 0;
        while (endPos != start.GetPos() && x < 1000)
        {
            //Debug.Log("endpos: "+endPos + " start: " + start.GetPos());
            //path.Insert(0, endPos);
            newPath.Insert(0, endPos);
            g = g.GetParent();
            try
            {
                endPos = g.GetPos();
            }
            catch (Exception)
            {
                Debug.Log("fuck me i guess, never did figure out why this happens");
                okPath = false;
                break;
                //return;
            }
            x++;
        }
        //curPath = path.get(1).sub(path.get(0));

        //path.Insert(0, endPos);
        newPath.Insert(0, endPos);

        // only update path if there is a path
        if (okPath) path = newPath;
        //curPath = path[1] - body.position;
    }

    // creates simple path from a to b
    public void InitPath(Point a, Point b)
    {
        path.Add(a.GetPos());
        path.Add(b.GetPos());
    }
}
