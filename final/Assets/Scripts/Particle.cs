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


    private Vector2 pos;
    private Vector2 vel;
    private float dt = 0.009f;
    private GameObject sprite;

    private int life = 100;

    public Particle(Vector2 p, Vector2 v, GameObject s)
    {
        pos = p;
        vel = v;
        sprite = s;
    }

    public void Move()
    {
        pos += (vel * dt);
        vel += (vel * dt);

        life--;
    }

    public bool IsDead()
    {
        return life <= 0;
    }
}
