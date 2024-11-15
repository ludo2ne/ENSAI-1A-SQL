INSERT INTO dvd.adherent VALUES
    (5, 'Duchemin', 'Pierre',      '12 Route de Brest 35000 Rennes'),
    (6, 'Martin',   'Jean',        '11 rue du technopole 29200 Brest'),
    (1, 'Dupont',   'Marie',       '4 rue de Saint-Malo 35000 Rennes'),
    (2, 'Duchemin', 'Anne',        '10 route de Vannes 29000 Quimper'),
    (3, 'Duchemin', 'Dominique',   '3 Cours des 50 otages 44000 Nantes'),
    (4, 'Simon',    'Pierre-Yves', '7 rue de la gare 35170 Bruz'),
    (7, 'Duchemin', 'Anne',        '13 place Adolphe Cherioux 75000 Paris');


INSERT INTO dvd.film VALUES
    (10, 'La guerre des etoiles',                'science-fiction',    TO_DATE('1977', 'YYYY')),
    (11, 'Nikita',                               'policier',           TO_DATE('1989', 'YYYY')),
    (12, 'L''empire contre-attaque',             'science-fiction',    TO_DATE('1980', 'YYYY')),
    (13, 'La cage aux folles',                   'comédie',            TO_DATE('1978', 'YYYY')),
    (14, 'Witness',                              'policier',           TO_DATE('1984', 'YYYY')),
    (15, 'Le cercle des poetes disparus',        'drame',              TO_DATE('1989', 'YYYY')),
    (17, 'Les choristes',                        'comédie',            TO_DATE('2004', 'YYYY')),
    (18, 'Trois couleurs : Bleu',                'drame',              TO_DATE('1993', 'YYYY')),
    (19, 'Trois couleurs : Blanc',               'drame',              TO_DATE('1994', 'YYYY')),
    (20, 'Trois couleurs : Rouge',               'drame',              TO_DATE('1994', 'YYYY')),
    (21, 'Trois hommes à abattre',               'policier',           TO_DATE('1980', 'YYYY')),
    (22, 'Intouchables',                         'comédie dramatique', TO_DATE('2011', 'YYYY')),
    (23, 'Qu''est-ce qu''on a fait au Bon Dieu', 'comédie dramatique', TO_DATE('2014', 'YYYY'));


INSERT INTO dvd.realisateur VALUES
    (50, 'Besson',       'Luc'),
    (51, 'Lucas',        'Georges'),
    (52, 'Kershner',     'Irvin'),
    (53, 'Molinaro',     'Edouard'),
    (54, 'Weir',         'Peter'),
    (55, 'Kieslowski',   'Krzysztof'),
    (56, 'Barratier',    'Christophe'),
    (57, 'Deray',        'Jacques'),
    (58, 'Toledano',     'Éric'),
    (59, 'Nakache',      'Olivier'),
    (60, 'de Chauveron', 'Philippe');

INSERT INTO dvd.a_realise VALUES
    (11, 50),
    (10, 51),
    (12, 52),
    (13, 53),
    (14, 54),
    (15, 54),
    (17, 56),
    (18, 55),
    (19, 55),
    (20, 55),
    (21, 57),
    (22, 58),
    (22, 59),
    (23, 60);

INSERT INTO dvd.dvd VALUES
    (100, TO_DATE('12-02-1990', 'DD-MM-YYYY'), 2,   10),
    (110, TO_DATE('04-05-1989', 'DD-MM-YYYY'), 2.5, 13),
    (120, TO_DATE('15-08-1992', 'DD-MM-YYYY'), 2,   10),
    (130, TO_DATE('14-03-1995', 'DD-MM-YYYY'), 2,   10),
    (140, TO_DATE('12-02-1990', 'DD-MM-YYYY'), 2.1, 11),
    (150, TO_DATE('12-02-1990', 'DD-MM-YYYY'), 2.5, 14),
    (160, TO_DATE('12-02-1990', 'DD-MM-YYYY'), 2.6, 15),
    (170, TO_DATE('12-02-1992', 'DD-MM-YYYY'), 2,   14),
    (180, TO_DATE('12-02-2005', 'DD-MM-YYYY'), 2,   17),
    (190, TO_DATE('14-04-2005', 'DD-MM-YYYY'), 2,   17),
    (200, TO_DATE('14-04-2000', 'DD-MM-YYYY'), 2,   21),
    (210, TO_DATE('01-07-2012', 'DD-MM-YYYY'), 2.8, 22),
    (220, TO_DATE('15-10-2014', 'DD-MM-YYYY'), 3,   23);

