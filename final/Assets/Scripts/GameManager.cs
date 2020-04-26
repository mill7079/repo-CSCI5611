using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{

    public static GameManager instance = null;
    //public Board board;
    public Dungeon dungeon;

    // unity whyyyyy
    public GameObject[] walls;
    public GameObject[] floors;
    public GameObject[] doors;

    public GameObject[] testEnemies;
    public GameObject player;

    // Start is called before the first frame update
    void Awake()
    {
        if (instance == null)
        {
            instance = this;
        } else if (instance != this)
        {
            Destroy(gameObject);
        }

        DontDestroyOnLoad(gameObject);
        
        //board = GetComponent<Board>();
        //board.SetupBoard();

        dungeon = GetComponent<Dungeon>();
        dungeon.StartDungeon();
        //DontDestroyOnLoad(dungeon.gameObject);

        //GameObject dude = Instantiate(player, new Vector3(3,3,0f), Quaternion.identity) as GameObject;
        //dude.transform.SetParent(dungeon.transform);

    }

    public void MoveRoom(Room next)
    {
        //dungeon.MoveRoom(next.GetTiles());
        dungeon.MoveRoom(next);
    }

    public GameObject[] GetWalls() { return walls; }
    public GameObject[] GetDoors() { return doors; }
    public GameObject[] GetFloors() { return floors; }
    public GameObject[] GetTestEnemies() { return testEnemies; }
    public GameObject GetPlayer() { return player; }

    // Update is called once per frame
    void Update()
    {
        
    }
}
