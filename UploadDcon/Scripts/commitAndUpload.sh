cd $1 && git add . && git commit -m "files commit by hackathon dcon auto upload" && git push && ./upload.py unversioned --unversioned_revision nov15Conquer --new_files $2 2>&1
