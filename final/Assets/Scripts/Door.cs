using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Door : MonoBehaviour
{
    void OnTriggerEnter2D(Collider2D collision)
    {
        PlayerController player = collision.GetComponent<PlayerController>();
        if (player != null)
        {
            //Debug.Log("went through door");
            BoxCollider2D door = this.GetComponent<BoxCollider2D>();

            Room cur = player.GetCurrentRoom();
            //Debug.Log("cur: " + cur + " num doors: "+cur.GetDoors());

            Room next = cur.GetNextRoom(door);
            if (next.GetTiles() == null) next.Create();
            //Debug.Log("next: " + next);

            //GameObject playerObject = GameObject.FindGameObjectWithTag("Player");
            //playerObject.transform.
            if (next == null) Debug.Log("fuckity fuck");
            else
            {
                // move player to next room and set location at door they just came through
                player.MoveTo(next);
                //if (next == cur.GetUp()) player.SetLocation(new Vector2(Dungeon.boardRows, Dungeon.boardCols / 2));
                //else if (next == cur.GetDown()) player.SetLocation(new Vector2(0, Dungeon.boardCols / 2));
                //else if (next == cur.GetLeft()) player.SetLocation(new Vector2(Dungeon.boardRows / 2, Dungeon.boardCols));
                //else if (next == cur.GetRight()) player.SetLocation(new Vector2(Dungeon.boardRows / 2, 0));
                //else Debug.Log("Pointer failure");

                //player.SetLocation(new Vector2(5, 5));
                if (next == cur.GetUp())
                {
                    //player.SetLocation(new Vector2(5, Dungeon.boardCols / 2));
                    player.SetLocation(new Vector2(door.transform.position.x, 1));
                    //Debug.Log("DOOR UP");
                }
                else if (next == cur.GetDown())
                {
                    //player.SetLocation(new Vector2(Dungeon.boardRows, Dungeon.boardCols / 2));
                    player.SetLocation(new Vector2(door.transform.position.x, Dungeon.boardRows));
                    //Debug.Log("DOOR DOWN");
                }
                else if (next == cur.GetLeft())
                {
                    player.SetLocation(new Vector2(Dungeon.boardCols - 1, door.transform.position.y));
                    //Debug.Log("DOOR LEFT");
                }
                else if (next == cur.GetRight())
                {
                    player.SetLocation(new Vector2(1, door.transform.position.y));
                    //Debug.Log("DOOR RIGHT");
                }
                else Debug.Log("Pointer failure");

                //Application.LoadLevel(Application.loadedLevel);
                //SceneManager.LoadScene(SceneManager.GetActiveScene().name);
                GameManager.instance.MoveRoom(next);
            }
        }
    }
}
