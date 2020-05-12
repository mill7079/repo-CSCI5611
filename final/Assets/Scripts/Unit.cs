using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Unit : MonoBehaviour
{
    public float attack, defense, maxHealth, attackRadius, speed;
    protected float currentHealth;
    public GameObject rangedAttack; // null if no ranged non-magic attack
    protected bool isDead = false;

    protected Animator animator;
    protected Vector2 lookDirection = new Vector2(1, 0);
    protected Rigidbody2D body;

    protected Particles magic;
    public bool useMagic;

    // Start is called before the first frame update
    protected virtual void Awake()
    {
        Physics2D.IgnoreLayerCollision(8, 10);

        currentHealth = maxHealth;

        animator = GetComponent<Animator>();
        body = GetComponent<Rigidbody2D>();

        magic = GetComponentInChildren<Particles>();

        useMagic = false;
    }

    // Update is called once per frame
    //void Update()
    //{
    //    if (isDead) return;
    //}

    // gets ratio of current to max health for sizing the health bar
    public float GetCurrentHealth()
    {
        return currentHealth / maxHealth;
    }

    // check if the unit is dead
    public bool IsDead()
    {
        return isDead;
    }

    // get the position of the unit
    public Point GetPos()
    {
        return new Point(body.position);
    }

    // unit takes damage from an attack
    // if the attack was from a spell, damage is particle-based so has to ignore defense
        // until I figure out a better way of taking defense into account
    public void Damage(float att, bool isParticle) 
    {
        if (isParticle)
        {
            currentHealth -= att;
        } else
        {
            if (defense >= att) currentHealth -= 1;
            else currentHealth -= (att - defense);
        }

        if (currentHealth <= 0) isDead = true;
    }
}
