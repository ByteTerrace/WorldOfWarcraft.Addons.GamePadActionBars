## GamePadActionBars
A lightweight mod that grants efficient access to 65 different bindings by mapping gamepad shoulder inputs to action bar swaps and intuitively reorganizing the main action bar.

### _How does it work?_
The mod sets up temporary bindings using a secure button frame that captures the shoulder trigger (`PADLTRIGGER`/`PADRTRIGGER`) inputs. The driver can be in one of 5 states:

1. **no** trigger held
2. **only** `PADLTRIGGER` held
3. **only** `PADRTRIGGER` held
4. `PADRTRIGGER` **then** `PADLTRIGGER`
5. `PADLTRIGGER` **then** `PADRTRIGGER`

These states map to their corresponding action bar page in the World of Warcraft UI, along with a set of predefined bindings that are outlined in the table below.

| GamePad Button Name | State 1 Binding        | State 2 Binding          | State 3 Binding           | State 4 Binding    | State 5 Binding     |
| ------------------- | ---------------------- | ------------------------ | ------------------------- | ------------------ | ------------------- |
| `PADSELECT`         | **TOGGLEWORLDMAP**     | **OPENALLBAGS**          | **TOGGLECHARACTER0**      | **TOGGLESOCIAL**   | **TOGGLESPELLBOOK** |
| `PADSTART`          | TOGGLEGAMEMENU         | TOGGLEGAMEMENU           | TOGGLEGAMEMENU            | TOGGLEGAMEMENU     | TOGGLEGAMEMENU      |
| `PADDUP`            | ACTIONBUTTON1          | BOTTOMLEFTACTIONBUTTON1  | BOTTOMRIGHTACTIONBUTTON1  | LEFTACTIONBUTTON1  | RIGHTACTIONBUTTON1  |
| `PADDRIGHT`         | ACTIONBUTTON2          | BOTTOMLEFTACTIONBUTTON2  | BOTTOMRIGHTACTIONBUTTON2  | LEFTACTIONBUTTON2  | RIGHTACTIONBUTTON2  |
| `PADDDOWN`          | ACTIONBUTTON3          | BOTTOMLEFTACTIONBUTTON3  | BOTTOMRIGHTACTIONBUTTON3  | LEFTACTIONBUTTON3  | RIGHTACTIONBUTTON3  |
| `PADDLEFT`          | ACTIONBUTTON4          | BOTTOMLEFTACTIONBUTTON4  | BOTTOMRIGHTACTIONBUTTON4  | LEFTACTIONBUTTON4  | RIGHTACTIONBUTTON4  |
| `PADLSHOULDER`      | **TARGETNEARESTENEMY** | **TARGETNEARESTFRIEND**  | **UNBOUND**               | LEFTACTIONBUTTON5  | RIGHTACTIONBUTTON5  |
| `PADLSTICK`         | ACTIONBUTTON6          | BOTTOMLEFTACTIONBUTTON6  | BOTTOMRIGHTACTIONBUTTON6  | LEFTACTIONBUTTON6  | RIGHTACTIONBUTTON6  |
| `PAD4`              | ACTIONBUTTON7          | BOTTOMLEFTACTIONBUTTON7  | BOTTOMRIGHTACTIONBUTTON7  | LEFTACTIONBUTTON7  | RIGHTACTIONBUTTON7  |
| `PAD3`              | ACTIONBUTTON8          | BOTTOMLEFTACTIONBUTTON8  | BOTTOMRIGHTACTIONBUTTON8  | LEFTACTIONBUTTON8  | RIGHTACTIONBUTTON8  |
| `PAD1`              | **JUMP**               | BOTTOMLEFTACTIONBUTTON9  | BOTTOMRIGHTACTIONBUTTON9  | LEFTACTIONBUTTON9  | RIGHTACTIONBUTTON9  |
| `PAD2`              | ACTIONBUTTON10         | BOTTOMLEFTACTIONBUTTON10 | BOTTOMRIGHTACTIONBUTTON10 | LEFTACTIONBUTTON10 | RIGHTACTIONBUTTON10 |
| `PADRSHOULDER`      | **INTERACTMOUSEOVER**  | **TOGGLEAUTORUN**        | **FLIPCAMERAYAW**         | LEFTACTIONBUTTON11 | RIGHTACTIONBUTTON11 |
| `PADRSTICK`         | ACTIONBUTTON12         | BOTTOMLEFTACTIONBUTTON12 | BOTTOMRIGHTACTIONBUTTON12 | LEFTACTIONBUTTON12 | RIGHTACTIONBUTTON12 |

### _Screenshots_

**State 1 Example:**

![](/Documentation/Images/State1.png)

**State 2 Example:**

![](/Documentation/Images/State2.png)

**State 3 Example:**

![](/Documentation/Images/State3.png)

**State 4 Example:**

![](/Documentation/Images/State4.png)

**State 5 Example:**

![](/Documentation/Images/State5.png)
