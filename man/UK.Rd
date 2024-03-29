% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/UK.R
\name{UK}
\alias{UK}
\title{United Kingdom Class for downloading, cleaning and processing notification
data.}
\source{
\url{https://coronavirus.data.gov.uk/details/download}

\url{https://coronavirus.data.gov.uk/details/download}
}
\description{
Extracts daily COVID-19 data for the UK, stratified by region
and nation. Additional options for this class are: to return subnational
English regions using NHS region boundaries instead of PHE boundaries
(nhsregions = TRUE), a release date to download from (release_date) and a
geographical resolution (resolution).
}
\examples{
\dontrun{
# setup a data cache
start_using_memoise()

# download, clean and process level 1 UK data with hospital admissions
region <- UK$new(level = "1", nhsregions = TRUE)
region$return()

# initialise level 2 data
utla <- UK$new(level = "2")

# download UTLA data
utla$download()

# clean UTLA data
utla$clean()

# inspect available level 1 regions
utla$available_regions(level = "1")

# filter data to the East of England
utla$filter("East of England")

# process UTLA data
utla$process()

# return processed and filtered data
utla$return()

# inspect all data steps
utla$data
}

## ------------------------------------------------
## Method `UK$new`
## ------------------------------------------------

\dontrun{
UK$new(
 level = 1, localise = TRUE,
 verbose = True, steps = FALSE,
 nhsregions = FALSE, release_date = NULL,
 resolution = "utla"
)
}
}
\seealso{
Subnational data sources
\code{\link{Belgium}},
\code{\link{Brazil}},
\code{\link{Canada}},
\code{\link{Colombia}},
\code{\link{Covid19DataHub}},
\code{\link{Cuba}},
\code{\link{Estonia}},
\code{\link{France}},
\code{\link{Germany}},
\code{\link{Google}},
\code{\link{India}},
\code{\link{Italy}},
\code{\link{JHU}},
\code{\link{Lithuania}},
\code{\link{Mexico}},
\code{\link{Netherlands}},
\code{\link{SouthAfrica}},
\code{\link{Switzerland}},
\code{\link{USA}}
}
\concept{dataset}
\concept{subnational}
\section{Super class}{
\code{\link[covidregionaldata:DataClass]{covidregionaldata::DataClass}} -> \code{UK}
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{origin}}{name of origin to fetch data for}

\item{\code{supported_levels}}{A list of supported levels.}

\item{\code{supported_region_names}}{A list of region names in order of level.}

\item{\code{supported_region_codes}}{A list of region codes in order of level.}

\item{\code{common_data_urls}}{List of named links to raw data. The first, and
only entry, is be named main.}

\item{\code{level_data_urls}}{List of named links to raw data that are level
specific.}

\item{\code{source_data_cols}}{existing columns within the raw data}

\item{\code{source_text}}{Plain text description of the source of the data}

\item{\code{source_url}}{Website address for explanation/introduction of the
data}

\item{\code{query_filters}}{Set what filters to use to query the data}

\item{\code{nhsregions}}{Whether to include NHS regions in the data}

\item{\code{release_date}}{The release date for the data}

\item{\code{resolution}}{The resolution of the data to return}

\item{\code{authority_data}}{The raw data for creating authority lookup tables}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-set_region_codes}{\code{UK$set_region_codes()}}
\item \href{#method-download}{\code{UK$download()}}
\item \href{#method-clean_level_1}{\code{UK$clean_level_1()}}
\item \href{#method-clean_level_2}{\code{UK$clean_level_2()}}
\item \href{#method-new}{\code{UK$new()}}
\item \href{#method-download_filter}{\code{UK$download_filter()}}
\item \href{#method-set_filters}{\code{UK$set_filters()}}
\item \href{#method-download_nhs_regions}{\code{UK$download_nhs_regions()}}
\item \href{#method-add_nhs_regions}{\code{UK$add_nhs_regions()}}
\item \href{#method-specific_tests}{\code{UK$specific_tests()}}
\item \href{#method-clone}{\code{UK$clone()}}
}
}
\if{html}{
\out{<details ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="covidregionaldata" data-topic="DataClass" data-id="available_regions">}\href{../../covidregionaldata/html/DataClass.html#method-available_regions}{\code{covidregionaldata::DataClass$available_regions()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="covidregionaldata" data-topic="DataClass" data-id="clean">}\href{../../covidregionaldata/html/DataClass.html#method-clean}{\code{covidregionaldata::DataClass$clean()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="covidregionaldata" data-topic="DataClass" data-id="clean_common">}\href{../../covidregionaldata/html/DataClass.html#method-clean_common}{\code{covidregionaldata::DataClass$clean_common()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="covidregionaldata" data-topic="DataClass" data-id="download_JSON">}\href{../../covidregionaldata/html/DataClass.html#method-download_JSON}{\code{covidregionaldata::DataClass$download_JSON()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="covidregionaldata" data-topic="DataClass" data-id="filter">}\href{../../covidregionaldata/html/DataClass.html#method-filter}{\code{covidregionaldata::DataClass$filter()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="covidregionaldata" data-topic="DataClass" data-id="get">}\href{../../covidregionaldata/html/DataClass.html#method-get}{\code{covidregionaldata::DataClass$get()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="covidregionaldata" data-topic="DataClass" data-id="process">}\href{../../covidregionaldata/html/DataClass.html#method-process}{\code{covidregionaldata::DataClass$process()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="covidregionaldata" data-topic="DataClass" data-id="return">}\href{../../covidregionaldata/html/DataClass.html#method-return}{\code{covidregionaldata::DataClass$return()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="covidregionaldata" data-topic="DataClass" data-id="summary">}\href{../../covidregionaldata/html/DataClass.html#method-summary}{\code{covidregionaldata::DataClass$summary()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="covidregionaldata" data-topic="DataClass" data-id="test">}\href{../../covidregionaldata/html/DataClass.html#method-test}{\code{covidregionaldata::DataClass$test()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-set_region_codes"></a>}}
\if{latex}{\out{\hypertarget{method-set_region_codes}{}}}
\subsection{Method \code{set_region_codes()}}{
Specific function for getting region codes for UK .
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{UK$set_region_codes()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-download"></a>}}
\if{latex}{\out{\hypertarget{method-download}{}}}
\subsection{Method \code{download()}}{
UK specific \code{download()} function.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{UK$download()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clean_level_1"></a>}}
\if{latex}{\out{\hypertarget{method-clean_level_1}{}}}
\subsection{Method \code{clean_level_1()}}{
Region Level Data Cleaning
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{UK$clean_level_1()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clean_level_2"></a>}}
\if{latex}{\out{\hypertarget{method-clean_level_2}{}}}
\subsection{Method \code{clean_level_2()}}{
Level 2 Data Cleaning
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{UK$clean_level_2()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\if{latex}{\out{\hypertarget{method-new}{}}}
\subsection{Method \code{new()}}{
Initalize the UK Class
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{UK$new(nhsregions = FALSE, release_date = NULL, resolution = "utla", ...)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{nhsregions}}{Return subnational English regions using NHS region
boundaries instead of PHE boundaries.}

\item{\code{release_date}}{Date data was released. Default is to extract
latest release. Dates should be in the format "yyyy-mm-dd".}

\item{\code{resolution}}{"utla" (default) or "ltla", depending on which
geographical resolution is preferred}

\item{\code{...}}{Optional arguments passed to \code{\link[=DataClass]{DataClass()}} initalize.}
}
\if{html}{\out{</div>}}
}
\subsection{Examples}{
\if{html}{\out{<div class="r example copy">}}
\preformatted{\dontrun{
UK$new(
 level = 1, localise = TRUE,
 verbose = True, steps = FALSE,
 nhsregions = FALSE, release_date = NULL,
 resolution = "utla"
)
}
}
\if{html}{\out{</div>}}

}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-download_filter"></a>}}
\if{latex}{\out{\hypertarget{method-download_filter}{}}}
\subsection{Method \code{download_filter()}}{
Helper function for downloading data API
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{UK$download_filter(filter)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{filter}}{region filters}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-set_filters"></a>}}
\if{latex}{\out{\hypertarget{method-set_filters}{}}}
\subsection{Method \code{set_filters()}}{
Set filters for UK data api query.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{UK$set_filters()}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-download_nhs_regions"></a>}}
\if{latex}{\out{\hypertarget{method-download_nhs_regions}{}}}
\subsection{Method \code{download_nhs_regions()}}{
Download NHS data for level 1 regions
Separate NHS data is available for "first" admissions, excluding
readmissions. This is available for England + English regions only.
Data are available separately for the periods 2020-08-01 to 2021-04-06,
and 2021-04-07 - present.
See: \url{https://www.england.nhs.uk/statistics/statistical-work-areas/covid-19-hospital-activity/}
Section 2, "2. Estimated new hospital cases"
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{UK$download_nhs_regions()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
nhs data.frame of nhs regions
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-add_nhs_regions"></a>}}
\if{latex}{\out{\hypertarget{method-add_nhs_regions}{}}}
\subsection{Method \code{add_nhs_regions()}}{
Add NHS data for level 1 regions
Separate NHS data is available for "first" admissions, excluding
readmissions. This is available for England + English regions only.
See: \url{https://www.england.nhs.uk/statistics/statistical-work-areas/covid-19-hospital-activity/}
Section 2, "2. Estimated new hospital cases"
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{UK$add_nhs_regions(clean_data, nhs_data)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{clean_data}}{Cleaned UK covid-19 data}

\item{\code{nhs_data}}{NHS region data}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-specific_tests"></a>}}
\if{latex}{\out{\hypertarget{method-specific_tests}{}}}
\subsection{Method \code{specific_tests()}}{
Specific tests for UK data. In addition to generic tests ran
by \code{DataClass$test()} data for NHS regions are downloaded and ran through
the same generic checks (test_cleaning, test_processing, test_return). If
download = TRUE or a snapshot file is not found, the nhs data is
downloaded and saved to the snapshot location provided. If an existing
snapshot file is found then this data is used in the next tests.
Tests data can be downloaded, cleaned, processed and returned. Designed
to be ran from \code{test} and not ran directly.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{UK$specific_tests(
  self_copy,
  download = FALSE,
  all = FALSE,
  snapshot_path = "",
  ...
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{self_copy}}{R6class the object to test.}

\item{\code{download}}{logical. To download the data (TRUE) or use a snapshot
(FALSE). Defaults to FALSE.}

\item{\code{all}}{logical. Run tests with all settings (TRUE) or with those
defined in the current class instance (FALSE). Defaults to FALSE.}

\item{\code{snapshot_path}}{character_array the path to save the downloaded
snapshot to. Works on the snapshot path constructed by \code{test} but adds}

\item{\code{...}}{Additional parameters to pass to \code{specific_tests}}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\if{latex}{\out{\hypertarget{method-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{UK$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
