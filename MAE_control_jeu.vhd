----------------------------------------------------------------------------------
-- Company: 
-- Engineer: FREDERIC Pierre-Marie
-- 
-- Create Date: 15.07.2021 09:34:48
-- Design Name: 
-- Module Name: MAE_control_jeu - Behavioral
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

entity MAE_control_jeu is
Port (
    clk,reset : in std_logic;
    start : in  std_logic;
    droite, gauche, haut, bas:    in std_logic;
    
    teteH: out integer range 0 to 479;
    teteB: out integer range 0 to 479;
    teteG: out integer range 0 to 639;
    teteD: out integer range 0 to 639;
    
    pomH: in integer range 0 to 479;
    pomB: in integer range 0 to 479;
    pomG: in integer range 0 to 639;
    pomD: in integer range 0 to 479;
    
    nb_seg: out integer range 0 to 10;
    
    segB1: out integer range 0 to 479;
    segB2: out integer range 0 to 479;
    segB3: out integer range 0 to 479;
    segB4: out integer range 0 to 479;
    segB5: out integer range 0 to 479;
    segB6: out integer range 0 to 479;
    segB7: out integer range 0 to 479;
    segB8: out integer range 0 to 479;
    segB9: out integer range 0 to 479;
    segB10: out integer range 0 to 479;
    
    segG1: out integer range 0 to 639;
    segG2: out integer range 0 to 639;
    segG3: out integer range 0 to 639;
    segG4: out integer range 0 to 639;
    segG5: out integer range 0 to 639;
    segG6: out integer range 0 to 639;
    segG7: out integer range 0 to 639;
    segG8: out integer range 0 to 639;
    segG9: out integer range 0 to 639;
    segG10: out integer range 0 to 639;
    
    segH1: out integer range 0 to 469;
    segH2: out integer range 0 to 469;
    segH3: out integer range 0 to 469;
    segH4: out integer range 0 to 469;
    segH5: out integer range 0 to 469;
    segH6: out integer range 0 to 469;
    segH7: out integer range 0 to 469;
    segH8: out integer range 0 to 469;
    segH9: out integer range 0 to 469;
    segH10: out integer range 0 to 469;
    
    segD1: out integer range 0 to 639;
    segD2: out integer range 0 to 639;
    segD3: out integer range 0 to 639;
    segD4: out integer range 0 to 639;
    segD5: out integer range 0 to 639;
    segD6: out integer range 0 to 639;
    segD7: out integer range 0 to 639;
    segD8: out integer range 0 to 639;
    segD9: out integer range 0 to 639;
    segD10: out integer range 0 to 639;
    
    chrono, cptLose: in integer range 0 to 125000000;
    
    clkVit: out  std_logic;
    
    pause: in   std_logic
 );
end MAE_control_jeu;

architecture Behavioral of MAE_control_jeu is

-- Constantes serpent (coordonnées initiales)
    constant POSI_G: integer := 314;
    constant POSI_D: integer := POSI_G+10;
    constant POSI_H: integer := 234;
    constant POSI_B: integer := POSI_H+10;
    
-- appui touche directionnelle: signaux qui passent et restent à 1 quand on appui sur gauche, droite, haut ou bas jusqu'au prochain changement de direction
    signal appuiG : std_logic := '0';
    signal appuiD : std_logic := '0';
    signal appuiH : std_logic := '0';
    signal appuiB : std_logic := '0';
    
-- coordonnées de la tête du serpent
    signal teteH_s: integer range 0 to 479:= POSI_H;
    signal teteB_s: integer range 0 to 479:= POSI_B;
    signal teteG_s: integer range 0 to 639:= POSI_G;
    signal teteD_s: integer range 0 to 639:= POSI_D;
    
-- compteur pour l'horloge commandant la vitesse
    signal cpt:   integer range 0 to 2500000:=0;
    --signal cpt:   integer range 0 to 1:=0;--pour simulation
    
-- horloge qui gère la vitesse du serpent
    signal clkVit_s : std_logic := '0';
    
-- nb de segment du serpent
    signal nb_seg_s: integer range 0 to 10 := 0;
    
-- signal signalant un changement de direction du serpent
    signal chgmt: std_logic;        

