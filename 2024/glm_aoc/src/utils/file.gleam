import file_streams/file_stream
import file_streams/text_encoding

fn read_line(result: String, stream: file_stream.FileStream) -> String {
    case file_stream.read_line(stream) {
        Ok(line) -> read_line(result <> line, stream)
        Error(_) -> result
    }
}

pub fn read_input(filename: String) -> String {
    let stream = case file_stream.open_read_text(filename, text_encoding.Unicode) {
        Ok(stream) -> stream
        Error(_) -> panic as "Error opening input"
    }
    read_line("", stream)
}