INSERT INTO dvd.emprunte (num_emprunt, num_adherent, num_dvd, date_debut) VALUES
    (3, 5, 100, TO_DATE('04-04-2005', 'DD-MM-YYYY')),
    (4, 5, 110, TO_DATE('04-04-2005', 'DD-MM-YYYY')),
    (5, 1, 130, TO_DATE('10-04-2005', 'DD-MM-YYYY')),
    (6, 3, 180, TO_DATE('15-04-2005', 'DD-MM-YYYY'));

INSERT INTO dvd.emprunte VALUES
    (1,  3, 100, TO_DATE('19-10-2004', 'DD-MM-YYYY'), TO_DATE('25-10-2004', 'DD-MM-YYYY')),
    (2,  3, 150, TO_DATE('19-10-2004', 'DD-MM-YYYY'), TO_DATE('25-10-2004', 'DD-MM-YYYY')),
    (7,  3, 190, TO_DATE('02-03-2004', 'DD-MM-YYYY'), TO_DATE('05-03-2005', 'DD-MM-YYYY')),
    (8,  2, 140, TO_DATE('02-08-2010', 'DD-MM-YYYY'), TO_DATE('05-09-2010', 'DD-MM-YYYY')),
    (9,  7, 130, TO_DATE('02-07-2010', 'DD-MM-YYYY'), TO_DATE('23-07-2010', 'DD-MM-YYYY')),
    (10, 6, 160, TO_DATE('02-07-2008', 'DD-MM-YYYY'), TO_DATE('23-07-2008', 'DD-MM-YYYY')),
    (11, 6, 130, TO_DATE('20-07-2009', 'DD-MM-YYYY'), TO_DATE('23-07-2009', 'DD-MM-YYYY')),
    (12, 6, 190, TO_DATE('15-07-2009', 'DD-MM-YYYY'), TO_DATE('23-07-2009', 'DD-MM-YYYY')),
    (13, 6, 180, TO_DATE('16-07-2010', 'DD-MM-YYYY'), TO_DATE('27-07-2010', 'DD-MM-YYYY')),
    (14, 7, 160, TO_DATE('02-07-2008', 'DD-MM-YYYY'), TO_DATE('23-07-2008', 'DD-MM-YYYY')),
    (15, 2, 130, TO_DATE('20-07-2009', 'DD-MM-YYYY'), TO_DATE('23-07-2009', 'DD-MM-YYYY')),
    (16, 7, 190, TO_DATE('15-07-2009', 'DD-MM-YYYY'), TO_DATE('23-07-2009', 'DD-MM-YYYY')),
    (17, 2, 180, TO_DATE('16-07-2010', 'DD-MM-YYYY'), TO_DATE('27-07-2010', 'DD-MM-YYYY')),
    (18, 2, 190, TO_DATE('13-08-2010', 'DD-MM-YYYY'), TO_DATE('25-08-2010', 'DD-MM-YYYY')),
    (19, 1, 140, TO_DATE('02-08-2007', 'DD-MM-YYYY'), TO_DATE('05-09-2007', 'DD-MM-YYYY')),
    (20, 1, 150, TO_DATE('02-08-2010', 'DD-MM-YYYY'), TO_DATE('05-09-2010', 'DD-MM-YYYY')),
    (21, 1, 200, TO_DATE('02-08-2010', 'DD-MM-YYYY'), TO_DATE('05-09-2010', 'DD-MM-YYYY')),
    (22, 7, 210, TO_DATE('04-08-2012', 'DD-MM-YYYY'), TO_DATE('16-08-2012', 'DD-MM-YYYY')),
    (23, 4, 220, TO_DATE('03-11-2014', 'DD-MM-YYYY'), NULL);



