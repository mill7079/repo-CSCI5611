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
    private float experience;
    private int level;

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
        level = 1;
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.Log("use magic: " + useMagic);
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
            // change animation direction (i.e. left vs right animations)
            animator.SetFloat("LookX", lookDirection.x);
            animator.SetFloat("LookY", lookDirection.y);

            // change to/from idle/moving
            animator.SetFloat("Speed", move.magnitude);
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
            animator.SetTrigger("Attack");
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
                    experience += e.Damage(attack, false);
                    //Debug.Log("attacked enemy");
                }
            }
        }

        // fires selected magical attack
        if (Input.GetButtonDown("Fire2") && useMagic)
        {
            animator.SetTrigger("Attack");
            Debug.Log("fire magic");
            magic.Fire(attackDir);
        }

        LevelUp();

    }

    public Room GetCurrentRoom()
    {
        return currentRoom;
    }

    // move to next room
    public bool MoveTo(Room destination)
    {
        if (destination == null) return false;
        currentRoom = destination;
        return true;
    }

    // move to specific location
    public void SetLocation(Vector2 pos)
    {
        // not sure why i'm not just using this.transform? hm
        GameObject player = GameObject.FindGameObjectWithTag("Player");
        player.transform.position = pos;
    }

    public void LevelUp()
    {
        if (experience >= level*1000)
        {
            level++;
            experience = 0;
            maxHealth += 10;
            currentHealth = maxHealth;
            attack += 1;
        }
    }

    public float GetCurrentExperience()
    {
        return experience / (level * 1000);
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
