// import jwtDecode from 'jwt-decode'; // Utilisez jwt-decode pour décoder le token JWT
import VueJwtDecode from 'vue-jwt-decode'

export function isUserAdmin(token) {
  if (!token) {
    return false;
  }
  
  try {
    const decoded = VueJwtDecode.decode(token);

    console.log(decoded.sub);
    
    // Supposons que l'info "role" est dans le token et que "admin" est le rôle attendu
    if(decoded.sub == 2){
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
