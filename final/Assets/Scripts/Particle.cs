using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Particle : MonoBehaviour
{
    //private Vector2 pos;
    private Vector2 vel;
    private float dt = 0.18f;
    //private GameObject sprite;
    private Rigidbody2D body;
    //private Collider2D collide;

    private int life = 100;
    private float damage;
    private string origin;

    //public Particle(GameObject s, Vector2 v, int damage)
    //{
    //    vel = v;
    //    sprite = s;
    //    this.damage = damage;

    //    body = s.GetComponent<Rigidbody2D>();
    //    collider = s.GetComponent<Collider2D>();
    //}
    private void Awake()
    {
        body = GetComponent<Rigidbody2D>();
    }

    public void SetUp(Vector2 velocity, float damage, string originTag)
    {
        vel = velocity;
        this.damage = damage;
        origin = originTag;
    }

    public void Move()
    {
        if (body == null)
        {
            Debug.Log("no rigidbody");
            return;
        }

        body.MovePosition(body.position + (vel * dt));

        life--;
    }

    public bool IsDead()
    {
        return life <= 0;
    }

    public void HitObstacle()
    {
        life = 0;
    }

    public float Hit()
    {
        return damage;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Particle")) return;
        if (collision.CompareTag(origin) && collision.CompareTag("Player")) return;

        Debug.Log("tag: " + collision.tag);
        Enemy e = collision.GetComponent<Enemy>();
        if (e != null)
        {
            //Debug.Log("hit enemy");
            e.Damage(damage, true);
        }
        //else if (!collision.gameObject.CompareTag("Wall")) return;
        HitObstacle();
    }

}
