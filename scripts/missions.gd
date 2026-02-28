extends Node

var initial_cutscene: bool = false ## The cutscene at the start of the game

# Lobisome
var first_lobisomen_talk: bool = false ## Has the player talked once with the lobi?
var lobisome_asleep: bool = false ## Has the Veterinario made lobisome sleep?

# Comilona
var first_comilona_talk: bool = false ## Has the player talked once with Comilona?
var comilona_ate_gelatina: bool = false ## Has the player gave Colimona the Gelatina?

# Chefe
var first_chefe_talk: bool = false ## Has the player talked once with the Chefe?

# Vampero
var first_vampero_talk: bool = false ## Has the player talked once with the Vampero?
var vampero_at_escritorio: bool = false ## Is the Vampero at its escritorio?

# Veterinario
var first_veterinario_talk: bool = false ## Has the player talked once with the Veterinario?
var veterinario_at_escritorio: bool = false ## Is the Veterinario at its escritorio?


# Stickman Almoxarife
var first_stickman_talk: bool = false ## Has the player talked once with the Stickman?
var stickman_has_forms: bool = true ## Player has required forms for toilet paper
var stickman_has_stamp: bool = true ## Player has required stamp for toilet paper
var stickman_requested_tp: bool = false ## Player has requested toilet paper
var stickman_has_tp: bool = false ## Player has requested toilet paper