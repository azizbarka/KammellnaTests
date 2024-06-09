using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;


public class ImageEditorWindow : EditorWindow
{
   
    public Vector2 range;
    [SerializeField]
    public Texture2D texture;
    private float _leftEdge;
    public float leftEdge
    {
        get => _leftEdge;
        set
        {
            if (_leftEdge != value)
            {
                _leftEdge = value;
                isPropertyChanged = true;
            }
        }
      
    }

    private float _rightEdge =1;
    public float rightEdge
    {
        get => _rightEdge;
        set
        {
            if (_rightEdge != value)
            {
                _rightEdge = value;
                isPropertyChanged = true;
                Debug.Log(isPropertyChanged);
            }
        }

    }
    private Texture2D targetTexture;
    private string text = "Hello World";
    private bool isPropertyChanged;

    //Background colors : texture type
    private static Texture2D whiteBackground;
    private static Texture2D redBackground;
    [MenuItem("Tools/Show Editor Window")]
    public static void Display()
    {
        GetWindow<ImageEditorWindow>().Show();
    }
    private void OnEnable()
    {
        whiteBackground = CreateTextureColor(Color.white);
        redBackground = CreateTextureColor(Color.red);

    }

    private void OnGUI()
    {


        text = GUILayout.TextArea(text);
        leftEdge = GUILayout.HorizontalSlider(leftEdge, 0, 1);
        
        GUILayout.Space(20);
        rightEdge = GUILayout.HorizontalSlider(rightEdge, 0, 1);

        GUILayout.Box("",GUILayout.Height(100));
        var rect = GUILayoutUtility.GetLastRect();
        rect.width = texture.width;
        rect.height = texture.height;
        //  GUI.DrawTexture(rect, texture);
        // GUI.DrawTexture(rect, whiteBackground);
          GUI.DrawTexture(rect, texture, ScaleMode.ScaleToFit, false, 0, Color.white, leftEdge, rightEdge);
      //  GUI.DrawTexture(new Rect(0, 0, texture.width, texture.height), texture);    
    }


    private Texture2D CreateTextureColor(Color color)
    {
        var textureColor = new Texture2D(1, 1);
        textureColor.SetPixel(0, 0, color);
        textureColor.Apply();
        return textureColor;
    }


}
