enum SchoolTrack { maternelle, primaire, college, lycee, superieur, concours }

class SchoolLevel {
  const SchoolLevel({required this.id, required this.label, required this.track, required this.description});
  final String id;
  final String label;
  final SchoolTrack track;
  final String description;
}

const schoolLevels = <SchoolLevel>[
  SchoolLevel(id: 'sil', label: 'SIL', track: SchoolTrack.maternelle, description: 'Maternelle'),
  SchoolLevel(id: 'cp', label: 'CP', track: SchoolTrack.primaire, description: 'Cours préparatoire'),
  SchoolLevel(id: 'ce1', label: 'CE1', track: SchoolTrack.primaire, description: 'Cours élémentaire 1'),
  SchoolLevel(id: 'ce2', label: 'CE2', track: SchoolTrack.primaire, description: 'Cours élémentaire 2'),
  SchoolLevel(id: 'cm1', label: 'CM1', track: SchoolTrack.primaire, description: 'Cours moyen 1'),
  SchoolLevel(id: 'cm2', label: 'CM2', track: SchoolTrack.primaire, description: 'Cours moyen 2'),
  SchoolLevel(id: '6eme', label: '6ème', track: SchoolTrack.college, description: 'Collège'),
  SchoolLevel(id: '5eme', label: '5ème', track: SchoolTrack.college, description: 'Collège'),
  SchoolLevel(id: '4eme', label: '4ème', track: SchoolTrack.college, description: 'Collège'),
  SchoolLevel(id: '3eme', label: '3ème', track: SchoolTrack.college, description: 'Préparation BEPC'),
  SchoolLevel(id: '2nde', label: '2nde', track: SchoolTrack.lycee, description: 'Lycée'),
  SchoolLevel(id: '1ere', label: '1ère', track: SchoolTrack.lycee, description: 'Lycée'),
  SchoolLevel(id: 'tle-c', label: 'Terminale C', track: SchoolTrack.lycee, description: 'Préparation BAC scientifique'),
  SchoolLevel(id: 'tle-a', label: 'Terminale A', track: SchoolTrack.lycee, description: 'Préparation BAC littéraire'),
  SchoolLevel(id: 'licence', label: 'Licence', track: SchoolTrack.superieur, description: 'Université'),
  SchoolLevel(id: 'master', label: 'Master', track: SchoolTrack.superieur, description: 'Université'),
  SchoolLevel(id: 'bts', label: 'BTS / DUT', track: SchoolTrack.superieur, description: 'Formation professionnelle'),
  SchoolLevel(id: 'concours', label: 'Concours', track: SchoolTrack.concours, description: 'ENAM, ENS, Polytech...'),
];
