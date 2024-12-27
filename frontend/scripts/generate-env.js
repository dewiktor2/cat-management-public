const fs = require("fs");
const path = require("path");
const dotenv = require("dotenv");
const yargs = require("yargs/yargs");
const { hideBin } = require("yargs/helpers");


const argv = yargs(hideBin(process.argv))
  .option("configuration", {
    alias: "c",
    describe: "Set the environment configuration (development, staging, production)",
    type: "string",
    default: "development"
  })
  .help()
  .argv;

const config = argv.configuration;

console.log(`Using configuration: ${config}`);

const envFileMap = {
  development: ".env",
  staging: ".env",
  production: ".env",
};

if (!envFileMap[config]) {
  console.error(`Not supported env: ${config}`);
  process.exit(1);
}

const privateRepoEnvPath = path.join(process.cwd(), `../../cat-management-private/${envFileMap[config]}`);

if (!fs.existsSync(privateRepoEnvPath)) {
  console.error(`File ${privateRepoEnvPath} not exist!`);
  process.exit(1);
}

// Load file `.env`
const envConfig = dotenv.parse(fs.readFileSync(privateRepoEnvPath));

const envContent = `
export const environment = {
  production: ${config === "production"},
  supabaseUrl: '${envConfig["SUPABASE_URL"]}',
  supabaseAnonKey: '${envConfig["SUPABASE_ANON_KEY"]}'
};
`;

// final dest
const targetPath = path.join(__dirname, `../src/environments/environment.${config}.ts`);

// Save file
fs.writeFileSync(targetPath, envContent);
// console.log(`Plik \`environment.${config}.ts\` został wygenerowany z pliku \`${envFileMap[config]}\`.`);
// console.log(`SUPABASE_URL: ${envConfig["SUPABASE_URL"]}`);
// console.log(`SUPABASE_ANON_KEY: ${envConfig["SUPABASE_ANON_KEY"]}`);