import { type User } from './constants';
import { type DocumentDTO, type FileDTO } from './file-manager';
import { t } from './t';

type AssuranceSheetData = {
  hashFunction: string;
  users: User[];
  doc: DocumentDTO;
  files: FileDTO[];
};

export async function createAssuranceSheet(data: AssuranceSheetData) {
  const {
    Document,
    Paragraph,
    Table,
    TableCell,
    TableRow,
    Packer,
    WidthType,
    BorderStyle,
    AlignmentType,
    HeadingLevel,
    // TextRun,
    // ShadingType,
    PatchType,
    TextRun,
    patchDocument,
    VerticalAlign,
  } = await import('docx');

  /**
    const tableColumnsWidth = [   / %%%
        100,
        // 1 row
        [30, 70],
        // 2 row
        [12, 18, 48, 22], 
        // 3 row
        [12, 18, 48, 22],
        // 4 row
        [30, 70],
        // 5 row,
        [30, 23, 23, 24],
        //  6 row
        [53   ,23,12, 12],
      ]
   */
  

  fetch('./template_1.docx').then(async (response) => {
    const fileData = await response.blob();
    patchDocument(fileData,{
      patches: {
        hash_function_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(data.hashFunction),
          ]
        },
        last_modified_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.last_modified),
          ]
        },
        file_size_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.file_size),
          ]
        },
        checksum_value_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.checksum_value),
          ]
        },
        work_type_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.work_type),
          ]
        },
        surname_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.surname),
          ]
        },
        signature_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.signature),
          ]
        },
        signing_date_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.signing_date),
          ]
        },
        file_name_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.file_name),
          ]
        },
        assurance_sheet_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.assurance_sheet),
          ]
        },
        sheets_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.sheets),
          ]
        },
        sheet_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.sheet),
          ]
        },
        object_name_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.object_name),
          ]
        },
        object_name_value: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(data.doc.objectName),
          ]
        },
        serial_number_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.serial_number),
          ]
        },
        serial_number_value: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(String(data.doc.serialNumber)),
          ]
        },
        document_designation_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.document_designation),
          ]
        },
        document_designation_value: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(data.doc.designation),
          ]
        },
        document_name_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.document_name),
          ]
        },
        document_name_value: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(data.doc.documentName),
          ]
        },
        last_change_number_key: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(t.last_change_number),
          ]
        },
        last_change_number_value: {
          type: PatchType.PARAGRAPH,
          children: [
            new TextRun(String(data.doc.lastChangeNumber)),
          ]
        },
      }
    }).then(async (blob)=> {
      const DocXBlob = new Blob([blob]);

      const reader = new FileReader();
    
      await new Promise((resolve) => {
        reader.onloadend = resolve;
        reader.readAsDataURL(DocXBlob);
      });
    
      // crate link to download
      const link = window.document.createElement('a');
      link.href = reader.result as string;
      link.download = 'template_1.docx';
      window.document.body.appendChild(link);
      link.click();
      window.document.body.removeChild(link);
    });
  });
  const document = new Document({
    styles: {
      default: {
        document: {
          run: {
            font: 'Times New Roman',
            size: 12,
          },
        },
      },
      // Define other styles as needed
    },
    sections: [
      {
        children: [
          new Paragraph({
            text: t.assurance_sheet,
            heading: HeadingLevel.TITLE,
            alignment: AlignmentType.CENTER,
          }),
          createAssuranceTable(data),
        ],
      },
    ],
  });

  function createAssuranceTable(data: AssuranceSheetData) {
    const rows: any[] = [createRow([
      { label: t.serial_number },
      { label: t.document_designation },
      { label: t.product_name, colSpan: 2},
      { label: t.last_change_number },
    ]), createRow([
      { label: String(data.doc.serialNumber) },
      { label: data.doc.designation },
      { label: data.doc.documentName, colSpan: 2 },
      { label: String(data.doc.lastChangeNumber) },
    ]), createRow([
      {
        label: data.hashFunction,
        colSpan: 2,
      },
      {
        label: data.files.length === 1 ? data.files[0].hash : '',
        colSpan: 3,
      },
    ])];

    const fileHeadingRow = [
      {
        label: t.file_name,
        colSpan: 2,
      },
      {
        label: t.last_modified,
        colSpan: 2,
      },
      {
        label: t.file_size,
      },
    ];
    if (data.files.length > 1) {
      fileHeadingRow[1].colSpan = 1;
      fileHeadingRow.push({
        label: t.checksum_value,
      });
    }

    rows.push(createRow(fileHeadingRow));

    data.files.forEach((model: FileDTO) => {
      const rowContent = [
        {
          label: model.fileName,
          colSpan: 2,
        },
        {
          label: model.fileLastModified,
          colSpan: 2,
        },
        {
          label: model.formattedSize,
        },
      ];
      if (data.files.length > 1) {
        rowContent[1].colSpan = 1;
        rowContent.push({
          label: model.hash,
        });
      }
      const fileRows = [
        createRow(rowContent),
      ];
      fileRows.forEach((row) => {
        rows.push(row);
      });
    })
    const table = new Table({
      columnWidths: [1260, 2520, 3780, 2520, 1260],
      rows: [
        createRow([
          { label: t.object_name, colSpan: 2 },
          { label: data.doc.objectName, colSpan: 3},
        ]),
        ...rows,
        createRow([
          { label: t.work_type, colSpan: 2 },
          { label: t.full_name },
          { label: t.signature },
          { label: t.signing_date },
        ]),
        ...data.users.map((user) =>
          createRow([
            { label: user.role, colSpan: 2 },
            { label: user.lastName },
            { label: '' },
            { label: '' },
          ]),
        ),
        createSpacingRow(),
        createRow([
          { rowSpan: 2, label: t.assurance_sheet },
          { colSpan: 2, rowSpan: 2, label: `${t.u_l} ${data.doc.designation}` },
          { rowSpan: 1, label: t.sheet },
          { rowSpan: 1, label: t.sheets },
        ]),
        createRow([
          { rowSpan: 1, label: '1' },
          { rowSpan: 1, label: '1' },
        ])
      ],
      width: {
        size: 100,
        type: WidthType.PERCENTAGE,
      },
      borders: {
        top: { size: 1, style: BorderStyle.SINGLE },
        bottom: { size: 1, style: BorderStyle.SINGLE },
        left: { size: 1, style: BorderStyle.SINGLE },
        right: { size: 1, style: BorderStyle.SINGLE },
        insideHorizontal: { size: 1, style: BorderStyle.SINGLE },
        insideVertical: { size: 1, style: BorderStyle.SINGLE },
      },
    });

    return table;
  }

  function createSpacingRow() {
    return new TableRow({
      children: [
        new TableCell({
          borders: {
            left: { size: 0, style: BorderStyle.SINGLE },
            right: { size: 0, style: BorderStyle.SINGLE },
          },
          children: [new Paragraph('')],
          columnSpan: 5,
          // shading: {
          //   type: ShadingType.SOLID,
          //   color: 'CCCCCC',
          // },
          verticalAlign: VerticalAlign.CENTER,
        }),
      ],
    });
  }

  function createRow(
    cells: Array<{
      label: string;
      colSpan?: number;
      rowSpan?: number;
      alignment?: keyof typeof AlignmentType;
    }>,
  ) {
    return new TableRow({
      children: cells.map((cell) => {
        return new TableCell({
          children: [
            new Paragraph({
              text: cell.label,
            }),
          ],
          columnSpan: cell.colSpan,
          rowSpan: cell.rowSpan,
          verticalAlign: VerticalAlign.CENTER,
        });
      }),
    });
  }

  const DocXBlob = await Packer.toBlob(document);

  const reader = new FileReader();

  await new Promise((resolve) => {
    reader.onloadend = resolve;
    reader.readAsDataURL(DocXBlob);
  });

  return reader.result as string;
}

// Example usage:
//   const creator = new DocumentCreator();
//   const doc = creator.create({

//   });

// The 'doc' object now contains a Document instance that can be written to a DOCX file.
