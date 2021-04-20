# Dutch profile for datasets v2 schema plugin

Dutch profile for datasets v2 (iso19139.nl.geografie.2.0.0).

## Installing the plugin

### GeoNetwork version to use with this plugin

Use GeoNetwork 3.12.

### Adding the plugin to the source code


The best approach is to add the plugin as a submodule:

1. Use [add-schema.sh](https://github.com/geonetwork/core-geonetwork/blob/3.12.x/add-schema.sh) for automatic deployment:

   ```
   ./add-schema.sh iso19139.nl.geografie.2.0.0 https://github.com/metadata101/iso19139.nl.geografie.2.0.0 3.12.x
   ```

2. Build the application:

   ```
   mvn clean install -Penv-prod -DskipTests
   ```

3. Once the application is built, the war file contains the schema plugin:

   ```
   cd web
   mvn jetty:run -Penv-dev
   ```

### Deploy the profile in an existing installation

After building the application, it's possible to deploy the schema plugin manually in an existing GeoNetwork installation:

- Copy the content of the folder schemas/iso19139.nl.geografie.2.0.0/src/main/plugin to INSTALL_DIR/geonetwork/WEB-INF/data/config/schema_plugins/iso19139.nl.geografie.2.0.0

- Copy the jar file schemas/iso19139.nl.geografie.2.0.0/target/schema-iso19139.nl.geografie.2.0.0-3.12.jar to INSTALL_DIR/geonetwork/WEB-INF/lib.

If there's no changes to the profile Java code or the configuration (config-spring-geonetwork.xml), the jar file is not required to be deployed each time.

### Setup xml snippets

The editor uses a snippet-directive for the conformance field which allows to select a snippet from the catalogue, to be introduced at that location.
Unzip [snippets.zip](snippets.zip) to a folder, use import (select type 'subtemplate') to import all the files into the catalogue.

### Setup thesauri

The editor uses a number of thesauri as pick lists for various fields. These thesauri can be downloaded from the INSPIRE registry and Nationaalgeoregister.nl.

  - [INSPIRE themes](http://inspire.ec.europa.eu/theme),

  - [Priority Dataset](http://inspire.ec.europa.eu/metadata-codelist/PriorityDataset),

  - [Protocol Value](http://inspire.ec.europa.eu/metadata-codelist/ProtocolValue),

  - [Spatial Data Service Category](https://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceCategory),

  - [Quality Of Service Criteria](http://inspire.ec.europa.eu/metadata-codelist/QualityOfServiceCriteria),

  - [Spatial Scope](http://inspire.ec.europa.eu/metadata-codelist/SpatialScope),

  - [Spatial DataService Type](https://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceType).