-- coordonnées des différents segment du serpent
-- Segment 1
    signal segH1_s: integer range 0 to 479;
    signal segB1_s: integer range 0 to 479;
    signal segG1_s: integer range 0 to 639;
    signal segD1_s: integer range 0 to 639;
-- Segment 2
    signal segH2_s: integer range 0 to 479;
    signal segB2_s: integer range 0 to 479;
    signal segG2_s: integer range 0 to 639;
    signal segD2_s: integer range 0 to 639;
-- Segment 3
    signal segH3_s: integer range 0 to 479;
    signal segB3_s: integer range 0 to 479;
    signal segG3_s: integer range 0 to 639;
    signal segD3_s: integer range 0 to 639;
-- Segment 4
    signal segH4_s: integer range 0 to 479;
    signal segB4_s: integer range 0 to 479;
    signal segG4_s: integer range 0 to 639;
    signal segD4_s: integer range 0 to 639;
-- Segment 5
    signal segH5_s: integer range 0 to 479;
    signal segB5_s: integer range 0 to 479;
    signal segG5_s: integer range 0 to 639;
    signal segD5_s: integer range 0 to 639;
-- Segment 6
    signal segH6_s: integer range 0 to 479;
    signal segB6_s: integer range 0 to 479;
    signal segG6_s: integer range 0 to 639;
    signal segD6_s: integer range 0 to 639;
    -- Signal 7
    signal segH7_s: integer range 0 to 479;
    signal segB7_s: integer range 0 to 479;
    signal segG7_s: integer range 0 to 639;
    signal segD7_s: integer range 0 to 639;
-- Segment 8
    signal segH8_s: integer range 0 to 479;
    signal segB8_s: integer range 0 to 479;
    signal segG8_s: integer range 0 to 639;
    signal segD8_s: integer range 0 to 639;
-- Segment 9
    signal segH9_s: integer range 0 to 479;
    signal segB9_s: integer range 0 to 479;
    signal segG9_s: integer range 0 to 639;
    signal segD9_s: integer range 0 to 639;
-- Segment 10
    signal segH10_s: integer range 0 to 479;
    signal segB10_s: integer range 0 to 479;
    signal segG10_s: integer range 0 to 639;
    signal segD10_s: integer range 0 to 639;
    
begin
--======================================--
-- GESTION APPUI TOUCHE DIRECTIONNELLES --
--======================================--
    process(clk, reset, start, droite, gauche, haut, bas, appuiD, appuiG, appuiH, appuiB)
    begin
        if reset = '1'  or cptLose = 125000000 then appuiG <= '0';appuiD <= '0';appuiH <= '0';appuiB <= '0';
        elsif rising_edge(clk) then
            if start = '1' then
                if nb_seg_s = 10 then appuiG <= '0'; appuiD <= '0'; appuiH <= '0'; appuiB <= '0';
            --traitement des cas particuliers où l'ordre ne doit pas être exécuté
                elsif droite = '1' and appuiG = '1' then appuiG <= '1'; appuiD <= '0'; appuiH <= '0'; appuiB <= '0';
                elsif gauche = '1' and appuiD = '1' then appuiG <= '0'; appuiD <= '1'; appuiH <= '0'; appuiB <= '0';
                elsif haut = '1' and appuiB = '1' then appuiG <= '0'; appuiD <= '0'; appuiH <= '0'; appuiB <= '1';
                elsif bas = '1' and appuiH = '1' then appuiG <= '0'; appuiD <= '0'; appuiH <= '1'; appuiB <= '0';
            --on teste s'il y a appui sur une touche directionnelle et on exécute l'ordre donnée
                elsif droite = '1' then appuiG <= '0'; appuiD <= '1'; appuiH <= '0'; appuiB <= '0';
                elsif bas = '1' then appuiG <= '0'; appuiD <= '0'; appuiH <= '0'; appuiB <= '1';
                elsif gauche = '1' then appuiG <= '1'; appuiD <= '0'; appuiH <= '0'; appuiB <= '0';
                elsif haut = '1' then appuiG <= '0'; appuiD <= '0'; appuiH <= '1'; appuiB <= '0';
            --si aucune touche directionnelle n'a été enfoncé, on maintient l'ordre précédent
                elsif appuiD = '1' then appuiG <= '0'; appuiD <= '1'; appuiH <= '0'; appuiB <= '0';
                elsif appuiB = '1' then appuiG <= '0'; appuiD <= '0'; appuiH <= '0'; appuiB <= '1';
                elsif appuiG = '1' then appuiG <= '1'; appuiD <= '0'; appuiH <= '0'; appuiB <= '0';
                elsif appuiH = '1' then appuiG <= '0'; appuiD <= '0'; appuiH <= '1'; appuiB <= '0';
                end if;
            end if;
        end if;  
    end process;
    
