#!/bin/bash
echo ""
echo "Installing Luigi with Angular and basic configuration"
echo ""
if [[ "$1" = "" ]]; then
  read -p "Luigi project folder name: " folder
else
  folder=$1
  echo "Luigi project folder name: $folder"
fi
# steps to execute line by line
echo ""
ng new $folder --routing && cd $folder

npm i -P @luigi-project/core @luigi-project/client fiori-fundamentals webpack webpack-cli @babel/core @babel/preset-env babel-loader 
sed 's/"scripts": {/"scripts": {\
\   "buildConfig":"webpack --entry .\/src\/luigi-config\/basic\/basicConfiguration.js -o .\/src\/assets\/luigi-config.js --mode production",/1' package.json > p.tmp.json && mv p.tmp.json package.json
mkdir -p src/luigi-config/basic

 # the following steps can be copy and pasted to the terminal at once
mv src/index.html src/angular.html

# download 
curl https://raw.githubusercontent.com/SAP/luigi/master/test/e2e-test-application/src/index.html > src/index.html
curl https://raw.githubusercontent.com/SAP/luigi/master/test/e2e-test-application/src/luigi-config/basic/basicConfiguration.js > src/luigi-config/basic/basicConfiguration.js
curl https://raw.githubusercontent.com/SAP/luigi/master/test/e2e-test-application/src/assets/sampleexternal.html > src/assets/basicexternal.html


# string replacements in some files
sed 's/extendedConfiguration.bundle.js/luigi-config.js/g' src/index.html > src/index.tmp.html && mv src/index.tmp.html src/index.html
sed 's#"src/index.html"#"src/angular.html"#g' angular.json > tmp.json && mv tmp.json angular.json
sed 's#"src/styles.css"#"src/styles.css", "node_modules/fiori-fundamentals/dist/fiori-fundamentals.min.css"#g' angular.json > tmp.json && mv tmp.json angular.json
sed 's#"src/assets"#"src/assets","src/index.html","src/logout.html",{"glob": "fiori-fundamentals.min.css","input": "node_modules/fiori-fundamentals/dist","output": "/fiori-fundamentals"},{"glob": "fonts/**","input": "node_modules/fiori-fundamentals/dist","output": "/fiori-fundamentals"},{"glob": "SAP-icons.*","input": "node_modules/fiori-fundamentals/dist","output": "/fiori-fundamentals"},{"glob": "**","input": "node_modules/@luigi-project/core","output": "/luigi-core"},{"glob": "luigi-client.js","input": "node_modules/@luigi-project/client","output": "/luigi-client"}#g' angular.json > tmp.json && mv tmp.json angular.json

npm run buildConfig
npm run start