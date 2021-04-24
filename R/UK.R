#' United Kingdom Class for downloading, cleaning and processing notification
#' data.
#'
#' @description Extracts daily COVID-19 data for the UK, stratified by region
#' and nation. Additional options for this class are: to return subnational
#' English regions using NHS region boundaries instead of PHE boundaries
#' (nhsregions = TRUE), a release date to download from (release_date) and a
#' geographical resolution (resolution).
#'
# nolint start
#' @source \url{https://coronavirus.data.gov.uk/details/download}
# nolint end
#' @export
#' @concept dataset
#' @examples
#' \dontrun{
#' region <- UK$new(level = "1", verbose = TRUE, steps = TRUE, get = TRUE)
#' region$return()
#' }
UK <- R6::R6Class("UK",
  inherit = DataClass,
  public = list(
    # Core Attributes (amend each paramater for origin specific infomation)
    #' @field origin name of origin to fetch data for
    origin = "United Kingdom (UK)",
    #' @field supported_levels A list of supported levels.
    supported_levels = list("1", "2"),
    #' @field supported_region_names A list of region names in order of level.
    supported_region_names = list("1" = "region", "2" = "authority"),
    #' @field supported_region_codes A list of region codes in order of level.
    supported_region_codes = list(
      "1" = "region_code",
      "2" = "local_authority_code"
    ),
    #' @field common_data_urls List of named links to raw data. The first, and
    #' only entry, is be named main.
    common_data_urls = list(
      "main" = "https://api.coronavirus.data.gov.uk/v2/data"
    ),
    #' @field level_data_urls List of named links to raw data that are level
    #' specific.
    level_data_urls = list(
      "1" = list("nhs_base_url" = "https://www.england.nhs.uk/statistics")
    ),
    #' @field source_data_cols existing columns within the raw data
    source_data_cols = list(
      # Cases by date of specimen
      "newCasesBySpecimenDate", "cumCasesBySpecimenDate",
      # Cases by date of report
      "newCasesByPublishDate", "cumCasesByPublishDate",
      # deaths by date of report
      "newDeaths28DaysByPublishDate", "cumDeaths28DaysByPublishDate",
      # deaths by date of death
      "newDeaths28DaysByDeathDate", "cumDeaths28DaysByDeathDate",
      # Tests - all
      "newTestsByPublishDate", "cumTestsByPublishDate",
      # Hospital - admissions
      "newAdmissions", "cumAdmissions",
      #
      # --- Additional non-standard variables --- #
      # # # Hospital
      # "cumAdmissionsByAge", "covidOccupiedMVBeds",
      # "hospitalCases", "plannedCapacityByPublishDate",
      # Tests by pillar
      "newPillarOneTestsByPublishDate", "newPillarTwoTestsByPublishDate",
      "newPillarThreeTestsByPublishDate", "newPillarFourTestsByPublishDate"
    ),

    #' @description Specific function for getting region codes for UK .
    set_region_codes = function() {
      self$codes_lookup$`2` <- covidregionaldata::uk_codes
    },

    #' @description UK specific `download()` function.
    #' @importFrom purrr map
    #' @importFrom dplyr bind_rows
    download = function() {
      # set up filters
      self$set_filters()
      message_verbose(self$verbose, "Downloading UK data.")
      self$data$raw <- map(self$query_filters, self$download_filter)

      if (self$level == "1") {
        # get NHS data if requested
        if (self$nhsregions) {
          self$data$raw$nhs <- self$download_nhs_regions()
        }
      }
    },

    #' @description Region Level Data Cleaning
    #' @importFrom dplyr bind_rows mutate rename %>%
    #' @importFrom lubridate ymd
    #' @importFrom rlang .data
    clean_level_1 = function() {
      self$data$clean <- bind_rows(
        self$data$raw$nation, self$data$raw$region
      )
      self$data$clean <- self$data$clean %>%
        mutate(
          date = ymd(.data$date),
          # Cases and deaths by specimen date and date of death
          #   for all nations + regions
          cases_new = .data$newCasesBySpecimenDate,
          cases_total = .data$cumCasesBySpecimenDate,
          deaths_new = .data$newDeaths28DaysByDeathDate,
          deaths_total = .data$cumDeaths28DaysByDeathDate
        ) %>%
        # Hospitalisations and tested variables are only available for nations
        # (not regions)
        # sub-national English regions are available in the NHS data below
        # (with arg nhsregions = TRUE)
        rename(
          hosp_new = .data$newAdmissions,
          hosp_total = .data$cumAdmissions,
          tested_new = .data$newTestsByPublishDate,
          tested_total = .data$cumTestsByPublishDate,
          level_1_region = .data$areaName,
          level_1_region_code = .data$areaCode
        )
      if (!is.null(self$release_date)) {
        self$data$clean <- mutate(
          self$data$clean,
          release_date <- self$release_date
        )
      }
      # get NHS data if requested
      if (self$nhsregions) {
        self$data$clean <- self$add_nhs_regions(
          self$data$clean,
          self$data$raw$nhs
        )
      }
    },

    #' @description Level 2 Data Cleaning
    #' @importFrom dplyr mutate rename left_join select %>%
    #' @importFrom lubridate ymd
    #' @importFrom stringr str_detect
    #' @importFrom rlang .data
    clean_level_2 = function() {
      self$data$clean <- self$data$raw[["utla"]] %>%
        mutate(
          date = ymd(.data$date),
          # Cases and deaths are by publish date for Scotland, Wales;
          #   but by specimen date and date of death for England and NI
          cases_new = ifelse(str_detect(.data$areaCode, "^[EN]"),
            .data$newCasesBySpecimenDate,
            .data$newCasesByPublishDate
          ),
          cases_total = ifelse(str_detect(.data$areaCode, "^[EN]"),
            .data$cumCasesBySpecimenDate,
            .data$cumCasesByPublishDate
          ),
          deaths_new = ifelse(str_detect(.data$areaCode, "^[EN]"),
            .data$newDeaths28DaysByDeathDate,
            .data$newDeaths28DaysByPublishDate
          ),
          deaths_total = ifelse(str_detect(.data$areaCode, "^[EN]"),
            .data$cumDeaths28DaysByDeathDate,
            .data$cumDeaths28DaysByPublishDate
          )
        ) %>%
        # Hospitalisations and tested variables are consistent across nations
        rename(
          level_2_region = .data$areaName,
          level_2_region_code = .data$areaCode
        ) %>%
        # Join local authority codes to level 1 regions
        left_join(self$codes_lookup[["2"]],
          by = "level_2_region"
        ) %>%
        rename(level_2_region_code = .data$level_2_region_code.x) %>%
        select(-.data$level_2_region_code.y) %>%
        mutate(
          level_1_region = ifelse(grepl("^W", .data$level_2_region_code),
            "Wales",
            ifelse(grepl("^S", .data$level_2_region_code),
              "Scotland",
              ifelse(grepl("^N", .data$level_2_region_code),
                "Northern Ireland", .data$level_1_region
              )
            )
          ),
          level_1_region_code = ifelse(
            .data$level_1_region == "Scotland", "S92000003",
            ifelse(.data$level_1_region == "Wales", "W92000004",
              ifelse(.data$level_1_region == "Northern Ireland",
                "N92000002", .data$level_1_region_code
              )
            )
          )
        )

      if (!is.null(self$release_date)) {
        self$data$clean <- dplyr::mutate(self$data$clean,
          release_date = self$release_date
        )
      }
    },

    #' @description Initalize the UK Class
    #' @export
    #' @param nhsregions Return subnational English regions using NHS region
    #' boundaries instead of PHE boundaries.
    #' @param release_date Date data was released. Default is to extract
    #' latest release. Dates should be in the format "yyyy-mm-dd".
    #' @param resolution "utla" (default) or "ltla", depending on which
    #' geographical resolution is preferred
    #' @param ... Optional arguments passed to [DataClass()] initalize.
    #' @examples
    #' \dontrun{
    #' UK$new(
    #'  level = 1, localise = TRUE,
    #'  verbose = True, steps = FALSE,
    #'  nhsregions = FALSE, release_date = NULL,
    #'  resolution = "utla"
    #' )
    #' }
    initialize = function(nhsregions = FALSE, release_date = NULL,
                          resolution = "utla", ...) {
      self$nhsregions <- nhsregions
      self$release_date <- release_date
      self$resolution <- resolution
      super$initialize(...)
    },

    #' @field query_filters Set what filters to use to query the data
    query_filters = NA,
    #' @field nhsregions Whether to include NHS regions in the data
    nhsregions = FALSE,
    #' @field release_date The release date for the data
    release_date = NA,
    #' @field resolution The resolution of the data to return
    resolution = "utla",
    #' @field authority_data The raw data for creating authority lookup tables
    authority_data = NA,

    #' @description Helper function for downloading data API
    #' @importFrom purrr map safely compact reduce
    #' @importFrom dplyr full_join mutate
    #' @param filter region filters
    download_filter = function(filter) {
      # build a list of download links as limited to 4 variables per request
      csv_links <- map(
        1:(ceiling(length(self$source_data_cols) / 4)),
        ~ paste0(
          self$data_urls[["main"]], "?", unlist(filter), "&",
          paste(paste0(
            "metric=",
            self$source_data_cols[(1 + 4 * (. - 1)):min(
              (4 * .), length(self$source_data_cols)
            )]
          ),
          collapse = "&"
          ),
          "&format=csv"
        )
      )
      # add in release data if defined
      if (!is.null(self$release_date)) {
        csv_links <- map(csv_links, ~ paste0(
          .,
          "&release=",
          self$release_date
        ))
      }
      # download and link all data into a single data frame
      safe_reader <- safely(csv_reader)
      csv <- map(csv_links, ~ safe_reader(., verbose = self$verbose)[[1]])
      csv <- compact(csv)
      csv <- reduce(csv, full_join,
        by = c("date", "areaType", "areaCode", "areaName")
      )
      if (is.null(csv)) {
        stop("Data retrieval failed")
      }
      # add release date as variable if missing
      if (!is.null(self$release_date)) {
        csv <- mutate(
          csv,
          release_date = as.Date(self$release_date)
        )
      }
      return(csv)
    },

    #' @description Set filters for UK data api query.
    set_filters = function() {
      if (self$level == "1") {
        self$query_filters <- list(
          nation = "areaType=nation",
          region = "areaType=region"
        )
      } else if (self$level == "2") {
        self$resolution <- match.arg(self$resolution,
          choices = c("utla", "ltla")
        )
        self$query_filters <- list(
          paste("areaType", self$resolution, sep = "=")
        )
        names(self$query_filters) <- self$resolution
      } else {
        stop(paste("UK data not supported for level", self$level))
      }
    },

    #' @description Download NHS data for level 1 regions
    #' Separate NHS data is available for "first" admissions, excluding
    #' readmissions. This is available for England + English regions only.
    # nolint start
    #'   See: \url{https://www.england.nhs.uk/statistics/statistical-work-areas/covid-19-hospital-activity/}
    # nolint end
    #'     Section 2, "2. Estimated new hospital cases"
    #' @return nhs data.frame of nhs regions
    # nolint start
    #' @source \url{https://coronavirus.data.gov.uk/details/download}
    # nolint end
    #' @importFrom lubridate year month
    #' @importFrom readxl read_excel cell_limits
    #' @importFrom dplyr %>%
    download_nhs_regions = function() {
      if (is.null(self$release_date)) {
        self$release_date <- Sys.Date() - 1
      }
      if (self$release_date < (Sys.Date() - 7)) {
        stop("Data by NHS regions is only available in archived form for the
             last 7 days")
      }
      message_verbose(
        self$verbose,
        "Arranging data by NHS region. Also adding new variable:
        hosp_new_first_admissions. This is NHS data for first hospital
        admissions, which excludes readmissions. This is available for
        England and English regions only."
      )
      nhs_url <- paste0(
        self$data_urls[["nhs_base_url"]],
        "/wp-content/uploads/sites/2/",
        year(self$release_date), "/",
        ifelse(month(self$release_date) < 10,
          paste0(0, month(self$release_date)),
          month(self$release_date)
        ),
        "/COVID-19-daily-admissions-and-beds-",
        gsub("-", "", as.character(self$release_date)),
        ".xlsx"
      )
      tmp <- file.path(tempdir(), "nhs.xlsx")
      download.file(nhs_url,
        destfile = tmp,
        mode = "wb", quiet = !(self$verbose)
      )
      nhs <- suppressMessages(
        read_excel(tmp,
          sheet = 1,
          range = cell_limits(c(28, 2), c(36, NA))
        ) %>%
          t()
      )
      return(as.data.frame(nhs))
    },

    #' @description Add NHS data for level 1 regions
    #' Separate NHS data is available for "first" admissions, excluding
    #' readmissions. This is available for England + English regions only.
    # nolint start
    #'   See: \url{https://www.england.nhs.uk/statistics/statistical-work-areas/covid-19-hospital-activity/}
    # nolint end
    #'     Section 2, "2. Estimated new hospital cases"
    #' @importFrom lubridate year month
    #' @importFrom readxl read_excel cell_limits
    #' @importFrom tibble as_tibble
    #' @importFrom dplyr mutate select %>% group_by summarise left_join
    #' @importFrom tidyr pivot_longer
    #' @param clean_data Cleaned UK covid-19 data
    #' @param nhs_data NHS region data
    add_nhs_regions = function(clean_data, nhs_data) {
      colnames(nhs_data) <- nhs_data[1, ]
      nhs_data <- nhs_data[2:nrow(nhs_data), ]
      nhs_data <- nhs_data %>%
        as_tibble() %>%
        mutate(date = seq.Date(
          from = as.Date("2020-08-01"),
          by = 1,
          length.out = nrow(.)
        )) %>%
        pivot_longer(-date,
          names_to = "level_1_region",
          values_to = "hosp_new_first_admissions"
        ) %>%
        mutate(
          level_1_region = ifelse(level_1_region == "ENGLAND",
            "England", level_1_region
          ),
          hosp_new_first_admissions = as.numeric(hosp_new_first_admissions)
        )

      # Merge PHE data into NHS regions ---------------------------------------
      clean_data <- clean_data %>%
        select(-.data$level_1_region_code) %>%
        mutate(
          level_1_region = ifelse(
            .data$level_1_region == "East Midlands" | .data$level_1_region == "West Midlands", # nolint
            "Midlands",
            .data$level_1_region
          ),
          level_1_region = ifelse(
            .data$level_1_region == "Yorkshire and The Humber" | .data$level_1_region == "North East", # nolint
            "North East and Yorkshire", .data$level_1_region
          )
        ) %>%
        group_by(date, .data$level_1_region) %>%
        summarise(
          cases_new = sum(.data$cases_new),
          cases_total = sum(.data$cases_total),
          deaths_new = sum(.data$deaths_new),
          deaths_total = sum(.data$deaths_total),
          hosp_new = sum(.data$hosp_new),
          hosp_total = sum(.data$hosp_total),
          .groups = "drop"
        )

      # Merge PHE and NHS data
      clean_data <- left_join(
        clean_data, nhs_data,
        by = c("level_1_region", "date")
      ) %>%
        # Create a blended variable that uses "all" hospital admissions
        # (includes readmissions) for devolved nations and "first" hospital
        # admissions for England + English regions
        mutate(
          hosp_new_blend = ifelse(
            .data$level_1_region %in% c(
              "Wales",
              "Scotland",
              "Northern Ireland"
            ),
            .data$hosp_new, .data$hosp_new_first_admissions
          ),
          level_1_region_code = NA,
          release_date = self$release_date
        )
      return(clean_data)
    }
  )
)