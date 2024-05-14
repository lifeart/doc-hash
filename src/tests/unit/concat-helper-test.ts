import { module, test } from 'qunit';
import { concat } from '@/utils/helpers';
module('Unit | helpers | concat', function () {
  test('it works', async function (assert) {
    const result = concat('hello', 'world');
    assert.equal(result, 'hello world');
  });
});