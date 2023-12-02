#!/bin/bash

# CSV file path
csv_file="last30days.csv"

# HTML file path
html_file="tracker.html"

# Read CSV file and generate HTML rows
html_rows=""
while IFS=',' read -r type url ip added; do
    html_rows+="<tr>\n"
    html_rows+="    <td>$type</td>\n"
    html_rows+="    <td>$url</td>\n"
    html_rows+="    <td>$ip</td>\n"
    html_rows+="    <td>$added</td>\n"
    html_rows+="</tr>\n"
done < "$csv_file"

# Find the closing tag of the existing table body in HTML
table_body_end=$(awk '/<\/tbody>/ { print NR; exit }' "$html_file")

# Insert the generated HTML rows before the closing tag
awk -v rows="$html_rows" -v end="$table_body_end" 'NR==end-1 { print rows } { print }' "$html_file" > temp.html
mv temp.html "$html_file"

echo "CSV data added to the HTML table."

