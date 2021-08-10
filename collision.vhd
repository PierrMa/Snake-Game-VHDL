----------------------------------------------------------------------------------
-- Company: 
-- Engineer: FREDERIC Pierre-Marie
-- 
-- Create Date: 28.07.2021 20:08:35
-- Design Name: 
-- Module Name: collision - Behavioral
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

entity collision is
Port ( 
    teteH: in integer range 0 to 479;
    teteB: in integer range 0 to 479;
    teteG: in integer range 0 to 639;
    teteD: in integer range 0 to 639;
    
    segB1: in integer range 0 to 479;
    segB2: in integer range 0 to 479;
    segB3: in integer range 0 to 479;
    segB4: in integer range 0 to 479;
    segB5: in integer range 0 to 479;
    segB6: in integer range 0 to 479;
    segB7: in integer range 0 to 479;
    segB8: in integer range 0 to 479;
    segB9: in integer range 0 to 479;
    segB10: in integer range 0 to 479;
    
    segG1: in integer range 0 to 639;
    segG2: in integer range 0 to 639;
    segG3: in integer range 0 to 639;
    segG4: in integer range 0 to 639;
    segG5: in integer range 0 to 639;
    segG6: in integer range 0 to 639;
    segG7: in integer range 0 to 639;
    segG8: in integer range 0 to 639;
    segG9: in integer range 0 to 639;
    segG10: in integer range 0 to 639;
    
    segH1: in integer range 0 to 469;
    segH2: in integer range 0 to 469;
    segH3: in integer range 0 to 469;
    segH4: in integer range 0 to 469;
    segH5: in integer range 0 to 469;
    segH6: in integer range 0 to 469;
    segH7: in integer range 0 to 469;
    segH8: in integer range 0 to 469;
    segH9: in integer range 0 to 469;
    segH10: in integer range 0 to 469;
    
    segD1: in integer range 0 to 639;
    segD2: in integer range 0 to 639;
    segD3: in integer range 0 to 639;
    segD4: in integer range 0 to 639;
    segD5: in integer range 0 to 639;
    segD6: in integer range 0 to 639;
    segD7: in integer range 0 to 639;
    segD8: in integer range 0 to 639;
    segD9: in integer range 0 to 639;
    segD10: in integer range 0 to 639;
    
    lose: out std_logic:='0';
    
    clkVit,clk25: in  std_logic;
    reset: in std_logic;
    cpt:    out integer range 0 to 125000000
);
end collision;

