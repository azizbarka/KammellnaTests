using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;
using UnityEngine.UI;
[RequireComponent(typeof(Button))]

public class CustomButton : MonoBehaviour
{
    [SerializeField]
    private bool _interactable;
    public bool Interactable
    {
        get
        {
            return _interactable;
        }
        set
        {
            _interactable = value;
        }
    }


    // Start is called before the first frame update
    void Start()
    {
        OnInteractableStateChanged();
    }

    private void OnInteractableStateChanged()
    {
        GetComponent<Button>().interactable = Interactable;
        GetComponentInChildren<Text>().color = Interactable ? Color.blue : Color.red;
    }
    private void OnValidate()
    {
        OnInteractableStateChanged();
    }
}




