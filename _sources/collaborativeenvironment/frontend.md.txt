# Frontend

## Technologies

The main technologies used for the frontend are:

1. **NGINX:** is open source software for web serving, reverse proxying, caching, load balancing, media streaming, and more. 
1. **React:** is a free and open-source front-end JavaScript library for building user interfaces based on UI components. It is maintained by Meta (formerly Facebook) and a community of individual developers and companies. React can be used as a base in the development of single-page, mobile, or server-rendered applications with frameworks like Next.js. However, React is only concerned with state management and rendering that state to the DOM, so creating React applications usually requires the use of additional libraries for routing, as well as certain client-side functionality.
1. **MUI:** is a massive library of UI components designers and developers can use to build React applications. The open-source project follows Google's guidelines for creating components, giving you a customizable library of foundational and advanced UI elements. The template used is stored by DEUSTO.

## React components

Class based components are not recommended since React 16. The following are different ways to create function based components:

```javascript
function ReactExampleComponent({ text }) {
  return (
    <div>
        <p>
            {text}
        </p>
    </div>
  );
}
```

```javascript
const ReactExampleComponent = ({ text }) => {
    // if you want to put logic here
  return (
    <div>
        <p>
            {text}
        </p>
    </div>
  );
}
```

```javascript
const ReactExampleComponent = ({ text }) => <div>
        <p>
            {text}
        </p>
    </div>
```


## How to add a new element

Given the previous component, we could add a MUI button adding:

```javascript
import { Button } from '@mui/material';

const ReactExampleComponent = ({ text }) => {
  const handleClick = () => {
    // do something
  }

  return <div>
        <p>
          <Button
            size='small'
            onClick={handleClick}
          >
            Text inside the button
          </Button>
        </p>
    </div>
}
```

Checkout the MUI components: 
https://mui.com/material-ui/

## How to add a new route

React Router DOM is an npm package that enables you to implement dynamic routing in a web app. It allows you to display pages and allow users to navigate them. It is a fully-featured client and server-side routing library for React.

Routes are stored in https://github.com/interlink-project/frontend/tree/master/react/src/routes

To add the route coproductionprocesses/:processId/mynewsection would be something like:

```javascript
...
const ReactExampleComponent = Loadable(lazy(() => import('../components/ReactExampleComponent')));
...

export const routes = [
  {
    path: 'dashboard',
    element: (
      <DashboardLayout />
    ),
    children: [
      {
        path: 'coproductionprocesses/:processId',
        children: [
          {
            path: '',
            element: <AuthGuard><CoproductionProcessProfile /></AuthGuard>
          },
          {
            path: 'mynewsection',
            element: <ReactExampleComponent>
          },
          ...
        ]
      },
      ...
    ],
  },
];
```

Now, the route is accessible through the specified URI. Instead, we want the users to be able to get to the route by clicking on some element in the graphical interface, for example, a button or a sidebar entry.

## How to add a new element in the sidebar

At the end of the day, the sidebar is a react component. At the time of writing, the sidebar code is at https://github.com/interlink-project/frontend/blob/master/react/src/components/navsidebars/ProcessSidebar.js.

The only thing you have to do is to add a new element in the *sections* variable:

```javascript
const sections = [

    {
      title: '',
      items: [
        {
          title: t('Overview'),
          path: `/dashboard/coproductionprocesses/${processId}/overview`,
          icon: <Dashboard />,
          disabled: false
        },
        ...
        {
          title: t('My new section'),
          path: `/dashboard/coproductionprocesses/${processId}/mynewsection`,
          icon: <Dashboard />,
          disabled: false
        },
      ]
    },
  ];
```

## File structure

