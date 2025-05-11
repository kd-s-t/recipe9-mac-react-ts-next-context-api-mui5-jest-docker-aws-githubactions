Example .env.stage (staging)
```env
NEXT_PUBLIC_API_URL=https://staging.api.myapp.com
```

Example .env (prod)
```env
NEXT_PUBLIC_API_URL=https://staging.api.myapp.com
```

Usage commands
```bash
docker composer -f devops/local/docker-compose.yml up --build -d
docker composer -f devops/stage/docker-compose.yml up --build -d 
docker composer -f devops/prod/docker-compose.yml up --build -d
```
