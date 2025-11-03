use crate::error::{Proto2FFIError, Result};
use std::io::{Read, Write};

pub trait ProtoSerialize {
    fn serialize<W: Write>(&self, writer: &mut W) -> Result<()>;
    fn serialized_size(&self) -> usize;
}

pub trait ProtoDeserialize: Sized {
    fn deserialize<R: Read>(reader: &mut R) -> Result<Self>;
}

pub fn write_varint<W: Write>(writer: &mut W, mut value: u64) -> Result<()> {
    while value >= 0x80 {
        writer.write_all(&[(value as u8) | 0x80])?;
        value >>= 7;
    }
    writer.write_all(&[value as u8])?;
    Ok(())
}

pub fn read_varint<R: Read>(reader: &mut R) -> Result<u64> {
    let mut result = 0u64;
    let mut shift = 0;

    loop {
        let mut buf = [0u8; 1];
        reader.read_exact(&mut buf)?;
        let byte = buf[0];

        result |= ((byte & 0x7F) as u64) << shift;

        if byte & 0x80 == 0 {
            break;
        }

        shift += 7;
        if shift >= 64 {
            return Err(Proto2FFIError::ParseError("varint overflow".into()));
        }
    }

    Ok(result)
}

pub fn write_fixed32<W: Write>(writer: &mut W, value: u32) -> Result<()> {
    writer.write_all(&value.to_le_bytes())?;
    Ok(())
}

pub fn read_fixed32<R: Read>(reader: &mut R) -> Result<u32> {
    let mut buf = [0u8; 4];
    reader.read_exact(&mut buf)?;
    Ok(u32::from_le_bytes(buf))
}

pub fn write_fixed64<W: Write>(writer: &mut W, value: u64) -> Result<()> {
    writer.write_all(&value.to_le_bytes())?;
    Ok(())
}

pub fn read_fixed64<R: Read>(reader: &mut R) -> Result<u64> {
    let mut buf = [0u8; 8];
    reader.read_exact(&mut buf)?;
    Ok(u64::from_le_bytes(buf))
}

pub fn write_length_delimited<W: Write>(writer: &mut W, data: &[u8]) -> Result<()> {
    write_varint(writer, data.len() as u64)?;
    writer.write_all(data)?;
    Ok(())
}

pub fn read_length_delimited<R: Read>(reader: &mut R) -> Result<Vec<u8>> {
    let len = read_varint(reader)? as usize;
    let mut buf = vec![0u8; len];
    reader.read_exact(&mut buf)?;
    Ok(buf)
}

pub fn write_zigzag32<W: Write>(writer: &mut W, value: i32) -> Result<()> {
    let encoded = ((value << 1) ^ (value >> 31)) as u32;
    write_varint(writer, encoded as u64)
}

pub fn read_zigzag32<R: Read>(reader: &mut R) -> Result<i32> {
    let encoded = read_varint(reader)? as u32;
    Ok(((encoded >> 1) as i32) ^ (-((encoded & 1) as i32)))
}

pub fn write_zigzag64<W: Write>(writer: &mut W, value: i64) -> Result<()> {
    let encoded = ((value << 1) ^ (value >> 63)) as u64;
    write_varint(writer, encoded)
}

