using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateDust : MonoBehaviour
{
    public float fromAngle;
    public float toAngle;
    public float speed = 1;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.localEulerAngles = Vector3.forward * Mathf.Lerp(fromAngle, toAngle, (Time.time * speed) % 1);
    }
}
