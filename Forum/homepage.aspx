
<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="homepage.aspx.cs" Inherits="Forum.WebForm2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">



    <style>

        .card {
            border: 1px solid #ccc;
            margin: 20px 0;
            border-radius: 10px;
            transition: transform 0.1s;
            background-color: #f2f2f2;
        }
       .liked {
        color: mediumpurple !important;
    }
       .rounded-title {
       background-color: mediumpurple; 
       color: white; 
       border-radius: 20px; 
       padding: 5px 15px; 
       }
      
     .custom-button {
      border: 2px solid #ccc; /* Gray border color */
        color: #333; /* Gray text color */
     }

/* Animated flame border */
.flame-border {
    animation: flame-border 2s infinite alternate-reverse;
}

@keyframes flame-border {
    0% {
        transform: rotate(0deg) scale(1.05);
        box-shadow: 0 0 5px 0 rgba(255, 100, 0, 0.5);
    }
    100% {
        transform: rotate(1deg) scale(1.1);
        box-shadow: 0 0 10px 0 rgba(255, 100, 0, 0.7);
    }
}



    .custom-button:hover,
    .custom-button:active,
    .custom-button:focus {
        color: white !important; 
        background-color: mediumpurple ;
        border-color: mediumpurple ;
    }
  
.custom-button:hover .bx-chat {
    color: white !important; /* White icon color on hover */
}
.custom-button:hover .bx-like {
    color: white !important; /* White icon color on hover */
}
.custom-button:hover .like-count {
    color: white !important; /* White like count color on hover */
}

  .post-image { 
        overflow: hidden; 
        transition: transform 0.3s;
        z-index: -1;
    }
     .post-image:hover {
        transform: scale(1.1); 
        z-index: 5;
    }

     /* Apply a lighting border when hovered */
.card:hover {
    box-shadow: 0 0 8px 0 rgba(255, 100, 0, 0.7); /* Lighting border */
    transform: scale(1.01); /* Slightly smaller zoom effect */
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div class="col-md-8 offset-md-2">
    <asp:Repeater ID="PostRepeater" runat="server" OnItemCommand="PostRepeater_ItemCommand">
        <ItemTemplate>
            <div class="card mt-4" style="border: solid 1px;border-color: rgb(167, 167, 167); box-shadow: 0 0 8px 0 mediumpurple; margin: 2% 1%">
                <div class="card-header" style="background-color: #ebf2f2; border: dotted 1px">
                   Posted By:
                    <asp:Label runat="server" Text='<%# Eval("Username")%>'></asp:Label>
                   
                        <p class="mb-0">
                            <small class="text-muted"><asp:Label runat="server" Text='<%# Eval("PostDate") %>'></asp:Label></small>
                        </p>
                    <!-- <asp:Panel ID="adminpanel" runat="server" Visible="true"> -->
                    <% if (Session["role"].ToString()=="admin")
                    {   
                    %>
                        <div class="d-flex justify-content-between" style="font-size: x-large">
                            <asp:LinkButton ID="EditLink" OnClick="EditLink_Click" CommandArgument='<%#Eval("Id")%>' style="text-decoration: none; color: black" runat="server">
                                <i class='bx bx-edit-alt'></i>
                            </asp:LinkButton>
                            <asp:LinkButton ID="DeleteLink" OnClientClick="return confirm('Are you sure you want to delete this post?');" OnClick="DeleteLink_Click" CommandArgument='<%#Eval("Id")%>' style="text-decoration: none; color: rgb(133, 2, 2)" runat="server">
                                <i class='bx bxs-trash'></i>
                            </asp:LinkButton>
                        </div>
                    <% 
                    }
                    %>
                   
                   <!-- </asp:Panel> -->      
                </div>
                <div class="card-body" style="background-color:#fcffff">
                    <h6 class="card-title ">
                        <asp:Label runat="server" CssClass="rounded-title" Text='<%# Eval("PostTitle")%>'></asp:Label>
                    </h6>
                  
                  <br />
                    <asp>

                    </asp>
    <asp:PlaceHolder runat="server" Visible='<%# IsImageAvailable(Eval("PostPic")) %>'>
    <div class="row">
        <div class="col-md-4">
            <asp:Image runat="server" ImageUrl='<%# GetPostPicUrl(Eval("PostPic")) %>'
                CssClass="img-fluid rounded shadow post-image" />
        </div>
        <div class="col-md-8">
            <p class="card-content">
                <asp:Label runat="server" CssClass="card-text" Text='<%# Eval("PostContent")%>'></asp:Label>
            </p>
            <!-- Other content related to your blog post can go here -->
        </div>
    </div>
</asp:PlaceHolder>

<asp:PlaceHolder runat="server" Visible='<%# !IsImageAvailable(Eval("PostPic")) %>'>
    <div class="row">
        <div class="col-md-8">
            <p class="card-content">
                <asp:Label runat="server" CssClass="card-text" Text='<%# Eval("PostContent")%>'></asp:Label>
            </p>
            <!-- Other content related to your blog post can go here -->
        </div>
    </div>
</asp:PlaceHolder>



                     <!-- Display user's uploaded image -->
                  <br />
                   <div class="btn-group mt-2" role="group" aria-label="Second group">
    <asp:LinkButton ID="ReplyLink" OnClick="ReplyLink_Click" CommandArgument='<%#Eval("Id")%>' CssClass="btn btn-outline-primary custom-button" runat="server">
        <i class="bx bx-chat" style="color: mediumpurple;"></i>
        &nbsp;
      
    </asp:LinkButton>   &nbsp;
                       <asp:LinkButton ID="LikeLink" OnClick="LikeLink_Click" CommandArgument='<%#Eval("Id")%>' CssClass="btn btn-outline-primary custom-button" runat="server">
            <i class="bx bx-like" style="font-size: x-large; color:mediumpurple"></i>
            <span class="like-count" style="color:mediumpurple">
    <%# Eval("LikeCount") %>
</span>

        </asp:LinkButton>
</div>

                </div>
            </div>

        </ItemTemplate>
        
    </asp:Repeater>
             </div>
</asp:Content>
