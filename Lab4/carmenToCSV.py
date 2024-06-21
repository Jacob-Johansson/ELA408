import csv



def text_to_csv(input_file, output_file):
    with open(input_file, 'r') as file:
        content = file.read()
        
    # Split the content by "FLASER"
    blocks = content.split("FLASER")[1:]
    
    # Prepare the data for CSV
    rows = []
    for block in blocks:
        # Split each block by "0 pippo 0" and take the first part
        data = block.split("0 pippo 0")[0].strip()
        if data:
            # Split by spaces to get individual values
            row = data.split()
            rows.append(row)
    
    # Write the rows to the CSV file
    with open(output_file, 'w', newline='') as csv_file:
        writer = csv.writer(csv_file)
        writer.writerows(rows)

text_to_csv("fr-campus-20040714.carmen.gfs.log", 'fr-campus.csv')