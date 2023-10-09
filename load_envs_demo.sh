#!/bin/bash

# Path to the .env file
ENV_FILE="envs/demo/.env"

# Check if the .env file exists and is readable
if [[ -f "$ENV_FILE" && -r "$ENV_FILE" ]]; then
    # Iterate through each line in the .env file
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Ignore empty lines and comments
        if [[ -n $line && ! $line =~ ^# ]]; then
            # Execute export for each valid line
            export "$line"
        fi
    done < "$ENV_FILE"
else
    echo "The file $ENV_FILE does not exist or is not readable."
fi
