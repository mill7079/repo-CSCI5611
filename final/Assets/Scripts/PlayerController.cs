using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : Unit
{
    private Room currentRoom;

    // rpg mechanics
    public float attackAngle;
    private Vector2 attackDir;
    public float detectRadius;

    // sprite
    //private SpriteRenderer sprite;
    //private bool spriteSelected;

    protected override void Awake()
    {
        GameObject spriteData = GameObject.FindGameObjectWithTag("SpriteData");
        if (spriteData != null)
        {
            Animator newAnimator = spriteData.GetComponent<Animator>();
            //Debug.Log("new animator: " + newAnimator.runtimeAnimatorController + " old animator: " + GetComponent<Animator>().runtimeAnimatorController);
            gameObject.GetComponent<Animator>().runtimeAnimatorController = newAnimator.runtimeAnimatorController;
            //Debug.Log("new animator: " + newAnimator.runtimeAnimatorController + " old animator: " + GetComponent<Animator>().runtimeAnimatorController);
        }
        base.Awake();
        attackDir = lookDirection;
        //sprite = gameObject.GetComponent<SpriteRenderer>();
        //spriteSelected = false;
    }

    // Update is called once per frame
    void Update()
    {
        if (isDead)
        {
            //Debug.Log("you be dead");
            return;
        }


        /** moving/animating **/

        float horizontal = Input.GetAxis("Horizontal");
        float vertical = Input.GetAxis("Vertical");
        Vector2 move = new Vector2(horizontal, vertical);
        if (!Mathf.Approximately(move.x, 0.0f) || !Mathf.Approximately(move.y, 0.0f))
        {
            lookDirection.Set(move.x, move.y);
            lookDirection.Normalize();
        }

        if (animator != null)
        {
            //Debug.Log("animating " + animator.runtimeAnimatorController);
            animator.SetFloat("LookX", lookDirection.x);
            animator.SetFloat("LookY", lookDirection.y);
            //Debug.Log("float x: " + animator.GetFloat("LookX"));
            //Debug.Log("float y: " + animator.GetFloat("LookY"));
        }

        Vector2 position = body.position;
        position = position + move * speed * Time.deltaTime;
        body.MovePosition(position);


        /** attacking **/

        // ensure player is always able to attack even if not moving
        if (!Mathf.Approximately(move.magnitude, 0.0f))
        {
            attackDir = move;
            attackDir.Normalize();
        }

        // fires selected physical attack
        if (Input.GetButtonDown("Fire1"))
        {
            // attack in direction player is facing
            Vector3 look = new Vector3(attackDir.x, attackDir.y, 0);

            // find enemies in range (layer 8 is units)
            Collider2D[] enemiesInRange = Physics2D.OverlapCircleAll(body.position, attackRadius, (1 << 8));
            //Debug.Log("found " + enemiesInRange.Length + " enemies in circular range");
            for (int i = 0; i < enemiesInRange.Length; i++)
            {
                if (!enemiesInRange[i].CompareTag("Enemy")) continue;

                Enemy e = enemiesInRange[i].GetComponent<Enemy>();
                Rigidbody2D eBody = e.GetComponent<Rigidbody2D>();
                Vector2 toEnemy = eBody.position - body.position;

                //Debug.Log("Angle: " + Vector2.Angle(look, toEnemy));
                if (Vector2.Angle(look, toEnemy) < attackAngle)
                {
                    // enemy is in range
                    e.Damage(attack, false);
                    //Debug.Log("attacked enemy");
                }
            }
        }

        // fires selected magical attack
        if (Input.GetButtonDown("Fire2"))
        {
            Debug.Log("fire magic");
            magic.Fire(attackDir);
        }

    }

    public Room GetCurrentRoom()
    {
        return currentRoom;
    }

    //public Point GetPos() { return new Point(body.position); }

    public bool MoveTo(Room destination)
    {
        // TODO move to location of door
        if (destination == null) return false;
        currentRoom = destination;
        return true;
    }

    public void SetLocation(Vector2 pos)
    {
        //body.MovePosition(pos);
        GameObject player = GameObject.FindGameObjectWithTag("Player");
        player.transform.position = pos;
    }

    //void StartMenu(int windowID)
    //{
    //    if (GUI.Button(new Rect(0, 10, 150, 490), "!"))
    //    {
    //        sprite.sprite = GameManager.instance.playerSprites[0];
    //    }
    //    else if (GUI.Button(new Rect(150, 10, 150, 490), "?"))
    //    {
    //        sprite.sprite = GameManager.instance.playerSprites[1];
    //    }
    //}
    //private void OnGUI()
    //{
    //    if (!spriteSelected) GUI.Window(8, new Rect(0, 0, 500, 500), StartMenu, "aujf");
    //}
}
