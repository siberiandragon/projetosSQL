select * from pctabprcli c
join pclogcadastro e on c.rowid = e.rowidcampo
order by datalog desc