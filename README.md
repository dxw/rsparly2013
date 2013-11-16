## Parliament Hack 2013

### Data Model

**Legislation**
- Title
- Date Passed
- Date Introduced

**Cross headings**
- Belongs to a Legislation
- Title
- Order

**Clause**
- Belongs to a Crossheading
- Number (In Crossheading)
- Text

**Amendments**
- Belongs to a Clause
- Stage (1,2,C,3,P)
- House (Lords/Commons)
- Date
- Text (Formatted)

**Debate**
- Dialogue
- Belongs to an Amendment
- Date

### Mockup
![Mockup](https://raw.github.com/dxw/rsparly2013/master/mockup.png)
