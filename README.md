**Name**: README download_clc.R

**Date**: 22.04.2024

**R version**: 4.3.2

**Author**: Tillman Reuter (tillreuter@gmx.net, github.com/DryocopusMartius)

---

#### This is a documentation file for the automated download process of Corine Land Cover data using the provided "download_clc.R" R-script.

#### The script was created in the course of the doctoral thesis of Moritz Hartig and adapts to the corresponding data needs.

## Datasets: 
CORINE Land Cover 2000 (vector/raster 100 m), Europe, 6-yearly

CORINE Land Cover 2006 (vector/raster 100 m), Europe, 6-yearly

CORINE Land Cover 2012 (vector/raster 100 m), Europe, 6-yearly

CORINE Land Cover 2018 (vector/raster 100 m), Europe, 6-yearly


## Constraints by default:
Area covered (NUTS-Codes and Countries):
- DK Denmark
- DE Germany
- PT Germany
- ES Spain
- SE Sweden

---


download_clc.R therefore automatically retrieves Corine Land Cover data of 2000, 2006, 2012, 2018 of the countries Denmark, Germany, Portugal, Spain, and Sweden. It is commented throughout, so adaptions can be made. To extend the covered area, adapt the vector "nuts_codes". To obtain only the dataset of one year, the code is written in a way that you can delete every line of code that contains any year, that you are not interested in, adapt the vector "task.ids" and delete the blocks of code titled with the years, in which you are not interested in (in the chapter of downloading and unzipping):

Since the datasets are regularly reviewed and updated, file structure or file names may change in the future. Tillman Reuter might post updates under github.com/DryocopusMartius/clc

# Further information:

  ## Copernicus:
  
  https://land.copernicus.eu/en
  
  ## Datasets:
  
  https://image.discomap.eea.europa.eu/arcgis/rest/services/Corine/CLC2000_WM/MapServer
  
  https://image.discomap.eea.europa.eu/arcgis/rest/services/Corine/CLC2006_WM/MapServer
  
  https://image.discomap.eea.europa.eu/arcgis/rest/services/Corine/CLC2012_WM/MapServer
  
  https://image.discomap.eea.europa.eu/arcgis/rest/services/Corine/CLC2018_WM/MapServer
  
  
  https://land.copernicus.eu/api/en/products/corine-land-cover/clc-2000
  
  https://land.copernicus.eu/api/en/products/corine-land-cover/clc-2006
  
  https://land.copernicus.eu/api/en/products/corine-land-cover/clc-2012
  
  https://land.copernicus.eu/api/en/products/corine-land-cover/clc2018 [sic!]
  
  
  ## API:
  
  https://land.copernicus.eu/api/en/how-to-guides/how-to-download-spatial-data/how-to-download-m2m/how-to-download-m2m.pdf

  https://eea.github.io/clms-api-docs/download.html
  

# Citation information:

## Datasets:
- 2000    https://doi.org/10.2909/ddacbd5e-068f-4e52-a596-d606e8de7f40 

- 2006    https://doi.org/10.2909/08560441-2fd5-4eb9-bf4c-9ef16725726a

- 2012    https://doi.org/10.2909/a84ae124-c5c5-4577-8e10-511bfe55cc0d

- 2018    https://doi.org/10.2909/960998c1-1870-4e82-8051-6485205ebbac

## [Reproducibility package]:
  Moritz Hartig
  [20..]
  [...]

## download_clc.R & Documentation:
  Tillman Reuter
  2024


## Packages used in download_clc.R
  baseR
  openssl
  jose
  jsonlite
  httr
  readr
  terra
  
# BibTeX:
  
