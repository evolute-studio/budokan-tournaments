// SPDX-License-Identifier: BUSL-1.1

use starknet::{ContractAddress};
use core::num::traits::Zero;
use tournaments::components::models::schedule::Schedule;

#[dojo::model]
#[derive(Drop, Serde)]
pub struct Tournament {
    #[key]
    pub id: u64,
    pub created_at: u64,
    pub created_by: ContractAddress,
    pub creator_token_id: u64,
    pub metadata: Metadata,
    pub schedule: Schedule,
    pub game_config: GameConfig,
    pub entry_fee: Option<EntryFee>,
    pub entry_requirement: Option<EntryRequirement>,
}

#[derive(Drop, Serde, Introspect, DojoStore)]
pub struct Metadata {
    pub name: felt252,
    pub description: ByteArray,
}

#[derive(Copy, Drop, Serde, Introspect, DojoStore)]
pub struct GameConfig {
    pub address: ContractAddress,
    pub settings_id: u32,
    pub prize_spots: u8,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore)]
pub struct EntryFee {
    pub token_address: ContractAddress,
    pub amount: u128,
    pub distribution: Span<u8>,
    pub tournament_creator_share: Option<u8>,
    pub game_creator_share: Option<u8>,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore)]
pub struct EntryRequirement {
    pub entry_limit: u8,
    pub entry_requirement_type: EntryRequirementType,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore)]
pub enum EntryRequirementType {
    token: ContractAddress,
    tournament: TournamentType,
    allowlist: Span<ContractAddress>,
}

impl EntryRequirementTypeDefault of Default<EntryRequirementType> {
    fn default() -> EntryRequirementType {
        EntryRequirementType::token(Zero::zero())
    }
}

#[dojo::model]
#[derive(Drop, Serde)]
pub struct QualificationEntries {
    #[key]
    pub tournament_id: u64,
    #[key]
    pub qualification_proof: QualificationProof,
    pub entry_count: u8,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore)]
pub enum TournamentType {
    #[default]
    winners: Span<u64>,
    participants: Span<u64>,
}

impl TournamentTypeDefault of Default<TournamentType> {
    fn default() -> TournamentType {
        TournamentType::winners(array![].span())
    }
}


#[derive(Copy, Drop, Serde, Introspect, DojoStore, Default)]
pub struct ERC20Data {
    pub amount: u128,
}

#[derive(Copy, Drop, Serde, Introspect, DojoStore, Default)]
pub struct ERC721Data {
    pub id: u128,
}

#[derive(Copy, Drop, Serde, Introspect, DojoStore, Default)]
pub enum TokenType {
    #[default]
    erc20: ERC20Data,
    erc721: ERC721Data,
}

#[dojo::model]
#[derive(Copy, Drop, Serde, IntrospectPacked)]
pub struct Registration {
    #[key]
    pub game_address: ContractAddress,
    #[key]
    pub game_token_id: u64,
    pub tournament_id: u64,
    pub entry_number: u32,
    pub has_submitted: bool,
}

#[dojo::model]
#[derive(Drop, Serde)]
pub struct Leaderboard {
    #[key]
    pub tournament_id: u64,
    pub token_ids: Array<u64>,
}

#[dojo::model]
#[derive(Copy, Drop, Serde, IntrospectPacked)]
pub struct PlatformMetrics {
    #[key]
    pub key: felt252,
    pub total_tournaments: u64,
}

#[dojo::model]
#[derive(Copy, Drop, Serde, IntrospectPacked)]
pub struct TournamentTokenMetrics {
    #[key]
    pub key: felt252,
    pub total_supply: u64,
}

#[dojo::model]
#[derive(Copy, Drop, Serde, IntrospectPacked)]
pub struct PrizeMetrics {
    #[key]
    pub key: felt252,
    pub total_prizes: u64,
}

#[dojo::model]
#[derive(Copy, Drop, Serde, IntrospectPacked)]
pub struct EntryCount {
    #[key]
    pub tournament_id: u64,
    pub count: u32,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
pub struct Prize {
    #[key]
    pub id: u64,
    pub tournament_id: u64,
    pub payout_position: u8,
    pub token_address: ContractAddress,
    pub token_type: TokenType,
    pub sponsor_address: ContractAddress,
}

//TODO: Remove name and symbol from the model
#[dojo::model]
#[derive(Drop, Serde)]
pub struct Token {
    #[key]
    pub address: ContractAddress,
    pub name: ByteArray,
    pub symbol: ByteArray,
    pub token_type: TokenType,
    pub is_registered: bool,
}

#[dojo::model]
#[derive(Copy, Drop, Serde)]
pub struct TournamentConfig {
    #[key]
    pub key: felt252,
    pub safe_mode: bool,
    pub test_mode: bool,
}

#[dojo::model]
#[derive(Copy, Drop, Serde, IntrospectPacked)]
pub struct PrizeClaim {
    #[key]
    pub tournament_id: u64,
    #[key]
    pub prize_type: PrizeType,
    pub claimed: bool,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore, Default)]
pub enum Role {
    #[default]
    TournamentCreator,
    GameCreator,
    Position: u8,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore, Default)]
pub enum PrizeType {
    #[default]
    EntryFees: Role,
    Sponsored: u64,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore, Default)]
pub enum QualificationProof {
    // For qualifying via previous tournament
    #[default]
    Tournament: TournamentQualification,
    // For qualifying via NFT ownership
    NFT: NFTQualification,
    Address: ContractAddress,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore, Default)]
pub struct TournamentQualification {
    pub tournament_id: u64,
    pub token_id: u64,
    pub position: u8,
}

#[derive(Copy, Drop, Serde, PartialEq, Introspect, DojoStore)]
pub struct NFTQualification {
    pub token_id: u256,
}
