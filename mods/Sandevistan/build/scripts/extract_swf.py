import struct, hashlib, zlib, os, sys

exe = r'C:\Program Files (x86)\Steam\steamapps\common\Remains\Remains.exe'
data = open(exe, 'rb').read()
print("exe size:", len(data))

found = []
for m in (b'FWS', b'CWS', b'ZWS'):
    start = 0
    while True:
        i = data.find(m, start)
        if i == -1:
            break
        if i + 8 <= len(data):
            ver = data[i+3]
            ulen = struct.unpack('<I', data[i+4:i+8])[0]
            if 30 <= ver <= 53 and 100000 < ulen < 200_000_000:
                found.append((m, i, ver, ulen))
        start = i + 1

print("candidate SWF blobs:", len(found))
out = r'C:\Program Files (x86)\Steam\steamapps\common\Remains\_sandevistan_dev'
os.makedirs(out, exist_ok=True)

for idx, (m, i, ver, ulen) in enumerate(found):
    nxt = min([f[1] for f in found if f[1] > i] or [len(data)])
    raw = data[i:nxt]
    try:
        if m == b'FWS':
            body = raw
        else:
            body = m + bytes([ver]) + struct.pack('<I', ulen) + zlib.decompress(raw[8:])
        h = hashlib.sha256(body).hexdigest()
        p = os.path.join(out, f'embedded_{idx}.swf')
        open(p, 'wb').write(body)
        print(m.decode(), "off", hex(i), "ver", ver, "declen", ulen, "sha", h[:16], "->", p)
    except Exception as e:
        print(m.decode(), "off", hex(i), "ver", ver, "declen", ulen, "ERR", e)
