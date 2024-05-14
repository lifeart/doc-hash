export function style() {
    return `
      *,
  *:before,
  *:after {
    color: #000;
    box-shadow: none;
    text-shadow: none;
    margin: 0;
    padding: 0;
  }
  body {
    background-color: #fff;
    margin: 0;
    padding: 0;
    font: 13px/20px normal Arial, Helvetica, sans-serif;
    color: #4f5155;
    line-height: 1.2;
    color: #000;
  }
  
  @page {
    size: A4 portrait;
    margin: 20mm 0 10mm 0;
  }
  
  h1 {
    font-weight: bold;
    padding-bottom: 16px;
    text-align: center;
    font-size: 1.5em;
  }
  
  table {
    width: 100%;
    border: #000 1px solid !important;
    border-collapse: collapse;
  }
  
  tr,
  td {
    border: #000 1px solid !important;
  }
  
  td {
    padding: 10px;
    overflow-wrap: break-word;
    word-wrap: break-word;
    word-break: break-word;
  }
  
  .text-center {
    text-align: center;
  }
  
  .font-bold {
    font-weight: bold;
    word-break: auto-phrase;
  }
  
  .header,
  .container {
    padding-right: 24px;
    padding-left: 24px;
  }
  
  .header {
    background-color: #eee;
    padding-top: 8px;
    padding-bottom: 8px;
    display: flex;
    justify-content: flex-end;
  }
  
  .header__button {
    background-color: #079f48;
    color: #fff;
    font-weight: bold;
    font-size: 16px;
    border: none;
    padding: 12px 20px;
    border-radius: 8px;
    cursor: pointer;
  }
  
  .header__button:hover {
    background-color: #068f41;
  }
  
  .container {
    margin-top: 32px;
  }
  
  @media print {
    html,
    body {
      /* background-color:#fc0 */
    }
    .header {
      display: none;
    }
    .container {
      margin-top: 0;
      padding-right: 24px;
      padding-left: 80px;
    }
  }
  
      `;
  }
  