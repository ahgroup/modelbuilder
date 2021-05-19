# Updates to **modelbuilder** by WEST

## 2021-05-19

1. Added "add" and "remove" buttons for variables, flows, and paramters
    - Description: Each variable, flow, and parameter has its own add/remove button.
  Variables, flows, and parameters can only be removed if there are is more than one remaining. 
    - Functions Changed: `app.R`, `add_model_par`, `add_model_var`, `add_model_flow`

1. Variables have dynamic display names
    - Description: Variables are instantiated with a name (i.e. "Variable 1"). If the user changes the Variable Name, then the displayed name for that variable is changed to the entered value.
    - Functions changed: `app.R`, `generate_buildUI`, `add_model_par`, `add_model_var`, `add_model_flow`

1. Added a confirmation modal to confirm deletion of variables
    - Description: After a user clicks the remove button for a variable, a modal pops up asking for confirmation. This was implemented to avoid accidental variable deletion.
    - Functions changed: `app.R`, `remove_model_variableModal` (*this function was added*)

1. App doesn’t "forget" changes made to a model if the user navigates away from / back to the Build tab. 
    - Description: The object `values$buildUiTrigger` was created for this purpose in `app.R`. It is used to decide whether or not to generate the ui for the Build tab. The object is instantiated with a value of 0. If the user navigates to the Build tab, then the value is changed to 1. If a user uploads a model or chooses an example model, then the value is changed to 0. The Build tab's ui will only be regenerated if the `buildUiTrigger` object has a value of 0.
    - Functions changed: `app.R`

1. Improved indexing for variables, flows, and parameters.
    - Description: (I am going to just refer to variables in the description of this task for the sake of brevity, but the same logic applies to flows and parameters). Users can now add variables at any part of the application. This means that whenever a variable was added, it couldn’t just be added to the end of the list of variables. And when a variable was removed, we couldn’t just remove that last variable. For example, a user could click the add variable button on Variable 1 three times resulting in Variable 1, Variable 4, Variable 3, and Variable 2 (in that order). Then the user deletes Variable 1 and Variable 4 (in that order). If using numeric indexing, the app would error when trying to delete Variable 4 because there were only 3 variables left after first deleting Variable 1. To avoid this issue, a table of variable names is kept (`values$masterVarDF`), and variables are removed by referencing their names instead of their numeric index.
    - Functions changed: `app.R`, `generate_buildUI`, `add_model_par`, `add_model_var`, `add_model_flow`, `remove_model_var`, `remove_model_par`, `remove_model_flow`, `check_model`, `generate_model`
