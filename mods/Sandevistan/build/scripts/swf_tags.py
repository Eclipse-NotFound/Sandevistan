import struct, sys, zlib

def parse_swf(path):
    data = open(path, 'rb').read()
    sig = data[:3]
    ver = data[3]
    if sig in (b'CWS', b'ZWS'):
        ulen = struct.unpack('<I', data[4:8])[0]
        body = zlib.decompress(data[8:])
        data = sig + bytes([ver]) + struct.pack('<I', ulen) + body
    elif sig == b'FWS':
        pass
    else:
        print("unknown sig", sig)
        return
    # header: FWS(3) ver(1) filelen(4) then frame size (RECT), frame rate, frame count
    pos = 8
    # RECT: 5 bits nbits, then nbits*4 values
    nbits = data[pos] >> 3
    rect_bytes = (5 + nbits * 4 + 7) // 8
    pos += rect_bytes
    framerate = struct.unpack('<H', data[pos:pos+2])[0] / 256.0
    framecount = struct.unpack('<H', data[pos+2:pos+4])[0]
    pos += 4
    print(f"SWF v{ver} {framecount} frames @{framerate}fps, header end at {pos}")
    tags = []
    while pos + 2 <= len(data):
        code_len = struct.unpack('<H', data[pos:pos+2])[0]
        code = code_len >> 6
        ln = code_len & 0x3F
        pos += 2
        if ln == 0x3F:
            ln = struct.unpack('<I', data[pos:pos+4])[0]
            pos += 4
        body = data[pos:pos+ln]
        pos += ln
        tags.append((code, body))
        if code == 0:
            break
    return ver, tags

def main():
    path = sys.argv[1]
    ver, tags = parse_swf(path)
    print("total tags:", len(tags))
    for code, body in tags:
        if code == 76:  # SymbolClass
            # u16 count, then (u16 id, string name)*
            n = struct.unpack('<H', body[0:2])[0]
            p = 2
            for i in range(n):
                sid = struct.unpack('<H', body[p:p+2])[0]
                p += 2
                elen = body.index(0, p) - p
                name = body[p:p+elen].decode('utf-8', errors='replace')
                p += elen + 1
                print(f"  SymbolClass id={sid} class={name}")
        elif code == 82:  # DoABC
            # flags u32, name string, then ABC
            flags = struct.unpack('<I', body[0:4])[0]
            p = 4
            elen = body.index(0, p) - p
            abcname = body[p:p+elen].decode('utf-8', errors='replace')
            print(f"  DoABC flags={flags} name={abcname!r} size={len(body)}")
        elif code in (20, 60):  # DoAction / DoInitAction
            print(f"  Tag {code} (DoAction/DoInitAction) size={len(body)}")
        elif code == 1:  # ShowFrame
            pass
        elif code in (9, 22, 24, 26, 39, 46, 48, 49, 56, 73, 84, 87, 88, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106):
            pass
        else:
            print(f"  Tag {code} size={len(body)}")

if __name__ == '__main__':
    main()
