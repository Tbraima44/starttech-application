# 1. Update Dockerfile to use Go 1.24
sed -i 's|golang:1.23-alpine|golang:1.24-alpine|' Dockerfile

# 2. Set go.mod to use Go 1.24
sed -i 's/^go .*/go 1.24.0/' go.mod
sed -i '/^toolchain /d' go.mod   # remove any toolchain line, if present

# 3. Regenerate go.sum with Go 1.24
docker run --rm -v "$(pwd):/app" -w /app golang:1.24-alpine go mod tidy