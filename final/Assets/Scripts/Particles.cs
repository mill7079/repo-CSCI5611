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
    Transform transOrigin;
    public GameObject[] particle;

    // holds duration of spell
    int fire = -1;
    public bool constant;  // if constant particle system (i.e. on bomb) or not constant (magic spell)
    Vector2 fireDir;
    private float bombLife;  // frames before bomb explodes

    // Start is called before the first frame update
    //void Start()
    void Awake()
    {
        Physics2D.IgnoreLayerCollision(9, 10);
        particles = new List<Particle>();
        //particles = new Dictionary<GameObject, Vector3>();
        numParticles = genRate * dt;

        //if (numParticles == 0) numParticles = 50;

        origin = this.GetComponentInParent<Rigidbody2D>();
        transOrigin = this.GetComponentInParent<Transform>();

        if (constant) fire = 1;
    }
    private void Start()
    {
        bombLife = Time.time;
    }

    public void Fire(Vector2 dir)
    {
        Debug.Log("firing in direction " + dir);
        fire = 60;
        fireDir = dir;
    }

    public void Explode()
    {
        float angle = 0.0f;
        for (int i = 0; i < 32; i++)
        {
            angle = (angle + i * (Mathf.PI / 32)) % (2 * Mathf.PI);
            GameObject p1 = Instantiate(particle[0], origin.position, Quaternion.identity);
            GameObject p2 = Instantiate(particle[1], origin.position, Quaternion.identity);
            GameObject p3 = Instantiate(particle[2], origin.position, Quaternion.identity);
            Particle part1 = p1.GetComponent<Particle>();
            Particle part2 = p2.GetComponent<Particle>();
            Particle part3 = p3.GetComponent<Particle>();
            // part.SetUp(startVel, particleDamage, origin.tag, maxLife);
            //Vector pos = spherePos.add(new Vector(sin(angle), 1, cos(angle)));
            Vector2 v = new Vector2(Mathf.Sin(angle), Mathf.Cos(angle));
            part1.SetUp(v, 50, origin.tag, maxLife*2);
            part2.SetUp(v, 40, origin.tag, maxLife*1.5f);
            part3.SetUp(v, 30, origin.tag, maxLife);
            particles.Add(part1);
            particles.Add(part2);
            particles.Add(part3);
            //angle = (angle + PI/8) % (2*PI); 
        }
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
        if (!constant) fire--;
        else
        {
            if (Time.time - bombLife >= 10) // 10 seconds until explosion
            {
                Debug.Log("Time.time: " + Time.time + " bomb life: " + bombLife);
                Explode();
                fire = -1;
            }
        }
    }

    // generate particles around a single point
    public void GenerateParticles(Vector2 vel)
    {
        //if (vel == null)
        //{
        //    //Debug.Log("null velocity");
        //    return;
        //}

        if (constant) vel = new Vector2(Random.Range(-1.0f, 1.0f), Random.Range(-1.0f, 1.0f)).normalized;
        //Debug.Log("no return. vel = " + vel);
        //Debug.Log("num particles: " + numParticles);
        Debug.Log(vel);
        Vector2 startVel = new Vector2(vel.x, vel.y);
        for (int i = 0; i < numParticles; i++)
        {
            //Debug.Log("in loop");
            //particles.Add(new Particle(origin.position.x, origin.position.y));
            //Debug.Log(particle[Random.Range(0, particle.Length)]);
            //Debug.Log(" "+origin);
            GameObject p;
            if (origin != null)
            {
                p = Instantiate(particle[Random.Range(0, particle.Length)], origin.position + new Vector2(Random.Range(-0.1f, 0.1f), Random.Range(-0.1f, 0.1f)), Quaternion.identity);
            }
            else
            {
                p = Instantiate(particle[Random.Range(0, particle.Length)], ((Vector2)transOrigin.position) + new Vector2(Random.Range(-0.1f, 0.1f), Random.Range(-0.1f, 0.1f)), Quaternion.identity);
            }
            //particles[p] = new Vector3(vel.x, vel.y, maxLife);

            //particles.Add(new Particle(p, new Vector2(vel.x, vel.y), particleDamage));
            Particle part = p.GetComponent<Particle>();
            //Debug.Log("part null? " + part == null);
            //part.SetUp(new Vector2(vel.x, vel.y), particleDamage);
            //part.SetUp(startVel, particleDamage, transOrigin.tag, maxLife);
            if (origin != null) part.SetUp(startVel, particleDamage, origin.tag, maxLife);
            else part.SetUp(startVel, particleDamage, transOrigin.tag, maxLife);
            particles.Add(part);

        }

        //Debug.Log("length after generating particles: " + particles.Count);
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
