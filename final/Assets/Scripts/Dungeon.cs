using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Dungeon : MonoBehaviour
{
    public static Dictionary<Vector2Int, Room> locations;// = new Dictionary<Vector2Int, Room>();
    public static int boardRows = 17, boardCols = 17;
    public static double doorChance = 2; // door should generate ~50% of time with no preexisting door
    public Room start, current;

    public int numPoints = 500;  // number of points in PRM 
    public float neighborRadius = boardRows / 3.0f;  // used for generating PRM

    GameObject player;
    PlayerController playerController;

    private Transform roomHolder;

    public static List<Enemy> newEnemies;

    // GUI
    public GUIStyle style = new GUIStyle();
    public GUIContent inventoryButton;
    public GUIContent craftingButton;

    public void Update()
    {
        if (Input.GetButtonDown("Jump")) // pause the game/view menu
        {
            if (GameManager.isPaused)
            {
                GameManager.isPaused = false;
                Time.timeScale = 1;
            } else
            {
                GameManager.isPaused = true;
                Time.timeScale = 0;
            }
            //GameManager.isPaused = !GameManager.isPaused;
        }

        // remove enemies that are dead
        List<Enemy> enemies = current.GetEnemies();
        //Debug.Log("enemies count " + enemies.Count);
        for (int i = enemies.Count - 1; i >= 0; i--)
        {
            //Debug.Log("enemy health: " + enemies[i].health);
            if (enemies[i].IsDead())
            {
                Enemy x = enemies[i];
                current.GetEnemies().Remove(enemies[i]);
                //enemies[i].gameObject.SetActive(false);
                GameObject.Destroy(x.gameObject);
            }
        }

        // really not sure when newEnemies get added to the room's enemies
        for (int i = newEnemies.Count - 1; i >= 0; i--)
        {
            if (newEnemies[i].IsDead())
            {
                Enemy e = newEnemies[i];
                newEnemies.Remove(e);
                //e.gameObject.SetActive(false);
                GameObject.Destroy(e.gameObject);
            }
        }


        // recalculate enemy paths every so often
        if (Time.frameCount % 60 == 0)
        {
            for (int i = 0; i < enemies.Count + newEnemies.Count; i++)
            {
                if (i < enemies.Count) UpdateEnemy(enemies[i]);
                if (i < newEnemies.Count) UpdateEnemy(newEnemies[i]);
            }
        }
    }

    public void StartDungeon()
    {
        //Debug.Log("start dungeon");
        Time.timeScale = 1;
        GameManager.isPaused = false;
        locations = new Dictionary<Vector2Int, Room>();
        newEnemies = new List<Enemy>();

        start = new Room(0, 0);
        current = start;
        //GameManager.instance.GetPlayer().GetComponent<PlayerController>().MoveTo(start);
        player = GameObject.FindGameObjectWithTag("Player");
        playerController = player.GetComponent<PlayerController>();
        Debug.Log("Player controller: " + playerController);
        playerController.MoveTo(start);

        //Debug.Log("find tag player room: " + player.GetComponent<PlayerController>().GetCurrentRoom() + " " + player.GetComponent<PlayerController>().GetCurrentRoom().loc);
        MoveRoom(start);
    }

    //public void MoveRoom(GameObject[,] floor
    public void MoveRoom(Room room) 
    {
        newEnemies.Clear();
        current = room;
        //Debug.Log("move to room at coords " + room.loc);
        GameObject[,] floor = room.GetTiles();
        Dictionary<Vector2Int, GameObject> obstacles = room.GetObstacles();
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

        roomHolder = this.transform;
        for (int i = 0; i < floor.GetLength(0); i++)
        {
            for (int j = 0; j < floor.GetLength(1); j++)
            {
                GameObject tile = floor[i, j];
                if (tile == null) continue;
                //GameObject instance = Instantiate(tile, new Vector3(i, j, 0f), Quaternion.identity) as GameObject;
                //GameObject instance = Instantiate(tile, new Vector3(floor.GetLength(1) - j - 1, floor.GetLength(0) - i - 1, 0f), Quaternion.identity) as GameObject;
                GameObject instance = Instantiate(tile, new Vector3(j, floor.GetLength(0) - i - 1, 0f), Quaternion.identity) as GameObject;

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

        } // end instantiating room

        // instantiate non-enemy obstacles in room
        //foreach (GameObject obs in obstacles.Keys)
        foreach (Vector2Int loc in obstacles.Keys)
        {
            //Vector2Int loc = obstacles[obs];
            GameObject instance = Instantiate(obstacles[loc], new Vector3(loc.x, floor.GetLength(0) - loc.y - 1, 0f), Quaternion.identity) as GameObject;
            instance.transform.SetParent(roomHolder);
        }

        // create PRM for room if not created yet
        if (room.GetPoints() == null) {
            List<Point> prm = SamplePoints();
            CreateGraph(prm);
            room.SetPoints(prm);
        }

        // place existing enemies/generate and place new ones
        PlaceEnemies(room);


        List<Enemy> enemies = room.GetEnemies();
        //Point playerLoc = ClosestPoint(GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerController>().GetPos(), room.GetPoints());
        foreach (Enemy e in enemies)
        {

            UpdateEnemy(e);
        }

        foreach (Enemy e in newEnemies)
        {

            UpdateEnemy(e);
        }
    } // end MoveRoom

    public static void AddNewEnemy(Enemy enemy)
    {
        //Debug.Log("add enemy");
        newEnemies.Add(enemy);
        //Debug.Log("new enemies length after adding: " + newEnemies.Count);
    }

    // i don't think this will work when it comes to dealing with health but we'll see TODO
    public void PlaceEnemies(Room room)
    {
        List<Enemy> enemies = room.GetEnemies();
        //Debug.Log("enemies count entering place enemies " + enemies.Count + " room " + room);
        //foreach (Enemy e in enemies)
        //{
        //    //Instantiate(e, new Vector2(e.transform.position.x, e.transform.position.y), Quaternion.identity);
        //    //e.enabled = true;
        //    e.gameObject.SetActive(true);
        //}
        room.EnemiesActive(true);

        //while (enemies.Count + newEnemies.Count < (boardRows / 2))
        while (enemies.Count + newEnemies.Count < 5)
        {
            Vector2Int spot = room.GetOpenSpots()[Random.Range(0,room.GetOpenSpots().Count)];
            GameObject[] listEnemies = GameManager.instance.GetTestEnemies();
            //j - 1, floor.GetLength(0) - i - 1
            //GameObject newEnemy = Instantiate(listEnemies[Random.Range(0, listEnemies.Length)], new Vector2(spot.x, spot.y), Quaternion.identity);
            GameObject newEnemy = Instantiate(listEnemies[Random.Range(0, listEnemies.Length)], new Vector2(spot.x, boardRows - spot.y - 1), Quaternion.identity);
            newEnemy.transform.SetParent(this.transform);
            //Debug.Log("enemies loop: enemies count " + enemies.Count + " new enemies count " + newEnemies.Count);
        }
    } // end PlaceEnemies

    // randomly samples numPoints number of points for PRM construction
    public List<Point> SamplePoints()
    {
        List<Point> points = new List<Point>();
        while (points.Count < numPoints)
        {
            // should be exclusive of upper bound because ints but who knows
            Vector2 curPoint = new Vector2(Random.Range(0.5f, boardRows + 0.5f), Random.Range(0.5f, boardCols + 0.5f));
            if (Physics2D.OverlapPoint(curPoint, (1<<10)) == null)
            {
                points.Add(new Point(curPoint));
            }

        }

        return points;
    }

    // sets up graph in list of points
    public void CreateGraph(List<Point> points)
    {
        foreach (Point cur in points)
        {
            foreach(Point p in points)
            {
                if (cur == p) continue; // avoid adding self to own neighbors list

                if (Vector2.Distance(p.GetPos(), cur.GetPos()) <= neighborRadius && GoodPath(cur.GetPos(), p.GetPos()))
                {
                    cur.AddNeighbor(p);
                    Debug.DrawLine(cur.GetPos(), p.GetPos(), new Color(255, 0, 0), 30.0f, false);
                }
            }
        }
    }

    // check if path FROM a TO b is clear
    // returns true if no colliders are hit on the configuration layer
    public static bool GoodPath(Vector2 a, Vector2 b)
    {
        Vector2 dir = b - a;
        //return Physics2D.Raycast(a, dir, dir.magnitude, LayerMask.GetMask("Configuration")).collider == null;
        return Physics2D.Raycast(a, dir, dir.magnitude, (1<<10)).collider == null;
    }


    // finds the closest point to a given point from a list of points
    public static Point ClosestPoint(Point point, List<Point> points)
    {
        Point closest = points[0];
        for (int i = 0; i < points.Count; i++)
        {
            if (Vector2.Distance(point.GetPos(), points[i].GetPos()) < Vector2.Distance(point.GetPos(), closest.GetPos()))
            {
                closest = points[i];
            }
        }

        return closest;
    }

    // update positions of enemies, re-finding path if required
    public void UpdateEnemy(Enemy e)
    {
        //if(e.pathCreated && GoodPath(e.GetPos().GetPos(), playerController.GetPos().GetPos())) {
        //    e.InitPath(e.GetPos(), playerController.GetPos());
        //    return;
        //}
        Point ePos = e.GetPos();
        Point playerPos = playerController.GetPos();

        // only do the pathfinding if the player is close enough to the enemy to be detected
        if (Vector2.Distance(ePos.GetPos(), playerPos.GetPos()) > playerController.detectRadius){
            return;
        }

        // if the player is already visible, no pathfinding required
        // apparently UCS is really fucking slow so avoid wherever possible
        if (GoodPath(ePos.GetPos(), playerPos.GetPos())) {
            e.InitPath(ePos, playerPos);
            return;
        }

        Point enemyStart = ClosestPoint(ePos, current.GetPoints());
        Point playerLoc = ClosestPoint(playerPos, current.GetPoints());

        e.UpdateEndpoints(enemyStart, playerLoc);
        GameManager.UCS(current.GetPoints(), enemyStart, playerLoc);
        e.CreatePath();
    }

    // GUI
    void GameOver(int windowID)
    {
        GUI.Label(new Rect(350, 500, 300, 100), "You have died.", style);
        if (GUI.Button(new Rect(350, 600, 400, 100), "Restart", style))
        {
            //Debug.Log("pressed restart");
            //SceneManager.LoadSceneAsync(SceneManager.GetActiveScene().name);
            //Debug.Log("finished loading scene");
            Restart();
        }
    }
    void PauseMenu(int windowID)
    {
        if (GUI.Button(new Rect(0, 15, 250, 125), inventoryButton))
        {
            Debug.Log("inventory");
        }

        if (GUI.Button(new Rect(0, 140, 250,125), craftingButton))
        {
            Debug.Log("Crafting");
        }
    }
    void Restart()
    {
        Debug.Log("pressed restart");
        SceneManager.LoadSceneAsync(SceneManager.GetActiveScene().name);
        Debug.Log("finished loading scene");
    }

    private void OnGUI()
    {
        if (GameManager.isPaused)
        {
            GUI.Window(0, new Rect(750, 250, 250, 265), PauseMenu, "Menu");
        }
        if (!playerController.IsDead()) return;

        Time.timeScale = 0;
        GUI.Window(0, new Rect(500, 0, 1000, 1000), GameOver, "Game Over");
    }
}
