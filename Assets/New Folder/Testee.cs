using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Testee : MonoBehaviour
{
    public LayoutGroup items;
    // Start is called before the first frame update
    void Start()
    {
        items.gameObject.SetActive(true);
        Debug.Log(items.preferredHeight);
    }
    private void Update()
    {
    }
    private void LateUpdate()
    {
        Debug.Log("Upd " + items.preferredHeight);
    }

}
