using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class Father : MonoBehaviour
{
    public EventTrigger eventTrigger;
    private void Awake()
    {
        EventTrigger.Entry entry = new EventTrigger.Entry();
        entry.eventID = EventTriggerType.PointerDown;
        entry.callback.AddListener(Perform);
        eventTrigger.triggers.Add(entry);
        
    }
    public void Perform(BaseEventData data)
    {
        Do();
    }
    public virtual void Do()
    {
        Debug.Log("Father");         
    }
}



