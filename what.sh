

#process dataset


# 1 untar dataset

tar -xzvf signal.tar.gz

# 2 prep output dir
mkdir signal_scaled


# 3 map files while considering meta data
python scripts/process.py signal/file1.txt signal/meta.json signal_scaled/file1.txt
python scripts/process.py signal/file2.txt signal/meta.json signal_scaled/file2.txt
python scripts/process.py signal/file3.txt signal/meta.json signal_scaled/file3.txt


# 4 create new metadata

cat signal_scaled/file*.txt|awk '{a+=$1}END{print a}'|jq '.|{sum: .}' > signal_scaled/meta.json



# 5 repack dataset

tar -czvf signal_scaled.tar.gz signal_scaled/*