--==================================--
-- GESTION DE LA VITESSE DU SERPENT --
--==================================--
    process(clk,reset)
    begin
        if reset='1' then cpt <= 0;
        elsif rising_edge(clk) then
            if cpt = 2500000 then cpt <= 0; clkVit_s <= '1';
            --if cpt = 1 then cpt <= 0; clkVit_s <= '1';--pour simulation
            else cpt <= cpt+1; clkVit_s <= '0'; end if;
        end if; 
    end process;
    
--========================--
-- DEPLACEMENT DU SERPENT --
--========================--
    process(clkVit_s,reset,appuiG,appuiD,appuiH,appuiB,chgmt)
    begin
        if reset = '1' or chrono = 125000000 or cptLose = 125000000 then 
        teteH_s <= POSI_H; teteB_s <= POSI_B; teteG_s <= POSI_G; teteD_s <= POSI_D;
        segH1_s <= 0; segB1_s <= 0; segG1_s <= 0; segD1_s <= 0;
        segH2_s <= 0; segB2_s <= 0; segG2_s <= 0; segD2_s <= 0;
        segH3_s <= 0; segB3_s <= 0; segG3_s <= 0; segD3_s <= 0;
        segH4_s <= 0; segB4_s <= 0; segG4_s <= 0; segD4_s <= 0;
        segH5_s <= 0; segB5_s <= 0; segG5_s <= 0; segD5_s <= 0;
        segH6_s <= 0; segB6_s <= 0; segG6_s <= 0; segD6_s <= 0;
        segH7_s <= 0; segB7_s <= 0; segG7_s <= 0; segD7_s <= 0;
        segH8_s <= 0; segB8_s <= 0; segG8_s <= 0; segD8_s <= 0;
        segH9_s <= 0; segB9_s <= 0; segG9_s <= 0; segD9_s <= 0;
        segH10_s <= 0; segB10_s <= 0; segG10_s <= 0; segD10_s <= 0;
        
        elsif rising_edge (clkVit_s) then
            --déplacement de la tête
            if pause = '1' then teteG_s <= teteG_s; teteD_s <= teteD_s; teteH_s <= teteH_s; teteB_s <= teteB_s;   
            elsif appuiG='1' then --vers la gauche
                --déplacement des segments
                segG1_s <= teteG_s; segD1_s <= teteD_s; segH1_s <= teteH_s; segB1_s <= teteB_s;
                segG2_s <= segG1_s; segD2_s <= segD1_s; segH2_s <= segH1_s; segB2_s <= segB1_s;
                segG3_s <= segG2_s; segD3_s <= segD2_s; segH3_s <= segH2_s; segB3_s <= segB2_s;
                segG4_s <= segG3_s; segD4_s <= segD3_s; segH4_s <= segH3_s; segB4_s <= segB3_s;
                segG5_s <= segG4_s; segD5_s <= segD4_s; segH5_s <= segH4_s; segB5_s <= segB4_s;
                segG6_s <= segG5_s; segD6_s <= segD5_s; segH6_s <= segH5_s; segB6_s <= segB5_s;
                segG7_s <= segG6_s; segD7_s <= segD6_s; segH7_s <= segH6_s; segB7_s <= segB6_s;
                segG8_s <= segG7_s; segD8_s <= segD7_s; segH8_s <= segH7_s; segB8_s <= segB7_s;
                segG9_s <= segG8_s; segD9_s <= segD8_s; segH9_s <= segH8_s; segB9_s <= segB8_s;
                segG10_s <= segG9_s; segD10_s <= segD9_s; segH10_s <= segH9_s; segB10_s <= segB9_s;
                if teteG_s - 10 < 0 then teteG_s <= 639 + teteG_s - 10; teteD_s <= teteG_s;
                else teteG_s <= teteG_s - 10; teteD_s <= teteG_s;
                end if;
            elsif appuiD = '1' then --vers la droite
                --déplacement des segments
                segG1_s <= teteG_s; segD1_s <= teteD_s; segH1_s <= teteH_s; segB1_s <= teteB_s;
                segG2_s <= segG1_s; segD2_s <= segD1_s; segH2_s <= segH1_s; segB2_s <= segB1_s;
                segG3_s <= segG2_s; segD3_s <= segD2_s; segH3_s <= segH2_s; segB3_s <= segB2_s;
                segG4_s <= segG3_s; segD4_s <= segD3_s; segH4_s <= segH3_s; segB4_s <= segB3_s;
                segG5_s <= segG4_s; segD5_s <= segD4_s; segH5_s <= segH4_s; segB5_s <= segB4_s;
                segG6_s <= segG5_s; segD6_s <= segD5_s; segH6_s <= segH5_s; segB6_s <= segB5_s;
                segG7_s <= segG6_s; segD7_s <= segD6_s; segH7_s <= segH6_s; segB7_s <= segB6_s;
                segG8_s <= segG7_s; segD8_s <= segD7_s; segH8_s <= segH7_s; segB8_s <= segB7_s;
                segG9_s <= segG8_s; segD9_s <= segD8_s; segH9_s <= segH8_s; segB9_s <= segB8_s;
                segG10_s <= segG9_s; segD10_s <= segD9_s; segH10_s <= segH9_s; segB10_s <= segB9_s;
                if teteD_s+10 > 639 then teteD_s <= teteD_s+10-639; teteG_s <= teteD_s;
                else teteD_s <= teteD_s + 10; teteG_s <= teteD_s;
                end if;
            elsif appuiH = '1' then --vers le haut
                --déplacement des segments
                segG1_s <= teteG_s; segD1_s <= teteD_s; segH1_s <= teteH_s; segB1_s <= teteB_s;
                segG2_s <= segG1_s; segD2_s <= segD1_s; segH2_s <= segH1_s; segB2_s <= segB1_s;
                segG3_s <= segG2_s; segD3_s <= segD2_s; segH3_s <= segH2_s; segB3_s <= segB2_s;
                segG4_s <= segG3_s; segD4_s <= segD3_s; segH4_s <= segH3_s; segB4_s <= segB3_s;
                segG5_s <= segG4_s; segD5_s <= segD4_s; segH5_s <= segH4_s; segB5_s <= segB4_s;
                segG6_s <= segG5_s; segD6_s <= segD5_s; segH6_s <= segH5_s; segB6_s <= segB5_s;
                segG7_s <= segG6_s; segD7_s <= segD6_s; segH7_s <= segH6_s; segB7_s <= segB6_s;
                segG8_s <= segG7_s; segD8_s <= segD7_s; segH8_s <= segH7_s; segB8_s <= segB7_s;
                segG9_s <= segG8_s; segD9_s <= segD8_s; segH9_s <= segH8_s; segB9_s <= segB8_s;
                segG10_s <= segG9_s; segD10_s <= segD9_s; segH10_s <= segH9_s; segB10_s <= segB9_s;
                if teteH_s - 10 < 0 then teteH_s <= 479 + teteH_s - 10; teteB_s <= teteH_s;
                else teteH_s <= teteH_s - 10; teteB_s <= teteH_s;
                end if;
            elsif appuiB = '1' then --vers le bas
                --déplacement des segments
                segG1_s <= teteG_s; segD1_s <= teteD_s; segH1_s <= teteH_s; segB1_s <= teteB_s;
                segG2_s <= segG1_s; segD2_s <= segD1_s; segH2_s <= segH1_s; segB2_s <= segB1_s;
                segG3_s <= segG2_s; segD3_s <= segD2_s; segH3_s <= segH2_s; segB3_s <= segB2_s;
                segG4_s <= segG3_s; segD4_s <= segD3_s; segH4_s <= segH3_s; segB4_s <= segB3_s;
                segG5_s <= segG4_s; segD5_s <= segD4_s; segH5_s <= segH4_s; segB5_s <= segB4_s;
                segG6_s <= segG5_s; segD6_s <= segD5_s; segH6_s <= segH5_s; segB6_s <= segB5_s;
                segG7_s <= segG6_s; segD7_s <= segD6_s; segH7_s <= segH6_s; segB7_s <= segB6_s;
                segG8_s <= segG7_s; segD8_s <= segD7_s; segH8_s <= segH7_s; segB8_s <= segB7_s;
                segG9_s <= segG8_s; segD9_s <= segD8_s; segH9_s <= segH8_s; segB9_s <= segB8_s;
                segG10_s <= segG9_s; segD10_s <= segD9_s; segH10_s <= segH9_s; segB10_s <= segB9_s;
                if teteB_s + 10 > 479 then teteB_s <= teteB_s + 10 - 479; teteH_s <= teteB_s;
                else teteB_s <= teteB_s + 10; teteH_s <= teteB_s; 
                end if; 
            end if;
        end if;
    end process;

