.pragma library

var db;

function openDB()
{
    db = openDatabaseSync("SmoozeDB","1.0","Smooze Database",10);
    createTable();
}

function createTable()
{
    db.transaction(
                function(tx) {
                    tx.executeSql("CREATE TABLE IF NOT EXISTS smoozeconfig (configkey TEXT DEFAULT 'resumeplaying', configvalue TEXT DEFAULT 'false')");
                }
                )
}

function dropTable()
{
    db.transaction(
                function(tx) {
                    tx.executeSql("DROP TABLE IF EXISTS smoozeconfig");
                }
                )
}

function createConfig(configItem)
{
    db.transaction(
                function(tx) {
                    tx.executeSql("INSERT INTO smoozeconfig (configkey, configvalue) VALUES(?,?)",[configItem.configkey, configItem.configvalue]);
                }
                )
}

function deleteConfig(configkey)
{
    db.transaction(
                function(tx) {
                    tx.executeSql("DELETE FROM smoozeconfig WHERE configkey = ?", [configkey]);
                }
                )
}

function readConfig(configkey) {
    var data = {}
    db.readTransaction(
                function(tx) {
                    var rs = tx.executeSql("SELECT * FROM smoozeconfig WHERE configkey = ?", [configkey])
                    if(rs.rows.length === 1) {
                        data = rs.rows.item(0)
                    }
                }
                )
    return data;
}

function defaultConfig()
{
    return {configkey: "", configvalue: ""}
}
