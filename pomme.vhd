----------------------------------------------------------------------------------
-- Company: 
-- Engineer: FREDERIC Pierre-Marie
-- 
-- Create Date: 21.07.2021 17:44:22
-- Design Name: 
-- Module Name: pomme - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pomme is
Port (
    reset, clk25:   in  std_logic;
    nb_seg: in  integer range 0 to 10;--signal utilisé pour savoir le numéro de la pomme à faire apparaître
    pomD:   out integer range 0 to 639;--coordonnées droite de la pomme à faire apparaître
    pomG:   out integer range 0 to 639;--coordonnées gauche de la pomme à faire apparaître
    pomH:   out integer range 0 to 479;--coordonnées haute de la pomme à faire apparaître
    pomB:   out integer range 0 to 479;--coordonnées basse de la pomme à faire apparaître
    win:    out std_logic := '0';
    chrono : out integer range 0 to 125000000 := 0
 );
end pomme;

architecture Behavioral of pomme is
--==========--
-- CONSTANT --
--==========--
    --coordonnées pomme 1
    constant POMG1: integer := 130;
    constant POMD1: integer := POMG1+10;
    constant POMH1: integer := 234; 
    constant POMB1: integer := POMH1+10;
    --coordonnées pomme 2
    constant POMG2: integer := 22;
    constant POMD2: integer := POMG2+10;
    constant POMH2: integer := 22;
    constant POMB2: integer := POMH2+10;
    --coordonnées pomme 3
    constant POMG3: integer := 63;
    constant POMD3: integer := POMG3+10;
    constant POMH3: integer := 345;
    constant POMB3: integer := POMH3+10;
    --coordonnées pomme 4
    constant POMD4: integer := 32;
    constant POMG4: integer := POMD4-10;
    constant POMH4: integer := 239;
    constant POMB4: integer := 239+10;
    --coordonnées pomme 5
    constant POMG5: integer := 521;
    constant POMD5: integer := POMG5+10;
    constant POMB5: integer := 456;
    constant POMH5: integer := POMB5-10;
    --coordonnées pomme 6
    constant POMG6: integer := 606;
    constant POMD6: integer := POMG6+10;
    constant POMH6: integer := 263;
    constant POMB6: integer := POMH6+10;
    --coordonnées pomme 7
    constant POMG7: integer := 617;
    constant POMD7: integer := POMG7+10;
    constant POMH7: integer := 217;
    constant POMB7: integer := POMH7+10;
    --coordonnées pomme 8
    constant POMG8: integer := 312;
    constant POMD8: integer := POMG8+10;
    constant POMH8: integer := 44;
    constant POMB8: integer := POMH8+10;
    --coordonnées pomme 9
    constant POMG9: integer := 421;
    constant POMD9: integer := POMG9+10;
    constant POMH9: integer := 33;
    constant POMB9: integer := POMH9+10;
    --coordonnées pomme 10
    constant POMD10: integer := 594;
    constant POMG10: integer := POMD10-10;
    constant POMH10: integer := 135;
    constant POMB10: integer := POMH10+10;
    
--=========--
-- SIGNAUX --
--=========--
--coordonnées de la pomme à afficher
    signal pomD_s:   integer range 0 to 639;--coordonnées droite de la pomme à faire apparaître
    signal pomG_s:   integer range 0 to 639;--coordonnées gauche de la pomme à faire apparaître
    signal pomH_s:   integer range 0 to 479;--coordonnées haute de la pomme à faire apparaître
    signal pomB_s:   integer range 0 to 479;--coordonnées basse de la pomme à faire apparaître

--compteur pour mesurer la durée d'affichage de l'écran de victoire
    signal top_chrono: std_logic := '0';
    signal chrono_s:  integer range 0 to 125000000 := 0;
    
    
--pour la MAE    
    type etat is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10);
    signal EP, EF : etat;
    
