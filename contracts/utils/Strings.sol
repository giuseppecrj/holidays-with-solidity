// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    // converts a uint to its ASCII `string` decimal representation
    function toString(uint value) internal pure returns (string memory) {
        if (value == 0) return "0";

        uint temp = value;
        uint digits;

        while (temp != 0) {
            digits++;
            temp /= 10;
        }

        bytes memory buffer = new bytes(digits);

        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }

        return string(buffer);
    }

    // converts a uint to its ASCII `string` hexadecimal representation
    function toHexString(uint value) internal pure returns (string memory) {
        if (value == 0) return "0x00";

        uint temp = value;
        uint length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }

        return toHexString(value, length);
    }

    // converts a uint to ASCII with fixed lenth
    function toHexString(uint value, uint length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }

        require(value == 0, "String: hex length insufficient");
        return string(buffer);
    }
}