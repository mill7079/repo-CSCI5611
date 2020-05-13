using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Obstacle : MonoBehaviour
{
    void OnTriggerEnter2D(Collider2D collision)
    {
        //Debug.Log("ouch, that's a cactus");
        Unit unit = collision.GetComponent<Unit>();

        // cacti are prickly
        if (CompareTag("Wall")) unit?.Damage(1, true);
        else if (CompareTag("Floor") && collision.CompareTag("Player")) // heal by stepping on grass
        {
            Debug.Log("heal");
            Particles heal = GetComponentInChildren<Particles>();
            heal?.Fire(new Vector2(0, 1));

            unit.Heal(30);

            Collider2D grass = GetComponent<Collider2D>();
            grass.enabled = false;
        } // don't ask why there's beautiful green grass in a dungeon
    }
}
