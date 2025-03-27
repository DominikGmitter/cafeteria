DROP DATABASE IF EXISTS projekt;
CREATE DATABASE IF NOT EXISTS projekt;
USE projekt;

CREATE TABLE Menu
( 
  idM INT NOT NULL PRIMARY KEY auto_increment, 
  nazov	VARCHAR(255) NOT NULL,
  cena	decimal(10,2) NOT NULL 
  check (cena > 0),
  dostupnost bool not null
);

CREATE TABLE Objednavka 
( 
  idO INT NOT NULL PRIMARY KEY auto_increment, 
  zakaznik_id INT NOT NULL,
  menu_id INT NOT NULL,
  jedalen_id int not null,
  den_obj DATE not null,
  pocet INT(5) not null
);

CREATE TABLE Zakaznik
( 
idZ INT NOT NULL PRIMARY KEY auto_increment,
meno varchar(20) NOT NULL,
priezvisko varchar(20) NOT NULL,
kategoria_stravnika varchar(45) NOT NULL,
skolsky_email varchar(45) 
);

CREATE TABLE Jedalen
( 
  idJ INT NOT NULL PRIMARY KEY auto_increment, 
  ulica Varchar(45) not null,
  cislo int not null,
  obec varchar(45) not null
);

INSERT Menu VALUES	('1','Pol.brokolicová s liatym cestom 330ml, Kur.na bylinkách 83g, Ryža/hranolky 110g/70g, Šalát mix 130g, Nápoj voda so sirupom 0,2l','6.23',true);
INSERT Menu VALUES	('2','Pol.brokolicová s liatym cestom 330ml , Brav.rezeň v jogurtovej marináde 140g , Zemiaková kaša 320g , Šalát mix 130g, Nápoj voda so sirupom 0,2','6.23',true);
INSERT Menu VALUES	('3','Pol.rassolnik 330ml, Minútka z kuracieho mäsa 83g , Zemiakové hranolky 150g, Čaj so sirupom 0,2l, Donuts 1ks(56g)','6.23',true);
INSERT Menu VALUES	('4','Pol.hrachová Minestra 330ml , Kur.po znojemsky 83g , Dusená zelenina anglicka** 200g , Šalát mix 130g, Čaj s citrónom 0,2l','6.23',false);
INSERT Menu VALUES	('5','Pol.hrachová Minestra 330ml , Vyprážaný syr 110g, Zemiakové hranolky 150g, Omáčka tatárska 30g , Čaj s citrónom 0,2l','6.23',true);


Insert objednavka values ('1','3','4','1','2024-11-10','2');
Insert objednavka values ('2','2','2','3','2222-02-02','2');
Insert objednavka values ('3','5','1','2','2024-11-8','1');
Insert objednavka values ('4','4','5','2','2024-11-10','1');
Insert objednavka values ('5','1','3','3','2024-10-24','5');


Insert Zakaznik values('1','Dominik', 'Gmitter','student','dominik.gmitter@student.upjs.sk');
Insert Zakaznik values('2','Meno1', 'Priezvisko1','student','meno1.priezvisko1@student.upjs.sk');
Insert Zakaznik values('3','Meno2', 'Priezvisko2','student','meno2.priezvisko2@student.upjs.sk');
Insert Zakaznik values('4','Meno3', 'Priezvisko3','zamestnanec','meno3.priezvisko3@upjs.sk');
Insert Zakaznik values('5','Meno4', 'Priezvisko4','zamestnanec','meno4.priezvisko4@upjs.sk');


INSERT Jedalen values ('1','Medicka','4','Košice');
INSERT Jedalen values ('2','Jesenna','5','Košice');
INSERT Jedalen values ('3','Popradska','66','Košice');
INSERT Jedalen values ('4','Moyzesova','9','Košice');


SELECT * FROM menu;
SELECT * FROM objednavka;
SELECT * FROM zakaznik;
SELECT * FROM jedalen;

create view Tohtoročné_objednávky as
select * from objednavka
where den_obj between '2024-09-01' and '2025-06-30' and pocet < '2'
order by den_obj asc;
select zakaznik_id, den_obj, pocet from Tohtoročné_objednávky;
#1 vsetky objednavky v tomto skolskom roku a pocet objednanych menu je menej ako 2

create view priem_pocet_obj as 
select 
    ulica as 'Miesto jedalne',
    round(avg(pocet), 1) as 'Priemerny pocet objednavok z danej jedalne'
from objednavka O
inner join jedalen J on J.idJ = O.jedalen_id
group by ulica
order by ulica desc;
#2 zobrazi miesto jedalne a avg pocet obj z danej jedalne a zoradi od najviac obj
select * from priem_pocet_obj;

create view dlhy_select as
select 
	idO as 'ID objednavky',
    concat(meno,' ', priezvisko) as 'Meno a Priezvisko zakaznika',
    pocet as 'Počet objednaných menu',
    sum(cena * pocet) as 'Minutý kredit'
from objednavka O
inner join menu M on M.idM = O.menu_id
inner join zakaznik Z on Z.idZ = O.zakaznik_id
where dostupnost = 1
group by idO
having sum(cena * pocet)> 6.23
order by sum(cena * pocet) desc ; 
#3 zobrazte meno a priezvisko ludi , ktori si uz kedysi objednali jedlo, bolo dostupne a minuli viac ako 6.23€
select * from dlhy_select;