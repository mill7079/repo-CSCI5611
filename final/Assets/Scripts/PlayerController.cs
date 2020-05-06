using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    Rigidbody2D body;
    public float moveSpeed = 3.0f;

    Room currentRoom;
    Vector2 lookDirection = new Vector2(1, 0);

    Animator animator;

    // Start is called before the first frame update
    void Awake()
    {
        DontDestroyOnLoad(gameObject);
        body = GetComponent<Rigidbody2D>();

        animator = GetComponent<Animator>();
        Physics2D.IgnoreLayerCollision(8, 10);
    }

    // Update is called once per frame
    void Update()
    {
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");
        Vector2 move = new Vector2(horizontal, vertical);
        if (!Mathf.Approximately(move.x, 0.0f) || !Mathf.Approximately(move.y, 0.0f))
        {
            lookDirection.Set(move.x, move.y);
            lookDirection.Normalize();
        }

        animator.SetFloat("Look X", lookDirection.x);
        animator.SetFloat("Look Y", lookDirection.y);

        Vector2 position = body.position;
        position = position + move * moveSpeed * Time.deltaTime;
        body.MovePosition(position);

    }

    public Room GetCurrentRoom()
    {
        return currentRoom;
    }

    public Point GetPos() { return new Point(body.position); }

    public bool MoveTo(Room destination)
    {
        // TODO move to location of door
        if (destination == null) return false;
        currentRoom = destination;
        return true;
    }

    public void SetLocation(Vector2 pos)
    {
        //body.MovePosition(pos);
        GameObject player = GameObject.FindGameObjectWithTag("Player");
        player.transform.position = pos;
    }

    // handle triggers, mostly for doors
    //private void OnTriggerEnter2D(Collider2D collision)
    //{
    //    if (collision.gameObject.CompareTag("Door"))
    //    {
    //        Debug.Log("DOOR");
    //    }
    //}
}
