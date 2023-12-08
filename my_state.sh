#!/bin/bash

# terraform state rm <address>

address=$(terraform state list)
for  resource  in $address; do 
    echo "Removing Resource Adress: $resource"
    terraform state rm "$resource"
    echo "____D__O__N__E_____"
done