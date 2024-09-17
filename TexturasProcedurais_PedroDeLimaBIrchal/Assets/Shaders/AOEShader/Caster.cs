using UnityEngine;

public class Caster : MonoBehaviour {
    [SerializeField] private float size = 5;
    private MeshRenderer render;
    
    private void Update() {

        if (Input.GetKeyDown(KeyCode.UpArrow)) 
            size += 0.5f;
        if (Input.GetKeyDown(KeyCode.DownArrow))
            size -= 0.5f;
        
        if (Input.GetMouseButton(0)) {
            Vector3 mousePos = Input.mousePosition;
            Ray ray = Camera.main.ScreenPointToRay(mousePos);
            Debug.DrawRay(ray.origin, ray.direction * 10, Color.yellow);
            RaycastHit hit;
            Physics.Raycast(ray, out hit);
            if (hit.collider == null) {
                render.material.SetFloat("_AoeRad", 0);
                return;
            }
            
            Vector3 aoeCenter = hit.textureCoord;
            
            if(render != null && hit.collider.GetComponent<MeshRenderer>() != render)
                render.material.SetFloat("_AoeRad",0);
            
            render = hit.collider.GetComponent<MeshRenderer>();
            if (render != null) {
                render.material.shader = Shader.Find("Unlit/DrawAOE");
                render.material.SetFloat("_AoeRad", size /  hit.collider.transform.localScale.x);
                render.material.SetVector("_AoeCenter", aoeCenter);
            }
        }
    }
}