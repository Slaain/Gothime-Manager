import { useContext, createContext, type PropsWithChildren } from 'react';
import { useStorageState } from './useStorageState';

const AuthContext = createContext<{
  signIn: () => void;
  setTemporaryToken: (token: string) => void;
  signOut: () => void;
  session?: string | null;
  isLoading: boolean;
  temporaryToken?: string;
}>({
  signIn: () => null,
  setTemporaryToken: () => null,
  signOut: () => null,
  session: null,
  isLoading: false,
  temporaryToken: null,
});

// This hook can be used to access the user info.
export function useSession() {
  const value = useContext(AuthContext);
  if (process.env.NODE_ENV !== 'production') {
    if (!value) {
      throw new Error('useSession must be wrapped in a <SessionProvider />');
    }
  }

  return value;
}

export function SessionProvider({ children }: PropsWithChildren) {
  const [[isLoading, session], setSession] = useStorageState('session');

  return (
    <AuthContext.Provider
      value={{
        signIn: (token) => {
          console.log("set session : ", token);

          // Perform sign-in logic here
          setSession(token);
        },
        signOut: () => {
          setSession(null);
        },
        setTemporaryToken: (token) => {
          setSession(token);
        },

        session,
        isLoading,
      }}>
      {children}
    </AuthContext.Provider>
  );
}
