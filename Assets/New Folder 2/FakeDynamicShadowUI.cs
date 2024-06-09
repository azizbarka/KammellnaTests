using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Image))]
public class FakeDynamicShadowUI : MonoBehaviour
{
    public Vector3 lightDirection = Vector3.down;
    public Transform target;
    public float offset;
    public Vector2 shadowOpacityRange = new Vector2(.85f, 0.2f);
    public Vector2 shadowScaleRange = new Vector2(1, 0.5f);
    public float maxShadowDistance = 1;
    [Range(0, 1f)]
    public float targetHeight;

    private Image shadow;
    private void Start()
    {
        shadow = GetComponent<Image>();
    }
    void LateUpdate()
    {
        transform.position = target.position + lightDirection * (offset + targetHeight * maxShadowDistance);
        transform.eulerAngles = target.eulerAngles;
        transform.localScale = Mathf.Lerp(shadowScaleRange.x, shadowScaleRange.y, targetHeight) * Vector3.one;
        //Set shadow opacity
        var shadowColor = shadow.color;
        shadowColor.a = Mathf.Lerp(shadowOpacityRange.x, shadowOpacityRange.y, targetHeight);
        shadow.color = shadowColor;

    }
}
