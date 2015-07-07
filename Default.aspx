<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <title>OpenStreetMap - Simple way to create an Offline Web Based Offline Maps</title>

    <script src="Scripts/jquery-1.10.2.min.js" type="text/javascript"></script>
    <script src="Scripts/OpenLayers.js" type="text/javascript"></script>    
    <script src="Scripts/mapUtility.js" type="text/javascript"></script>
    <script src="OLAPI/OpenLayers.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" onload="Load()"  ContentPlaceHolderID="MainContent">
    
     <h3>

        Creating Offline Maps in Web Based Application - OpenLayers</h3>

    <div id="map-canvas" style="width: auto; height: 500px;">

    </div>

</asp:Content>
