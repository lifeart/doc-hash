import { Component } from '@lifeart/gxt';
import type { User } from './../utils/constants';

export class RoleList extends Component<{
  Args: {
    user: User;
    onRemove: (user: User) => void;
  };
}> {
  <template>
    <li class='py-2'>
      <div class='flex justify-between'>
        <div class='flex-auto px-4 w-2/5'>{{@user.role}}</div>
        <div class='flex-auto px-4 w-2/5'>{{@user.lastName}}</div>
        <div class='flex-auto px-4'>
          <button
            class='bg-red-100 w-8 rounded text-gray shadow border-2 border-red-200 text-center'
            {{on 'click' (fn @onRemove @user)}}
          >×</button>
        </div>
      </div>
    </li>
  </template>
}
