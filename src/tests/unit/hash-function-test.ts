import { module, test } from 'qunit';
import { AlgorithmType, getHash } from '@/utils/constants';

module('Unit | functions | getHash', function () {
  test('md5 works', async function (assert) {
    const file = new File([new Blob(['hello world'])], 'filename.txt', {
      type: 'text/plain',
    });
    const hash = await getHash(file, AlgorithmType.MD5);
    assert.equal(hash, '5eb63bbbe01eeed093cb22bb8f5acdc3');
  });
  test('md5 hash not cached', async function (assert) {
    const file = new File([new Blob(['hello worlds'])], 'filename.txt', {
      type: 'text/plain',
    });
    const hash = await getHash(file, AlgorithmType.MD5);
    assert.equal(hash, 'b96b878ad72f56709dbb5628e1cea18d');
  });
  test('sha1 works', async function (assert) {
    const file = new File([new Blob(['hello world'])], 'filename.txt', {
      type: 'text/plain',
    });
    const hash = await getHash(file, AlgorithmType.SHA1);
    assert.equal(hash, '2aae6c35c94fcfb415dbe95f408b9ce91ee846ed');
  });
  test('sha1 not cached', async function (assert) {
    const file = new File([new Blob(['hello worlds'])], 'filename.txt', {
      type: 'text/plain',
    });
    const hash = await getHash(file, AlgorithmType.SHA1);
    assert.equal(hash, 'b1b91b92e4ef0b0afa7f3448658781018ca3310c');
  });
  test('crc32 works', async function (assert) {
    const file = new File([new Blob(['hello world'])], 'filename.txt', {
      type: 'text/plain',
    });
    const hash = await getHash(file, AlgorithmType.CRC32);
    assert.equal(hash, '0d4a1185');
  });
  test('crc32 not cached', async function (assert) {
    const file = new File([new Blob(['hello worlds'])], 'filename.txt', {
      type: 'text/plain',
    });
    const hash = await getHash(file, AlgorithmType.CRC32);
    assert.equal(hash, '86d1f2b5');
  });
});
