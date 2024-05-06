import { Component } from '@lifeart/gxt';

export class DocumentForm extends Component {
    <template>
        <div class="bg-warning bg-opacity-10 pt-3 pb-4 px-4">
            <h3 class="py-2">1. Документ</h3>
            <div>
                <label for="formOboz" class="form-label">Обозначение:</label>
                <input type="text" class="form-control" id="formOboz">
            </div>
            
            <div class="mt-3">
                <label for="formNaim" class="form-label">Наименование документа:</label>
                <textarea class="form-control" id="formNaim" rows="3"></textarea>
            </div>
            
            <div class="row">
                <div class="mt-3 col-6 col-md-6 col-lg-6">
                    <label for="formVer" class="form-label">Версия:</label>
                    <input type="number" class="form-control" id="formVer">
                </div>
                
                <div class="mt-3 col-6 col-md-6 col-lg-6">
                    <label for="formNum" class="form-label">Номер последнего изменения:</label>
                    <input type="number" class="form-control" id="formNum">
                </div>
            </div>
        </div>
    </template>
}