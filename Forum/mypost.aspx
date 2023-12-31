﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="mypost.aspx.cs" Inherits="Forum.WebForm7" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <style>
     .purple-button {
        background-color: aliceblue;
        border-color: mediumpurple;
        color: mediumpurple;
        transition: background-color 0.3s, border-color 0.3s, color 0.3s;
    }

    /* Hover state styles */
    .purple-button:hover {
        background-color: mediumpurple;
        border-color: aliceblue;
    }

    .abc :focus{
        border: solid 2.5px;
        border-color: mediumpurple;
    }
        </style>
</asp:Content>
   
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="m-5">
        <center>
            <asp:Label ID="datanotexist" runat="server" Text="" Font-Size="24"></asp:Label>
        </center>
    </div>
    
    <asp:Repeater ID="PostRepeater" runat="server">
        <ItemTemplate>
            <div class="card" style="border: solid 1px;border-color: rgb(167, 167, 167); margin: 2% 1%">
            <div class="card-header">
                <input type="hidden" id="editdata" value='<%#Eval("Id")%>'/>
                    Posted By: <asp:Label runat="server" Text='<%# Eval("UserName")%>'></asp:Label>
                    <p style="margin: 0">
                        <asp:Label runat="server" Text='<%# Eval("PostDate")%>'></asp:Label>
                    </p>
                    <div class="d-flex justify-content-between" style="font-size: x-large">
                        <asp:LinkButton ID="EditLink" OnClick="EditLink_Click" CommandArgument='<%#Eval("Id")%>' style="text-decoration: none; color: black" runat="server">
                            <i class='bx bx-edit-alt'></i>
                        </asp:LinkButton>
                        <asp:LinkButton ID="DeleteLink" OnClientClick="return confirm('Are you sure you want to delete this post?');" OnClick="DeleteLink_Click" CommandArgument='<%#Eval("Id")%>' style="text-decoration: none; color: rgb(133, 2, 2)" runat="server">
                            <i class='bx bxs-trash'></i>
                        </asp:LinkButton>
                    </div>
                </div>
                <div class="card-body">
                    <h5 class="card-title">
                        <asp:Label runat="server" Text='<%# Eval("PostTitle")%>'></asp:Label>
                    </h5>
                    <p class="card-content">
                        <asp:Label runat="server" CssClass="card-text" Text='<%# Eval("PostContent")%>'></asp:Label>
                    </p>
                    
                    <div class="btn-group mt-2" role="group" aria-label="Second group">
                        <asp:LinkButton ID="ReplyLink" OnClick="ReplyLink_Click" CommandArgument='<%#Eval("Id")%>' CssClass="btn btn-outline-primary purple-button" runat="server">
                            <i class="bx bx-chat" style="font-size: x-large"></i>
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </ItemTemplate>
 </asp:Repeater>
</asp:Content>
