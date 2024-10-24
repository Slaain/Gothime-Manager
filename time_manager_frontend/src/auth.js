// import jwtDecode from 'jwt-decode'; // Utilisez jwt-decode pour décoder le token JWT
import axios from 'axios';
import VueJwtDecode from 'vue-jwt-decode'

export async function isUserAdmin(token) {
  if (!token) {
    return false;
  }
  
  try {
    const decoded = VueJwtDecode.decode(token);

    console.log("id : ", decoded.sub);
    
    const response = await axios.get("http://localhost:4000/api/roles", {
      headers: {
      Authorization: `Bearer ${token}`
      }
    })
    
        console.log("response : ", response);
        
        if(response.data.role == "admin"){
          console.log("admin");
          
          return true;
        } else {
          console.log("not admin");
          return false;
        }
    
    

    // Supposons que l'info "role" est dans le token et que "admin" est le rôle attendu
    
    // return decoded.role && decoded.role === 'admin';
  } catch (error) {
    return false;
  }
}
