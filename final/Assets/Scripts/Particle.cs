using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Particle : MonoBehaviour
{
    //private Vector2 pos;
    private Vector2 vel;
    public float dt = 0.18f;
    //private GameObject sprite;
    private Rigidbody2D body;
    //private Collider2D collide;

    private float life;
    private float damage;
    private string origin;

    public bool interact;  // true if trigger causes particle to disappear

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

    public void SetUp(Vector2 velocity, float damage, string originTag, float maxLife)
    {
        vel = velocity;
        this.damage = damage;
        origin = originTag;
        life = maxLife;
    }

    public void Move()
    {
        if (body == null || Time.timeScale == 0)
        {
            //Debug.Log("no rigidbody ");
            return;
        }

        //Debug.Log("moving particle. pos = " + body.position);
        body.MovePosition(body.position + (vel * dt));
        //body.MovePosition(body.position + (vel * Time.deltaTime));

        life--;
    }

    public bool IsDead()
    {
        return life <= 0;
    }

    public void HitObstacle()
    {
        if (interact) life = 0;
    }

    public float Hit()
    {
        return damage;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        //Debug.Log(collision.tag + " "+ origin);
        if (collision.CompareTag("Particle")) return;
        if (collision.CompareTag(origin) && collision.CompareTag("Player")) return;

        Debug.Log("obstacle");
        //Debug.Log("tag: " + collision.tag);
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
