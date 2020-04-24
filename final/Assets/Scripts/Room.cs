using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Room
{

    public class Coord
    {
        //public int row { get { return r; } }
        //public int col { get { return c; } }

        //private int r, c;

        public int row { get; set; }
        public int col { get; set; }

        public Coord(int r, int c)
        {
            //this.r = r;
            //this.c = c;
            row = r;
            col = c;
        }

        public bool Equals(Coord other)
        {
            return other.row == row && other.col == col;
        }

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

    }


    private Room up, down, left, right;
    private Coord loc;
    private Board board;
    private Dictionary<BoxCollider2D, Room> doors = new Dictionary<BoxCollider2D, Room>();

    // for instantiating first room
    public Room(int r, int c)
    {
        loc = new Coord(r, c);
        Dungeon.locations.Add(loc, this);
        Create();
    }

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

    public Room GetUp() { return up; }
    public Room GetDown() { return down; }
    public Room GetLeft() { return left; }
    public Room GetRight() { return right; }
    public void SetUp(Room r) { up = r; }
    public void SetDown(Room r) { down = r; }
    public void SetLeft(Room r) { left = r; }
    public void SetRight(Room r) { right = r; }

    public void Create()
    {
        if (board != null) return;
        board = new Board();
        board.setup(this);
    }

    public void AddDoor(BoxCollider2D door, Room room)
    {
        doors.Add(door, room);
    }

    public Room GetNextRoom(BoxCollider2D door)
    {
        return doors[door];
    }

    public void AddUp()
    {
        Coord other = new Coord(loc.row - 1, loc.col);
        if (!Dungeon.locations.TryGetValue(other, out up))
        {
            up = new Room(loc, other);
            Dungeon.locations.Add(other, up);
        }
        else
        {
            up.SetDown(this);
        }
    }

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


    //Node[] neighbors;
    //BoxCollider2D[] doors;
    //Board board = null;

    //Coord loc;

    //public Node(Coord location, BoxCollider2D[] door)
    //{
    //    loc = location;
    //    doors = door;
    //}

    //public Board getBoard()
    //{
    //    return board;
    //}

    ///**
    // * Sets up the board graphics and enemies.
    // */
    //public void createBoard()
    //{
    //    board = new Board();
    //    board.setup();
    //}f

    //public Node(Board b)
    //{
    //    board = b;
    //    doors = new Node[b.getNumDoors()];
    //}

    //public Node getLeft()
    //{
    //    return left;
    //}
}
