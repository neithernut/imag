use toml::Value;

use libimagstore::store::Entry;

use result::Result;
use tag::Tag;
use error::{TagError, TagErrorKind};

pub fn add_tag(e: &mut Entry, t: &Tag) -> Result<()> {
    let tags = e.get_header().read("imag.tags");
    if tags.is_err() {
        let kind = TagErrorKind::HeaderReadError;
        return Err(TagError::new(kind, Some(Box::new(tags.err().unwrap()))));
    }
    let tags = tags.unwrap();

    if !tags.iter().all(|t| match t { &Value::String(_) => true, _ => false }) {
        return Err(TagError::new(TagErrorKind::TagTypeError, None));
    }

    if tags.is_none() {
        return Ok(());
    }
    let tags = tags.unwrap();

    if !match tags { Value::Array(_) => true, _ => false } {
        return Err(TagError::new(TagErrorKind::TagTypeError, None));
    }

    match tags {
        Value::Array(tag_array) => {
            let mut new_tags = tag_array.clone();
            new_tags.push(Value::String(t.clone()));

            e.get_header_mut()
                .set("imag.tags", Value::Array(new_tags))
                .map_err(|e| TagError::new(TagErrorKind::TagTypeError, Some(Box::new(e))))
                .map(|_| ())
        },

        _ => unreachable!(),
    }
}
