Create database Gestion_Paiement;

Create Table Diplome(
	id_diplome int not null auto_increment primary key,
	nom varchar(100) not null unique
	)engine="Innodb";

Create Table Grade(
	id_grade int(4) auto_increment primary key,
	nom varchar(100) not null unique
	)engine="Innodb";

/*Etat-0: si la valeur est 0 alors ça veut dire que l'etat est 'Expiré'
Etat-1: si la valeur est 1 alors ça veut dire que l'etat est 'Non_expiré' et par defaut la 
						valeur est '1'
*/
Create Table Diplo_Grade(
	id_diplo_grade int not null auto_increment primary key,
	etat enum('0','1') default '1',
	date date not null,
	id_diplome int(4) NOT NULL,	
	id_grade int(4)NOT NULL, 
        FOREIGN KEY(id_grade) REFERENCES Grade(id_grade),
	FOREIGN KEY(id_diplome) REFERENCES Diplome(id_diplome)
	)engine="Innodb";


Create Table Salaire_de_base(
	id_SB int not null auto_increment primary key,
	Somme int(100) not null,
	date_db date not null,
	/*Comme la date fin n'est pas connue au debut,on ne va pas mettre l'indication 'not null'*/
	date_fin date,
	id_diplo_grade int(4) not null,
	 FOREIGN KEY(id_diplo_grade) REFERENCES Diplo_Grade(id_diplo_grade)
	)engine="Innodb";

Create Table Type_Cotisation(
	id_type_cot int  auto_increment primary key,
	nom varchar(100) not null unique
	)engine="Innodb";

Create Table Cotisation(
	id_cotisation int not null auto_increment primary key,
	pourcent_SB int(100) not null,
	id_SB int(4) NOT NULL,	
	id_type_cot int(4) not null,
 	FOREIGN KEY(id_SB) REFERENCES Salaire_de_base(id_SB),
      FOREIGN KEY(id_type_cot) REFERENCES Type_Cotisation(id_type_cot)
	)engine="Innodb";

alter table Cotisation add constraint unicite_cotisation unique(id_SB,id_type_cot);
Create Table Employe(
	id_employe int not null auto_increment primary key,
	nom varchar(100) not null,
	prenom varchar(100) not null
	)engine="Innodb";

Create Table SB_Empl(
	id_SB_empl int not null auto_increment primary key,
	date_db date not null,
	date_fin date,
	id_SB int(4) NOT NULL,
	 FOREIGN KEY(id_SB) REFERENCES Salaire_de_base(id_SB),
	id_employe int(4) NOT null,
        FOREIGN KEY(id_employe) REFERENCES Employe(id_employe)
	)engine="Innodb";

Create Table Fonction(
	id_fonction int not null auto_increment primary key,
	nom varchar(100) not null unique
	)engine="Innodb";

Create Table Emplo_Fonc(
	id_emplo_fonc int not null auto_increment primary key,
	date date not null,
	etat enum('0','1') default '1',
	id_employe int(4) NOT NULL,
	 FOREIGN KEY(id_employe) REFERENCES Employe(id_employe),
	id_fonction int(4) not null,
	 FOREIGN KEY(id_fonction) REFERENCES Fonction(id_fonction)
	)engine="Innodb";

alter table Emplo_Fonc add constraint unicite_Emplo_Fonc unique(id_employe,id_fonction,date);

Create Table Indemnite(
	id_indemnite int not null auto_increment primary key,
	nom varchar(100) not null unique
	)engine="Innodb";

Create Table Fonc_Indem(
	id_Fonc_Indem int not null auto_increment primary key,
	date date not null,
	Somme int not null,
	etat enum('0','1') default '1',
	id_indemnite int(4)NOT NULL,
	 FOREIGN KEY(id_indemnite) REFERENCES Indemnite(id_indemnite),
	id_fonction int(4) NOT NULL,
        FOREIGN KEY(id_fonction) REFERENCES Fonction(id_fonction)
	)engine="Innodb";

alter table Fonc_Indem add constraint unicite_Fonc_Indem unique(id_indemnite,id_fonction,date);



Create Table Paiement(
	id_Paiement int(11) auto_increment primary key,
	date date not null,
	Salairenet int(11) not null,
	Salairebrut int(11) not null,
	mois int(2) not null,
	annee int(4) not null,
	Somme_cotisation int(11) not null,
	id_SB_empl int(5) not null,
	 FOREIGN KEY(id_SB_empl) REFERENCES SB_Empl(id_SB_empl)
	)engine="Innodb";

