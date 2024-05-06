import { createMD5, createSHA1, createCRC32 } from 'hash-wasm';

export enum AlgorithmType {
  MD5 = 'md5',
  SHA1 = 'sha1',
  CRC32 = 'crc32',
}

export const HashAlgorithmsMap = {
  [AlgorithmType.MD5]: createMD5,
  [AlgorithmType.SHA1]: createSHA1,
  [AlgorithmType.CRC32]: createCRC32,
};

export const HashFunctions: Record<
  AlgorithmType,
  null | Awaited<ReturnType<typeof createMD5>>
> = {
  [AlgorithmType.MD5]: null,
  [AlgorithmType.SHA1]: null,
  [AlgorithmType.CRC32]: null,
};

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
];

export const t = {
  project_roles: 'Роли в проекте',
  specify_role_and_surname: 'Укажите хотя бы одну роль и фамилию.',
  // Добавить
  add: 'Добавить',
  // Фамилия
  surname: 'Фамилия',
  // Роль
  role: 'Роль',
  // Документ
  document: 'Документ',
  // Обозначение
  designation: 'Обозначение',
  // Наименование документа
  document_name: 'Наименование документа',
  // Версия
  version: 'Версия',
  // Номер последнего изменения
  last_change_number: 'Номер последнего изменения',
  // Алгоритм расчета контрольной суммы
  checksum_calculation_algorithm: 'Алгоритм расчета контрольной суммы',
  // Файл
  file: 'Файл',
};

export async function getHash(file: File, algorithm: AlgorithmType) {
  const chunkSize = 64 * 1024 * 1024;
  const fileReader = new FileReader();
  const chunkNumber = Math.floor(file.size / chunkSize);

  if (!HashFunctions[algorithm]) {
    HashFunctions[algorithm] = await HashAlgorithmsMap[algorithm]();
  }

  const hasher = HashFunctions[algorithm]!;

  hasher.init();

  for (let i = 0; i <= chunkNumber; i++) {
    const chunk = file.slice(
      chunkSize * i,
      Math.min(chunkSize * (i + 1), file.size),
    );
    await hashChunk(chunk);
  }

  function hashChunk(chunk: Blob) {
    return new Promise((resolve, reject) => {
      fileReader.onload = async (e) => {
        if (!e.target?.result) {
          return reject('No result');
        }
        const view = new Uint8Array(e.target.result as ArrayBuffer);
        hasher.update(view);
        resolve(true);
      };

      fileReader.readAsArrayBuffer(chunk);
    });
  }

  return hasher.digest();
}
