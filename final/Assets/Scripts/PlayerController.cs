using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    Rigidbody2D body;
    public float moveSpeed = 3.0f;

    Room currentRoom;

    // Start is called before the first frame update
    void Start()
    {
        body = GetComponent<Rigidbody2D>();
    }

    // Update is called once per frame
    void Update()
    {
        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");
        Vector2 move = new Vector2(horizontal, vertical);

        Vector2 position = body.position;
        position = position + move * moveSpeed * Time.deltaTime;
        body.MovePosition(position);

    }

    public Room GetCurrentRoom()
    {
        return currentRoom;
    }

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
    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.CompareTag("Door"))
        {
            Debug.Log("DOOR");
        }
    }
}
