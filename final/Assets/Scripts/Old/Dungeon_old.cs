//using System.Collections;
//using System.Collections.Generic;
//using UnityEngine;
//using Random = UnityEngine.Random;

//public class Dungeon_old : MonoBehaviour
//{
//    //public static Dictionary<BoxCollider2D, Node[]> connections;
//    //public static Dictionary<BoxCollider2D, Room[]> connections;
//    //public static Dictionary<Vector2, Room> locations;
//    public static Dictionary<Room.Coord, Room> locations;
//    public static int boardRows = 8, boardCols = 8;
//    public Room start;

//    // pass in player's current location?
//    //public Dungeon()
//    //{
//    //    //connections = new Dictionary<BoxCollider2D, Node[]>();
//    //    //connections = new Dictionary<BoxCollider2D, Room[]>();
//    //    //locations = new Dictionary<Vector2, Room>();
//    //    locations = new Dictionary<Room.Coord, Room>();

//    //    // start in random location
//    //    Room start = new Room(Random.Range(0,6), Random.Range(0,6));

//    //}

//    public void StartDungeon()
//    {
//        locations = new Dictionary<Room.Coord, Room>();

//        //// start in random location
//        ////start = new Room(Random.Range(6, 9), Random.Range(6, 9));
//        start = new Room(8, 8);
//    }
//    //Board[,] layout;
//    //public int rows;
//    //public int cols;

//    //public Dungeon()
//    //{
//    //    // why does c# do 2d arrays so strangely
//    //    layout = new Board[rows, cols];


//    //}
//    //// Start is called before the first frame update
//    //void Start()
//    //{

//    //}

//    //// Update is called once per frame
//    //void Update()
//    //{

//    //}
//}
