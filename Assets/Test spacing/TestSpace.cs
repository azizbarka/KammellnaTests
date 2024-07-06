using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestSpace : MonoBehaviour
{
    public RectTransform topObject;
    public RectTransform bottomObject;
    public float distance;
    public Canvas canvas;

    private void Start()
    {
        distance = Vector3.Distance(topObject.position, bottomObject.position);
    }
}
