export enum AlgorithmType {
  MD5 = 'md5',
  SHA1 = 'sha1',
  CRC32 = 'crc32',
}

export type User = { role: string; lastName: string };

export const algos = [
  { label: 'MD5', value: AlgorithmType.MD5 },
  { label: 'SHA1', value: AlgorithmType.SHA1 },
  { label: 'CRC32', value: AlgorithmType.CRC32 },
];

export const defaultRoles = [
  'Выполнил',
  'ГИП',
  'ГАП',
  'Ген.директор',
  'Гл.инженер',
  'Н.контроль',
  'Разработал',
  'Проверил',
  'Составил',
];


export const roles = [
  ...defaultRoles.map((role) => ({ label: role, value: role })),
]

export const t = {
  project_roles: 'Роли в проекте',
  specify_role_and_surname: 'Укажите хотя бы одну роль и фамилию.',
  // Добавить
  add: 'Добавить',
  // Фамилия
  surname: 'Фамилия',
  // Роль
  role: 'Роль',
}
