import { type User } from './constants';
import { FileDTO } from './file-manager';
import { t } from './t';

type AssuranceSheetData = {
  hashFunction: string;
  users: User[];
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
    ShadingType,
    VerticalAlign,
  } = await import('docx');
  const document = new Document({
    styles: {
      default: {
        document: {
          run: {
            font: 'Arial',
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
    const rows: any[] = [];
    data.files.forEach((model: FileDTO) => {
      const fileRows = [
        createRow([
          { label: t.serial_number },
          { label: t.document_designation },
          { label: t.product_name },
          { label: t.version },
          { label: t.last_change_number },
        ]),
        createRow([
          { label: '' },
          { label: model.designation },
          { label: model.documentName },
          { label: String(model.version) },
          { label: String(model.lastChangeNumber) },
        ]),
        createRow([
          {
            label: data.hashFunction,
            colSpan: 2,
          },
          {
            label: model.hash,
            colSpan: 3,
          },
        ]),
        createRow([
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
        ]),
        createRow([
          {
            label: model.fileName,
            colSpan: 2,
          },
          {
            label: model.fileLastModified,
            colSpan: 2,
          },
          {
            label: String(model.fileSize),
          },
        ]),
        createSpacingRow(),
      ];
      fileRows.forEach((row) => {
        rows.push(row);
      });
    })
    const table = new Table({
      columnWidths: [1260, 2520, 3780, 2520, 1260],
      rows: [
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
          shading: {
            type: ShadingType.SOLID,
            color: 'CCCCCC',
          },
          verticalAlign: VerticalAlign.CENTER,
        }),
      ],
    });
  }

  function createRow(
    cells: Array<{
      label: string;
      colSpan?: number;
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