architecture Behavioral of collision is
--==========--
-- CONSTANT --
--==========--
    -- Constantes pour les obstacles
	constant LIM_G1: integer := 214; --limite gauche de l'obstacle
	constant LIM_D1: integer := LIM_G1+206; --limite droite de l'obstacle
	constant LIM_H1: integer := 33; --limite haute de l'obstacle
    constant LIM_B1: integer := LIM_H1+10; --limite basse de l'obstacle
    
    constant LIM_G2: integer := 214; --limite gauche de l'obstacle
	constant LIM_D2: integer := LIM_G2+206; --limite droite de l'obstacle
	constant LIM_H2: integer := 435; --limite haute de l'obstacle
    constant LIM_B2: integer := LIM_H2+10; --limite basse de l'obstacle
    
    constant LIM_G3: integer := 63; --limite gauche de l'obstacle
	constant LIM_D3: integer := LIM_G3+10; --limite droite de l'obstacle
	constant LIM_H3: integer := 135; --limite haute de l'obstacle
    constant LIM_B3: integer := LIM_H3+208; --limite basse de l'obstacle
    
    constant LIM_G4: integer := 565; --limite gauche de l'obstacle
	constant LIM_D4: integer := LIM_G4+10; --limite droite de l'obstacle
	constant LIM_H4: integer := 135; --limite haute de l'obstacle
    constant LIM_B4: integer := LIM_H4+208; --limite basse de l'obstacle
    
    constant LIM_G5: integer := 11; --limite gauche de l'obstacle
	constant LIM_D5: integer := LIM_G5+206; --limite droite de l'obstacle
	constant LIM_H5: integer := 11; --limite haute de l'obstacle
    constant LIM_B5: integer := LIM_H5+10; --limite basse de l'obstacle
    
    constant LIM_G6: integer := 421; --limite gauche de l'obstacle
	constant LIM_D6: integer := LIM_G6+206; --limite droite de l'obstacle
	constant LIM_H6: integer := 11; --limite haute de l'obstacle
    constant LIM_B6: integer := LIM_H6+10; --limite basse de l'obstacle
    
    constant LIM_G7: integer := 11; --limite gauche de l'obstacle
	constant LIM_D7: integer := LIM_G7+206; --limite droite de l'obstacle
	constant LIM_H7: integer := 458; --limite haute de l'obstacle
    constant LIM_B7: integer := LIM_H7+10; --limite basse de l'obstacle
    
    constant LIM_G8: integer := 421; --limite gauche de l'obstacle
	constant LIM_D8: integer := LIM_G8+206; --limite droite de l'obstacle
	constant LIM_H8: integer := 458; --limite haute de l'obstacle
    constant LIM_B8: integer := LIM_H8+10; --limite basse de l'obstacle
    
    constant LIM_G9: integer := 11; --limite gauche de l'obstacle
	constant LIM_D9: integer := LIM_G9+10; --limite droite de l'obstacle
	constant LIM_H9: integer := 21; --limite haute de l'obstacle
    constant LIM_B9: integer := LIM_H9+195; --limite basse de l'obstacle
    
    constant LIM_G10: integer := 11; --limite gauche de l'obstacle
	constant LIM_D10: integer := LIM_G10+10; --limite droite de l'obstacle
	constant LIM_H10: integer := 263; --limite haute de l'obstacle
    constant LIM_B10: integer := LIM_H10+195; --limite basse de l'obstacle
    
    constant LIM_G11: integer := 617; --limite gauche de l'obstacle
	constant LIM_D11: integer := LIM_G11+10; --limite droite de l'obstacle
	constant LIM_H11: integer := 263; --limite haute de l'obstacle
    constant LIM_B11: integer := LIM_H11+195; --limite basse de l'obstacle
    
    constant LIM_G12: integer := 617; --limite gauche de l'obstacle
	constant LIM_D12: integer := LIM_G12+10; --limite droite de l'obstacle
	constant LIM_H12: integer := 21; --limite haute de l'obstacle
    constant LIM_B12: integer := LIM_H12+195; --limite basse de l'obstacle

--=========--
-- SIGNAUX --
--=========--
    -- compteur pour l'affiche de l'écran de perte
    signal cpt_s: integer range 0 to 125000000 :=0;
    
    signal lose_s: std_logic := '0';
    
begin

