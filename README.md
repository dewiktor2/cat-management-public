# cat-management-public

An Angular SPA application for managing cats, planning visits, adoptions, and other features.

## Aktualnie używane technologie

- **Angular**: 19+ (standalone components, routing, lazy loading).
- **Tailwind CSS**
- **Akita**
- **Jest**
- **Docker**
- **Supabase**
- **TypeScript**

## Features (current)

1. **Docker** - env, prod build on Node (so far in plan nginx and SSR)

... **more in future**

## Running project  ##

Dev
```bash
cd frontend
npm install
npm run start
```

Prod with private cat-management-private repo

```bash 
docker-compose up --build -d
