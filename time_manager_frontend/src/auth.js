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
    
    if(!token) return false;
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
  
    // return decoded.role && decoded.role === 'admin';
  } catch (error) {
    return false;
  }
}

export async function isUserManager(token) {
  if (!token) {
    return false;
  }
  
  try {
    const decoded = VueJwtDecode.decode(token);
    
    if(!token) return false;
    const response = await axios.get("http://localhost:4000/api/roles", {
      headers: {
      Authorization: `Bearer ${token}`
      }
    })
    
        console.log("response : ", response);
        
        if(response.data.role == "manager" || response.data.role == "admin"){
          console.log("manager");
          
          return true;
        } else {
          console.log("not manager");
          return false;
        }
  
    // return decoded.role && decoded.role === 'manager';
  } catch (error) {
    return false;
  }
}