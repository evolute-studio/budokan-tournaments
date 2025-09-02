#[derive(Copy, Drop, Serde, Introspect, DojoStore)]
pub struct Lifecycle {
    pub mint: u64,
    pub start: Option<u64>,
    pub end: Option<u64>,
}
