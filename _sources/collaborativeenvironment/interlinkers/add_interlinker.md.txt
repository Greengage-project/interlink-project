# Instructions to create new Interlinkers
## For internal software INTERLINKERS:

A new software interlinker can be added directly to the catalogue following the steps below:

1. Create a new folder with the interlinker name, if the name has multiple words, it can't use spaces (hyphens between words):

    For example:

    "Survey Editor Interlinker" should be named: survey-editor

2. Inside the interlinker's folder create the following files:

    ```
    interlinker-name
    ├── sanpshots (directory)
    |    └── img_1.png (file) 
    |    └── img_2.png (file) 
    |    ...
    ├── instructions.md (file)
    ├── logo.jpeg (file)
    └── metadata.json (file)               
    ```

    For example for the [augmenter INTERLINKER folder](https://github.com/interlink-project/backend-catalogue/tree/master/catalogue/seed/interlinkers/software/augmenter) can be taken as a reference of a internal software INTERLINKER.

3. The catalogue allow to any interlinker to have several snapshots which display the interlinker functionality. All images must be included in the **snapshots folder**. For example, the interlinker augmenter has the follow snapshots:()
   * annotate.png
   * approve.png
   * descriptions.png
   * manage.png
   
    All the images will be displayed in the carousel of images inside the catalogue.
   

   ![Carousel](https://github.com/interlink-project/interlink-project/raw/master/docs/collaborativeenvironment/interlinkers/images/addInterlinker/carruselInterlinker_1.png)

   
4. Fill the **instructions.md** file with all necessary information to be able to use this interlinker. The instructions must follow markdown language ([https://en.wikipedia.org/wiki/Markdown](https://en.wikipedia.org/wiki/Markdown)).

5. The **logo.jpeg** must be the logo which will identify assets created by the interlinker.

6. The **metadata.json** must include the following information:

    ***Administrative_scopes***

    This metadata information refers to the scope where the interlink is implemented, this information must be one of the follow options:

        eu = European Union
        national= Inside a specific country
        local= Inside a specific city

    ***Constraints_and_limitations_translations***
    
    This metadata describes general information about the translations.

    ***Description_translations***

    This metadata describes and present the interlinker. It could be added as a list of several languages. For example, in the case of two languages the metadata information will be:

        "en": "Augmenter is an Open Source application …",

        "es":"Augmenter es una aplicación de código abierto …"

    ***Difficulty***

    Describe the level of difficulty in the use of the interlinker. For example if the component is very easy and requires few easy steps to deploy then the level of difficulty could be easy. In others cases the level could be greater as it need a lot of parameters to configure or depends on other software to deploy, the level then could be hard.

    ***Environments***

    The environment where the interlinker will be deploy. For example, if there are several severs where the platform is deployed, it will contain a list with the names of each server.

    ***Id***

    A unique identifier for the interlinker in the catalogue.

    ***Instructions_translations***

    This metadata contains a link to a document where the instructions to create a new translation language.

    ***Integration***

    This metadata contains several variables used by the collaborative environment to integrate with a new *software interlinker*. Several of them can be grouped inside the same category.

    Server configuration parameters. 
    
        - For example, in case of augmenter it will be located inside a subdomain called "servicepedia" (https://servicepedia.dev.interlink-project.ue):
    
            Domain: "",
            Is_subdomain: true,
            Path: "servicepedia",
            Service_name: "servicepedia"
        
        - Another example is the case of google Drive (external software INTERLINKER)
        
            "domain": "",
            "is_subdomain": false,
            "path": "googledrive",
            “service_name": "googledrive"

    Interlinker calling options. For example, for the interlinker augmenter the options used to call the interlinker functionality are:

    ```
    "capabilities": {
        _"clone":false,
        "_delete":true,
        "_edit":true,
        "_instantiate":true,
        "_open\_in\_modal":false,
        "_preview":false,
        "_shortcut":true,
        "_view":true
        }
    ```

    Translation messages needed when the interlinker is called. For example, in case of the augmenter the options are:

    ```
    "capabilities_translations": {
        "delete_text_translations":
            { "en": "Delete una description of Augmenter",
            "es": "Eliminar una descripción del Augmenter"},
        "instantiate_text_translations":
            { "en": "Create a new description in Augmenter",
            "es": "Crear una nueva descripci\u00f3n en Augmenter"},
        "view_text_translations":
            {"en": "Open a description web site to annotate.",
            "es": "Abrir una p\u00e1gina con descripciones para anotar"}
    ```

    ***Is_responsive***

    This metadata specifies if the component is responsive

    ***Is_sustainability_related***
    
    This metadata register if the interlinker is sustainable.

    ***Laguages***

    This metadata specifies the languages supported by the interlinker.

    ***Licence***

    This metadata specifies the license needed to use this interlinker.

    ***Logotype***

    This metadata specifies the location of the logo file.

    ***Name_translations***

    This metadata specifies the translations of the interlinker's name. For example, in the case of the augmenter all the translation are the same:

    ```
    "name_translations": {
        "en": "Augmenter",
        "es": "Augmenter",
        "it": "Augmenter",
        "iv": "Augmenter"
    }
    ```
    ***Overview_text***

    This metadata contains a short description of the interlinker.

    ***Problemprofiles***

    This metadata contains all the related problem profiles.

    ***Regulations_and_standards_translations***
    ```
    "regulations_and_standards_translations": {
        "en": "None",
        "es": "None"
    },
    ```

    ***Supported_by***

    This metadata specifies if the interlinker is deployed together with the platform or in a external server.

    ***Supports_internationalization***

    Specifies if the interlinker support several languages.

    ***Tags_translations***

    Contains a several tags where the interlinker that describe the interlinker functionality.

    ```
    "en": [
        "decision making",
        "idea management",
        "improve descriptions",
        "public service descriptions"
    ]
    ```

    ***Targets***

    ```
    "targets": [
        "all"
    ],
    ```

    ***Type***

    This metadata specifies the type of interlinker, there is four options:
    - Software
    - Externalsoftware
    - Knowledge
    - Externalknowledge
    

    ***Types***
    This metadata specifies the functionality of the interlinker. 
    ```
    "types": [
        "enabling_services;operation_services"
    ]
    ```

7. The next step is to upload this folder to the container interlinkers-catalogue. Inside there is the folder under "/catalogue/seed/" called "[interlinkers](https://github.com/interlink-project/backend-catalogue/tree/master/catalogue/seed/interlinkers/)" with several separated types of interlinker.

    ```
    backend-catalogue (container)
    /catalogue/seed/ (subfolder)
    └── interlinkers
        ├── externalknowledge
        ├── externalsoftware
        ├── images 
        ├── knowledge
        └── software

    ```

    For example, the interlinker augmenter was placed in:
    ```
    interlinkers-data/interlinkers/software/
    ```
## For external software INTERLINKERS:
1. Clone one of the directories under [backend-catalogue/catalogue/seed/interlinkers/externalsoftware/](https://github.com/interlink-project/backend-catalogue/tree/master/catalogue/seed/interlinkers/externalsoftware).
2. Rename the folder to the corresponding name of such component.
3. Add logo.png, instructions.md and modify adequately metadata.json. (most of it is already explained in the first section, internal software INTERLINKERS)
4. On the integration section of metadata.json for example the google drive INTERLINKER the information is:  
    ```
    "domain": "",
    "is_subdomain": false,
    "path": "googledrive",
    “service_name": "googledrive"
    ```
    
## For internal knowledge INTERLINKER:
1. Clone one of the directories under [backend-catalogue/catalogue/seed/interlinkers/knowledge/](https://github.com/interlink-project/backend-catalogue/tree/master/catalogue/seed/interlinkers/knowledge).
2. Rename the folder according to the sought internal knowledge INTERLINKER.
3. Update folder snapshots, metadata.json and corresponding resource. (most of it is already explained in the first section, internal software INTERLINKERS)

## For external knowledge INTERLINKER:
1. Clone one of the directories under [backend-catalogue/catalogue/seed/interlinkers/externalknowledge/](https://github.com/interlink-project/backend-catalogue/tree/master/catalogue/seed/interlinkers/externalknowledge).
2. Rename the folder according to the sought internal knowledge INTERLINKER.
3. Update folder snapshots, metadata.json and corresponding resource. (most of it is already explained in the first section, internal software INTERLINKERS)

 
 
 
 
