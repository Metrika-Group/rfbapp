##SQLITE
library(DBI)
library(RSQLite)


conn <- dbConnect(
  RSQLite::SQLite(),
  "inst/creavar/rfbapp_web/temp.sqlite3"
)

create_mtcars_query = "CREATE TABLE newtable (
  uid                             INTEGER PRIMARY KEY  AUTOINCREMENT,
  model                           TEXT,
  mpg                             REAL,
  cyl                             REAL,
  disp                            REAL,
  hp                              REAL,
  drat                            REAL,
  wt                              REAL,
  qsec                            REAL,
  vs                              TEXT,
  am                              TEXT,
  gear                            REAL,
  carb                            REAL
)"

DBI::dbExecute(conn, "DROP TABLE IF EXISTS newtable")

# Execute the query created above
DBI::dbExecute(conn, create_mtcars_query)

##insertar sin usar el nombre del as columnas
dbExecute(conn, "INSERT INTO newtable VALUES ('1','corvet',160.0,110,3.90,2.620,16.46,0,1,'res1','res2', 12.2,32.12)")

##insertar valores usando el nombre de las columnas
dbExecute(conn, "INSERT INTO newtable (model, mpg, cyl, disp, hp, drat, wt, qsec, vs,am, gear, carb)
                 VALUES ('corvet',160.0,110,3.90,2.620,16.46,0,1,'res1', 'res2', 12.2,32.12)")

#cerrar la conexion de la tabla y la base de datso
dbDisconnect(conn)


##comprobando la insercion de la tabla
#conectamos la base de datos
conn <- dbConnect(RSQLite::SQLite(), "inst/creavar/rfbapp_web/temp.sqlite3")
#verificamos los datos de la tabla
dbGetQuery(conn, 'SELECT * FROM newtable')
a1 <- dbGetQuery(conn, "SELECT COUNT(uid) FROM newtable") %>% dplyr::nth(1)

dbExecute(conn, "INSERT INTO newtable VALUES (corvet',160.0,110,3.90,2.620,16.46,0,1,'res1', 'res2', 12.2,32.12)")

dbExecute(conn, "INSERT INTO newtable (model, mpg, cyl, disp, hp, drat, wt, qsec, vs,am, gear, carb)
                 VALUES ('corvet',160.0,110,3.90,2.620,16.46,0,1,'res1', 'res2', 12.2, NULL)")

dbExecute(conn, "INSERT INTO vartable (trait, format, defaultValue, minimum,                         
                                       maximum, details, categories, isVisible, realPosition)
                 VALUES ('corvet','a1','b2', 160.0,110,3.90,2.620,16.46,0,1)")



dbGetQuery(conn, 'SELECT * FROM newtable')


dbDisconnect(conn)



#### Referencias

#https://cran.r-project.org/web/packages/RSQLite/vignettes/RSQLite.html
#https://www.datacamp.com/community/tutorials/sqlite-in-r
#https://stackoverflow.com/questions/65818056/create-sqlite-table-with-primary-key-in-r
#Video CRUD in R https://www.youtube.com/watch?v=7bC_2AfDULc
#ejemplo: https://stackoverflow.com/questions/48719266/how-to-ensure-unique-ids-when-inserting-into-sqlite-database-in-r-shiny
