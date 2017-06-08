foreach (SPUser user in web.AllUsers)
{
   SPUserToken token = user.UserToken;
   using (SPSite impersonatedSite = new SPSite(web.Site.ID, token))
   {
      using (SPWeb impersonatedWeb = impersonatedSite.OpenWeb(web.ID))
      {
         SPList list = impersonatedWeb.GetList(web.Url + "/Lists/YourList");
         SPViewCollection views = list.Views;
         //delete the personal views here by checking SPView.PersonView property
      }
   }
}