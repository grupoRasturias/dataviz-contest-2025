# Data visualization contest with R: fourth edition

## About the contest

1. On **February 15th 2025, the database base will be made publicly available** updating this repository. Anybody will be able to participate sending a plot made with [R](https://www.r-project.org/).

2. The project submission period will be open **from the day the data is published (February 15, 2025) until 11:59 PM on March 31, 2025**. Participants must send an email to [grupo.usuarios.r.asturias\@gmail.com](mailto:grupousuariosrasturias@gmail.com) with their visualization or a URL linking to it, in their preferred format. Please refer to **point seven** of the [contest rules](bases_en.md) for detailed email submission guidelines.

3. The jury will issue its **final decision throught April, 2025**. The declaration will be made public on this repository and our [Twitter](https://twitter.com/grupoRasturias) account, and the winners will be notified by e-mail.

4. The price amount is **three hundred euros (300 €)** for the first prize and **one hundred euros (100 €)** for the second prize.

5. Contest's rules and further instructions can be accesed within this [repository](bases_en.md).

## About the data

For this edition, we have selected the `school` database from the `collegeScorecard` package. For more information about the database and the meaning of each variable, you can visit the official documentation [here](https://vincentarelbundock.github.io/Rdatasets/doc/collegeScorecard/school.html).

```R
install.packages('collegeScorecard')
library(collegeScorecard)

school
# id name          city  state zip   latitude longitude url   deg_predominant
#     <int> <chr>         <chr> <chr> <chr>    <dbl>     <dbl> <chr> <fct>          
#  1 100654 Alabama A & … Norm… AL    35762     34.8     -86.6 http… Bachelor       
#  2 100663 University o… Birm… AL    3529…     33.5     -86.8 http… Bachelor       
#  3 100672 Alabama Avia… Ozark AL    36360     NA        NA   NA    Associate      
#  4 100690 Amridge Univ… Mont… AL    3611…     32.4     -86.2 http… Bachelor       
#  5 100706 University o… Hunt… AL    35899     34.7     -86.6 http… Bachelor 
```
