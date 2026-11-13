- Code in a functional style rather than an imperative one - keep functions pure and variables constant most of the time, prefer functional helpers or recursion to loops, take advantage of first-class functions, etc.

- Components should be modular and the overall app architecture should just be attaching different pieces

- Separate logic from UI - all the UI needs to do is display content it's given

- App content for the most part should live outside the code - this includes the guided tasks in Tab 1 and the articles in Tab 3, but something like a button's text can be in the code.