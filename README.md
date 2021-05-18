
## PXWeb
Statistics Finland publishes statistical tables online using [PXWeb](https://www.scb.se/en/services/statistical-programs-for-px-files/px-web/), a software developed by Statistics Sweden (SCB) to disseminate [PX format](https://www.scb.se/en/services/statistical-programs-for-px-files/) statistics files on the web. Statistics Finland's statistical databases are available [here](https://www.stat.fi/tup/tilastotietokannat/index_en.html) and all tables are available through the PXWeb API.  

The API is called with a POST request where the query parameters are in the request body in JSON format.

### Documentation
 * [SCB's API documentation](https://pxnet2.stat.fi/API-description_SCB.pdf)
 * [Statistics Finland API guide in English, includes changelog](https://pxnet2.stat.fi/api1.html)
 * [Statistics Finland API guide in Finnish](https://www.stat.fi/static/media/uploads/org/avoindata/pxweb_api-ohje.pdf)

### Quickstart
* Select a table [from a free-of-charge database](https://www.stat.fi/tup/tilastotietokannat/index_en.html)
* Using the pxweb-web-interface, select which variables/dimensions to include in the table and click *Show table*
* Once the table is rendered, scroll down and click *API query for this table* and send the JSON query to the URL in the body of a POST request from your application

## API
The URL for the API call is constructed from:  

<pre>https://pxnet2.stat.fi/PXWeb/api/<b>apiVersion</b>/<b>languageName</b>/<b>databaseId</b>/<b>path</b>/<b>to</b>/<b>tableId.px</b></pre>

Where possible values for the URL's parameters are:  
* __apiVersion__  
    * v1
* __languageName__
    * fi/en/sv
* __databaseId__
    * [List of databases available in the api](https://pxnet2.stat.fi/PXWeb/api/v1/en)

The easiest way to get a table's __path__ and __tableId__ is to use the API's query function by adding a __query__ query string parameter to the url. The query function searches the API from any given node by the value of the *query* query string, e.g.


```
https://pxnet2.stat.fi/pxweb/api/v1/en/StatFin?query=*&filter=*
```
returns all tables in the StatFin database


```
https://pxnet2.stat.fi/pxweb/api/v1/en/StatFin/asu?query=*&filter=*
```


returns all tables in the housing statistic, etc.

Retrieving the path and tableId for table __"112n -- Price index of old dwellings in housing companies (2015=100) and numbers of transactions"__ in the __StatFin__ database can be done querying the API with, for example, "housing companies index".  

Sending a GET request (from e.g. a web browser) to:
<pre>https://pxnet2.stat.fi/PXWeb/api/v1/en/StatFin?query=housing%20companies%20index</pre>  

returns a list of tables from the StatFin database that match the query string:  
```
[
    {
        "id":"statfin_ashi_pxt_112n.px",
        "path":"/asu/ashi/kk",
        "title":"112n -- Price index of old dwellings in housing companies (2015=100) and numbers of transactions, monthly, 2015M01-2021M02*",
        "score":0.393164515,
        "published":"2021-03-30T07:50:00"
    },
    {
        "id":"statfin_ashi_pxt_12fv.px",
        "path":"/asu/ashi/nj",
        "title":"12fv -- Price index of new dwellings in housing companies (2015=100) and numbers of transactions, quarterly, 2015Q1-2020Q4",
        "score":0.390204251,
        "published":"2021-01-28T07:52:00"
    }, 
    ...
]
```


### Table metadata
From this, we can take the path and id for table __112n__ and get metadata associated to the table by sending a GET request to:  

<pre>https://pxnet2.stat.fi/PXWeb/api/v1/en/StatFin/asu/ashi/kk/statfin_ashi_pxt_112n.px</pre>  

Table metadata consists of a given table's variables and variables' dimensions, which can be used to either obtain a subset of the table or the full published table. A table's numerical variables listed in the *values* list of the *Tiedot* list item.

``` 
{
   "title":"Price index of old dwellings in housing companies (2015=100) and numbers of transactions, monthly by Region, Building type, Month and Information",
   "variables":[
      {
         "code":"Talotyyppi",
         "text":"Building type",
         "values":["0","1","3"],
         "valueTexts":["Building types total","Terraced houses","Blocks of flats"]
      },
      {
         "code":"Alue",
         "text":"Region",
         "values":["ksu","pks","msu","091","049","092","sat","853","837","564","1","2","3","4"],
         "valueTexts":["Whole country","Greater Helsinki","Whole country excluding Greater Helsinki","Helsinki","Espoo-Kauniainen","Vantaa","Satellite municipalities","Turku","Tampere","Oulu","Southern Finland","Western Finland","Eastern Finland","Northern Finland"]
      },
      {
         "code":"Kuukausi",
         "text":"Month",
         "values":["2015M01","2015M02","2015M03","2015M04","2015M05","2015M06","2015M07","2015M08","2015M09","2015M10","2015M11","2015M12","2016M01","2016M02","2016M03","2016M04","2016M05","2016M06","2016M07","2016M08","2016M09","2016M10","2016M11","2016M12","2017M01","2017M02","2017M03","2017M04","2017M05","2017M06","2017M07","2017M08","2017M09","2017M10","2017M11","2017M12","2018M01","2018M02","2018M03","2018M04","2018M05","2018M06","2018M07","2018M08","2018M09","2018M10","2018M11","2018M12","2019M01","2019M02","2019M03","2019M04","2019M05","2019M06","2019M07","2019M08","2019M09","2019M10","2019M11","2019M12","2020M01","2020M02","2020M03","2020M04","2020M05","2020M06","2020M07","2020M08","2020M09","2020M10","2020M11","2020M12","2021M01","2021M02"],
         "valueTexts":["2015M01","2015M02","2015M03","2015M04","2015M05","2015M06","2015M07","2015M08","2015M09","2015M10","2015M11","2015M12","2016M01","2016M02","2016M03","2016M04","2016M05","2016M06","2016M07","2016M08","2016M09","2016M10","2016M11","2016M12","2017M01","2017M02","2017M03","2017M04","2017M05","2017M06","2017M07","2017M08","2017M09","2017M10","2017M11","2017M12","2018M01","2018M02","2018M03","2018M04","2018M05","2018M06","2018M07","2018M08","2018M09","2018M10","2018M11","2018M12","2019M01","2019M02","2019M03","2019M04","2019M05","2019M06","2019M07","2019M08","2019M09","2019M10","2019M11","2019M12","2020M01*","2020M02*","2020M03*","2020M04*","2020M05*","2020M06*","2020M07*","2020M08*","2020M09*","2020M10*","2020M11*","2020M12*","2021M01*","2021M02*"],
         "time":true
      },
      {
         "code":"Tiedot",
         "text":"Information",
         "values":["keskihinta","ketjutettu_lv","kkmuutos_lv","vmuutos_lv","realind_lv","kkmuutos_realind_lv","vmuutos_realind_lv","lkm_julk_kk","lkm_julk_kvkl","myyntiaika"],
         "valueTexts":[ "Price per square meter (EUR/m2)","Index (2015=100)","Monthly change (index 2015=100)","Annual change (index 2015=100)","Real price index (2015=100)","Monthly change (real price index 2015=100)","Annual change (real price index 2015=100)","Number of sales, asset transfer tax data","Number of sales, real estate agents", "Average time to sale"]
      }
   ]
}
```

### API call
The API call to retrieve a table is made by sending a POST request to the same address that returned table metadata from a GET request.  

The JSON body of the API call consists of two parts:

1. Categorical and numerical variables are defined in the __query__ list
   * Categorical variables are individual query-list items
   * Numerical variables are listed in the values list in the item with code "Tiedot"

2. Output format is defined in the __response__ element. Supported output formats are json, csv, px, xlsx, json-stat and json-stat2.

```
{
   "query":[
      {
         "code":"categoricalVariable1",
         "selection":{
            "filter":"all",
            "values":[
               "*"
            ]
         }
      },
      {
         "code":"Tiedot",
         "selection":{
            "filter":"item",
            "values":[
               "numericalVariable1", 
               "numericalVariable2"
            ]
         }
      }
   ],
   "response":{
      "format":"csv"
   }
}

```

The __selection__ object of a variable is used to retrieve all dimensions or a subset of a variable. 

* When __filter__ is set to "__all__"  
         ```"selection":{"filter":"all","values":["*"]}```  
         ```"selection":{"filter":"all","values":["001*"]}```
    * "*" retrieves all numerical variables
    * "*" retrieves all dimensions of a categorical variable  
    * "001*" retrieves dimensions that start with the value "001"

* When __filter__ is set to "__item__"  
         ```"selection":{"filter":"item","values":["numericVariable1", "numericVariable2",...."numericVariable n"]}```  
         ```"selection":{"filter":"item","values":["code1", "code2",...."code n"]}```  
    * Numerical variables are included or excluded determined by the __values__ list
    * Categorical variables' dimensions are filtered by the values in the __values__ list  

* When __filter__ is set to "__top__"  
         ```"selection":{ "filter":"top","values":["2"]}```
    * Categorical variables' dimensions are filtered based on the integer value of the "values" list
        * E.g. applying the top filter with the value "2" to *Building type* in table __112n__, the API will return data only for "Building types total" and "Terraced houses", as they are the first two dimension in the *Building type* values list

    * Using the top filter on a date variable (e.q. yearly, monthly or quarterly data), will give the *n* most recent datapoints



To retrieve a subset of table __112n__, sending a POST request to:

<pre>https://pxnet2.stat.fi/PXWeb/api/v1/en/StatFin/asu/ashi/kk/statfin_ashi_pxt_112n.px</pre>  

with the following specifications:  
* include only Helsinki (variable code "Alue", value "091")  
* include all housing types (variable code "Talotyyppi")  
* return only price per square meter data (variable code "Tiedot", value "keskihinta") from the previous 6 months (variable code "Kuukausi")

``` 
{
   "query":[
      {
         "code":"Alue",
         "selection":{
            "filter":"item",
            "values":[
               "091"
            ]
         }
      },
      {
         "code":"Talotyyppi",
         "selection":{
            "filter":"all",
            "values":[
               "*"
            ]
         }
      },
      {
         "code":"Kuukausi",
         "selection":{
            "filter":"top",
            "values":[
               "6"
            ]
         }
      },
      {
         "code":"Tiedot",
         "selection":{
            "filter":"item",
            "values":[
                "keskihinta"
            ]
         }
      }
   ],
   "response":{
      "format":"csv"
   }
}
```

The API returns:

|Region  |Building type       |2020M09* Price per square meter (EUR/m2)|2020M10* Price per square meter (EUR/m2)|2020M11* Price per square meter (EUR/m2)|2020M12* Price per square meter (EUR/m2)|2021M01* Price per square meter (EUR/m2)|2021M02* Price per square meter (EUR/m2)|
|--------|--------------------|----------------------------------------|----------------------------------------|----------------------------------------|----------------------------------------|----------------------------------------|----------------------------------------|
|Helsinki|Building types total|4595                                    |4556                                    |4599                                    |4678                                    |4596                                    |4403                                    |
|Helsinki|Terraced houses     |3631                                    |3494                                    |3560                                    |3473                                    |3469                                    |3393                                    |
|Helsinki|Blocks of flats     |4951                                    |4957                                    |4989                                    |5142                                    |5026                                    |4782                                    |


When output format is set to "csv", the API returns only datapoints. Additional table metadata is available if output format is set to "json":

```
{
    "columns": [
        {
            "code": "Alue",
            "text": "Region",
            "comment": "Region\r\n",
            "type": "d"
        },
        {
            "code": "Talotyyppi",
            "text": "Building type",
            "comment": "A classification for different types of dwellings. For example, blocks of flats, attached houses, detached houses. The dwelling price statistics utilise the categories blocks of flats and attached houses. The data on attached houses also include detached houses with shares in a housing corporation.\r\n",
            "type": "d"
        },
        {
            "code": "Kuukausi",
            "text": "Month",
            "comment": "* preliminary data\r\n",
            "type": "t"
        },
        {
            "code": "keskihinta",
            "text": "Price per square meter (EUR/m2)",
            "comment": "Prices per square metre are weighted geometric averages of square metre prices (EUR/m²).\r\nPrices per square metre describe regional differences in price levels and they should not be used to calculate price change.\r\n",
            "type": "c"
        }
    ],
    "comments": [
        {
            "variable": "Kuukausi",
            "value": "2020M09",
            "comment": "* preliminary data\r\n"
        },
        {
            "variable": "Kuukausi",
            "value": "2020M10",
            "comment": "* preliminary data\r\n"
        },
        {
            "variable": "Kuukausi",
            "value": "2020M11",
            "comment": "* preliminary data\r\n"
        },
        {
            "variable": "Kuukausi",
            "value": "2020M12",
            "comment": "* preliminary data\r\n"
        },
        {
            "variable": "Kuukausi",
            "value": "2021M01",
            "comment": "* preliminary data\r\n"
        },
        {
            "variable": "Kuukausi",
            "value": "2021M02",
            "comment": "* preliminary data\r\n"
        }
    ],
    "data": [
        {
            "key": [
                "091",
                "0",
                "2020M09"
            ],
            "values": [
                "4595"
            ]
        },
        .
        .
        .
    ],
    "metadata": [
        {
            "updated": "2021-03-30T05:00:00Z",
            "label": "Price index of old dwellings in housing companies (2015=100) and numbers of transactions, monthly by Region, Building type, Month and Information",
            "source": "Prices of dwellings in housing companies, Statistics Finland"
        }
    ]
}
```

To retrieve the full table, categorical variables can be omitted from the JSON:
```
{
   "query":[
      {
         "code":"Tiedot",
         "selection":{
            "filter":"all",
            "values":[
                "*"
            ]
         }
      }
   ],
   "response":{
      "format":"csv"
   }
}
```

## Troubleshooting

* Make sure that the URL you are trying to send the request to is correct. This can be done by sending a request with a web browser, if the URL is valid, you should receive metadata for the table. Note that the API URL is case sensitive.
* Validate the JSON used in the API call with, for example, [jsonlint](https://jsonlint.com/)
* Configuring the __selection__ element of the JSON incorrectly will cause the API  to return 404
    * If using the __all__ option of __filter__
        * Make sure that you are using the asterisk operator __*__
    * If using the __item__ option of __filter__
        * Do not use the asterisk __*__ operator

## HTTP response codes

|code|meaning                                                                                                    |
|----|-----------------------------------------------------------------------------------------------------------|
|200 |OK                                                                                                         |
|404 |errors in syntax of the query or POST URL not found.                                                       |
|403 |blocking when querying for large data sets. The API limit is now 100,000 cells.                            |
|429 |Too many queries within a minute. The API limit is now 30 queries within 10 seconds.                       |
|503 |Time-out after 60 seconds. It may turn on, when extracting large XLSX datasets. (We do not recommend that).|

## Restrictions
The API's restrictions can be retrieved from:
<pre>https://pxnet2.stat.fi/PXWeb/api/v1/fi/?config</pre>
```
{
   "maxValues":100000,
   "maxCells":100000,
   "maxCalls":20,
   "timeWindow":10,
   "CORS":true
}
```
