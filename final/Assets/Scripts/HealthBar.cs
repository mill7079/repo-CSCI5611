using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HealthBar : MonoBehaviour
{
    Vector2 scale;
    //Enemy current;
    Unit current;

    // Start is called before the first frame update
    void Start()
    {
        scale = transform.localScale;
        //current = GetComponentInParent<Enemy>();
        current = GetComponentInParent<Unit>();
    }

    // Update is called once per frame
    void Update()
    {
        scale.x = current.GetCurrentHealth();
        transform.localScale = scale;
    }
}
