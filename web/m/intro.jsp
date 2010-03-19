<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page pageEncoding="euc-kr" import="java.util.*,java.sql.*, kr.pe.okjsp.BbsInfoBean,  kr.pe.okjsp.util.DbCon" %>
<%!
public HashMap getRecentList()
{
    int i =0;
    HashMap recentList = new HashMap();
    
    StringBuffer query = new StringBuffer();
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;	
	DbCon dbCon = new DbCon();
	
	try 
	{
		conn = dbCon.getConnection();
		 
	    query.append(" select bbsid, count(*) as cnt from okboard ");
	    query.append(" where ");
	    query.append(" cast(wtime as date)=cast(systimestamp as date) ");
	    query.append(" group by bbsid ");
	    query.append(" order by cnt desc ");
	    query.append(" for ORDERBY_NUM() BETWEEN 1 and 3 ");
		pstmt = conn.prepareStatement(query.toString());
		rs = pstmt.executeQuery();
	
		while(rs.next()) 
		{
			recentList.put("bbsid["+i+"]",rs.getString("bbsid"));
			recentList.put("cnt["+i+"]", rs.getInt("cnt"));
			recentList.put("nCount", i);
			
			i++;
		}
		
		rs.close();
		pstmt.close();
	} 
	catch(Exception e) 
	{
		e.printStackTrace();
	} finally 
	{
		dbCon.close(conn, pstmt, rs);
	}
	
	return recentList;
}
%>

<%@page import="twitter4j.api.ListSubscribersMethods"%><html>
<head>
<META HTTP-EQUIV="Content-type" CONTENT="text/html;charset=ksc5601">

<!-- IUI Header Start -->
<meta name="viewport" content="width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
<link rel="apple-touch-icon" href="/m/iui/iui-logo-touch-icon.png" />
<meta name="apple-touch-fullscreen" content="YES" />
<style type="text/css" media="screen">@import "/m/iui/iui.css";</style>
<script type="application/x-javascript" src="/m/iui/iui.js"></script>
<style type="text/css">
body > ul > li {
    font-size: 14px;
}
body > ul > li > a {
    padding-left: 54px;
    padding-right: 40px;
    min-height: 34px;
}
li .digg-count {
    display: block;
    position: absolute;
    margin: 0;
    left: 6px;
    top: 7px;
    text-align: center;
    font-size: 110%;
    letter-spacing: -0.07em;
    color: #93883F;
    font-weight: bold;
    text-decoration: none;
    width: 36px;
    height: 30px;
    padding: 7px 0 0 0;
    background: url(/m/iui/shade-compact.gif) no-repeat;
}
h2 {
    margin: 10px;
    color: slateblue;
}
p {
    margin: 10px;
}
</style>
<!-- IUI Header End -->

</head>
<body>
    <div class="toolbar">
        <h1 id="pageTitle"></h1>
        <a id="backButton" class="button" href="#"></a>
    </div>
    <ul title="OKJSP" selected="true">
		<%			
			HashMap map = (HashMap)application.getAttribute("bbsInfoMap");
			int listSize = (Integer)getRecentList().get("nCount");
			
			for(int i=0; i<=listSize; i++)
			{
			    BbsInfoBean bbsInfo = (BbsInfoBean)map.get(getRecentList().get("bbsid["+i+"]"));			    
		%>
        <li>
            <div class="digg-count"><%=(i+1)%></div>
            <a href="/bbs?act=MLIST&bbs=<%=bbsInfo.getBbs()%>"><%=bbsInfo.getName()%>[<%=getRecentList().get("cnt["+i+"]")%>]</a>
        </li>
		<%
			}
		%>
		<li>
			<div class="digg-count">4</div>
 			<a href="#">�ֱٱ� �Խ���</a>
		</li>
		<li>
			<div class="digg-count">5</div>
			<a href="main.jsp" target="_replace">Get More Page...</a>
		</li>		
    </ul>
</body>
</html>