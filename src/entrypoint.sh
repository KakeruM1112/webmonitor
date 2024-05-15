#!/bin/bash

if [ -n "$CE_URL" ]; then
  export URL="$CE_URL"
fi

exec "$@"