-- on verifie si la tête du serpent est sur la pomme
    process(reset,clkVit_s,nb_seg_s)
    begin
        if reset = '1' or cptLose = 125000000 then nb_seg_s <= 0;
        elsif rising_edge(clkVit_s) then --attention à bien utilisé la même horloge que celle utilisée pour le déplacement du serpent car si on utilise une horloge plus rapide elle peut compter plusieurs fois que le serpent a mangé la pomme
            if nb_seg_s+1 < 11 then
            --version précise
                --if(appuiG = '1' and (teteG_s = pomD and teteH_s = pomH))
                --or (appuiD = '1' and (teteD_s = pomG and teteH_s = pomH))
                --or (appuiH = '1' and (teteH_s = pomB and teteG_s = pomG))
                --or (appuiB = '1' and (teteB_s = pomH and teteG_s = pomG))
                --then nb_seg_s <= nb_seg_s+1; end if;
            --version considérant la pomme mangée dès lors qu'un pixel de la tete du serpent la touche 
                if ((pomG <= teteD_s and pomG >= teteG_s) and (pomB <= teteB_s and pomB >= teteH_s))--le coin gauche inf de la pomme est incluse dans le serpent
                or ((pomG <= teteD_s and pomG >= teteG_s) and (pomH <= teteB_s and pomH >= teteH_s))--le coin gauche sup de la pomme est incluse dans le serpent
                or ((pomD <= teteD_s and pomD >= teteG_s) and (pomB <= teteB_s and pomB >= teteH_s))--le coin droit inf de la pomme est incluse dans le serpent
                or ((pomD <= teteD_s and pomD >= teteG_s) and (pomH <= teteB_s and pomH >= teteH_s))--le coin droit sup de la pomme est incluse dans le serpent
                then nb_seg_s <= nb_seg_s+1;
                end if;
            else nb_seg_s <= 0;
            end if;
        end if;
    end process;

