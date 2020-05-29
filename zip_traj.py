from zipfile import ZipFile, ZIP_LZMA
from os.path import getsize

with ZipFile('trajectory.zip', 'w', allowZip64=True, compression=ZIP_LZMA) as z:
    z.write('./trajectory.dat')

old = getsize('./trajectory.dat')
new = getsize('./trajectory.zip')
change = (old - new) / old

print("successfully compressed trajectory by {}%".format(change*100))