pub fn read_zigzag64<R: Read>(reader: &mut R) -> Result<i64> {
    let encoded = read_varint(reader)?;
    Ok(((encoded >> 1) as i64) ^ (-((encoded & 1) as i64)))
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum WireType {
    Varint = 0,
    Fixed64 = 1,
    LengthDelimited = 2,
    Fixed32 = 5,
}

impl WireType {
    pub fn from_u8(value: u8) -> Option<Self> {
        match value {
            0 => Some(WireType::Varint),
            1 => Some(WireType::Fixed64),
            2 => Some(WireType::LengthDelimited),
            5 => Some(WireType::Fixed32),
            _ => None,
        }
    }
}

pub fn write_tag<W: Write>(writer: &mut W, field_number: u32, wire_type: WireType) -> Result<()> {
    let tag = (field_number << 3) | (wire_type as u32);
    write_varint(writer, tag as u64)
}

pub fn read_tag<R: Read>(reader: &mut R) -> Result<(u32, WireType)> {
    let tag = read_varint(reader)? as u32;
    let field_number = tag >> 3;
    let wire_type = WireType::from_u8((tag & 0x7) as u8)
        .ok_or_else(|| Proto2FFIError::ParseError(format!("invalid wire type: {}", tag & 0x7)))?;
    Ok((field_number, wire_type))
}

pub fn skip_value<R: Read>(reader: &mut R, wire_type: WireType) -> Result<()> {
    match wire_type {
        WireType::Varint => {
            read_varint(reader)?;
        }
        WireType::Fixed64 => {
            read_fixed64(reader)?;
        }
        WireType::LengthDelimited => {
            read_length_delimited(reader)?;
        }
        WireType::Fixed32 => {
            read_fixed32(reader)?;
        }
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_varint_roundtrip() {
        let test_values = vec![0u64, 1, 127, 128, 300, 16383, 16384, 2097151];

        for value in test_values {
            let mut buf = Vec::new();
            write_varint(&mut buf, value).unwrap();

            let mut cursor = std::io::Cursor::new(&buf);
            let decoded = read_varint(&mut cursor).unwrap();

            assert_eq!(value, decoded);
        }
    }

    #[test]
    fn test_varint_encoding() {
        let test_cases = vec![
            (0u64, vec![0x00]),
            (127u64, vec![0x7F]),
            (128u64, vec![0x80, 0x01]),
            (300u64, vec![0xAC, 0x02]),
        ];

        for (value, expected) in test_cases {
            let mut buf = Vec::new();
            write_varint(&mut buf, value).unwrap();
            assert_eq!(buf, expected);
        }
    }

    #[test]
    fn test_fixed32_roundtrip() {
        let values = vec![0u32, 1, 255, 256, 65535, 65536, u32::MAX];

        for value in values {
            let mut buf = Vec::new();
            write_fixed32(&mut buf, value).unwrap();

            let mut cursor = std::io::Cursor::new(&buf);
            let decoded = read_fixed32(&mut cursor).unwrap();

            assert_eq!(value, decoded);
        }
    }

    #[test]
    fn test_zigzag_encoding() {
        let test_cases = vec![
            (0i32, 0u64),
            (-1i32, 1u64),
            (1i32, 2u64),
            (-2i32, 3u64),
            (2147483647i32, 4294967294u64),
            (-2147483648i32, 4294967295u64),
        ];

        for (value, expected) in test_cases {
            let mut buf = Vec::new();
            write_zigzag32(&mut buf, value).unwrap();

            let mut cursor = std::io::Cursor::new(&buf);
            let encoded_varint = read_varint(&mut cursor).unwrap();

            assert_eq!(encoded_varint, expected);
        }
    }

    #[test]
    fn test_zigzag32_roundtrip() {
        let values = vec![0i32, 1, -1, 100, -100, i32::MAX, i32::MIN];

        for value in values {
            let mut buf = Vec::new();
            write_zigzag32(&mut buf, value).unwrap();

            let mut cursor = std::io::Cursor::new(&buf);
            let decoded = read_zigzag32(&mut cursor).unwrap();

            assert_eq!(value, decoded);
        }
    }

    #[test]
    fn test_tag_roundtrip() {
        let test_cases = vec![
            (1u32, WireType::Varint),
            (2u32, WireType::Fixed64),
            (3u32, WireType::LengthDelimited),
            (1000u32, WireType::Fixed32),
        ];

        for (field_number, wire_type) in test_cases {
            let mut buf = Vec::new();
            write_tag(&mut buf, field_number, wire_type).unwrap();

            let mut cursor = std::io::Cursor::new(&buf);
            let (decoded_field, decoded_type) = read_tag(&mut cursor).unwrap();

            assert_eq!(field_number, decoded_field);
            assert_eq!(wire_type, decoded_type);
        }
    }

    #[test]
    fn test_length_delimited() {
        let data = b"hello world";

        let mut buf = Vec::new();
        write_length_delimited(&mut buf, data).unwrap();

        let mut cursor = std::io::Cursor::new(&buf);
        let decoded = read_length_delimited(&mut cursor).unwrap();

        assert_eq!(data, decoded.as_slice());
    }
}
