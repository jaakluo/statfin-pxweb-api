/*
Parameters:
    url               e.g. -- https://pxnet2.stat.fi/PXWeb/api/v1/en/StatFin/yri/alyr/statfin_alyr_pxt_11ak.px
    json_body         Path to json file used as the body in the API call
                      e.g. -- D:\statfin-pxweb-api\json\tableid.json
    output_data       Name of output data
                      e.g. -- statfin_11ak
    out_dir           (optional) Directory to store http responses, if not used files 
                      are written into the work library
                      e.g  -- D:\statfin-pxweb-api\responses\
    http_options      (optional) Additional SAS options used in proc http, 
                      see SAS documentation
                      e.g. -- %str(
                                   proxyhost ="http://your_proxy.com:portnumber"
                                   ct        ="application/json"
                               )
    rename_variables  (optional) SAS datastep code. The CSV returned by the API contains 
                      spaces in variable names, and variable names can be over 32 bytes long. 
		      If two variables have identical names until 32 bytes, the first variable will be 
                      dropped when imported.
                      e.g. -- %str(
                                  content =tranwrd(content, "long variable name 1...",	"short_name_var1");
                                  content =tranwrd(content, "long variable name 2...",	"short_name_var2");
                              )
    Example:
        %get_px_table(
             url          =https://pxnet2.stat.fi/PXWeb/api/v1/en/StatFin/yri/alyr/statfin_alyr_pxt_11ak.px,
             json_body    =D:\statfin-px-api\examples\json\statfin_11ak_top1.json,
             output_data  =statfin_11ak_renamed,
	     out_dir      =D:\statfin-px-api\examples\responses\,
	     rename_variables =%str(
		        content=tranwrd(content, "Turnover of establishments of enterprises (EUR 1,000)",	
                                "turnover");
		        content=tranwrd(content, "Turnover of establishments of enterprises per person (EUR 1,000)",	
                                "turnover_per_person");
	         ),
	     http_options  =%str(
		        proxyhost   ="&config_proxy."
	         )
        );
*/

%macro get_px_table(
	url,
	json_body,
	output_data,
	out_dir          =,
	http_options     =,
	rename_variables =
);

	%if not %sysfunc(length(%quote(&out_dir.))) %then %do;
		%let out_dir=%sysfunc(getoption(work));
	%end;

	filename BODY   "&out_dir.response_body.txt";
	filename HEADER "&out_dir.response_header.txt";

	%put ----------------------------------------------;
	%put NOTE: HTTP response header and body saved to files:;
	%put NOTE: %sysfunc(pathname(BODY));
	%put NOTE: %sysfunc(pathname(HEADER));
	%put ----------------------------------------------;

	filename JSONIN "&json_body.";

	proc http
		url          ="&url."
		method       ="post"
		out          =BODY
		in           =JSONIN
		headerout    =HEADER
		&http_options.
	;
	run;

	/*  
		SAS converts numerical variables that have "...", 
		".." or "-" values to character format. 
		Changing these to "." values so that numerical 
		variables stay as numerical variables in the output dataset. 
	*/
	filename BODYMOD "&out_dir.response_body_modified.csv";

	data _null_;
		length 	content   $32767.;
		infile 	BODY      delimiter="|";

		file 	BODYMOD;
		input 	content $;

		if _n_=1 then do;
		    &rename_variables.
		end;
		
		/* between commas -> ,..., */
		content  =prxchange('s/(?<=\,)(\-)(?=\,)/./',    -1,content);
		content  =prxchange('s/(?<=\,)([.]{3})(?=\,)/./',-1,content);
		content  =prxchange('s/(?<=\,)([.]{2})(?=\,)/./',-1,content);

		/* line ends with successive dots or a dash */
		content  =prxchange('s/-$/./',     -1, strip(content));
		content  =prxchange('s/[.]{3}$/./',-1, strip(content));
		content  =prxchange('s/[.]{2}$/./',-1, strip(content));

		put content;
	run;

	proc import 
		datafile  =BODYMOD
		dbms      =csv
		out       =&output_data.
		replace
		;
		guessingrows=max
		;
		delimiter    =","
		;
	run;

%mend get_px_table;
