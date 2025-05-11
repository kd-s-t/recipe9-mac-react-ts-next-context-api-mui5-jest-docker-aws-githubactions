import { ThemeProvider } from "@emotion/react";
import { AppProvider } from "../app/context/AppContext";
import { AppProps } from "next/app";
import { createTheme, CssBaseline } from "@mui/material";

const theme = createTheme({
  palette: {
    mode: 'light'
  }
})

export default function MyApp({ Component, pageProps }: AppProps) {
  return (
    <AppProvider>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <Component {...pageProps} />
      </ThemeProvider>
    </AppProvider>
  )
}