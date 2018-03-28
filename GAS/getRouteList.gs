function doGet(e) {
  var response = UrlFetchApp.fetch("https://hakobus.bus-navigation.jp/wgsys/wgp/search.htm?tabName=routeTab&locale=ja&from=&to=");
  var html = response.getContentText()
  var blocks = html.match(/<tr class="item first">[\s\S]*?<\/a>/ig)
  var routes = [];
  
  for(var i = 0; i < blocks.length; i++){ 
    var obj = new Object();
    obj.routeId = parseInt(blocks[i].match(/routeClick\('([\s\S]*?)'\)/i)[1], 10);
    obj.name = blocks[i].match(/<\/i>([\s\S]*?)<span/i)[1].trim()

    routes.push(obj)
  }

  var output = ContentService.createTextOutput();
  output.setMimeType(ContentService.MimeType.JSON);
  output.setContent(JSON.stringify(routes));
  return output;
}
