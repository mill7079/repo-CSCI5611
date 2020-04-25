//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;

//public class Door_old : MonoBehaviour
//{
//    // Update is called once per frame
//    void Update()
//    {

//    }

//    void OnTriggerEnter2D(Collider2D collision)
//    {
//        PlayerController player = collision.GetComponent<PlayerController>();
//        if (player != null)
//        {
//            Debug.Log("went through door");
//            BoxCollider2D door = this.GetComponent<BoxCollider2D>();

//            Room cur = player.GetCurrentRoom();

//            Room next = cur.GetNextRoom(door);
//            if (next == null) Debug.Log("fuckity fuck");
//            else
//            {
//                player.MoveTo(next);
//                if (next == cur.GetUp()) player.SetLocation(new Vector2(Dungeon.boardRows, Dungeon.boardCols / 2));
//                else if (next == cur.GetDown()) player.SetLocation(new Vector2(0, Dungeon.boardCols / 2));
//                else if (next == cur.GetLeft()) player.SetLocation(new Vector2(Dungeon.boardRows / 2, Dungeon.boardCols));
//                else if (next == cur.GetRight()) player.SetLocation(new Vector2(Dungeon.boardRows / 2, 0));
//            }

            
//            //Room[] connect = Dungeon.connections[door];
//            ////Node[] connect = Dungeon.connections[door];

//            //// move player to next room
//            //if (player.getCurrentRoom() == connect[0])
//            //{
//            //    player.moveTo(connect[1]);
//            //}
//            //else
//            //{
//            //    player.moveTo(connect[0]);
//            //}

//            // if room hasn't been created yet, create it
//            //Node room = player.getCurrentRoom();
//            //Room room = player.getCurrentRoom();
//            //if (!room.IsVisited())
//            //{
//            //    // create room
//            //}
//            //if (room.getBoard() == null)
//            //{
//            //    room.createBoard();
//            //}
//        }
//    }

//}