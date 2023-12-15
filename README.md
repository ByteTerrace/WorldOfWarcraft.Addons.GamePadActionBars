## GamePadActionBars
A lightweight mod that grants efficient access to up to 57 of your existing action buttons by intuitively reorganizing the main action bar and mapping gamepad shoulder inputs to action bar swaps.

### _How does it work?_
The mod sets up temporary bindings using a hidden secure button frame that captures the shoulder trigger (`PADLTRIGGER`/`PADRTRIGGER`) inputs. The driver can be in one of 5 states:

1. **no** trigger held
2. **only** `PADLTRIGGER` held
3. **only** `PADRTRIGGER` held
4. `PADRTRIGGER` **then** `PADLTRIGGER`
5. `PADLTRIGGER` **then** `PADRTRIGGER`

These states map to their corresponding action bar page in the World of Warcraft UI, along with a set of predefined bindings that are outlined in the table below.

| GamePad Button Name | State 1 Binding Name | State 2 Binding Name    | State 3-5 Binding Name |
| ------------------- | -------------------- | ----------------------- | ---------------------- |
| `PADDUP`            | ACTIONBUTTON1        | ACTIONBUTTON1           | ACTIONBUTTON1          |
| `PADDRIGHT`         | ACTIONBUTTON2        | ACTIONBUTTON2           | ACTIONBUTTON2          |
| `PADDDOWN`          | ACTIONBUTTON3        | ACTIONBUTTON3           | ACTIONBUTTON3          |
| `PADDLEFT`          | ACTIONBUTTON4        | ACTIONBUTTON4           | ACTIONBUTTON4          |
| `PADLSHOULDER`      | **TARGETSCANENEMY**  | **TARGETNEARESTFRIEND** | ACTIONBUTTON5          |
| `PADLSTICK`         | ACTIONBUTTON6        | ACTIONBUTTON6           | ACTIONBUTTON6          |
| `PAD4`              | ACTIONBUTTON7        | ACTIONBUTTON7           | ACTIONBUTTON7          |
| `PAD3`              | ACTIONBUTTON8        | ACTIONBUTTON8           | ACTIONBUTTON8          |
| `PAD1`              | **JUMP**             | ACTIONBUTTON9           | ACTIONBUTTON9          |
| `PAD2`              | ACTIONBUTTON10       | ACTIONBUTTON10          | ACTIONBUTTON10         |
| `PADRSHOULDER`      | **INTERACTTARGET**   | **TOGGLEAUTORUN**       | ACTIONBUTTON11         |
| `PADRSTICK`         | ACTIONBUTTON12       | ACTIONBUTTON12          | ACTIONBUTTON12         |
| `PADFORWARD`        | TOGGLEGAMEMENU       | TOGGLEGAMEMENU          | TOGGLEGAMEMENU         |
