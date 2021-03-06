% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/processing.R
\name{add_extra_na_cols}
\alias{add_extra_na_cols}
\title{Add extra columns filled with NA values to a dataset.}
\usage{
add_extra_na_cols(data)
}
\arguments{
\item{data}{A data frame}
}
\value{
A tibble with relevant NA columns added
}
\description{
Adds extra columns filled with NAs to a dataset.
This ensures that all datasets from the covidregionaldata package return
datasets of the same underlying structure (i.e. same columns).
}
\seealso{
Compulsory processing functions
\code{\link{calculate_columns_from_existing_data}()},
\code{\link{complete_cumulative_columns}()},
\code{\link{fill_empty_dates_with_na}()}
}
\concept{compulsory_processing}
