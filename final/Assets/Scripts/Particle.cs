using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Particle// : MonoBehaviour
{
    // Start is called before the first frame update
    //void Start()
    //{

    //}

    //// Update is called once per frame
    //void Update()
    //{

    //}


    //private Vector2 pos;
    private Vector2 vel;
    private float dt = 0.18f;
    private GameObject sprite;
    private Rigidbody2D body;

    private int life = 100;

    public Particle(GameObject s, Vector2 v)
    {
        vel = v;
        sprite = s;

        body = s.GetComponent<Rigidbody2D>();
    }

    public void Move()
    {
        if (body == null)
        {
            Debug.Log("no rigidbody");
            return;
        }

        //pos += (vel * dt);
        body.MovePosition(body.position + (vel * dt));
        //vel += (vel * dt) ;

        life--;
    }

    public bool IsDead()
    {
        return life <= 0;
    }

    public void Destroy()
    {
        GameObject.Destroy(sprite);
    }
}
