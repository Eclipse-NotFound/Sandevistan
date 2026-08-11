import struct

exe = r'C:\Program Files (x86)\Steam\steamapps\common\Remains\Remains.exe'
data = open(exe, 'rb').read()

for m in (b'FWS', b'CWS', b'ZWS'):
    start = 0
    while True:
        i = data.find(m, start)
        if i == -1:
            break
        ctx = data[max(0,i-8):i+16]
        print(m.decode(), "off", hex(i), "ctx:", ctx.hex())
        start = i + 1
