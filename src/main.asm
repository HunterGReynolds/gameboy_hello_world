INCLUDE "hardware.inc"

    SECTION "data", WRAM0
frame_counter::
    db
    
    SECTION "main", ROM0
entry_point::
    ;; First thing we need to do is wait for Vblank so we can disable the LCD/PPU
    ;; this will allow us access to the VRAM without interruption. We enable the
    ;; interrupt flag here.
    ld a, IEF_VBLANK
    ldh [rIE], a
    ;; and then enable interrupts here. You don't want to do a halt immediately following
    ;; ei due to a bug, so we zero out a since we needed to anyway
    ei
    xor a
    halt

    di
    ;; turn off the LCD/PPU
    ld [rLCDC], a
    ;; turn off the sound system. Recommended to do if it's not being used
    ld [rNR52], a
    ld [frame_counter], a

    call load_graphics

    ;; load the palatte colors for the background
    ;; $E4 = 11 10 01 00 -- black, dark gray, light gray, white
    ld a, $E4
    ld [rBGP], a

    ;; We've got the graphics loaded and everything ready to go, so let's turn the LCD
    ;; back on and run our main loop
    ld a, LCDCF_ON | LCDCF_BGON
    ld [rLCDC], a
    ei

main_loop:
    xor a
    halt

    ld a, [frame_counter]
    inc a
    ld [frame_counter], a
    
    jp main_loop