--=========================================--
-- DETECTEUR DE COLLISION AVEC UN OBSTACLE --
--=========================================--
    process (reset, clkVit)
    begin
        if reset = '1' or cpt_s = 125000000 then lose_s <= '0';
        elsif rising_edge (clkVit) then
          --collision avec un obstacle 
            if ((teteH<= LIM_B1 and teteH >= LIM_H1) and (teteG <= LIM_D1 and teteG >= LIM_G1))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 1
            or ((teteH<= LIM_B2 and teteH >= LIM_H2) and (teteG <= LIM_D2 and teteG >= LIM_G2))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 2
            or ((teteH<= LIM_B3 and teteH >= LIM_H3) and (teteG <= LIM_D3 and teteG >= LIM_G3))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 3
            or ((teteH<= LIM_B4 and teteH >= LIM_H4) and (teteG <= LIM_D4 and teteG >= LIM_G4))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 4
            or ((teteH<= LIM_B5 and teteH >= LIM_H5) and (teteG <= LIM_D5 and teteG >= LIM_G5))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 5
            or ((teteH<= LIM_B6 and teteH >= LIM_H6) and (teteG <= LIM_D6 and teteG >= LIM_G6))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 6
            or ((teteH<= LIM_B7 and teteH >= LIM_H7) and (teteG <= LIM_D7 and teteG >= LIM_G7))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 7
            or ((teteH<= LIM_B8 and teteH >= LIM_H8) and (teteG <= LIM_D8 and teteG >= LIM_G8))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 8
            or ((teteH<= LIM_B9 and teteH >= LIM_H9) and (teteG <= LIM_D9 and teteG >= LIM_G9))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 9
            or ((teteH<= LIM_B10 and teteH >= LIM_H10) and (teteG <= LIM_D10 and teteG >= LIM_G10))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 10 
            or ((teteH<= LIM_B11 and teteH >= LIM_H11) and (teteG <= LIM_D11 and teteG >= LIM_G11))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 11
            or ((teteH<= LIM_B12 and teteH >= LIM_H12) and (teteG <= LIM_D12 and teteG >= LIM_G12))--la partie sup et gauche de la tête du serpent sont commprises dans l'obstacle 12
            
            or ((teteB>= LIM_H1 and teteB <= LIM_B1) and (teteG <= LIM_D1 and teteG >= LIM_G1))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 1
            or ((teteB>= LIM_H2 and teteB <= LIM_B2) and (teteG <= LIM_D2 and teteG >= LIM_G2))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 2
            or ((teteB>= LIM_H3 and teteB <= LIM_B3) and (teteG <= LIM_D3 and teteG >= LIM_G3))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 3
            or ((teteB>= LIM_H4 and teteB <= LIM_B4) and (teteG <= LIM_D4 and teteG >= LIM_G4))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 4
            or ((teteB>= LIM_H5 and teteB <= LIM_B5) and (teteG <= LIM_D5 and teteG >= LIM_G5))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 5
            or ((teteB>= LIM_H6 and teteB <= LIM_B6) and (teteG <= LIM_D6 and teteG >= LIM_G6))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 6
            or ((teteB>= LIM_H7 and teteB <= LIM_B7) and (teteG <= LIM_D7 and teteG >= LIM_G7))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 7
            or ((teteB>= LIM_H8 and teteB <= LIM_B8) and (teteG <= LIM_D8 and teteG >= LIM_G8))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 8
            or ((teteB>= LIM_H9 and teteB <= LIM_B9) and (teteG <= LIM_D9 and teteG >= LIM_G9))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 9
            or ((teteB>= LIM_H10 and teteB <= LIM_B10) and (teteG <= LIM_D10 and teteG >= LIM_G10))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 10
            or ((teteB>= LIM_H11 and teteB <= LIM_B11) and (teteG <= LIM_D11 and teteG >= LIM_G11))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 11
            or ((teteB>= LIM_H12 and teteB <= LIM_B12) and (teteG <= LIM_D12 and teteG >= LIM_G12))--la partie inf et gauche de la tête du serpent sont commprises dans l'obstacle 12
            
            or ((teteB>= LIM_H1 and teteB <= LIM_B1) and (teteD <= LIM_D1 and teteD >= LIM_G1))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 1
            or ((teteB>= LIM_H2 and teteB <= LIM_B2) and (teteD <= LIM_D2 and teteD >= LIM_G2))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 2
            or ((teteB>= LIM_H3 and teteB <= LIM_B3) and (teteD <= LIM_D3 and teteD >= LIM_G3))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 3
            or ((teteB>= LIM_H4 and teteB <= LIM_B4) and (teteD <= LIM_D4 and teteD >= LIM_G4))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 4
            or ((teteB>= LIM_H5 and teteB <= LIM_B5) and (teteD <= LIM_D5 and teteD >= LIM_G5))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 5
            or ((teteB>= LIM_H6 and teteB <= LIM_B6) and (teteD <= LIM_D6 and teteD >= LIM_G6))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 6
            or ((teteB>= LIM_H7 and teteB <= LIM_B7) and (teteD <= LIM_D7 and teteD >= LIM_G7))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 7
            or ((teteB>= LIM_H8 and teteB <= LIM_B8) and (teteD <= LIM_D8 and teteD >= LIM_G8))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 8
            or ((teteB>= LIM_H9 and teteB <= LIM_B9) and (teteD <= LIM_D9 and teteD >= LIM_G9))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 9
            or ((teteB>= LIM_H10 and teteB <= LIM_B10) and (teteD <= LIM_D10 and teteD >= LIM_G10))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 10
            or ((teteB>= LIM_H11 and teteB <= LIM_B11) and (teteD <= LIM_D11 and teteD >= LIM_G11))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 11
            or ((teteB>= LIM_H12 and teteB <= LIM_B12) and (teteD <= LIM_D12 and teteD >= LIM_G12))--la partie inf et droite de la tête du serpent sont commprises dans l'obstacle 12
            
            or ((teteH<= LIM_B1 and teteH >= LIM_H1) and (teteD <= LIM_D1 and teteD >= LIM_G1)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 1
            or ((teteH<= LIM_B2 and teteH >= LIM_H2) and (teteD <= LIM_D2 and teteD >= LIM_G2)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 2
            or ((teteH<= LIM_B3 and teteH >= LIM_H3) and (teteD <= LIM_D3 and teteD >= LIM_G3)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 3
            or ((teteH<= LIM_B4 and teteH >= LIM_H4) and (teteD <= LIM_D4 and teteD >= LIM_G4)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 4
            or ((teteH<= LIM_B5 and teteH >= LIM_H5) and (teteD <= LIM_D5 and teteD >= LIM_G5)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 5
            or ((teteH<= LIM_B6 and teteH >= LIM_H6) and (teteD <= LIM_D6 and teteD >= LIM_G6)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 6
            or ((teteH<= LIM_B7 and teteH >= LIM_H7) and (teteD <= LIM_D7 and teteD >= LIM_G7)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 7
            or ((teteH<= LIM_B8 and teteH >= LIM_H8) and (teteD <= LIM_D8 and teteD >= LIM_G8)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 8
            or ((teteH<= LIM_B9 and teteH >= LIM_H9) and (teteD <= LIM_D9 and teteD >= LIM_G9)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 9
            or ((teteH<= LIM_B10 and teteH >= LIM_H10) and (teteD <= LIM_D10 and teteD >= LIM_G10)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 10 
            or ((teteH<= LIM_B11 and teteH >= LIM_H11) and (teteD <= LIM_D11 and teteD >= LIM_G11)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 11
            or ((teteH<= LIM_B12 and teteH >= LIM_H12) and (teteD <= LIM_D12 and teteD >= LIM_G12)) --la partie sup et droite de la tête du serpent sont commprises dans l'obstacle 12
        
        -- collision avec la queue
            or ((segG1 < teteG+5 and teteG+5 < segD1) and (segH1 < teteH+5 and  teteH+5< segB1)) --on regarde si la centre de la tete se situe au niveau du segment 1
            or ((segG2 < teteG+5 and teteG+5 < segD2) and (segH2 < teteH+5 and  teteH+5< segB2)) --on regarde si la centre de la tete se situe au niveau du segment 2
            or ((segG3 < teteG+5 and teteG+5 < segD3) and (segH3 < teteH+5 and  teteH+5< segB3)) --on regarde si la centre de la tete se situe au niveau du segment 3
            or ((segG4 < teteG+5 and teteG+5 < segD4) and (segH4 < teteH+5 and  teteH+5< segB4)) --on regarde si la centre de la tete se situe au niveau du segment 4
            or ((segG5 < teteG+5 and teteG+5 < segD5) and (segH5 < teteH+5 and  teteH+5< segB5)) --on regarde si la centre de la tete se situe au niveau du segment 5
            or ((segG6 < teteG+5 and teteG+5 < segD6) and (segH6 < teteH+5 and  teteH+5< segB6)) --on regarde si la centre de la tete se situe au niveau du segment 6
            or ((segG7 < teteG+5 and teteG+5 < segD7) and (segH7 < teteH+5 and  teteH+5< segB7)) --on regarde si la centre de la tete se situe au niveau du segment 7
            or ((segG8 < teteG+5 and teteG+5 < segD8) and (segH8 < teteH+5 and  teteH+5< segB8)) --on regarde si la centre de la tete se situe au niveau du segment 8
            or ((segG9 < teteG+5 and teteG+5 < segD9) and (segH9 < teteH+5 and  teteH+5< segB9)) --on regarde si la centre de la tete se situe au niveau du segment 9
            or ((segG10 < teteG+5 and teteG+5 < segD10) and (segH10 < teteH+5 and  teteH+5< segB10)) --on regarde si la centre de la tete se situe au niveau du segment 10 
            then lose_s <= '1';
            end if;
        end if;
    end process;
        
--=====================================================--
-- GESTION DE LA DUREE D'AFFICHAGE DE L'ECRAN DE PERTE --
--=====================================================--
    process(reset,clk25)
    begin
        if reset = '1' or lose_s = '0' then cpt_s <= 0;
        elsif rising_edge(clk25) then
            if cpt_s = 125000000 then cpt_s <= 0; --au bout de 5sec l'écran de perte disparait car lose_s passe à 0
            else cpt_s <= cpt_s + 1;
            end if;
        end if;    
    end process;      

--Mise à jour du compteur
    cpt <= cpt_s;
    
--Mise à jour du signal de perte  
    lose <= lose_s;
          
end Behavioral;
