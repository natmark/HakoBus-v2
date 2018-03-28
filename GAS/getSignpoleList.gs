function doGet(e) {
  var APIResponse = UrlFetchApp.fetch("https://script.google.com/macros/s/AKfycbxgfOF4zuR9yJJXAIU8b8xVVGNnxi_SauL8RhsUGEQX-SYN8u8/exec")
  var json = JSON.parse(APIResponse.getContentText());
  
  var busStops = [];

  for(var i = 0; i < json.length; i++) {
    var param = json[i]["routeId"]
    var response = UrlFetchApp.fetch("https://hakobus.bus-navigation.jp/wgsys/wgp/route.htm?routeLayoutCd=" + param);
    var html = response.getContentText()
    var blocks = html.match(/<div class="listheader">[\s\S]*?<i class="flaticon-calendar53"><\/i>/ig)
    
    if(blocks!=null){
      for(var j = 0; j < blocks.length; j++){ 
        var obj = new Object();
        obj.name = blocks[j].match(/<img src="\/wgsys\/imgp\/signpole_small.png">([\s\S]*?)<\/h5>/i)[1].trim()
        if(blocks[j].match(/<a target="_blank" class="anchortab-link-color closelink" href="\/wgsys\/wgp\/busMap.htm\?signPoleKey=([\s\S]*?)&locale=ja">/i) == null){
          obj.signPoleKey = Number(blocks[j].match(/<a target="_blank" class="anchortab-link-color closelink" href="\/wgsys\/wgp\/busMap.htm\?signPoleKey=([\s\S]*?)&amp;locale=ja">/i)[1])
        }else{
          obj.signPoleKey = Number(blocks[j].match(/<a target="_blank" class="anchortab-link-color closelink" href="\/wgsys\/wgp\/busMap.htm\?signPoleKey=([\s\S]*?)&locale=ja">/i)[1])
        }
        if(blocks[j].match(/<a class="anchortab-link-color  closelink" href="http:\/\/www.hakobus.co.jp\/timetable\/\?busStopCode=([\s\S]*?)" target="_blank">/i) == null){
          obj.busStopCode = Number(blocks[j].match(/<a class="anchortab-link-color closelink" href="http:\/\/www.hakobus.co.jp\/timetable\/\?busStopCode=([\s\S]*?)" target="_blank">/i)[1])
        }else{
          obj.busStopCode = Number(blocks[j].match(/<a class="anchortab-link-color  closelink" href="http:\/\/www.hakobus.co.jp\/timetable\/\?busStopCode=([\s\S]*?)" target="_blank">/i)[1])
        }
        busStops.push(obj)
      } 
    }
  }
   
  var output = ContentService.createTextOutput();
  output.setMimeType(ContentService.MimeType.JSON);
  output.setContent(JSON.stringify(removeDuplicateElement(busStops)));
  return output;
}

function removeDuplicateElement (array) {
  var results = [], i = 0, l = array.length;

  while (i < l) {
    var value = array[i++];

    if (results.indexOf(value) === -1) {
      results.push(value);
    }
  }

  return results;
}
