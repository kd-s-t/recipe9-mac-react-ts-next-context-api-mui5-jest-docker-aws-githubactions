import { createContext, ReactNode, useContext, useState } from "react";

type AppContextType = {
  count: number;
  setCount: React.Dispatch<React.SetStateAction<number>>
}

const AppContext = createContext<AppContextType | undefined>(undefined)

export const AppProvider = ({ children }: { children: ReactNode }) => {
  const [count, setCount] = useState<number>(0)

  return (
    <AppContext.Provider value={{ count, setCount }}>
      {children}
    </AppContext.Provider>
  )
}

export const useAppContext = () => {
  const context = useContext(AppContext)
  if (!context) {
    throw new Error('useAppContext must be used inside AppProvider')
  }
  return context
}