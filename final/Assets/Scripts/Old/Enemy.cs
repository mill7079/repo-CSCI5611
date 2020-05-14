//using System;
//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;

//public class Enemy : MonoBehaviour
//{
//    GameObject player;
//    PlayerController playerController;

//    //public float move = 3.0f;
//    //private int direction = 1;
//    Rigidbody2D body;
//    Animator animator;
//    Vector2 lookDirection = new Vector2(1, 0);
//    Vector2 origin;
//    public bool pathCreated = false;

//    // motion planning
//    Point start, goal;
//    List<Vector2> path;
//    float dt = 0.009f;

//    // rpg mechanics
//    public float health, attack, defense;
//    private float maxHealth;
//    public float attackRadius;
//    public int speed; // affects movement speed
//    public GameObject rangedAttack; // if null, unit has no ranged attack; otherwise holds projectile
//    private bool isDead = false;

//    void Awake()
//    {
//        body = GetComponent<Rigidbody2D>();
//        origin = body.position;
//        animator = GetComponent<Animator>();
//        path = new List<Vector2>();
//        Physics2D.IgnoreLayerCollision(8, 10);

//        Dungeon.AddNewEnemy(this);

//        player = GameObject.FindGameObjectWithTag("Player");
//        playerController = player.GetComponent<PlayerController>();

//        maxHealth = health;
//    }

//    // Update is called once per frame
//    void Update()
//    {
//        // attack player - don't move if close enough to attack
//        Vector2 pos = body.position;
//        Vector2 move = new Vector2(0, 0);
//        bool goodPath = Dungeon.GoodPath(pos, player.gameObject.transform.position);

//        if (Time.frameCount % 80 == 0 && goodPath && (player.gameObject.transform.position - this.gameObject.transform.position).magnitude <= attackRadius)
//        {
//            playerController.Damage(attack);
//            return;
//        }

//        // motion planning with path smoothing

//        if (goodPath)
//        {
//            move = (path[path.Count - 1] - pos).normalized * dt * speed;
//            body.MovePosition(body.position + move);
//        }
//        else
//        {
//            for (int i = path.Count - 1; i >= 0; i--)
//            {
//                if (Dungeon.GoodPath(pos, path[i]))
//                {
//                    move = (path[i] - pos).normalized * dt * speed;
//                    body.MovePosition(body.position + move);
//                    break;
//                }
//            }
//        }
        
//        //// animation
//        //if (animator != null)
//        //{
//        //    float changeX = pos.x - body.position.x;
//        //    float changeY = pos.y - body.position.y;

//        //    if (changeX < 0) animator.SetFloat("LookX", -1);
//        //    else animator.SetFloat("LookX", 1);

//        //    if (changeY < 0) animator.SetFloat("LookY", -1);
//        //    else animator.SetFloat("LookY", 1);
//        //}

//        if (animator != null)
//        {
//            if (!Mathf.Approximately(move.x, 0.0f) || !Mathf.Approximately(move.y, 0.0f))
//            {
//                lookDirection.Set(move.x, move.y);
//                lookDirection.Normalize();
//            }

//            animator.SetFloat("LookX", lookDirection.x);
//            animator.SetFloat("LookY", lookDirection.y);
//        }
//    }

//    public Point GetPos() { return new Point(body.position); }

//    //private void OnTriggerEnter2D(Collision2D collision)
//    //{
//    //    //direction *= -1;
//    //    //if (collision.gameObject.CompareTag("Particle"))
//    //    Particle p = collision.gameObject.GetComponent<Particle>();
//    //    if (p != null)
//    //    {
//    //        Debug.Log("collision with enemy");
//    //        health -= p.Hit();
//    //    }
//    //}


//    // motion planning code
//    public void UpdateEndpoints(Point s, Point g)
//    {
//        start = s;
//        goal = g;
//    }

//    // backtrace from goal to create path
//    public void CreatePath()
//    {
//        pathCreated = true;
//        //path = new List<Vector2>();
//        List<Vector2> newPath = new List<Vector2>();
//        bool okPath = true;
//        //Debug.Log("start: " + start.GetPos() + " end: " + goal.GetPos());
//        if (start == goal) return;

//        Point g = goal;
//        Vector2 endPos = goal.GetPos();
//        int x = 0;
//        while (endPos != start.GetPos() && x < 1000)
//        {
//            //Debug.Log("endpos: "+endPos + " start: " + start.GetPos());
//            //path.Insert(0, endPos);
//            newPath.Insert(0, endPos);
//            g = g.GetParent();
//            try
//            {
//                endPos = g.GetPos();
//            }
//            catch (Exception)
//            {
//                // path to user does not exist - keep on original path
//                okPath = false;
//                break;
//                //return;
//            }
//            x++;
//        }
//        //curPath = path.get(1).sub(path.get(0));

//        //path.Insert(0, endPos);
//        newPath.Insert(0, endPos);

//        // only update path if there is a path
//        if (okPath) path = newPath;
//        //curPath = path[1] - body.position;
//    }

//    // creates simple path from a to b
//    public void InitPath(Point a, Point b)
//    {
//        path.Add(a.GetPos());
//        path.Add(b.GetPos());
//    }

//    // handles attack from player
//    //public void Damage(int att)
//    public void Damage(float att, bool particle)
//    {
//        if (particle) health -= att;
//        else health -= (att - defense);

//        if (health <= 0) isDead = true;
//    }

//    public bool IsDead()
//    {
//        return isDead;
//    }

//    public float GetCurrentHealth()
//    {
//        return health / maxHealth;
//    }
//}
