import { DocumentField } from "./constants";

const storageKey = `doc-hash-persisted`;

type StorageKey = 'fileHash' | 'algo' | 'fileLink' | 'designation' | 'documentName' | 'version' | 'lastChangeNumber' | 'users' | DocumentField;

export function read(key: StorageKey, defaultValue: string): string {
  const accessKey = `${storageKey}/${key}`;
  try {
    return localStorage.getItem(accessKey) ?? String(defaultValue);
  } catch {
    return defaultValue;
  }
}
export function write(key: StorageKey, rawValue: string | object) {
    const value = typeof rawValue === 'string' ? rawValue : JSON.stringify(rawValue);
  const accessKey = `${storageKey}/${key}`;
  try {
    localStorage.setItem(accessKey, value);
  } catch (e) {
    // OOPS
  }
}
