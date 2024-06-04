# Internal interlinkers
This project is intended to sum up the different interlinkers developed for the project. But, ¿what is an interlinker?

An *interlinker* is a tool that is used to create assets by *instantiating* them. These interlinkers can be classified by its *nature*: **software** or **knowledge**.

* **Software interlinkers**:

  Are software based interlinkers that create assets. For example, **forum** interlinker can be instantiated to create a forum where users can create channels and send messages. This "forum instance" is called an "asset". 

* **Knowledge interlinkers**:
  
  Refer to assets made by users that can be used as templates. For example, an user can create a google drive word document using **googledrive** interlinker and add some text to it. Now, this document could be reused, as if it was a template. 

  A knowledge interlinker points to the software interlinker used to create an asset (softwareinterlinker_id) and the id of the specific asset that should be treated as the template (genesis_asset_id). 

  ![Interlinkers models](images/integration/model.png)

  This allows us to create knowledge interlinkers based on any software interlinker (with some conditions, as it is going to be explained later):

    * Survey: create survey templates for specific aspects that users could reuse (such us "Survey for interlinker quality assurance")
    * Googledrive: (google apps) create document, slides or sheet templates
    * Etherpad: create document templates

    ...


## Endpoints needed for SOFTWARE INTERLINKERS integration

Each interlinker is treated as an independent component, so they can be developed with any framework or tool (MEAN, MERN, django, NextJS... the possibilities are infinite). But they all need to expose these endpoints to integrate them: 

1. **Instantiate assets:**  

    * **WHAT:** basic GUI por asset instantiation. This is gonna be iframed.
    * **Method:** GET
    * **URL:** /assets/instantiate
    * Messages for the main frontend integration:
      * When initialized, send a message to the parent like { 'code': 'initialized', } 
      * When asset created, send a message to the parent like { 'code': 'asset_created', 'message': data of the asset }
    * Examples:
      * googledrive interlinker (left): file input
      * survey interlinker (right): form name and description

      ![Google Drive instantiate](images/integration/instantiators.png)

      
      * etherpad: text input for specifying a name

2. **Data of given asset:** 

    * **WHAT:** returns data for given asset.
    * **Method:** GET
    * **URL:** /assets/{id}
      
    It must return these values 
    
    ```
    {
      "name": string,
      "created_at": datetime,
      "updated_at": datetime,
      "icon": optional string
    }
    ```
      

3. **Viewer for given asset:** 

    * **WHAT:** shows GUI for given asset.
    * **Method:** GET
    * **URL:** /assets/{id}/view
    * Examples:
      * googledrive interlinker (left): redirects to Google Drive
      * survey (right): renders HTML

      ![Asset data](images/integration/viewers.png)

      * etherpad: renders an iframe that shows etherpad GUI running in a diferent location (such as /etherpad/p/{padID})

4. **Delete existing asset:** 

    * **WHAT:** deletes assets by id
    * **Method:** DELETE
    * **URL:** /assets/{id}


5. **[OPTIONAL] Editor for given asset:** 

    * **WHAT:** shows GUI for editing some asset.
    * **Method:** GET
    * **URL:** /assets/{id}/edit
    * Examples:
      * googledrive interlinker: not necessary
      * etherpad: not necessary
      * survey: renders a GUI for modifying the survey

      ![Asset data](images/integration/editor.png)

4. **[OPTIONAL] Clone given asset:** 

    * **WHAT:** clones asset given an id.
    * **Method:** POST
    * **URL:** /assets/{id}/clone

> :warning: If /clone not specified, the interlinker can not be used to generate knowledge interlinkers.
  
Furthermore, interlinkers can implement any other endpoints needed for its functionality. For example, Googledrive (left) and survey (right) interlinker implements:

![APIS](images/integration/APIS.png)


### In conclusion:

```
/                           GET       redirects to swagger / redoc DOCS (maybe not possible)
/assets/instantiate         GET       GUI for asset creation
/assets/{ASSET_ID}          GET       JSON data of asset
/assets/{ASSET_ID}          POST      [OPTIONAL] Posts data for asset creation and return JSON of asset
/assets/{ASSET_ID}/view     GET       GUI for the interaction with the asset
/assets/{ASSET_ID}          DELETE    Deletes asset and returns No content
/assets/{ASSET_ID}/edit     GET       [OPTIONAL] GUI for asset editing
/assets/{ASSET_ID}/clone    POST      [OPTIONAL] Clones the asset and returns JSON data

... custom endpoints needed for its own logic
```
## Example flow with Googledrive interlinker

VIDEO: https://youtu.be/N3jB3lwOsRo

When the user selects a file, a POST request to /api/v1/assets **OF THE INTERLINKER** (in this case /googledrive/api/v1/assets) is made with the data needed for the asset instantiation (in this case, the file). When response received, a message to the parent is sent with the asset data:

![Googledrive instantiator code](images/integration/code.png)

When the **Collaborative Environment frontend** receives the message, makes a POST request to /coproduction/api/v1/assets/ to store that asset for the task where the user has pressed "Add asset" button.

![Collaborative environment message listener](images/integration/frontend.png)

