import { Component } from '@lifeart/gxt';
import type { User } from './../utils/constants';

export class RoleList extends Component<{
  Args: {
    user: User;
    onRemove: (user: User) => void;
  };
}> {
  <template>
    <li class='list-group-item'><div class='row'><div
          class='col-12 col-md-5 col-lg-6 d-flex align-items-center fw-bold'
        >{{@user.role}}</div><div
          class='col-12 col-md-7 col-lg-6 d-flex flex-column flex-md-row align-items-stretch align-items-md-center justify-content-md-between'
        ><span>{{@user.lastName}}</span><div class='d-grid mt-2 mt-md-0'><button
              class='btn btn-light text-danger fw-bold'
              {{on 'click' (fn @onRemove @user)}}
            >×</button></div></div></div></li>
  </template>
}
