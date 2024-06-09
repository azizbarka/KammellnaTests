using UnityEngine;

public class DeepChild : Child
{
    [ContextMenu("Do")]
    public override void Do()
    {
        Debug.Log("Child");
    }
}

