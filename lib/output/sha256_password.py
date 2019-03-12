"""
Short script to encode password for use with CTFd
"""

import sys
from passlib.hash import bcrypt_sha256
hashed = bcrypt_sha256.encrypt(sys.argv[1])
print(hashed, end='')
