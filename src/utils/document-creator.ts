import { t } from './constants';

type AssuranceSheetData = {
  documentDesignation: string;
  productName: string;
  version: string;
  lastChangeNumber: string;
  hashFunction: string;
  hashValue: string;
  fileName: string;
  lastModified: string;
  fileSize: string;
  workCharacter: string;
  fullName: string;
  signature: string;
  signingDate: string;
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
    const table = new Table({
      columnWidths: [1260, 2520, 3780, 2520, 1260],
      rows: [
        createContentRow(
          t.serial_number,
          t.document_designation,
          t.product_name,
          t.version,
          t.last_change_number,
        ),
        createContentRow(
          '',
          data.documentDesignation,
          data.productName,
          data.version,
          data.lastChangeNumber,
        ),
        createContentRow('', '', data.hashFunction, data.hashValue, ''),
        createSpacingRow(),
        createContentRow(
          '',
          '',
          t.file_name,
          t.last_modified,
          t.file_size,
        ),
        createContentRow(
          '',
          '',
          data.fileName,
          data.lastModified,
          data.fileSize,
        ),
        createSpacingRow(),
        createContentRow(
          '',
          t.work_type,
          t.full_name,
          t.signature,
          t.signing_date,
        ),
        createContentRow(
          '',
          data.workCharacter,
          data.fullName,
          data.signature,
          data.signingDate,
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

  function createContentRow(
    index: string,
    leftLabel: string,
    leftContent: string,
    rightLabel: string,
    rightContent: string,
  ) {
    return new TableRow({
      children: [
        new TableCell({
          children: [
            new Paragraph({ text: index, alignment: AlignmentType.CENTER }),
          ],
          verticalAlign: VerticalAlign.CENTER,
        }),
        new TableCell({
          children: [new Paragraph(leftLabel)],
          verticalAlign: VerticalAlign.CENTER,
        }),
        new TableCell({
          children: [new Paragraph(leftContent)],
          verticalAlign: VerticalAlign.CENTER,
        }),
        new TableCell({
          children: [new Paragraph(rightLabel)],
          verticalAlign: VerticalAlign.CENTER,
        }),
        new TableCell({
          children: [new Paragraph(rightContent)],
          verticalAlign: VerticalAlign.CENTER,
        }),
      ],
    });
  }

  const DocXBlob = await Packer.toBlob(document);

  const reader = new FileReader()
    
  await new Promise(resolve => {
      reader.onloadend = resolve
      reader.readAsDataURL(DocXBlob);
  });

  return reader.result as string;
}

// Example usage:
//   const creator = new DocumentCreator();
//   const doc = creator.create({

//   });

// The 'doc' object now contains a Document instance that can be written to a DOCX file.
