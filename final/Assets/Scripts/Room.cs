using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Room
{
    // pointers to link to neighboring rooms
    private Room up, down, left, right;
    //public Coord loc; // coordinates of current room (row,col)
    public Vector2Int loc;
    private GameObject[,] tiles; // array of tiles to be instantiated when player moves

    // length and width of room; might become random later? idk
    private int rows = Dungeon.boardRows, cols = Dungeon.boardCols;

    // store which colliders go to which rooms for ease of movement
    private Dictionary<BoxCollider2D, Room> doors = new Dictionary<BoxCollider2D, Room>();

    // list of enemies in the current room
    private List<Enemy> enemies;

    // list of open floor spots
    private List<Vector2Int> spots;

    // list of points for PRM
    public List<Point> prm;


    /*Constructors*/
    // used for creating first room in dungeon - just has initial coords
    public Room(int r, int c)
    {
        enemies = new List<Enemy>();
        //Debug.Log("short cons*|*|*|*|*|*|*|*|*");
        //Debug.Log("new room");
        //loc = new Coord(r, c);
        loc = new Vector2Int(r, c);
        Dungeon.locations.Add(loc, this);
        Create();
    }

    // used for creating all other rooms - pass in coords for this room and other room
    //public Room(Coord current, Coord source)
    public Room(Vector2Int current, Vector2Int source)
    {
        //Debug.Log("long cons*|*|*|*|*|*|*|*|*");
        //Debug.Log("cur: " + current + " source: " + source);
        //Debug.Log("locations length: " + Dungeon.locations.Count);
        //foreach (Vector2Int l in Dungeon.locations.Keys) Debug.Log("Dict " + l + " looking for: " + source);
        //foreach (KeyValuePair<Vector2Int, Room> pair in Dungeon.locations) Debug.Log("location " + pair.Key);

        enemies = new List<Enemy>();
        loc = current;
        //if (loc.Above(source))
        if (Above(loc, source)) 
        {
            //Debug.Log("above cons");
            //Debug.Log(Dungeon.locations.TryGetValue(source, out down));
            Dungeon.locations.TryGetValue(source, out down);
            //Debug.Log("down: " + down);
        }
        //else if (loc.Below(source))
        else if (Below(loc, source))
        {
            //Debug.Log("below cons");
            //Debug.Log(Dungeon.locations.TryGetValue(source, out up));
            //Debug.Log("up: " + up);
            Dungeon.locations.TryGetValue(source, out up);
        }
        //else if (loc.Left(source))
        else if (Left(loc, source))
        {
            //Debug.Log("left cons");
            //Debug.Log(Dungeon.locations.TryGetValue(source, out right));
            //Debug.Log("right: " + right);
            Dungeon.locations.TryGetValue(source, out right);
        }
        //else if (loc.Right(source))
        else if (Right(loc, source))
        {
            //Debug.Log("right cons");
            //Debug.Log(Dungeon.locations.TryGetValue(source, out left));
            //Debug.Log("left: " + left);
            Dungeon.locations.TryGetValue(source, out left);
        }

    }


    /*Methods*/
    // getters/setters for room pointers
    public Room GetUp() { return up; }
    public Room GetDown() { return down; }
    public Room GetLeft() { return left; }
    public Room GetRight() { return right; }
    public List<Point> GetPoints() { return prm; }
    public void SetPoints(List<Point> points) { prm = points; }
    public void SetUp(Room r) { up = r; }
    public void SetDown(Room r) { down = r; }
    public void SetLeft(Room r) { left = r; }
    public void SetRight(Room r) { right = r; }

    public GameObject[,] GetTiles() { return tiles; }
    public int GetDoors() { return doors.Count; }
    public List<Enemy> GetEnemies() { return enemies; }
    public List<Vector2Int> GetOpenSpots() { return spots; }

    // check if current Vector2 is <name> the source Vector2 - x and y are array indices so row/col
    public bool Above(Vector2Int cur, Vector2Int source)
    {
        return source.x > cur.x && source.y == cur.y;
    }

    public bool Below(Vector2Int cur, Vector2Int source)
    {
        return source.x < cur.x && source.y == cur.y;
    }

    public bool Left(Vector2Int cur, Vector2Int source)
    {
        return source.x == cur.x && source.y > cur.y;
    }

    public bool Right(Vector2Int cur, Vector2Int source)
    {
        return source.x == cur.x && source.y < cur.y;
    }


    // associates a door collider with a room and stores in the dictionary
    public void AddDoor(BoxCollider2D door, Room room)
    {
        if (!doors.ContainsKey(door)) doors.Add(door, room);
    }

    // adds an enemy to the enemies list
    public void AddEnemy(Enemy enemy)
    {
        enemies.Add(enemy);
    }

    // gets the room associated with a door collider
    public Room GetNextRoom(BoxCollider2D door)
    {
        return doors[door];
    }

    // empties dictionary of doors, not sure if needed
    public void ClearDoors()
    {
        doors = new Dictionary<BoxCollider2D, Room>();
    }


    // adding new rooms to directions; if a room already exists in that direction, update its pointers
    // adds an empty room in the up direction
    public void AddUp()
    {
        // find coordinates for new room
        //Coord other = new Coord(loc.row - 1, loc.col);
        Vector2Int other = new Vector2Int(loc.x - 1, loc.y);

        // if the room at those coordinates exists, update this room's up pointer
        if (!Dungeon.locations.TryGetValue(other, out up))
        {
            // ...otherwise create the room and add it to the locations list
            //up = new Room(loc, other);
            up = new Room(other, loc);
            Dungeon.locations.Add(other, up);
        }
        else // update the preexisting room's pointer to this room
        {
            up.SetDown(this);
        }
    }

    // add empty room in down direction
    public void AddDown()
    {
        //Coord other = new Coord(loc.row + 1, loc.col);
        Vector2Int other = new Vector2Int(loc.x + 1, loc.y);
        if (!Dungeon.locations.TryGetValue(other, out down))
        {
            //down = new Room(loc, other);
            down = new Room(other, loc);
            Dungeon.locations.Add(other, down);
        }
        else
        {
            down.SetUp(this);
        }
    }

    // add empty room in left direction
    public void AddLeft()
    {
        //Coord other = new Coord(loc.row, loc.col - 1);
        Vector2Int other = new Vector2Int(loc.x, loc.y - 1);
        if (!Dungeon.locations.TryGetValue(other, out left))
        {
            // left = new Room(loc, other);
            left = new Room(other, loc);
            Dungeon.locations.Add(other, left);
        }
        else
        {
            left.SetRight(this);
        }
    }

    // add empty room in right direction
    public void AddRight()
    {
        //Coord other = new Coord(loc.row, loc.col + 1);
        Vector2Int other = new Vector2Int(loc.x, loc.y + 1);
        if (!Dungeon.locations.TryGetValue(other, out right))
        {
            //right = new Room(loc, other);
            right = new Room(other, loc);
            Dungeon.locations.Add(other, right);
        }
        else
        {
            right.SetLeft(this);
        }
    }

    // turns enemies in room on or off depending on active
    public void EnemiesActive(bool active)
    {
        foreach (Enemy e in enemies)
        {
            e.gameObject.SetActive(active);
        }
    }

    // sets up 2D array of room tiles to be instantiated when player enters the room
    // modified from board_old.cs
    public void Create()
    {
        // add 2 extra rows/cols to array so open space is rows x cols
        tiles = new GameObject[rows + 2, cols + 2];
        GameObject[] floors = GameManager.instance.GetFloors();
        GameObject[] doors = GameManager.instance.GetDoors();
        GameObject[] walls = GameManager.instance.GetWalls();

        for (int i = 0; i < tiles.GetLength(0); i++)
        {
            for (int j = 0; j < tiles.GetLength(1); j++)
            {
                // default to floor
                GameObject tile = floors[0];
                if (Random.Range(0, 999) % 99 == 0) tile = floors[1];

                // change to wall or door if on edge of board
                //if (i == -1 || j == -1 || i == rows || j == columns)
                if (i == 0 || j == 0 || i == rows + 1 || j == cols + 1)
                {
                    // tile will usually be a wall in this case
                    tile = walls[0];

                    // handle pre-existing doors; there's gotta be a better way to do this TODO
                    //if (j == columns / 2 && i == -1) // up
                    if (j == (cols + 1) / 2 && i == 0) // up
                    {
                        // no preexisting door, no random generation - leave as wall
                        if (up == null && (Random.Range(0, 999) % Dungeon.doorChance != 0))
                        {
                            tiles[i, j] = tile;
                            continue;
                        }

                        // otherwise, there'll be a door
                        tile = doors[0];
                        //BoxCollider2D door = tile.GetComponent<BoxCollider2D>();

                        // if no room exists in that direction, add one
                        // door was randomly generated in that direction
                        if (up == null)
                        {
                            AddUp();
                        }
                        //AddDoor(door, up);
                    }
                    else if (j == (cols + 1) / 2 && i == (rows + 1)) // down
                    {
                        if (down == null && (Random.Range(0, 999) % Dungeon.doorChance != 0))
                        {
                            tiles[i, j] = tile;
                            continue;
                        }

                        tile = doors[0];
                        //BoxCollider2D door = tile.GetComponent<BoxCollider2D>();

                        if (down == null)
                        {
                            AddDown();
                        }
                        //AddDoor(door, down);
                    }
                    else if (i == (rows + 1) / 2 && j == 0) // left
                    {
                        if (left == null && (Random.Range(0, 999) % Dungeon.doorChance != 0))
                        {
                            tiles[i, j] = tile;
                            continue;
                        }

                        tile = doors[0];
                        //BoxCollider2D door = tile.GetComponent<BoxCollider2D>();

                        if (left == null)
                        {
                            AddLeft();
                        }
                        //AddDoor(door, left);
                    }
                    else if (i == (rows + 1) / 2 && j == (cols + 1)) // right
                    {
                        if (right == null && (Random.Range(0, 999) % Dungeon.doorChance != 0))
                        {
                            tiles[i, j] = tile;
                            continue;
                        }

                        tile = doors[0];
                        //BoxCollider2D door = tile.GetComponent<BoxCollider2D>();

                        if (right == null)
                        {
                            AddRight();
                        }
                        //AddDoor(door, right);
                    }

                }

                tiles[i, j] = tile;
            }
        }
        PlaceRandom();
    }

    // places wall tiles in random locations throughout the room
    public void PlaceRandom()
    {
        // set up list of open spots
        spots = new List<Vector2Int>();
        //for (int i = 1; i <= rows; i++)
        //{
        //    for (int j = 0; j < cols; j++)
        //    {
        //        spots.Add(new Vector2Int(j,i));
        //    }
        //}

        // j-1, floor.GetLength(0) - i - 1
        for (int i = 2; i < tiles.GetLength(0) - 2; i++)
        {
            for (int j = 2; j < tiles.GetLength(1) - 2; j++)
            {
                spots.Add(new Vector2Int(i, j));
            }
        }

        int numObs = Random.Range(GameManager.instance.numObstacles / 2, GameManager.instance.numObstacles);
        for (int i = 0; i < numObs && !(spots.Count == 0); i++)
        {
            Vector2Int location = spots[Random.Range(0, spots.Count)];
            tiles[location.x, location.y] = GameManager.instance.walls[0];
            //tiles[location.y, location.x] = GameManager.instance.walls[0];
            spots.Remove(location);
            //Debug.Log("wall at " + location + " in room space and (" + (location.y) + ", " + (tiles.GetLength(0) - location.x - 1)+") in unity space");
        }
    }

    public override string ToString()
    {
        // print tiles
        //string ret = "";
        //for (int i = 0; i < tiles.GetLength(0); i++)
        //{
        //    for (int j = 0; j < tiles.GetLength(1); j++)
        //    {
        //        ret += tiles[i, j] + " ";
        //    }
        //    ret += "\n";
        //}
        //return ret;

        // print doors
        //return "up " + (up?.loc) + " down " + (down?.loc) + " left " + (left?.loc) + " right " + (right?.loc);

        // print location
        return "" + loc;

    }
}