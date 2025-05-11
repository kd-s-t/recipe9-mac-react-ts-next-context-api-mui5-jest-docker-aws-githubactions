import { useAppContext } from "@/app/context/AppContext"
import { Box, Button, Typography } from "@mui/material"

export default function Count() {
  const { count, setCount } = useAppContext()

  return (
    <Box style={{ padding: 20 }}>
      <Typography variant="h4">count: {count}</Typography>
      <Button sx={{ mr: 2 }} variant="contained" color="primary" onClick={() => setCount(count + 1)}>Increment</Button>
      <Button sx={{ mr: 2 }} variant="contained" color="primary" onClick={() => setCount(count - 1)}>Decrement</Button>
    </Box>
  )
}