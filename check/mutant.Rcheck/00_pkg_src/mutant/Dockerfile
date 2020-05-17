FROM rocker/r-ubuntu:20.04
WORKDIR /mutant
COPY . .
RUN apt update && apt install \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev
RUN Rscript -e "install.packages(c('devtools'), repos='http://cran.rstudio.com')"
RUN Rscript -e "install.packages('remotes')" \
            -e "remotes::install_deps(dependencies = TRUE)" \
            -e "remotes::install_cran('rcmdcheck')"
RUN Rscript -e "rcmdcheck::rcmdcheck(args = '--no-manual', check_dir = 'check')"