-- Mise à jour des coordonnées du serpent
    teteG <= teteG_s;
    teteD <= teteD_s;
    teteH <= teteH_s;
    teteB <= teteB_s;
    
    segB1 <= segB1_s;
    segB2 <= segB2_s;
    segB3 <= segB3_s;
    segB4 <= segB4_s;
    segB5 <= segB5_s;
    segB6 <= segB6_s;
    segB7 <= segB7_s;
    segB8 <= segB8_s;
    segB9 <= segB9_s;
    segB10 <= segB10_s;
    
    segG1 <= segG1_s;
    segG2 <= segG2_s;
    segG3 <= segG3_s;
    segG4 <= segG4_s;
    segG5 <= segG5_s;
    segG6 <= segG6_s;
    segG7 <= segG7_s;
    segG8 <= segG8_s;
    segG9 <= segG9_s;
    segG10 <= segG10_s;
    
    segH1 <= segH1_s;
    segH2 <= segH2_s;
    segH3 <= segH3_s;
    segH4 <= segH4_s;
    segH5 <= segH5_s;
    segH6 <= segH6_s;
    segH7 <= segH7_s;
    segH8 <= segH8_s;
    segH9 <= segH9_s;
    segH10 <= segH10_s;
    
    segD1 <= segD1_s;
    segD2 <= segD2_s;
    segD3 <= segD3_s;
    segD4 <= segD4_s;
    segD5 <= segD5_s;
    segD6 <= segD6_s;
    segD7 <= segD7_s;
    segD8 <= segD8_s;
    segD9 <= segD9_s;
    segD10 <= segD10_s;
    
--Mise à jour du nombre de segment du serpent
    nb_seg <= nb_seg_s;  

--Mise à jour de l'horloge pour la vitesse du serpent
    clkVit <= clkVit_s;
      
end Behavioral;