```
.
├── Dockerfile                # file for generating the docker image based on the nginx official image
├── entrypoint.sh             # shell script to execute on container start
├── i18next-parser.config.js  # configuration of the translation files parser
├── jsconfig.json
├── nginx.conf                # configuration of nginx
├── node_modules              # javascript dependencies for the app
├── package-lock.json       
├── package.json              # dependencies and metadata of the application
├── public                    # public static files (not dynamic: css, images, favicon, main index.html used where react is imported...)
│   ├── _redirects
│   ├── index.html
│   └── static
└── src                       # files of the react app
    ├── App.js                # has the root component of the react app because every view and component are handled with hierarchy in React, where <App /> is the top most component in the hierarchy. This gives you the feel that you maintain hierarchy in your code starting from App.js.Other than that, you can have the App logic in the index.js file itself. But it's something related to conventions followed by the community using the library or framework. It always feels good to go along the community.
    ├── __api__               # calls to the API (coproduction / catalogue services)
    ├── axiosInstance.js      # axios (http library) customized object
    ├── components            # components of the application
    ├── configuration.js      # some environment variables
    ├── constants.js          # some constants
    ├── contexts
    ├── hooks
    ├── icons                 # some svg icons
    ├── index.js              # is the traditional and actual entry point for all node apps. Here in React it just has code of what to render and where to render.
    ├── pages                 # at the end of the day, they are components, but those ones used by the routes
    ├── routes                # specification of the routes of the application
    ├── slices
    ├── store
    ├── theme                 # variables of the theme of the app
    ├── translations          # translation files and i18n object
    └── utils                 # some generic utils
```

## Translations

react-i18next is a powerful internationalization framework for React / React Native which is based on i18next. The module provides multiple components eg. to assert that needed translations get loaded or that your content gets rendered when the language changes.

You should read the i18next documentation. The configuration options and translation functionalities like plurals, formatting, interpolation, ... are documented there.
https://react.i18next.com/guides/quick-start

