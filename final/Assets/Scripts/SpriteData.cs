using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpriteData : MonoBehaviour
{
    void Awake()
    {
        DontDestroyOnLoad(gameObject);
    }
}
