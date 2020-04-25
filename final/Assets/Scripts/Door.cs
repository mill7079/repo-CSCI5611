using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    void OnTriggerEnter2D(Collider2D collision)
    {
        PlayerController player = collision.GetComponent<PlayerController>();
        if (player != null)
        {
            Debug.Log("went through door");
            BoxCollider2D door = this.GetComponent<BoxCollider2D>();

            Room cur = player.GetCurrentRoom();
            Debug.Log("cur: " + cur + " num doors: "+cur.GetDoors());

            Room next = cur.GetNextRoom(door);
            next.Create();
            Debug.Log("next: " + next);
            if (next == null) Debug.Log("fuckity fuck");
            else
            {
                // move player to next room and set location at door they just came through
                player.MoveTo(next);
                if (next == cur.GetUp()) player.SetLocation(new Vector2(Dungeon.boardRows, Dungeon.boardCols / 2));
                else if (next == cur.GetDown()) player.SetLocation(new Vector2(0, Dungeon.boardCols / 2));
                else if (next == cur.GetLeft()) player.SetLocation(new Vector2(Dungeon.boardRows / 2, Dungeon.boardCols));
                else if (next == cur.GetRight()) player.SetLocation(new Vector2(Dungeon.boardRows / 2, 0));

                GameManager.instance.MoveRoom(next);
            }
        }
    }
}
