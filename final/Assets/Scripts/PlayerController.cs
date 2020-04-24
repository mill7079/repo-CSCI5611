using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    Rigidbody2D body;
    public float moveSpeed = 3.0f;

    //Node currentRoom;
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

    //public Node getCurrentRoom()
    //{
    //    return currentRoom;
    //}
    public Room GetCurrentRoom()
    {
        return currentRoom;
    }

    //public bool moveTo(Node destination)
    //{
    //    if (destination == null) return false;
    //    currentRoom = destination;
    //    return true;
    //}
    public bool MoveTo(Room destination)
    {
        // TODO move to location of door
        if (destination == null) return false;
        currentRoom = destination;
        return true;
    }

    public void SetLocation(Vector2 pos)
    {
        body.MovePosition(pos);
    }
}