Create Table Detail_paiement(
	id_detail_paiement int not null auto_increment primary key,
	id_SB int(5) not null,
	id_Paiement int(11) NOT NULL,
	FOREIGN KEY(id_SB) REFERENCES Salaire_de_base(id_SB), /*Somme,diplome,date_db,date_fin*/
	id_emplo_fonc int(5) not null,
	FOREIGN KEY(id_emplo_fonc) REFERENCES Emplo_Fonc(id_emplo_fonc)
	)engine="Innodb";
alter table Detail_paiement add column 
id_Paiement int(11) NOT NULL;
alter table Detail_paiement add constraint dep_fk 
FOREIGN KEY(id_Paiement) REFERENCES 
paiement(id_Paiement);
	
Create Table Detail_paiement_Idem_Coti(
	id_detail_paiement_Idem int not null auto_increment primary key,
	id_Fonc_Indem int(6),
	FOREIGN KEY(id_Fonc_Indem) REFERENCES Fonc_Indem(id_Fonc_Indem),
	id_cotisation int(6),
	FOREIGN KEY(id_cotisation) REFERENCES Cotisation(id_cotisation),
	id_detail_paiement int not null, 
	FOREIGN KEY(id_detail_paiement) REFERENCES Detail_paiement(id_detail_paiement)
)Engine="Innodb";




-------Insertion dans la table employé--------


 insert into employe (nom,prenom) values ("kusimwa","King Etienne"),
("Hakizimana","Tony Carlin"),
("Dushime","Hamza"),("Iteka","Deborah");



-------Insertion dans la table fonction--------


insert into fonction (nom) values ("PDG"),("DG"),("Secretaire");


-------Insertion dans la table grade--------

insert into grade (nom) values ("D1"),("D2"),("D3"),("K7"),("A10");

-------Insertion dans la table indemnite--------

insert into indemnite (nom) values ("impot"),
("Mutuelle"),("deplacement"),("frais_de_location");

-------Insertion dans la table diplome--------

insert into diplome (nom) values ("A2"),("D7"),("Bac"),("Msc"),("Dr"),("Phd");

insert into diplo_grade(date,id_diplome,id_grade) values(now(),3,4),(now(),1,5),(now(),4,3);


insert into salaire_de_base(Somme,date_db,id_diplo_grade) values(200000,now(),1),
(100000,now(),2),(350000,now(),3);



insert into sb_empl(date_db,id_SB,id_employe) values (now(),1,2),(now(),2,3),
(now(),3,4);

insert into fonc_indem(date,somme,id_indemnite,id_fonction) values(now(),450000,2,1),(now(),470000,3,1),(now(),30000,1,3);
insert into emplo_fonc(date,id_employe,id_fonction) values (now(),2,2);


create trigger insertion_DetailPaiement after insert on Paiement
for each row
begin
    DECLARE empsbID,emploFoncID INT DEFAULT -1;
    DECLARE empID,paiementID,sbID,detail_paiementID,cotisationID INT DEFAULT -1;
    DECLARE done INT DEFAULT 0;  	
    DECLARE detail_cotisation CURSOR FOR SELECT id_cotisation FROM cotisation where id_SB in (SELECT id_SB from sb_empl  where id_SB_empl=NEW.id_SB_empl);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    SELECT id_employe,id_SB INTO empID,sbID from sb_empl  where id_SB_empl=NEW.id_SB_empl;
    select id_emplo_fonc into emploFoncID from emplo_fonc where id_employe=empID and etat='1';
    insert into detail_paiement(id_SB,id_emplo_fonc,id_Paiement) values(sbID,emploFoncID,NEW.id_Paiement);

    select id_detail_paiement INTO detail_paiementID from detail_paiement where id_SB=sbID and id_emplo_fonc=emploFoncID order by id_detail_paiement desc limit 1; 

    OPEN detail_cotisation;

    cotisation_loop: LOOP
     FETCH detail_cotisation INTO cotisationID;
     IF done THEN
      LEAVE cotisation_loop;
   END IF;
   IF cotisationID > 0 THEN
  	 INSERT INTO detail_paiement_idem_coti(id_cotisation,id_detail_paiement) values(cotisationID,detail_paiementID);
    END IF;
    Set cotisationID=-1 ;	
END LOOP;
  
CLOSE detail_cotisation;
	
    	
END


---------------------------------------conge payé----------------------------------

Create Table Conge_paye(
	id_cong_paye int not null auto_increment primary key,
	date_db date not null,
	date_fin date not null,
	id_emplo_fonc (4) not null,	
	id_diplo_grade int(4)NOT NULL, 
        FOREIGN KEY(id_diplo_grade) REFERENCES Diplo_grade(id_diplo_grade),
	FOREIGN KEY(id_emplo_fonc) REFERENCES Emplo_Fonc(id_emplo_fonc)
	)engine="Innodb";



---------------------------------------conge non payé----------------------------------------------------------------------------------------------

