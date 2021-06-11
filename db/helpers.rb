require 'pg'

def run_sql(sql, params = [])
    db = PG.connect(ENV['DATABASE_URL'] || {dbname: 'project_2'})
    # db.exec_params("select * from dishes where id = $1", [params["id"]])
    # res = db.exec(sql)
    res = db.exec_params(sql, params)
    db.close
    return res
end