begin
--Registre d'états
    process(clk25,reset)
    begin
        if reset = '1' then EP <= S0;
        elsif rising_edge (clk25) then EP <= EF;
        end if;
    end process;
    
--combinatoire des états
    process(EP,nb_seg,chrono_s)
    begin
        case (EP) is
            when S0 => EF <= S0; if nb_seg = 1 then EF <= S1; end if;
            when S1 => EF <= S1; if nb_seg = 2 then EF <= S2; elsif nb_seg = 0 then EF <= S0; end if;
            when S2 => EF <= S2; if nb_seg = 3 then EF <= S3; elsif nb_seg = 0 then EF <= S0; end if;
            when S3 => EF <= S3; if nb_seg = 4 then EF <= S4; elsif nb_seg = 0 then EF <= S0; end if;
            when S4 => EF <= S4; if nb_seg = 5 then EF <= S5; elsif nb_seg = 0 then EF <= S0; end if;
            when S5 => EF <= S5; if nb_seg = 6 then EF <= S6; elsif nb_seg = 0 then EF <= S0; end if;
            when S6 => EF <= S6; if nb_seg = 7 then EF <= S7; elsif nb_seg = 0 then EF <= S0; end if;
            when S7 => EF <= S7; if nb_seg = 8 then EF <= S8; elsif nb_seg = 0 then EF <= S0; end if;
            when S8 => EF <= S8; if nb_seg = 9 then EF <= S9; elsif nb_seg = 0 then EF <= S0; end if;
            when S9 => EF <= S9; if nb_seg = 10 then EF <= S10; elsif nb_seg = 0 then EF <= S0; end if;
            when S10 => EF <= S10; if chrono_s = 125000000 then EF <= S0; end if;
        end case;    
    end process;
    
--combinatoire des sorties
    process(EP)
    begin
        case(EP) is
            when S0 => pomD_s <= POMD1; pomG_s <= POMG1; pomH_s <= POMH1; pomB_s <= POMB1; win <= '0'; top_chrono <= '0';
            when S1 => pomD_s <= POMD2; pomG_s <= POMG2; pomH_s <= POMH2; pomB_s <= POMB2;
            when S2 => pomD_s <= POMD3; pomG_s <= POMG3; pomH_s <= POMH3; pomB_s <= POMB3;
            when S3 => pomD_s <= POMD4; pomG_s <= POMG4; pomH_s <= POMH4; pomB_s <= POMB4;
            when S4 => pomD_s <= POMD5; pomG_s <= POMG5; pomH_s <= POMH5; pomB_s <= POMB5;
            when S5 => pomD_s <= POMD6; pomG_s <= POMG6; pomH_s <= POMH6; pomB_s <= POMB6;
            when S6 => pomD_s <= POMD7; pomG_s <= POMG7; pomH_s <= POMH7; pomB_s <= POMB7;
            when S7 => pomD_s <= POMD8; pomG_s <= POMG8; pomH_s <= POMH8; pomB_s <= POMB8;
            when S8 => pomD_s <= POMD9; pomG_s <= POMG9; pomH_s <= POMH9; pomB_s <= POMB9;
            when S9 => pomD_s <= POMD10; pomG_s <= POMG10; pomH_s <= POMH10; pomB_s <= POMB10;
            when S10 => win <= '1'; top_chrono <= '1';
        end case;
    end process;
    
    process(reset,clk25)
    begin
        if reset = '1' then chrono_s <= 0;
        elsif rising_edge (clk25) and top_chrono = '1' then 
            if chrono_s + 1 > 125000000 then chrono_s <= 0;
            else chrono_s <= chrono_s + 1;
            end if;
        end if;
    end process;
    
--mise à jour des coordonnées de la pomme à afficher    
    pomD <= pomD_s;
    pomG <= pomG_s;
    pomH <= pomH_s;
    pomB <= pomB_s;

--mise à jour du compteur
    chrono <= chrono_s;
        
end Behavioral;
