type AssuranceSheetData = {
  documentDesignation: string;
  productName: string;
  version: string;
  lastChangeNumber: string;
  sha1: string;
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
            text: 'Информационно-удостоверяющий лист',
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
          '№ п/п',
          'Обозначение документа',
          'Наименование изделия, наименование документа',
          'Версия',
          'Номер последнего изменения',
        ),
        createContentRow(
          '',
          data.documentDesignation,
          data.productName,
          data.version,
          data.lastChangeNumber,
        ),
        createContentRow('', '', 'SHA1', data.sha1, ''),
        createSpacingRow(),
        createContentRow(
          '',
          '',
          'Наименование файла',
          'Дата и время последнего изменения файла',
          'Размер файла, байт',
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
          'Характер работы',
          'ФИО',
          'Подпись',
          'Дата подписания',
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
