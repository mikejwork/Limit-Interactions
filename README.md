<h1 align="center">
    <br>
    <img src="https://i.imgur.com/Pq1PHnN.png" alt="Limit" width="450">
    <br>
</h1>

<h4 align="center">A prop interaction system for FiveM.</h4>

<p align="center">
  <a href="#credits">Credits</a> •
  <a href="#usage">Usage</a> •
  <a href="#usage">Showcase</a> •
  <a href="#infrastructure">Infrastructure</a> •
  <a href="#personal-notes">Personal notes</a>
</p>
<br>

FiveM is a "modification for Grand Theft Auto V enabling you to play multiplayer on customized dedicated servers". Scripts for servers can be made using given developer docs, either in Lua, C# or Javascript.

Limit-Interactions provides a system for users to create new interactable game props, and can give a callback to the handler so that their function is called when a player interacts with the specified prop. The project uses Ractive.js to manage the list of interacts on screen, has smooth mouse control to ensure the user does not get stuck. Has Anti-abuse features preventing the player using the interact icon as an in-game crosshair.

## Credits
- [FiveM Documentation](https://docs.fivem.net/docs/ "FiveM Documentation")  
- [GTA V Prop hashes](http://gtahash.site/?s=121155 "GTA V Prop hashes")  
- [Ractive.js](https://ractive.js.org "Ractive.js")  

# Usage
<p align="center">
    <img src="https://i.imgur.com/buNiN9F.png" alt="usage" width="750">
    <img src="showcase/showcase.gif" alt="usage" width="600">
</p>

## Infrastructure
Project is created with:
* Lua
* JavaScript
* HTML
* CSS
* Ractive.js

## Personal Notes
If i was to remake this project i would change from using Ractive.js to use React.js, at the time i chose to use Ractive.js as i did not understand React fully, but now i have a good knowledge in React and could improve the UI considerably.
