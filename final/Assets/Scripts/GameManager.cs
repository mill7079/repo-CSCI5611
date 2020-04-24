using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{

    public static GameManager instance = null;
    // *** public Board board;
    public Dungeon dungeon;

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
        // *** board = GetComponent<Board>();
        // *** board.SetupBoard();

        dungeon = GetComponent<Dungeon>();
        dungeon.StartDungeon();

    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