The i18n.js file (https://github.com/interlink-project/frontend/blob/master/react/src/translations/i18n.js) initializes the i18n object with some custom settings, such as allowed languages and the fallback language, in case of a key not having a translation for a given language. 

There is a generic hook (provided by the module) to access the function to translate the strings.

```javascript
...
import { useTranslation } from 'react-i18next';
...

const Example = () => {
  ...
  const { t } = useTranslation();

  return (
    <>
    {t("Hi, this is a translatable string")}
    </>
  );
};

export default Home;
```
Instead, two custom hooks have been created for the project (both of them specified in https://github.com/interlink-project/frontend/blob/master/react/src/hooks/useDependantTranslation.js):

* useDependantTranslation: gets the language of the process in the global state (will be explained later)
* useCustomTranslation: accepts a language code as a parameter.


```javascript
...
import useDependantTranslation, { useCustomTranslation } from 'hooks/useDependantTranslation';

...

const Example = () => {
  ...
  const custom_t = useCustomTranslation('es');
  const process_t = useDependantTranslation();

  return (
    <>
    {custom_t("Hi")} <!-- returns "Hola"-->
    {process_t("Hi")} <!-- returns "Ciao"-->
    </>
  );
};

export default Home;
```

> IMPORTANT: For the sake of clarity, the variable names custom_t and process_t have been used, but in order for the parser, as will now be seen, to find the keys, the variable must be named "t". 

When new translatable strings are added into the javascript files, the translation files may be updated. For that, we can use the i18n parser, which scans the files to find new translatable elements, by executing:

```bash
# from /react directory, where the package.json file is located
npm run translations
```

Then, you can modify the translated strings by modifying the value in the JSON file. The translation files are located in https://github.com/interlink-project/frontend/blob/master/react/src/translations:
```json
{
  "Cancel": "Cancelar",
  "external-resource": "Recurso externo",
  "Name": "Nombre",
  "Created": "Creado",
  "Updated": "Actualizado",
  "Interlinker": "INTERLINKER",
  "Actions": "Acciones",
  "No resources yet": "No existen recursos aún",
  "(it will be not related to project but it is useful for features exploration)": "(no estará relacionado con el proyecto pero es útil para la exploración de características)",
  ...
}
```
## API calls

For reasons of cleanliness, the API calls are located in the https://github.com/interlink-project/frontend/tree/master/react/src/_\_api__ folder.

The general.js file defines the class from which the other classes will inherit. It defines the basic HTTP calls (GET - retrieve / list, POST - create, PUT - update, DELETE - remove).

There is a class for each entity of the data model (following the REST philosophy) that inherit from the generic class. For example, the API endpoints related with the interlinker entity are served from http://localhost/catalogue/api/v1/interlinkers

```javascript
import axiosInstance from 'axiosInstance';
import GeneralApi, { removeEmpty } from '../general';

class InterlinkersApi extends GeneralApi {
  // set the main path of the API in the constructor. 
  constructor() {
    super('catalogue/api/v1/interlinkers');
  }

  // set specific methods for this entity
  async getRelated(page, size, id) {
    const res = await axiosInstance.get(
      `/${this.url}/${id}/related`, {
        params: removeEmpty({
          page,
          size
        })
      }
    );
    console.log('get related interlinkers call', res.data);
    return res.data;
  }
}

export const interlinkersApi = new InterlinkersApi();
```

## State management

There are multiple state management concerns in react. 

### Props

Props are read-only

```javascript
const PropsExample = ({ counter }) => {
    return <p> {counter} times clicked </p>;
}
```
### Component level state

The key difference between props and state is that state is internal and controlled by the component itself while props are external and controlled by whatever renders the component. State can be changed (Mutable), whereas Props can't (Immutable)

Functional components should use "useState" react hook to create and manage their states.

```javascript
const ReactExampleComponent = () => {
  
  const [counter, setCounter] = useState(0)
  return (
    <div>
        <p>
            {counter} times clicked
        </p>
    </div>
  );
}
```

Combined with props:

```javascript
const PropsExampleButton = ({ clickCount, onClick }) => {
    return <Button
            size='small'
            onClick={onClick}
          >
            This button has been clicked {clickCount}
          </Button>;
}

const PropsExample = () => {
    const [clickCount, setClickCount] = useState(0)

    const onClick = (e) => {
      setClickCount(clickCount + 1)
    }

    return <PropsExampleButton clickCount={clickCount} onClick={onClick} />;
}
```
 
### Global state

There are plenty of third party libraries aiming to provide a single place to store our state, but when we are talking about React, Redux is the king in that regard.

With the release of context API in React 16.3 and especially hooks in React 16.8, a new world of possibilites suddenly arose. 
React context suffers from a common problem: useContext hook will re-render whenever your context is modified. In other words, every component subscribed to our global state will re-render upon a context change, which in some scenarios might lead to performance issues.

```javascript
import { AuthProvider } from './contexts/CookieContext';
import { SettingsProvider } from './contexts/SettingsContext';
import store from './store';

...

ReactDOM.render(
  <StrictMode>
    ...
    <ReduxProvider store={store}>
      <SettingsProvider>
        <AuthProvider>
          <App />
        </AuthProvider>
      </SettingsProvider>
    </ReduxProvider>
    ...
  </StrictMode>, document.getElementById('root')
);
```

In https://github.com/interlink-project/frontend/blob/master/react/src/index.js


Context provides a way to pass data through the component tree without having to pass props down manually at every level, more info about it in this link

This is great! We can make data accessible to many different components regardless its level in the tree, that is to say, we can subscribe components to a "global" data store. Just wrap your app within a context provider and feed that provider with the data you want to make global:

```javascript
import { createContext, useEffect, useState } from 'react';
import { createCustomTheme } from 'theme';
import { THEMES } from '../constants';
import { getLanguage, setLanguage } from '../translations/i18n';

const initialSettings = {
  ...

};

export const restoreSettings = () => {
  ...
};

export const storeSettings = (settings) => {
  window.localStorage.setItem('settings', JSON.stringify(settings));
};

const SettingsContext = createContext({
  settings: initialSettings,
  saveSettings: (settings) => { },
});

export const SettingsProvider = (props) => {
  const { children } = props;
  const [settings, setSettings] = useState(initialSettings);

  const saveSettings = (updatedSettings) => {
    ...
  };

  return (
    <SettingsContext.Provider
      value={{
        settings,
        saveSettings,
      }}
    >
      {children}
    </SettingsContext.Provider>
  );
};

SettingsProvider.propTypes = {
  children: PropTypes.node.isRequired,
};

export const SettingsConsumer = SettingsContext.Consumer;

export default SettingsContext;

```
https://github.com/interlink-project/frontend/blob/master/react/src/contexts/SettingsContext.js

```javascript
import { useContext } from 'react';
import SettingsContext from '../contexts/SettingsContext';

const useSettings = () => useContext(SettingsContext);

export default useSettings;
```
https://github.com/interlink-project/frontend/blob/master/react/src/hooks/useSettings.js

Example component accessing global state managed by the SettingsContext
```javascript
import useSettings from '../../hooks/useSettings';

...

const SettingsPage = () => {
  const { settings, saveSettings } = useSettings();
  ...
}
```
https://github.com/interlink-project/frontend/blob/master/react/src/components/navsidebars/SettingsPopover.js

### State managed by Redux

#TODO