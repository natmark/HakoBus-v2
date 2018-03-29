function doGet(e) {
  var search_txt = "";
  if(e.parameter.search_txt){
    search_txt = e.parameter.search_txt;
  }

  var response = UrlFetchApp.fetch("http://www.hakobus.co.jp/search/pl/bus_stop.cgi?mode=get_place&search_txt=" + search_txt)
  var csv = response.getContentText().split(/\r\n|\r|\n/);
  Logger.log(csv)
  
  var output = ContentService.createTextOutput();
  output.setMimeType(ContentService.MimeType.JSON);
  output.setContent(JSON.stringify(csv2json(csv)));
  return output;
}

function csv2json(csvArray){
  var jsonArray = [];
  var items = ["name","stopcode"]

  for (var i = 1; i < csvArray.length - 1; i++) {
    var a_line = new Object();
    var csvArrayD = csvArray[i].split(',');
    for (var j = 0; j < items.length; j++) {
      a_line[items[j]] = csvArrayD[j];
    }
    jsonArray.push(a_line);
  }
  return jsonArray;
}
