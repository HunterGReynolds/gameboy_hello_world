    SECTION "graphics_functions", ROM0
load_graphics::
    ;; de = data source
    ;; hl = destination
    ;; bc = length
    ld de, bg_tile_data
    ld hl, $9000
    ld bc, bg_tile_data_end - bg_tile_data
    call mem_copy

    ld de, tilemap
    ld hl, $9800
    ld bc, tilemap_end - tilemap
    call mem_copy
    ret

mem_copy::
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jr nz, mem_copy
    ret
    
    SECTION "graphics_data", ROM0
bg_tile_data:
    INCBIN "assets/font.2bpp"
bg_tile_data_end:
