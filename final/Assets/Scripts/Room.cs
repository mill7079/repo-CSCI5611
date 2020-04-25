using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Room
{

    // class to handle coordinates of rooms
    public class Coord
    {

        public int row { get; set; }
        public int col { get; set; }

        public Coord(int r, int c)
        {
            row = r;
            col = c;
        }

        // equality override for map
        public bool Equals(Coord other)
        {
            return other.row == row && other.col == col;
        }

        // directional checkers to clean up other code
        // return true if this coord is <name> other coord
            // i.e. for Above, return true if this coord is above other coord
        public bool Above(Coord other)
        {
            return other.row == (row + 1) && other.col == col;
        }

        public bool Below(Coord other)
        {
            return other.row == (row - 1) && other.col == col;
        }

        public bool Left(Coord other)
        {
            return other.row == row && other.col == (col + 1);
        }

        public bool Right(Coord other)
        {
            return other.row == row && other.col == (col - 1);
        }

        public override string ToString()
        {
            return "row: " + row + " col: " + col;
        }

    }


    // pointers to link to neighboring rooms
    private Room up, down, left, right;
    public Coord loc; // coordinates of current room (row,col)
    private GameObject[,] tiles; // array of tiles to be instantiated when player moves

    // length and width of room; might become random later? idk
    private int rows = Dungeon.boardRows, cols = Dungeon.boardCols;

    // store which colliders go to which rooms for ease of movement
    private Dictionary<BoxCollider2D, Room> doors = new Dictionary<BoxCollider2D, Room>();

    // used for creating first room in dungeon - just has initial coords
    public Room(int r, int c)
    {
        Debug.Log("new room");
        loc = new Coord(r, c);
        Dungeon.locations.Add(loc, this);
        Create();
    }

    // used for creating all other rooms - pass in coords for this room and other room
    public Room(Coord l, Coord other)
    {
        loc = l;
        if (loc.Above(other))
        {
            Dungeon.locations.TryGetValue(other, out down);
        }
        else if (loc.Below(other))
        {
            Dungeon.locations.TryGetValue(other, out up);
        }
        else if (loc.Left(other))
        {
            Dungeon.locations.TryGetValue(other, out right);
        }
        else if (loc.Right(other))
        {
            Dungeon.locations.TryGetValue(other, out left);
        }

    }


    // getters/setters for room pointers
    public Room GetUp() { return up; }
    public Room GetDown() { return down; }
    public Room GetLeft() { return left; }
    public Room GetRight() { return right; }
    public void SetUp(Room r) { up = r; }
    public void SetDown(Room r) { down = r; }
    public void SetLeft(Room r) { left = r; }
    public void SetRight(Room r) { right = r; }

    public GameObject[,] GetTiles() { return tiles; }
    public int GetDoors() { return doors.Count; }



    // associates a door collider with a room and stores in the dictionary
    public void AddDoor(BoxCollider2D door, Room room)
    {
        doors.Add(door, room);
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
        Coord other = new Coord(loc.row - 1, loc.col);

        // if the room at those coordinates exists, update this room's up pointer
        if (!Dungeon.locations.TryGetValue(other, out up))
        {
            // ...otherwise create the room and add it to the locations list
            up = new Room(loc, other);
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
        Coord other = new Coord(loc.row + 1, loc.col);
        if (!Dungeon.locations.TryGetValue(other, out down))
        {
            down = new Room(loc, other);
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
        Coord other = new Coord(loc.row, loc.col - 1);
        if (!Dungeon.locations.TryGetValue(other, out left))
        {
            left = new Room(loc, other);
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
        Coord other = new Coord(loc.row, loc.col + 1);
        if (!Dungeon.locations.TryGetValue(other, out right))
        {
            right = new Room(loc, other);
            Dungeon.locations.Add(other, right);
        }
        else
        {
            right.SetLeft(this);
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
                        BoxCollider2D door = tile.GetComponent<BoxCollider2D>();

                        // if no room exists in that direction, add one
                        // ...alright i'm not really sure what this is doing TODO
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
                        BoxCollider2D door = tile.GetComponent<BoxCollider2D>();

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
                        BoxCollider2D door = tile.GetComponent<BoxCollider2D>();

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
                        BoxCollider2D door = tile.GetComponent<BoxCollider2D>();

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
    }
}
