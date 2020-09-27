.pragma library

function addrToNum(network) {
    var bytes = getBytes(network)
    var num = 0
    for (var byte = 0; byte < 4; byte++) {
        num += bytes[3-byte] << (byte*8)
    }
    return num
}

function numToAddr(number) {
    var bytes = []
    for (var byte = 0; byte < 4; byte++) {
        bytes[3-byte] = number >> (byte*8);
        bytes[3-byte] &= 255
    }
    return bytes.join('.')
}

function getMaskLength(network) {
    return network.split('/')[1]
}

function getBytes(network) {
    return network.split('/')[0].split('.')
}

function getNetwork(network) {
    var bytes = getBytes(network)
    var mask = getMask(network).split('.')
    var net = []
    for (var byte = 0; byte < 4; byte++) {
        net[byte] = bytes[byte] & mask[byte]
    }
    return net.join('.')
}

function getMask(network) {
    var len = getMaskLength(network)
    var mask = []
    if (len >= 0 && len <= 32) {
        for (var byte = 0; byte < 4; byte++) {
            mask[byte] = 0
            for (var bit = 7; bit >= 0 && len > 0; bit--) {
                mask[byte] += Math.pow(2, bit)
                len--
            }
        }
    }
    return mask.join('.')
}

function getBroadcast(network) {
    var bytes = getBytes(network)
    var mask = getMask(network).split('.')
    var broad = []
    for (var byte = 0; byte < 4; byte++) {
        broad[byte] = (bytes[byte] | ~mask[byte]) & 255
    }
    return broad.join('.')
}

function getMinHost(network) {
    var num = addrToNum(network)
    return numToAddr(num+1)
}

function getMaxHost(network) {
    var bytes = getBroadcast(network).split('.')
    bytes[3]--
    return bytes.join('.')
}

function getNumHosts(network) {
    var mask = getMask(network).split('.')
    var num = (~mask[3] & 255) +1
    for (var byte = 2; byte >= 0; byte--) {
        num *= (~mask[byte] & 255) + 1
    }
    return num-2 > 0 ? num-2 : 0
}

//function hostMath(network, number) {
    // TODO
//}

function networkMath(network, number) {
    var mask = getMaskLength(network)
    var num = addrToNum(network)
    num += number << (32-mask)
    return numToAddr(num) + "/" + mask
}
