function doGet(e) {
  var from = "";
  var to = "";
  if(e.parameter.from){
    from = e.parameter.from;
  }
  if(e.parameter.to){
    to = e.parameter.to;
  }

  var response = UrlFetchApp.fetch("https://hakobus.bus-navigation.jp/wgsys/wgp/bus.htm?fromType=1&toType=1&locale=ja&from=" + from + "&to=" + to)
  var html = response.getContentText()
  var blocks = html.match(/<table width="100%">[\s\S]*?<\/div>[\s\S]*?<\/div>/ig)
  var approaches = []

  var infoBetStops = html.match(/showInfoBetStops([\s\S]*?);/ig)
  
  if(blocks != null){
    for(var i = 0; i < blocks.length; i++){ 
      var obj = new Object();
      obj.route = blocks[i].match(/<font size="3" style="color: blue;">([\s\S]*?)<\/font>/i)[1].trim()
      obj.destination = blocks[i].match(/<td>([\s\S]*?)<\/td>/ig)[2].match(/<td>([\s\S]*?)<\/td>/i)[1].replace("&nbsp;", "").replace(/<!--[\s\S]*?-->/, "").replace(/\s+/g, "").replace("行き","");
      obj.departure_time = blocks[i].match(/<td>([\s\S]*?)<\/td>/ig)[5].match(/<td>([\s\S]*?)<\/td>/i)[1].replace(/&nbsp;/g,"").replace(/\s+/g, "").replace("予定時刻", "");
      obj.destination_time = blocks[i].match(/<td>([\s\S]*?)<\/td>/ig)[7].match(/<td>([\s\S]*?)<\/td>/i)[1].replace(/&nbsp;/g,"").replace(/\s+/g, "").replace("予定時刻", "");
      obj.estimated_departure_time = blocks[i].match(/<td>([\s\S]*?)<\/td>/ig)[6].match(/<td>([\s\S]*?)<\/td>/i)[1].replace(/&nbsp;/g,"").replace(/\s+/g, "").replace("発車予測", "");
      obj.estimated_destination_time = blocks[i].match(/<td>([\s\S]*?)<\/td>/ig)[8].match(/<td>([\s\S]*?)<\/td>/i)[1].replace(/&nbsp;/g,"").replace(/\s+/g, "").replace("到着予測", "");
      
      if(infoBetStops != null && infoBetStops.length > i) {
        var infoBetStop = infoBetStops[i].match(/showInfoBetStops\(([\s\S]*?)\);/i)[1].replace(/'/g,"").split(",")

        var betStop = Object();
        betStop.from_signpole_key = parseInt(infoBetStop[1], 10)
        betStop.to_signpole_key = parseInt(infoBetStop[2], 10)
        betStop.route_pattern_cd = parseInt(infoBetStop[3], 10)
        betStop.source_time = parseInt(infoBetStop[4], 10)
        obj.bet_stop = betStop
      }

      approaches.push(obj)
    }
  }

  var output = ContentService.createTextOutput();
  output.setMimeType(ContentService.MimeType.JSON);
  output.setContent(JSON.stringify(approaches));
  return output;
}
