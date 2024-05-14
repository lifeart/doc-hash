import type { createMD5 as createMD5Type } from 'hash-wasm';
import { t } from '@/utils/t';

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

export type DocumentField = 'lastChangeNumber' | 'serialNumber' | 'documentName' | 'designation';

export const algos = [
  { label: 'MD5', value: AlgorithmType.MD5 },
  { label: 'SHA1', value: AlgorithmType.SHA1 },
  { label: 'CRC32', value: AlgorithmType.CRC32 },
];

export const defaultRoles = [
  t.role_creator,
  t.role_gip,
  t.role_gap,
  t.role_general_director,
  t.role_chief_engineer,
  t.role_scientific_control,
  t.role_developer,
  t.role_verifier,
  t.role_composer,
];

export const roles = [
  ...defaultRoles.map((role) => ({ label: role, value: role })),
];

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
