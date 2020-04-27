using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Dungeon : MonoBehaviour
{
    //public static Dictionary<Room.Coord, Room> locations = new Dictionary<Room.Coord, Room>();
    public static Dictionary<Vector2Int, Room> locations = new Dictionary<Vector2Int, Room>();
    public static int boardRows = 8, boardCols = 8;
    public static double doorChance = 2; // door should generate ~50% of time with no preexisting door
    public Room start;

    private Transform roomHolder;

    public static List<Enemy> newEnemies;

    public void StartDungeon()
    {
        //Debug.Log("start dungeon");
        start = new Room(0, 0);
        //GameManager.instance.GetPlayer().GetComponent<PlayerController>().MoveTo(start);
        //Debug.Log("plauer room: " + GameManager.instance.GetPlayer().GetComponent<PlayerController>().GetCurrentRoom());
        GameObject player = GameObject.FindGameObjectWithTag("Player");
        player.GetComponent<PlayerController>().MoveTo(start);

        newEnemies = new List<Enemy>();
        //Debug.Log("find tag player room: " + player.GetComponent<PlayerController>().GetCurrentRoom() + " " + player.GetComponent<PlayerController>().GetCurrentRoom().loc);
        MoveRoom(start);
    }

    //public void MoveRoom(GameObject[,] floor
    public void MoveRoom(Room room) 
    {
        newEnemies.Clear();
        //Debug.Log("move to room at coords " + room.loc);
        GameObject[,] floor = room.GetTiles();
        //if (floor == null) Debug.Log("floor null");
        //room.ClearDoors();

        if (roomHolder != null)
        {
            foreach (Transform child in roomHolder.transform)
            {
                if (!child.CompareTag("Enemy")) GameObject.Destroy(child.gameObject);
                else
                {
                    child.SetParent(null); // deparent enemies so they aren't destroyed
                }
            }
        }

        //if (roomHolder != null) Debug.Log("room holder child count: "+roomHolder.childCount);
        //else { Debug.Log("room holder null"); }

        //roomHolder = new GameObject("Dungeon").transform;
        roomHolder = this.transform;
        for (int i = 0; i < floor.GetLength(0); i++)
        {
            for (int j = 0; j < floor.GetLength(1); j++)
            {
                GameObject tile = floor[i, j];
                if (tile == null) continue;
                //GameObject instance = Instantiate(tile, new Vector3(i, j, 0f), Quaternion.identity) as GameObject;
                //GameObject instance = Instantiate(tile, new Vector3(floor.GetLength(1) - j - 1, floor.GetLength(0) - i - 1, 0f), Quaternion.identity) as GameObject;
                GameObject instance = Instantiate(tile, new Vector3(j-1, floor.GetLength(0) - i - 1, 0f), Quaternion.identity) as GameObject;

                // add door to map in room
                if (tile.CompareTag("Door"))
                {
                    //Debug.Log(i + " " + j + " door");
                    BoxCollider2D door = instance.GetComponent<BoxCollider2D>();
                    //Debug.Log("floor length/2: " + floor.GetLength(1) / 2);
                    if (j == (floor.GetLength(1) - 1) / 2)
                    {
                        if (i == 0)
                        {
                            //Debug.Log("add up");
                            room.AddDoor(door, room.GetUp());
                        }
                        else if (i == floor.GetLength(0) - 1)
                        {
                            //Debug.Log("add down");
                            room.AddDoor(door, room.GetDown());
                        }
                    }
                    else if (i == (floor.GetLength(0) - 1) / 2)
                    {
                        if (j == 0)
                        {
                            //Debug.Log("add left");
                            room.AddDoor(door, room.GetLeft());
                        }
                        else if (j == floor.GetLength(1) - 1)
                        {
                            //Debug.Log("add right");
                            room.AddDoor(door, room.GetRight());
                        }
                    }
                }

                instance.transform.SetParent(roomHolder);
            }

        }
        //Debug.Log("doors: "+room.GetDoors());
        //Debug.Log("");
        //Debug.Log(room);
        //Debug.Log("");
        PlaceEnemies(room);
    }

    public static void AddNewEnemy(Enemy enemy)
    {
        //Debug.Log("add enemy");
        newEnemies.Add(enemy);
        Debug.Log("new enemies length after adding: " + newEnemies.Count);
    }

    // i don't think this will work when it comes to dealing with health but we'll see TODO
    public void PlaceEnemies(Room room)
    {
        List<Enemy> enemies = room.GetEnemies();
        Debug.Log("enemies count entering place enemies " + enemies.Count + " room " + room);
        //foreach (Enemy e in enemies)
        //{
        //    //Instantiate(e, new Vector2(e.transform.position.x, e.transform.position.y), Quaternion.identity);
        //    //e.enabled = true;
        //    e.gameObject.SetActive(true);
        //}
        room.EnemiesActive(true);

        int x = 0;
        while (enemies.Count + newEnemies.Count < (boardRows / 2))
        {
            Vector2Int spot = room.GetOpenSpots()[Random.Range(0,room.GetOpenSpots().Count)];
            GameObject[] listEnemies = GameManager.instance.GetTestEnemies();
            GameObject newEnemy = Instantiate(listEnemies[Random.Range(0, listEnemies.Length)], new Vector2(spot.x, spot.y), Quaternion.identity);
            newEnemy.transform.SetParent(this.transform);
            Debug.Log("enemies loop: enemies count " + enemies.Count + " new enemies count " + newEnemies.Count);
            x += 1;
        }
    }
}
