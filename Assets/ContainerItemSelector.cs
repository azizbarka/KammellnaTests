using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ContainerItemSelector2 : MonoBehaviour
{
    [field: SerializeField]
    private RectTransform container;
    [field: SerializeField]
    public int index { get; set; }
    [Header("View options")]
    [field:SerializeField]
    public bool isVertical;
    [field: SerializeField]
    public bool useItemPaddingSize;
    [field:SerializeField]
    public bool isReversed { get; set; }
    [field: SerializeField]
    public bool overridePositionFactor { get; set; }
    [field: SerializeField,Range(0,1f)]
    public float positionFactor { get; set; }
    [Header("Padding")]
    [Range(0.2f,1),SerializeField]
    private float horizontalPadding=1;
    [Range(0.2f, 1), SerializeField]
    private float verticalPadding = 1;
    [Header("Size(Multiplier)")]
    [Range(0.2f, 2f), SerializeField]
    private float widthMultiplier=1;
    [Range(0.2f, 2f), SerializeField]
    private float heightMultiplier=1;
 
    
    // Start is called before the first frame update
    void Awake()
    {
       SetPosition();
    }
    private void UpdateSize()
    {
        GetComponent<RectTransform>().sizeDelta = GetItemFitSize();
    }
    private Vector2 GetItemFitSize(bool useMultiplier=true)
    {
        Vector2 containerSize = container.sizeDelta;
        if(useItemPaddingSize)
        {
            containerSize.x *= horizontalPadding;
            containerSize.y *= verticalPadding;
        }
        int itemsCount = container.childCount;
        Vector2 divider = new Vector2(!isVertical ? itemsCount : 1, isVertical ? itemsCount : 1);
        if(useMultiplier)
        {
            divider.x /= widthMultiplier;
            divider.y /= heightMultiplier;
        }    
        return new Vector2(containerSize.x / divider.x, containerSize.y / divider.y);  
    }
    public Vector3 GetPositionByIndex(int index)
    {
        int itemsCount = container.childCount;
        //index out of range exception
        if (index >= itemsCount || index < 0)
            throw new IndexOutOfRangeException();
        //Getting the half size for each x and y axis in the container
        Vector2 extent = isVertical ? container.sizeDelta.y / 2 * Vector2.up : container.sizeDelta.x * Vector2.right / 2;
        Vector3 position = container.position, center = container.position;
        Vector2 itemHalfSize = GetItemFitSize(false) / 2;
        float positionFactor = index / (container.childCount * 1.0f);
        if (overridePositionFactor)
            positionFactor = Mathf.Lerp(0, (itemsCount - 1.0f) / itemsCount, this.positionFactor);
        if (isReversed)
            positionFactor = (itemsCount - 1.0f) / itemsCount - positionFactor;

        //Use the half size in or placement remapping
        if (!isVertical)
            position.x = Mathf.Lerp(center.x - extent.x * horizontalPadding, center.x + extent.x * horizontalPadding, positionFactor) + itemHalfSize.x;
        else
            position.y = Mathf.Lerp(center.y - extent.y * verticalPadding, center.y + extent.y * verticalPadding, positionFactor) + itemHalfSize.y;
        return position;
    }
    private void SetPosition()
    {
        GetComponent<RectTransform>().position = GetPositionByIndex(index);           
    }
    private void OnValidate()
    {
        SetPosition();
        UpdateSize();
    }
    private void OnDrawGizmos()
    {
        Vector2 size = container.sizeDelta;
        size.x *= horizontalPadding;
        size.y *= verticalPadding;
        Gizmos.color = Color.cyan;
        Gizmos.DrawWireCube(container.position, size);
    }

}
