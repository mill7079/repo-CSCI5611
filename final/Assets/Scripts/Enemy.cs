using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : Unit
{
    private GameObject player;
    private PlayerController playerController;

    [HideInInspector] public bool pathCreated = false;

    // motion planning
    private Point start, goal;
    private List<Vector2> path;
    private float dt = 0.009f;

    protected override void Awake()
    {
        path = new List<Vector2>();

        Dungeon.AddNewEnemy(this);

        player = GameObject.FindGameObjectWithTag("Player");
        playerController = player.GetComponent<PlayerController>();

        base.Awake();
    }

    // Update is called once per frame
    void Update()
    {
        if (isDead) return;

        // attack player - don't move if close enough to attack
        Vector2 pos = body.position;
        Vector2 move = new Vector2(0, 0);
        bool goodPath = Dungeon.GoodPath(pos, player.gameObject.transform.position);

        if (Time.frameCount % 80 == 0 && goodPath && (player.gameObject.transform.position - this.gameObject.transform.position).magnitude <= attackRadius)
        {
            playerController.Damage(attack, false);
            return;
        }

        // motion planning with path smoothing
        if (goodPath)
        {
            move = ((Vector2)player.gameObject.transform.position - pos).normalized * dt * speed;
            body.MovePosition(body.position + move);
        }
        else
        {
            for (int i = path.Count - 1; i >= 0; i--)
            {
                if (Dungeon.GoodPath(pos, path[i]))
                {
                    move = (path[i] - pos).normalized * dt * speed;
                    body.MovePosition(body.position + move);
                    break;
                }
            }
        }

        // animation
        if (animator != null)
        {
            if (!Mathf.Approximately(move.x, 0.0f) || !Mathf.Approximately(move.y, 0.0f))
            {
                lookDirection.Set(move.x, move.y);
                lookDirection.Normalize();
            }

            animator.SetFloat("LookX", lookDirection.x);
            animator.SetFloat("LookY", lookDirection.y);
        }
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
            newPath.Insert(0, endPos);
            g = g.GetParent();
            try
            {
                endPos = g.GetPos();
            }
            catch (Exception)
            {
                // path to user does not exist - keep on original path
                okPath = false;
                break;
            }
            x++;
        }

        newPath.Insert(0, endPos);

        // only update path if a path exists
        if (okPath) path = newPath;
    }

    // creates simple path from a to b
    public void InitPath(Point a, Point b)
    {
        path.Add(a.GetPos());
        path.Add(b.GetPos());
    }
}
