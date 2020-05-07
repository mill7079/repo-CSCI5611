using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Particles : MonoBehaviour
{
    //private List<Particle> particles;
    // maps GameObject for sprite/rigidbody to Vector3 containing x,y location and life in z position
    private Dictionary<GameObject, Vector3> particles;
    float numParticles;
    public float genRate;
    public float maxLife;
    private float dt = 0.009f;

    Rigidbody2D origin;
    public GameObject particle;

    int fire = -1;
    Vector2 fireDir;

    // Start is called before the first frame update
    void Start()
    {
        //particles = new List<Particle>();
        particles = new Dictionary<GameObject, Vector3>();
        numParticles = genRate * dt;

        origin = this.GetComponentInParent<Rigidbody2D>();
    }

    public void Fire(Vector2 dir)
    {
        fire = 60;
        fireDir = dir;
    }

    // Update is called once per frame
    void Update()
    {
        if (fire <= 0) return;
        
        foreach (GameObject p in particles.Keys)
        {
            Rigidbody2D body = p.GetComponent<Rigidbody2D>();
            if (body == null )
            {
                Debug.Log("no rigidbody");
                continue;
            }
            Vector2 vel = particles[p];
            Vector2 move = body.position + vel;
            body.MovePosition(move);
            particles[p] = particles[p] - new Vector3(0, 0, 1); // subtract one from life
            //particles[p] = particles[p] + (Vector3)(move * dt); // add position
        }

        GenerateParticles(fireDir);
        Clean();
    }

    // generate particles around a single point
    public void GenerateParticles(Vector2 vel)
    {
        if (vel == null) return;

        for (int i = 0; i < numParticles; i++)
        {
            //particles.Add(new Particle(origin.position.x, origin.position.y));
            GameObject p = Instantiate(particle, origin.position + new Vector2(Random.Range(-0.01f, 0.01f), Random.Range(-0.01f, 0.01f)), Quaternion.identity);
            particles[p] = new Vector3(vel.x, vel.y, maxLife);
        }

        Debug.Log("length after generating particles: " + particles.Count);
    }

    public void Clean()
    {
        //for (int i = particles.Count - 1; i >= 0; i--)
        //{
        //    if (particles[i].IsDead())
        //    {
        //        Particle x = particles[i];
        //        particles.Remove(x);
        //    }

        //}
        List<GameObject> toRemove = new List<GameObject>();
        foreach (GameObject p in particles.Keys)
        {
            if (particles[p].z <= 0)
            {
                toRemove.Add(p);
            }
        }

        for (int i = toRemove.Count - 1; i >= 0; i--)
        {
            particles.Remove(toRemove[i]);
            Destroy(toRemove[i]);
        }
    }
    
}
