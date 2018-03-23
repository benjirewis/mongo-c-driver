#!/bin/sh
set -o xtrace # print commands to stderr.

# regex to match public headers.
pattern="\.\/src\/mongoc\/mongoc.*[^private]\.h$"

# public headers we expect not to have BSON_BEGIN_DECLS and BSON_END_DECLS.
exclude="\.\/src\/mongoc\/mongoc-macros.h|.\/src\/mongoc\/mongoc.h"

# get all public headers.
find ./src/mongoc -regex $pattern -regextype posix-extended  -not -regex $exclude | sort  > /tmp/public_headers.txt

# get all public headers with BSON_BEGIN_DECLS.
find ./src/mongoc -regextype posix-extended -regex $pattern -not -regex $exclude | xargs grep -l "BSON_BEGIN_DECLS" | sort > /tmp/public_headers_with_extern_c.txt

echo "checking if any public headers are missing 'extern C' declaration"

# check if there's any diff.
diff -y /tmp/public_headers.txt /tmp/public_headers_with_extern_c.txt

# use return status of diff
exit $?