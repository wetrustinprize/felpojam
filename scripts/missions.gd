extends Node

var initial_cutscene: bool = false ## The cutscene at the start of the game

# Lobisome
var first_lobisomen_talk: bool = false ## Has the player talked once with the lobi?
var lobisome_asleep: bool = false ## Has the Veterinario made lobisome sleep?

# Comilona
var first_comilona_talk: bool = false ## Has the player talked once with Comilona?
var comilona_ate_gelatina: bool = false ## Has the player gave Colimona the Gelatina?

# Chefe
var first_chefe_talk: bool = true ## Has the player talked once with the Chefe?

# Vampero
var first_vampero_talk: bool = false ## Has the player talked once with the Vampero?
var vampero_talked_about_chave: bool = false ## Has the Vampero talked about its lost key?
var vampero_wants_to_go_escritorio: bool = false ## Has Vampero left the Copa and wants to enter its office?
var vampero_asks_to_go_escritorio: bool = false ## He asked player to ask him to enter the office lol
var vampero_at_copa: bool = false ## Is the Vamper at the Copa?
var vampero_at_escritorio: bool = false ## Is the Vampero at its escritorio?
var vampero_has_talked_sad_things: bool = false ## Has the Vampero talked about his sad life?

# Veterinario
var first_veterinario_talk: bool = false ## Has the player talked once with the Veterinario?
var veterinario_at_escritorio: bool = false ## Is the Veterinario at its escritorio?


# Stickman Almoxarife
var first_stickman_talk: bool = false ## Has the player talked once with the Stickman?
var stickman_requested_tp: bool = false ## Player has requested toilet paper
