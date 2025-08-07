#!/bin/bash

# Project: Craft a Interactive API Service Parser
# Description: A bash script to parse API responses and provide interactive features
# Version: 1.0
# Author: <Your Name>

# Function to send API request and get response
get_api_response() {
  local api_endpoint=$1
  local method=$2
  local data=$3

  if [ "$method" = "GET" ]; then
    curl -X GET "$api_endpoint"
  elif [ "$method" = "POST" ]; then
    curl -X POST -H "Content-Type: application/json" -d "$data" "$api_endpoint"
  fi
}

# Function to parse API response
parse_response() {
  local response=$1

  # Use jq to parse JSON response
  local parsed_response=$(jq '.[] | .name, .description' <<< "$response")

  echo "$parsed_response"
}

# Function to provide interactive features
interactive_features() {
  local response=$1

  while true; do
    echo "Choose an option:"
    echo "1. Show all items"
    echo "2. Filter by name"
    echo "3. Quit"

    read -p "Enter your choice: " choice

    case $choice in
      1)
        echo "$response"
        ;;
      2)
        read -p "Enter name to filter: " filter_name
        local filtered_response=$(jq ".[] | select(.name == \"$filter_name\")" <<< "$response")
        echo "$filtered_response"
        ;;
      3)
        exit 0
        ;;
      *)
        echo "Invalid choice. Please try again."
        ;;
    esac
  done
}

# Main function
main() {
  local api_endpoint="https://example.com/api/endpoint"
  local method="GET"
  local data='{"key": "value"}'

  local response=$(get_api_response "$api_endpoint" "$method" "$data")
  local parsed_response=$(parse_response "$response")

  interactive_features "$parsed_response"
}

main