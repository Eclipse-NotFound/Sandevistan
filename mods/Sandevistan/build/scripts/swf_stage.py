import struct, sys, os

def decode_rect(data, pos):
    b0 = data[pos]
    nbits = b0 >> 3
    vals = []
    bitpos = 5
    for i in range(4):
        val = 0
        for b in range(nbits):
            byte_idx = pos + (bitpos // 8)
            bit = (data[byte_idx] >> (7 - (bitpos % 8))) & 1
            val = (val << 1) | bit
            bitpos += 1
        vals.append(val)
    return vals, nbits

for p in [r'C:\Program Files (x86)\Steam\steamapps\common\Remains\pfe.swf',
          r'C:\Program Files (x86)\Steam\steamapps\common\Remains\DLC\pfeUI.swf',
          r'C:\Program Files (x86)\Steam\steamapps\common\Remains\DLC\pfe.swf']:
    d = open(p, 'rb').read()
    vals, nbits = decode_rect(d, 8)
    w = vals[1] - vals[0]
    h = vals[3] - vals[2]
    print(os.path.basename(p), 'stage:', w, 'x', h, 'nbits', nbits)
