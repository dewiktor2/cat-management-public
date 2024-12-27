const fs = require("fs");
const path = require("path");

const supabaseUrl = process.env.SUPABASE_URL || "REPLACE_ME_SUPABASE_URL";
const supabaseAnonKey = process.env.SUPABASE_ANON_KEY || "REPLACE_ME_ANON_KEY";

const envContent = `
export const environment = {
production: true,
supabaseUrl: '${supabaseUrl}',
supabaseAnonKey: '${supabaseAnonKey}'
};
`;

const targetPath = path.join(
  __dirname,
  "../src/environments/environment.production.ts"
);
fs.writeFileSync(targetPath, envContent);
console.log("environment.production.ts generated with build-time variables!");
