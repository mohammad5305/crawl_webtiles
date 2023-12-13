# Crawl Webtiles Docker Image
Docker container for Dungeon Crawl Stone Soup (DCSS) based on alpine.

## Build
You can either build or use the pre-built image on dockerhub
```bash
git clone https://github.com/mohammad5305/crawl_webtiles && cd crawl_webtiles
docker build -t crawl:latest .
docker run -p 80:8080 -d --name crawl crawl:latest
```

or 

```bash
docker pull mohammadbaj/crawl-webtiles
docker run -p 80:8080 -d  --name crawl mohammadbaj/crawl-webtiles
```

