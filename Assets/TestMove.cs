using System.Collections;
using System.Collections.Generic;
using DG.Tweening;
using UnityEngine;

public class TestMove : MonoBehaviour
{
    public AnimationCurve Xcurve;
    public AnimationCurve Ycurve;
    public RectTransform target;
    public float duration=2;


    private void Start()
    {
        transform.DOMove(transform.position + Vector3.up * 3, duration).SetEase(Ease.Linear).onPlay = () =>
        {
            Debug.Log("AA");
        };
      
       
    }
}


public class Extensions
{

     


}