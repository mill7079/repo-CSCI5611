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
    // Start is called before the first frame update
    void Awake()
    {
        //DontDestroyOnLoad(gameObject); // necessary? idk

        body = GetComponent<Rigidbody2D>();
        origin = body.position;
        animator = GetComponent<Animator>();

        Dungeon.AddNewEnemy(this);
    }

    // Update is called once per frame
    void Update()
    {
        // motion planning but for now just random
        Vector2 pos = body.position;

        pos.y = pos.y + move * Time.deltaTime * direction;
        if (animator != null)
        {
            animator.SetFloat("LookX", 0);
            animator.SetFloat("LookY", direction);
        }

        if (Mathf.Abs(origin.y - pos.y) >= radius) direction *= -1;

        body.MovePosition(pos);
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        //Debug.Log(collision.);
        direction *= -1;
    }
}