@misc{hijmans_terra_2023,
	title = {terra: {Spatial} {Data} {Analysis}},
	copyright = {GPL (≥ 3)},
	shorttitle = {terra},
	url = {https://cran.r-project.org/web/packages/terra/},
	urldate = {2023-05-12},
	author = {Hijmans, Robert J. and Bivand, Roger and Pebesma, Edzer and Sumner, Michael D.},
	month = apr,
	year = {2023},
	keywords = {Spatial, SpatioTemporal},
}

@misc{r-core-team_r_2018,
	address = {Vienna, Austria},
	title = {R: {A} {Language} and {Environment} for {Statistical} {Computing}},
	url = {https://www.R-project.org},
	publisher = {R Foundation for Statistical Computing},
	author = {R-Core-Team},
	year = {2018},
}

@misc{wickham_httr_2023,
	title = {httr: {Tools} for {Working} with {URLs} and {HTTP}},
	copyright = {MIT + file LICENSE},
	shorttitle = {httr},
	url = {https://cran.r-project.org/web/packages/httr/index.html},
	urldate = {2024-04-10},
	author = {Wickham, Hadley and Posit and PBC},
	month = aug,
	year = {2023},
	keywords = {WebTechnologies},
}

@misc{ooms__aut_jose_2021,
	title = {jose: {JavaScript} {Object} {Signing} and {Encryption}},
	copyright = {MIT + file LICENSE},
	shorttitle = {jose},
	url = {https://cran.r-project.org/web/packages/jose/index.html},
	urldate = {2024-04-10},
	author = {Ooms  [aut, Jeroen and cre},
	month = nov,
	year = {2021},
}

@misc{ooms__aut_openssl_2023,
	title = {openssl: {Toolkit} for {Encryption}, {Signatures} and {Certificates} {Based} on {OpenSSL}},
	copyright = {MIT + file LICENSE},
	shorttitle = {openssl},
	url = {https://cran.r-project.org/web/packages/openssl/index.html},
	urldate = {2024-04-10},
	author = {Ooms  [aut, Jeroen and cre and Keyes, Oliver},
	month = sep,
	year = {2023},
}

@misc{ooms__aut_jsonlite_2023,
	title = {jsonlite: {A} {Simple} and {Robust} {JSON} {Parser} and {Generator} for {R}},
	copyright = {MIT + file LICENSE},
	shorttitle = {jsonlite},
	url = {https://cran.r-project.org/web/packages/jsonlite/index.html},
	urldate = {2024-04-10},
	author = {Ooms  [aut, Jeroen and cre and Lang, Duncan Temple and libyajl), Lloyd Hilaiel (author of bundled},
	month = dec,
	year = {2023},
	keywords = {WebTechnologies},
}

@misc{wickham_readr_2024,
	title = {readr: {Read} {Rectangular} {Text} {Data}},
	copyright = {MIT + file LICENSE},
	shorttitle = {readr},
	url = {https://cran.r-project.org/web/packages/readr/index.html},
	urldate = {2024-04-10},
	author = {Wickham, Hadley and Hester, Jim and Francois, Romain and Bryan, Jennifer and Bearrows, Shelby and Software, Posit and PBC and library), https://github com/mandreyel/ (mio and implementation), Jukka Jylänki (grisu3 and implementation), Mikkel Jørgensen (grisu3},
	month = jan,
	year = {2024},
	keywords = {WebTechnologies},
}

@misc{reuter_download_clcr_2024,
	title = {download\_clc.{R}},
	author = {Reuter, Tillman},
	year = {2024},
}

@misc{hartig_reproducibility_nodate,
	title = {[{Reproducibility} {Package}]},
	author = {Hartig, Moritz},
}

@misc{european_environment_agency_corine_2020,
	title = {{CORINE} {Land} {Cover} 2000 (raster 100 m), {Europe}, 6-yearly - version 2020\_20u1},
	doi = {10.2909/ddacbd5e-068f-4e52-a596-d606e8de7f40},
	author = {European Environment Agency},
	month = may,
	year = {2020},
}

@misc{european_environment_agency_corine_2020-1,
	title = {{CORINE} {Land} {Cover} 2006 (raster 100 m), {Europe}, 6-yearly - version 2020\_20u1},
	doi = {10.2909/08560441-2fd5-4eb9-bf4c-9ef16725726a},
	author = {European Environment Agency},
	month = may,
	year = {2020},
}

@misc{european_environment_agency_corine_2020-2,
	title = {{CORINE} {Land} {Cover} 2012 (raster 100 m), {Europe}, 6-yearly - version 2020\_20u1},
	doi = {10.2909/a84ae124-c5c5-4577-8e10-511bfe55cc0d},
	author = {European Environment Agency},
	month = may,
	year = {2020},
}

@misc{european_environment_agency_corine_2020-3,
	title = {{CORINE} {Land} {Cover} 2018 (raster 100 m), {Europe}, 6-yearly - version 2020\_20u1},
	doi = {10.2909/960998c1-1870-4e82-8051-6485205ebbac},
	author = {European Environment Agency},
	month = may,
	year = {2020},
}
