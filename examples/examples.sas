
%let root =D:\statfin-pxweb-api;

%include "&root.\src\get_px_table.sas";
%include "&root.\examples\config.sas";

/* 
	Not defining out_dir will write http response in work 	
	folder (see log where work is located). 
*/
%get_px_table(
	url           =https://pxnet2.stat.fi/PXWeb/api/v1/en/StatFin/asu/ashi/kk/statfin_ashi_pxt_112n.px,
	json_body     =&root.\examples\json\statfin_112n.json,
	output_data   =statfin_112n,
	http_options  =%str(
		proxyhost  ="&config_proxy."
	)
);

/*  
	Statfin table 11ak has two numerical variables that are identical until 
	32 characters (SAS has a max length of 32 bytes for variable names).
    When using proc import, the latter variable will override the former 
	variable (which ends up being dropped).
*/
%get_px_table(
	url          =https://pxnet2.stat.fi/PXWeb/api/v1/en/StatFin/yri/alyr/statfin_alyr_pxt_11ak.px,
	json_body    =&root.\examples\json\statfin_11ak_top1.json,
	output_data  =statfin_11ak,
	out_dir      =&root.\examples\responses\,
	http_options =%str(
		proxyhost  ="&config_proxy."
	)
);


/*  
	Rename the two similarly named variables with the 
	"rename_variables" parameter so that both are included in the output dataset.
*/
%get_px_table(
	url          =https://pxnet2.stat.fi/PXWeb/api/v1/en/StatFin/yri/alyr/statfin_alyr_pxt_11ak.px,
	json_body    =&root.\examples\json\statfin_11ak_top1.json,
	output_data  =statfin_11ak_renamed,
	out_dir      =&root.\examples\responses\,
	rename_variables =%str(
		content=tranwrd(content, "Turnover of establishments of enterprises (EUR 1,000)",	"turnover");
		content=tranwrd(content, "Turnover of establishments of enterprises per person (EUR 1,000))",	"turnover_per_person");
	),
	http_options  =%str(
		proxyhost   ="&config_proxy."
	)
);
