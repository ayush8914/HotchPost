
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Forum
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
        public int checkadmin;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role"] == null)
            {
                Session["role"] = "";
            }
            RepeterData();
            PostRepeater.DataBind();
        }
        void RepeterData()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    // Modify the SQL query to include the LikeCount column.
                    string query = "SELECT [dbo].[Post].*, [dbo].[User].*, " +
                                   "CONVERT(VARBINARY(max), [dbo].[Post].PostPic, 1) AS Base64Image, " +
                                   "(SELECT COUNT(*) FROM [dbo].[Replies] WHERE [dbo].[Replies].PostId = [dbo].[Post].Id) AS ReplyCount " +
                                   "FROM [dbo].[Post] " +
                                   "INNER JOIN [dbo].[User] ON [dbo].[Post].userid = [dbo].[User].id";

                    SqlCommand cmd = new SqlCommand(query, con);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable ds = new DataTable();
                    da.Fill(ds);

                    // Bind the data to the Repeater control.
                    PostRepeater.DataSource = ds;
                    PostRepeater.DataBind();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }




        protected void ReplyLink_Click(object sender, EventArgs e)
        {
            if (Session["role"].ToString() == "")
            {
                Response.Redirect("userlogin.aspx");
            }
            LinkButton lb = (LinkButton)sender;
            string id = lb.CommandArgument;
            Response.Redirect("replies.aspx?id=" + id);
        }

        protected void EditLink_Click(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            string id = lb.CommandArgument;
            Response.Redirect("editpost.aspx?id=" + id);

        }

        protected void DeleteLink_Click(object sender, EventArgs e)
        {
            LinkButton lb = (LinkButton)sender;
            string id = lb.CommandArgument;
            int eid = Int32.Parse(id);

            Deletepost(eid);
        }

        protected void LikeLink_Click(object sender, EventArgs e)
        {
            if (Session["role"].ToString() == "")
            {
                Response.Redirect("userlogin.aspx");
            }
            LinkButton lb = (LinkButton)sender;
            string id = lb.CommandArgument;
            int postId = Int32.Parse(id);

            try
            {
                // Check if the user has already liked the post
                bool hasLiked = CheckUserLikedPost(postId);

                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    if (hasLiked)
                    {
                        // If the user has already liked the post, decrement the LikeCount
                        SqlCommand decrementCmd = new SqlCommand("UPDATE [dbo].[Post] SET LikeCount = LikeCount - 1 WHERE Id = @PostId", con);
                        decrementCmd.Parameters.AddWithValue("@PostId", postId);
                        decrementCmd.ExecuteNonQuery();

                        // Remove the user's like from the UserLikes table
                        SqlCommand removeLikeCmd = new SqlCommand("DELETE FROM [dbo].[UserLikes] WHERE UserId = @UserId AND PostId = @PostId", con);
                        removeLikeCmd.Parameters.AddWithValue("@UserId", Session["userid"]);
                        removeLikeCmd.Parameters.AddWithValue("@PostId", postId);
                        removeLikeCmd.ExecuteNonQuery();

                        lb.CssClass = "btn btn-outline-primary custom-button";
                    }
                    else
                    {
                        // If the user has not liked the post, increment the LikeCount
                        SqlCommand incrementCmd = new SqlCommand("UPDATE [dbo].[Post] SET LikeCount = LikeCount + 1 WHERE Id = @PostId", con);
                        incrementCmd.Parameters.AddWithValue("@PostId", postId);
                        incrementCmd.ExecuteNonQuery();

                        // Add the user's like to the UserLikes table
                        SqlCommand addLikeCmd = new SqlCommand("INSERT INTO [dbo].[UserLikes] (UserId, PostId) VALUES (@UserId, @PostId)", con);
                        addLikeCmd.Parameters.AddWithValue("@UserId", Session["userid"]);
                        addLikeCmd.Parameters.AddWithValue("@PostId", postId);
                        addLikeCmd.ExecuteNonQuery();
                    }

                    // Refresh the data to reflect the updated like count.
                    RepeterData();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }

        // Helper method to check if the user has already liked the post
        private bool CheckUserLikedPost(int postId)
        {
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM [dbo].[UserLikes] WHERE UserId = @UserId AND PostId = @PostId", con);
                cmd.Parameters.AddWithValue("@UserId", Session["userid"]);
                cmd.Parameters.AddWithValue("@PostId", postId);
                int likeCount = (int)cmd.ExecuteScalar();
                return likeCount > 0;
            }
        }


        protected string GetPostPicUrl(object postPic)
        {
            if (postPic != DBNull.Value)
            {
                byte[] imageData = (byte[])postPic;
                string base64String = Convert.ToBase64String(imageData);
                return "data:image/jpeg;base64," + base64String;
            }
            else
            {
                // Return a default image URL or an empty string
                // For example, return a URL to a placeholder image
                return "url_to_default_image.jpg";
            }
        }


        protected bool IsImageAvailable(object postPic)
        {
            return postPic != DBNull.Value;
        }


        void Deletepost(int eid)
        {
            try
            {
                SqlConnection con = new SqlConnection(strcon);
                if (con.State == ConnectionState.Closed)
                {
                    con.Open();
                }
                SqlCommand cmd = new SqlCommand("SELECT * from [dbo].[Post] where id=" + eid + ";", con);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 1)
                {
                    SqlCommand cmd1 = new SqlCommand("DELETE FROM [dbo].[Post]  WHERE id =" + eid + ";", con);
                    cmd1.ExecuteNonQuery();
                    Response.Write("<script>alert('Post deleted successfully.');</script>");
                    RepeterData();
                }
                else
                {
                    Response.Write("<script>alert('data not exist');</script>");
                }
                con.Close();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }

        }

        protected void PostRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

        }
    }
}