name: Readme downloader.R
date: 08.04.2024
R version: 4.3.2
author: Tillman Reuter (tillreuter@gmx.net, github.com/DryocopusMartius)


This is a documentation file for the automated download process of Corine Land Use Cover data using the provided "downloader.R" R-script.

The script was created in the course of the doctoral thesis of Moritz Hartig and adapts to the corresponding data needs.

Names of the datasets: 
CORINE Land Cover 2000 (vector/raster 100 m), Europe, 6-yearly
CORINE Land Cover 2006 (vector/raster 100 m), Europe, 6-yearly
CORINE Land Cover 2012 (vector/raster 100 m), Europe, 6-yearly
CORINE Land Cover 2018 (vector/raster 100 m), Europe, 6-yearly


Constraints by default:
  Area covered (NUTS-Codes and Countries):
    DK Denmark
    DE Germany
    PT Germany
    ES Spain
    SE Sweden


downloader.R therefore automatically retrieves Corine Land Use Cover data of 2000, 2006, 2012, 2018 of the countries Denmark, Germany, Portugal, Spain, and Sweden. It is commented throughout, so adaptions can be made. To extend the covered area, adapt the vector "nuts_codes". To obtain only the dataset of one year, the code is written in a way that you can delete every line of code that contains any year, that you are not interested in, adapt the vector "task.ids" and delete the blocks of code titled with the years, you are not interested in (in the chapter of downloading and unzipping)

Further information:




Citation information:

Datasets:
  doi 2000    https://doi.org/10.2909/ddacbd5e-068f-4e52-a596-d606e8de7f40 
  doi 2006    https://doi.org/10.2909/08560441-2fd5-4eb9-bf4c-9ef16725726a
  doi 2012    https://doi.org/10.2909/a84ae124-c5c5-4577-8e10-511bfe55cc0d
  doi 2018    https://doi.org/10.2909/960998c1-1870-4e82-8051-6485205ebbac

[Reproducibility package]:

  Moritz Hartig
  [20..]
  [...]

downloader.R & Documentation:
  Tillman Reuter
  2024


Packages used in downloader.R

  base R
  openssl
  jose
  jsonlite
  httr
  readr
  terra