using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    public float move = 3.0f;
    public int radius = 5;
    private int direction = 1;
    Rigidbody2D body;
    Animator animator;
    Vector2 origin;

    // motion planning
    Point start, goal;
    List<Vector2> path;
    //Vector2 curPath;
    //float dt = 0.058f;

    void Awake()
    {
        body = GetComponent<Rigidbody2D>();
        origin = body.position;
        animator = GetComponent<Animator>();
        path = new List<Vector2>();

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
                Vector2 move = (path[i] - pos).normalized * Time.deltaTime;
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
        if (start == goal) return;

        Point g = goal;
        Vector2 endPos = goal.GetPos();
        while (endPos != start.GetPos())
        {
            path.Insert(0, endPos);
            g = goal.GetParent();
            try
            {
                endPos = g.GetPos();
            }
            catch (Exception)
            {
                Debug.Log("fuck me i guess, never did figure out why this happens");
                return;
            }
        }
        //curPath = path.get(1).sub(path.get(0));
        path.Insert(0, endPos);
        //curPath = path[1] - body.position;
    }
}
