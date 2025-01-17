import { type User, AlgorithmType, algos } from './constants';
import { type DocumentDTO, type FileDTO } from './file-manager';
import { t } from './t';

export type AssuranceSheetData = {
  hashFunction: AlgorithmType[];
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
    // PatchType,
    TextRun,
    // patchDocument,
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

  const document = new Document({
    styles: {
      default: {
        document: {
          run: {
            font: 'Times New Roman',
            size: '12pt', // pc
          },
        },
      },
      // Define other styles as needed
    },
    sections: [
      {
        children: [
          new Paragraph({
            heading: HeadingLevel.TITLE,
            alignment: AlignmentType.CENTER,
            spacing: {
              after: 100,
            },
            children: [new TextRun({
              text: t.assurance_sheet,
              bold: true,
              size: 24,
            })],
          }),
          createAssuranceTable(data),
        ],
      },
    ],
  });

  function createAssuranceTable(data: AssuranceSheetData) {
    const isSingleHashFunction = data.hashFunction.length === 1;
    const firstHashName = data.hashFunction[0];
    const isSingleFileMode = data.files.length === 1;
    const rows: any[] = [
      createRow([
        { label: t.serial_number, size: 10, colSpan: 1 },
        { label: t.document_designation, size: 20, colSpan: 2 },
        { label: t.product_name, size: 50, colSpan: 5 },
        { label: t.last_change_number, size: 20, colSpan: 2 },
      ]),
      createRow([
        { label: String(data.doc.serialNumber), size: 10, colSpan: 1 },
        { label: data.doc.designation, size: 20, colSpan: 2 },
        { label: data.doc.documentName, size: 50, colSpan: 5 },
        { label: String(data.doc.lastChangeNumber), size: 20, colSpan: 2 },
      ]),
      isSingleHashFunction ? createRow([
        {
          label: algos.find((a) => a.value === firstHashName)?.label ?? '',
          size: 30,
          colSpan: 3,
        },
        {
          label: data.files.length === 1 ? data.files[0].hash[firstHashName] : '',
          size: 70,
          colSpan: 7,
        },
      ]) : null,
    ].filter((el) => el !== null);
    if (isSingleFileMode && !isSingleHashFunction) {
      data.hashFunction.forEach((hash) => {
        rows.push(createRow([
          {
            label: algos.find((a) => a.value === hash)?.label ?? '',
            size: 30,
            colSpan: 3,
          },
          {
            label: data.files.length === 1 ? data.files[0].hash[hash] : '',
            size: 70,
            colSpan: 7,
          },
        ]))
      });
    }
    // [30, 23, 23, 24],
    const fileHeadingRow = [
      {
        label: t.file_name,
        size: 30,
        colSpan: 3,
      },
      {
        label: t.last_modified,
        size: 30,
        colSpan: 3,
      },
      {
        label: t.file_size,
        size: 40,
        colSpan: 4,
      },
    ];
    if (data.files.length > 1) {
      fileHeadingRow.push({
        label: t.checksum_value,
        size: 30,
        colSpan: 3,
      });
      fileHeadingRow[1].size = 20;
      fileHeadingRow[1].colSpan = 2;
      fileHeadingRow[2].size = 20;
      fileHeadingRow[2].colSpan = 2;
    }

    rows.push(createRow(fileHeadingRow));

    data.files.forEach((model: FileDTO) => {
      const rowContent = [
        {
          label: model.fileName,
          size: 30,
          colSpan: 3,
        },
        {
          label: model.fileLastModified,
          size: 30,
          colSpan: 3,
        },
        {
          label: model.formattedSize,
          size: 40,
          colSpan: 4,
        },
      ];
      if (data.files.length > 1) {
        const hashLabel: string[] = [];
        data.hashFunction.forEach((hash) => {
          const hashName = algos.find((a) => a.value === hash)?.label ?? '';
          if (isSingleHashFunction) {
            hashLabel.push(model.hash[hash]);
          } else {
            hashLabel.push(`${hashName}: ${model.hash[hash]}`);
          }
        });
        rowContent.push({
          label: hashLabel.join('\n').trim(),
          colSpan: 3,
          size: 30,
        });
        rowContent[1].size = 20;
        rowContent[1].colSpan = 2;
        rowContent[2].size = 20;
        rowContent[2].colSpan = 2;
      }
      const fileRows = [createRow(rowContent)];
      fileRows.forEach((row) => {
        rows.push(row);
      });
    });
    const columnWidth = 910; // 963
    const gridSize = 10;
    const columnWidths = [
      columnWidth + 200,
      columnWidth,
      columnWidth,
      columnWidth,
      columnWidth - 200,
      columnWidth,
      columnWidth,
      columnWidth - 100,
      columnWidth,
      columnWidth + 100,
    ];
    const table = new Table({
      rows: [
        createRow([
          { label: t.object_name, size: 30, colSpan: 3, bold: true },
          { label: data.doc.objectName, size: 70, colSpan: 7, bold: true },
        ]),
        ...rows,
        createRow([
          { label: t.work_type, size: 30, colSpan: 3 },
          { label: t.full_name, size: 20, colSpan: 2 },
          { label: t.signature, size: 20, colSpan: 2 },
          { label: t.signing_date, size: 30, colSpan: 3 },
        ]),
        ...data.users.map((user) =>
          createRow([
            { label: user.role, size: 30, colSpan: 3 },
            { label: user.lastName, size: 20, colSpan: 2 },
            { label: '', size: 20, colSpan: 2 },
            { label: '', size: 30, colSpan: 3 },
          ]),
        ),
        createSpacingRow(),
        createRow([
          { rowSpan: 5, label: t.assurance_sheet, size: 50, colSpan: 5 },
          {
            rowSpan: 2,
            label: `${data.doc.designation} ${t.u_l}`,
            size: 30,
            colSpan: 3,
          },
          { rowSpan: 1, label: t.sheet, size: 10, colSpan: 1 },
          { rowSpan: 1, label: t.sheets, size: 10, colSpan: 1 },
        ]),
        createRow([
          { rowSpan: 1, label: '1', size: 10, colSpan: 1 },
          { rowSpan: 1, label: '1', size: 10, colSpan: 1 },
        ]),
      ],
      width: {
        size: columnWidth * gridSize,
        type: WidthType.DXA,
      },
      columnWidths: columnWidths,
      borders: {
        top: { size: 1, style: BorderStyle.SINGLE, color: '000000' },
        bottom: { size: 1, style: BorderStyle.SINGLE, color: '000000' },
        left: { size: 1, style: BorderStyle.SINGLE, color: '000000' },
        right: { size: 1, style: BorderStyle.SINGLE, color: '000000' },
        insideHorizontal: {
          size: 1,
          style: BorderStyle.SINGLE,
          color: '000000',
        },
        insideVertical: { size: 1, style: BorderStyle.SINGLE, color: '000000' },
      },
    });

    return table;
  }

  function createSpacingRow() {
    const spans = [3, 2, 2, 3];
    return new TableRow({
      children: [
        ...spans.map((size) => {
          return new TableCell({
            // borders: {
            //   left: { size: 0, style: BorderStyle.SINGLE },
            //   right: { size: 0, style: BorderStyle.SINGLE },
            // },
            children: [new Paragraph('')],
            columnSpan: size,
            // shading: {
            //   type: ShadingType.SOLID,
            //   color: 'CCCCCC',
            // },
            verticalAlign: VerticalAlign.CENTER,
            width: {
              size: size * 10,
              type: WidthType.PERCENTAGE,
            },
          });
        }),
      ],
    });
  }

  function createRow(
    cells: Array<{
      label: string;
      colSpan?: number;
      rowSpan?: number;
      size: number;
      bold?: boolean;
      alignment?: keyof typeof AlignmentType;
    }>,
  ) {
    return new TableRow({
      children: cells.map((cell) => {
        return new TableCell({
          width: {
            size: cell.size,
            type: WidthType.PERCENTAGE,
          },
          children: [
            new Paragraph({
              alignment: AlignmentType.CENTER,
              children: [
                new TextRun({
                  text: cell.label,
                  bold: cell.bold === true,
                  size: 12 * 2,
                }),
              ],
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
