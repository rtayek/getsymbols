# script  to split big csv file and add headers
# runs in /d/data/yahoodata
rm split.*
split -d --additional-suffix=.csv -l 10000  yahoosymbols.csv split.
sed -i "1s/^/`head -n 1 yahoosymbols.csv`\n/" split.*.csv
