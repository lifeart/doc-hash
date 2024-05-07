import type { createMD5 as createMD5Type } from 'hash-wasm';

export enum AlgorithmType {
  MD5 = 'md5',
  SHA1 = 'sha1',
  CRC32 = 'crc32',
}

export const HashFunctions: Record<
  AlgorithmType,
  null | Awaited<ReturnType<typeof createMD5Type>>
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
  // Информационно-удостоверяющий лист
  assurance_sheet: 'Информационно-удостоверяющий лист',
  // Наименование файла
  file_name: 'Наименование файла',
  // Дата и время последнего изменения файла
  last_modified: 'Дата и время последнего изменения файла',
  // Размер файла, байт
  file_size: 'Размер файла, байт',
  // Характер работы
  work_type: 'Характер работы',
  // ФИО
  full_name: 'ФИО',
  // Подпись
  signature: 'Подпись',
  // Дата подписания
  signing_date: 'Дата подписания',
  // Наименование изделия, наименование документа
  product_name: 'Наименование изделия, наименование документа',
  // Обозначение документа
  document_designation: 'Обозначение документа',
  // № п/п
  serial_number: '№ п/п',
  // Конструктор информационно-удостоверяющих листов для экспертизы. [GXT]
  title: 'Конструктор информационно-удостоверяющих листов для экспертизы. [GXT]',
  // Печать
  print: 'Печать',
  // Скачать ИУЛ
  download_assurance_sheet: 'Скачать ИУЛ',
  // Передпросмотр
  preview: 'Передпросмотр',
};

export async function getHash(file: File, algorithm: AlgorithmType) {
  const { createMD5, createSHA1, createCRC32 } = await import('hash-wasm');

  const chunkSize = 64 * 1024 * 1024;
  const fileReader = new FileReader();
  const chunkNumber = Math.floor(file.size / chunkSize);

  if (!HashFunctions[algorithm]) {
    if (algorithm === AlgorithmType.MD5) {
      HashFunctions[algorithm] = await createMD5();
    } else if (algorithm === AlgorithmType.SHA1) {
      HashFunctions[algorithm] = await createSHA1();
    } else if (algorithm === AlgorithmType.CRC32) {
      HashFunctions[algorithm] = await createCRC32();
    }
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



export function not(param: any) {
  return !param;
}