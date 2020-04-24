using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class Board : MonoBehaviour
{
    public int rows = Dungeon.boardRows;
    public int columns = Dungeon.boardCols;

    public GameObject[] walls;
    public GameObject[] floors;
    public GameObject[] doors;

    public GameObject[] testEnemies;
    public GameObject testDude;

    private Transform boardHolder;
    private double doorChance = 2; // 50% chance of door spawning for each edge, possibility for dead ends which is fine
    int numDoors = 1;

    // Start is called before the first frame update
    void Start()
    {
        //SetupBoard();
    }

    // Update is called once per frame
    void Update()
    {

    }

    //sample method for sprite/concept testing
    public Transform SetupBoard()
    //public void setup()
    {
        //boardHolder = this.transform;
        boardHolder = new GameObject("Board").transform;
        for (int i = -1; i <= rows; i++)
        {
            for (int j = -1; j <= columns; j++)
            {
                GameObject tile = floors[0];
                if (i == -1 || j == -1 || i == rows || j == columns)
                {
                    tile = walls[0];
                    if ((j == columns / 2 || i == rows / 2) && (Random.Range(0, 999) % doorChance == 0))
                    {
                        tile = doors[0];
                        numDoors++;
                    }

                }

                GameObject instance = Instantiate(tile, new Vector3(i, j, 0f), Quaternion.identity) as GameObject;
                instance.transform.SetParent(boardHolder);
            }
        }

        GameObject dude = Instantiate(testEnemies[0], new Vector3(5, 5, 0f), Quaternion.identity) as GameObject;
        dude.transform.SetParent(boardHolder);
        GameObject dude2 = Instantiate(testDude, new Vector3(6, 5, 0f), Quaternion.identity) as GameObject;
        dude2.transform.SetParent(boardHolder);
        GameObject darkshadow = Instantiate(testEnemies[1], new Vector3(6, 6, 0f), Quaternion.identity) as GameObject;
        darkshadow.transform.SetParent(boardHolder);

        return boardHolder;
    }

    //public void SetupBoard(Transform parent)
    //{
    //    Debug.Log("fuck this");
    //    boardHolder = parent;
    //    for (int i = -1; i <= rows; i++)
    //    {
    //        for (int j = -1; j <= columns; j++)
    //        {
    //            GameObject tile = floors[0];
    //            if (i == -1 || j == -1 || i == rows || j == columns)
    //            {
    //                tile = walls[0];
    //                if ((j == columns / 2 || i == rows / 2) && (Random.Range(0, 999) % doorChance == 0))
    //                {
    //                    tile = doors[0];
    //                    numDoors++;
    //                }

    //            }

    //            GameObject instance = Instantiate(tile, new Vector3(i, j, 0f), Quaternion.identity) as GameObject;
    //            instance.transform.SetParent(boardHolder);
    //        }
    //    }

    //    GameObject dude = Instantiate(testEnemies[0], new Vector3(5, 5, 0f), Quaternion.identity) as GameObject;
    //    dude.transform.SetParent(boardHolder);
    //    GameObject dude2 = Instantiate(testDude, new Vector3(6, 5, 0f), Quaternion.identity) as GameObject;
    //    dude2.transform.SetParent(boardHolder);
    //    GameObject darkshadow = Instantiate(testEnemies[1], new Vector3(6, 6, 0f), Quaternion.identity) as GameObject;
    //    darkshadow.transform.SetParent(boardHolder);

    //    //return boardHolder;
    //}


    public void setup (Room cur)
    {
        /*
         * setup walls/floor
         * add current doors
         * add new doors
         * add nodes for new doors*/

        boardHolder = this.transform;
        // bounds from -1 to rows to ensure open space is rows x columns
        for (int i = -1; i <= rows; i++)
        {
            for (int j = -1; j <= columns; j++)
            {
                GameObject tile = floors[0];
                // if wall
                if (i == -1 || j == -1 || i == rows || j == columns)
                {
                    tile = walls[0];
                    //if ((j == columns / 2 || i == rows / 2) && (Random.Range(0, 999) % doorChance == 0))
                    //{
                    //    tile = doors[0];
                    //    numDoors++;
                    //}
                    // handle pre-existing doors; there's gotta be a better way to do this TODO
                    if (j == columns/2 && i == -1) // up
                    {
                        // no door, no random generation
                        if (cur.GetUp() == null && (Random.Range(0, 999) % doorChance != 0))
                        {
                            continue;
                        }
                        tile = doors[0];
                        BoxCollider2D door = tile.GetComponent<BoxCollider2D>();
                        if (cur.GetUp() == null)
                        {
                            cur.AddUp();
                        }
                        cur.AddDoor(door, cur.GetUp());
                    }
                    else if (j == columns / 2 && i == rows) // down
                    {
                        if (cur.GetDown() == null && (Random.Range(0, 999) % doorChance != 0))
                        {
                            continue;
                        }
                        tile = doors[0];
                        BoxCollider2D door = tile.GetComponent<BoxCollider2D>();
                        if (cur.GetDown() == null)
                        {
                            cur.AddDown();
                        }
                        cur.AddDoor(door, cur.GetDown());
                    }
                    else if (i == rows / 2 && j == -1) // left
                    {
                        if (cur.GetLeft() == null && (Random.Range(0, 999) % doorChance != 0))
                        {
                            continue;
                        }
                        tile = doors[0];
                        BoxCollider2D door = tile.GetComponent<BoxCollider2D>();
                        if (cur.GetLeft() == null)
                        {
                            cur.AddLeft();
                        }
                        cur.AddDoor(door, cur.GetLeft());
                    }
                    else if (i == rows / 2 && j == columns) // right
                    {
                        if (cur.GetRight() == null && (Random.Range(0, 999) % doorChance != 0))
                        {
                            continue;
                        }
                        tile = doors[0];
                        BoxCollider2D door = tile.GetComponent<BoxCollider2D>();
                        if (cur.GetRight() == null)
                        {
                            cur.AddRight();
                        }
                        cur.AddDoor(door, cur.GetRight());
                    }

                }

                GameObject instance = Instantiate(tile, new Vector3(i, j, 0f), Quaternion.identity) as GameObject;
                instance.transform.SetParent(boardHolder);
            }
        }
    }


    public int getNumDoors()
    {
        return numDoors;
    }
}
