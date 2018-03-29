# HakoBus-v2
HakoBus App supported new bus location system


## APIs
### SwaggerHub Links
- [timetable](https://app.swaggerhub.com/apis/natmark/hakobus-timetable-api/1.0.0-oas3#/hakobus/get_search_pl_bus_stop_cgi)

- [navigation](https://app.swaggerhub.com/apis/natmark/hakobus-navigation-api/1.0.0-oas3)

## Get Bus stops
![Server Running Chacker](https://img.shields.io/badge/dynamic/json.svg?label=server&colorB=FF7F50&query=$.message&uri=https://script.google.com/macros/s/AKfycbxk8eerT1zPLjenWVk_mJJAFTSkN8pslCp9kQQjd1Aldltckak/exec?url=https://script.google.com/macros/s/AKfycbw1TI6OFxgd6iST4L-34oNfG-aSb8KgJZMR06w_Xfmgn4Q8SLVH/exec)

- BaseURL(GAS): `https://script.google.com/macros/s/AKfycbw1TI6OFxgd6iST4L-34oNfG-aSb8KgJZMR06w_Xfmgn4Q8SLVH/exec`
- HTTP Method: `GET`
- Request Parameters:
  - **search_text**
    - string(path)
 - Example Response
 ```
[
  {
    name: "あわび山荘前",
    stopcode: "82046"
  }
]
 ```

## Get Bus Approach Infomation
![Server Running Chacker](https://img.shields.io/badge/dynamic/json.svg?label=server&colorB=FF7F50&query=$.message&uri=https://script.google.com/macros/s/AKfycbxk8eerT1zPLjenWVk_mJJAFTSkN8pslCp9kQQjd1Aldltckak/exec?url=https://script.google.com/macros/s/AKfycbzBiiZZEr6p3rLlWiCyvSIOwkx9ed5z_C3xKul206VTMtI5DcBp/exec)
- BaseURL(GAS): `https://script.google.com/macros/s/AKfycbzBiiZZEr6p3rLlWiCyvSIOwkx9ed5z_C3xKul206VTMtI5DcBp/exec`
- HTTP Method: `GET`
- Request Parameters:
  - **to** 
    - *required
    - string(path)
  - **from** 
    - *required
    - string(path)
- Example Response
```
[
  {
    route: "１０５系統（未来大経由）",
    destination: "はこだて未来大学・赤川",
    departure_time: "19:28",
    destination_time: "19:40",
    estimated_departure_time: "19:32",
    estimated_destination_time: "19:45",
    bet_stop: {
      from_signpole_key: 54502,
      to_signpole_key: 54522,
      route_pattern_cd: 10684,
      source_time: 70362
    }
  }
]
```
