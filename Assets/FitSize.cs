using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FitSize : MonoBehaviour
{
    public RectTransform container;
    public Canvas canvasScaler;
    public float scaler;
    public Vector2 sizeOrigin;
    public Vector2 sizeMul;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    private void OnValidate()
    {
        transform.GetComponent<RectTransform>().sizeDelta = container.sizeDelta;
        scaler = Camera.main.scaledPixelWidth;
    }
    private void OnDrawGizmos()
    {
        var size = container.sizeDelta;
        size.x *= canvasScaler.transform.localScale.x;
        size.y *= canvasScaler.transform.localScale.y;
        scaler = canvasScaler.transform.localScale.x;
        sizeOrigin = container.sizeDelta;
        sizeMul = size;
        Gizmos.color = Color.cyan;
        Gizmos.DrawWireCube(container.position, sizeOrigin);
    }
}
