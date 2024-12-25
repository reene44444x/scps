git add .
git commit -m "Updated tag"
git tag v1.0.0 --delete
git tag -a v1.0.0 -m "Updated tag"
git push origin v1.0.0 --delete
git push origin v1.0.0