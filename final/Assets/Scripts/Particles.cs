using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Particles : MonoBehaviour
{
    private List<Particle> particles;
    // maps GameObject for sprite/rigidbody to Vector3 containing x,y location and life in z position
    //private Dictionary<GameObject, Vector3> particles;
    private float numParticles;
    public float genRate;
    public float maxLife;
    public float particleDamage;
    private float dt = 0.009f;

    Rigidbody2D origin;
    public GameObject particle;

    // holds duration of spell
    int fire = -1;
    public bool constant;  // if constant particle system (i.e. on bomb) or not constant (magic spell)
    Vector2 fireDir;

    // Start is called before the first frame update
    //void Start()
    void Awake()
    {
        particles = new List<Particle>();
        //particles = new Dictionary<GameObject, Vector3>();
        numParticles = genRate * dt;
        Debug.Log("genRate: " + genRate + " dt: " + dt);
        Debug.Log("Particle: " + particle);

        if (numParticles == 0) numParticles = 50;

        origin = this.GetComponentInParent<Rigidbody2D>();
    }

    public void Fire(Vector2 dir)
    {
        Debug.Log("firing in direction " + dir);
        fire = 60;
        fireDir = dir;
    }

    // Update is called once per frame
    void Update()
    {
        //foreach (GameObject p in particles.Keys)
        //{
        //    Rigidbody2D body = p.GetComponent<Rigidbody2D>();
        //    if (body == null )
        //    {
        //        Debug.Log("no rigidbody");
        //        continue;
        //    }
        //    Vector2 vel = particles[p];
        //    Vector2 move = body.position + vel;
        //    body.MovePosition(move);
        //    particles[p] = particles[p] - new Vector3(0, 0, 1); // subtract one from life
        //    //particles[p] = particles[p] + (Vector3)(move * dt); // add position
        //}

        if (Time.timeScale == 0) return;
        for (int i = 0; i < particles.Count; i++)
        {
            particles[i].Move();
        }
        Clean();

        if (fire <= 0) return;

        GenerateParticles(fireDir);
        fire--;
    }

    // generate particles around a single point
    public void GenerateParticles(Vector2 vel)
    {
        if (vel == null)
        {
            Debug.Log("null velocity");
            return;
        }

        //Debug.Log("no return. vel = " + vel);
        Debug.Log("num particles: " + numParticles);
        Vector2 startVel = new Vector2(vel.x, vel.y);
        for (int i = 0; i < numParticles; i++)
        {
            Debug.Log("in loop");
            //particles.Add(new Particle(origin.position.x, origin.position.y));
            GameObject p = Instantiate(particle, origin.position + new Vector2(Random.Range(-0.1f, 0.1f), Random.Range(-0.1f, 0.1f)), Quaternion.identity);
            //particles[p] = new Vector3(vel.x, vel.y, maxLife);

            //particles.Add(new Particle(p, new Vector2(vel.x, vel.y), particleDamage));
            Particle part = p.GetComponent<Particle>();
            //Debug.Log("part null? " + part == null);
            //part.SetUp(new Vector2(vel.x, vel.y), particleDamage);
            part.SetUp(startVel, particleDamage, origin.tag);
            particles.Add(part);

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
        //List<GameObject> toRemove = new List<GameObject>();
        //foreach (GameObject p in particles.Keys)
        //{
        //    if (particles[p].z <= 0)
        //    {
        //        toRemove.Add(p);
        //    }
        //}

        //for (int i = toRemove.Count - 1; i >= 0; i--)
        //{
        //    particles.Remove(toRemove[i]);
        //    Destroy(toRemove[i]);
        //}

        //Debug.Log("length before clean: " + particles.Count);
        List<Particle> toRemove = new List<Particle>();
        for (int i = 0; i < particles.Count; i++)
        {
            if (particles[i].IsDead()) toRemove.Add(particles[i]);
        }

        //Debug.Log("number to remove: " + toRemove.Count);
        for (int i = 0; i < toRemove.Count; i++)
        {
            particles.Remove(toRemove[i]);
            //toRemove[i].Destroy();
            GameObject.Destroy(toRemove[i].gameObject);
        }
        //Debug.Log("length after clean: " + particles.Count);
    }
    
}
