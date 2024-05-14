import { AssuranceSheetData } from './document-creator';
import { t } from './t';

export async function patchFile(data: AssuranceSheetData) {
  const {
    // TextRun,
    // ShadingType,
    PatchType,
    TextRun,
    patchDocument,
  } = await import('docx');
  fetch('./template_1.docx').then(async (response) => {
    const fileData = await response.blob();
    patchDocument(fileData, {
      patches: {
        hash_function_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(data.hashFunction)],
        },
        last_modified_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.last_modified)],
        },
        file_size_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.file_size)],
        },
        checksum_value_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.checksum_value)],
        },
        work_type_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.work_type)],
        },
        surname_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.surname)],
        },
        signature_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.signature)],
        },
        signing_date_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.signing_date)],
        },
        file_name_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.file_name)],
        },
        assurance_sheet_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.assurance_sheet)],
        },
        sheets_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.sheets)],
        },
        sheet_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.sheet)],
        },
        object_name_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.object_name)],
        },
        object_name_value: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(data.doc.objectName)],
        },
        serial_number_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.serial_number)],
        },
        serial_number_value: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(String(data.doc.serialNumber))],
        },
        document_designation_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.document_designation)],
        },
        document_designation_value: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(data.doc.designation)],
        },
        document_name_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.document_name)],
        },
        document_name_value: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(data.doc.documentName)],
        },
        last_change_number_key: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(t.last_change_number)],
        },
        last_change_number_value: {
          type: PatchType.PARAGRAPH,
          children: [new TextRun(String(data.doc.lastChangeNumber))],
        },
      },
    }).then(async (blob) => {
      const DocXBlob = new Blob([blob]);

      const reader = new FileReader();

      await new Promise((resolve) => {
        reader.onloadend = resolve;
        reader.readAsDataURL(DocXBlob);
      });

      const link = window.document.createElement('a');
      link.href = reader.result as string;
      link.download = 'template_1.docx';
      window.document.body.appendChild(link);
      link.click();
      window.document.body.removeChild(link);
    });
  });
}
