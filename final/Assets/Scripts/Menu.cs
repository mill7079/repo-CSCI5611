using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Menu : MonoBehaviour
{
    public Sprite[] playerSprites;

    public void Play()
    {
        GameObject spriteData = GameObject.FindGameObjectWithTag("SpriteData");
        Debug.Log(spriteData.GetComponent<Animator>().runtimeAnimatorController);
        if (!(spriteData.GetComponent<Animator>().runtimeAnimatorController == null)) SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }

    public void Quit()
    {
        Debug.Log("quit");
        Application.Quit();
    }
}
