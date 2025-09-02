#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore)]
pub struct Schedule {
    pub registration: Option<Period>,
    pub game: Period,
    pub submission_duration: u64,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore)]
pub struct Period {
    pub start: u64,
    pub end: u64,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore, Default)]
pub enum Phase {
    #[default]
    Scheduled,
    Registration,
    Staging,
    Live,
    Submission,
    Finalized,
}
