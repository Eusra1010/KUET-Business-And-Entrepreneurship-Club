<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KBEC - KUET Business &amp; Entrepreneurship Club</title>
    <link rel="stylesheet" href="kbec.css">
</head>

<body class="<%= Session["AdminRole"] != null && Session["AdminRole"].ToString() == "SuperAdmin" ? "admin-mode" : "" %>">

<% if (Session["AdminRole"] != null && Session["AdminRole"].ToString() == "SuperAdmin") { %>
<div class="admin-toolbar">
    <span>Admin Mode — <strong><%= Session["AdminName"] %></strong></span>
    <div class="admin-toolbar-btns">
        <a href="admin-dashboard.aspx" class="toolbar-btn">Dashboard</a>
        <a href="admin-logout.aspx" class="toolbar-btn toolbar-logout">Logout</a>
    </div>
</div>
<% } %>

    <header class="navbar">
        <div class="nav-left">
            <img src="logo.jpg" alt="Logo" />
            <h2>KBEC</h2>
        </div>

        <nav class="nav-links">
            <a href="kbec.aspx">Home</a>
            <a href="#">About</a>
            <a href="events.aspx">Events</a>
            <a href="executives.aspx">Alumni</a>
        </nav>

        <div class="nav-right">
            <div style="position:relative;">
                <button class="profile-btn" id="profileMenuButton" type="button"
                    aria-haspopup="true" aria-expanded="false" aria-controls="profileMenu">
                    <span class="sr-only">Menu</span>
                    <svg class="profile-icon" viewBox="0 0 24 24" aria-hidden="true" focusable="false">
                        <path d="M12 12a4 4 0 1 0-4-4 4 4 0 0 0 4 4Zm0 2c-4.42 0-8 2-8 4.5A1.5 1.5 0 0 0 5.5 20h13A1.5 1.5 0 0 0 20 18.5C20 16 16.42 14 12 14Z" />
                    </svg>
                </button>

                <div class="profile-menu" id="profileMenu" hidden>

                    <% if (Session["AdminRole"] != null && Session["AdminRole"].ToString() == "SuperAdmin") { %>
                    <div class="profile-menu-title">Super Admin</div>
                    <button type="button" class="profile-menu-item" onclick="window.location.href='admin-dashboard.aspx'">Dashboard</button>
                    <button type="button" class="profile-menu-item" onclick="window.location.href='executives.aspx'">Manage Members</button>
                    <div class="profile-menu-divider"></div>
                    <button type="button" class="profile-menu-item profile-menu-logout" onclick="window.location.href='admin-logout.aspx'">Logout</button>

                    <% } else if (Session["UserId"] != null) { %>
                    <div class="profile-menu-title"><%= Session["UserName"] %></div>
                    <button type="button" class="profile-menu-item" onclick="window.location.href='profile.aspx'">My Profile</button>
                    <button type="button" class="profile-menu-item" onclick="window.location.href='my-events.aspx'">My Events</button>
                    <div class="profile-menu-divider"></div>
                    <button type="button" class="profile-menu-item profile-menu-logout" onclick="window.location.href='logout.aspx'">Logout</button>

                    <% } else { %>
                    <div class="profile-menu-title">Login as</div>
                    <button type="button" class="profile-menu-item" onclick="window.location.href='login.aspx'">User Login</button>
                    <div class="profile-menu-divider"></div>
                    <button type="button" class="profile-menu-item" onclick="window.location.href='admin-login.aspx'">Admin Login</button>
                    <% } %>

                </div>
            </div>
        </div>
    </header>

    <section class="hero">
        <div class="hero-text">
            <h1>KBEC</h1>
            <p>
                Igniting innovation, leadership, and entrepreneurial excellence at KUET.
                Empowering students to grow, lead, and succeed globally.
            </p>
            <div class="hero-buttons">
                <button class="btn btn-outline" type="button">Discover More</button>
                <a class="btn btn-primary" href="events.aspx">View Events</a>
            </div>
        </div>
        <div class="hero-media">
            <img class="hero-logo" src="logo.jpg" alt="KBEC Logo" />
        </div>
    </section>

    <section class="what-next" aria-labelledby="whats-next-title">
        <div class="section-heading">
            <h2 id="whats-next-title">What's Next</h2>
        </div>
        <div class="what-next-marquee" aria-label="Upcoming events">
            <div class="what-next-track">
                <div class="what-next-item">KBEC NEXUS S3</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
                <div class="what-next-item">CASE CRACK 3.0</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
                <div class="what-next-item">TEDX KUET 2026</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
                <div class="what-next-item" aria-hidden="true">KBEC NEXUS S3</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
                <div class="what-next-item" aria-hidden="true">CASE CRACK 3.0</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
                <div class="what-next-item" aria-hidden="true">TEDX KUET 2026</div>
                <div class="what-next-divider" aria-hidden="true">|</div>
            </div>
        </div>
    </section>

    <section class="sponsors">
        <h2>Our Sponsors</h2>
        <div class="sponsor-marquee">
            <div class="sponsor-logos" aria-label="Sponsor logos">
                <div><img src="images/sponsors/10%20minute%20school.jpg" alt="10 Minute School" /></div>
                <div><img src="images/sponsors/banglalink.jpg" alt="Banglalink" /></div>
                <div><img src="images/sponsors/Bank%20asia.jpg" alt="Bank Asia" /></div>
                <div><img src="images/sponsors/NCC%20bank.jpg" alt="NCC Bank" /></div>
                <div><img src="images/sponsors/prime_bank.jpeg" alt="Prime Bank" /></div>
                <div><img src="images/sponsors/Somoy%20tv.jpg" alt="Somoy TV" /></div>
                <div><img src="images/sponsors/Walton.jpg" alt="Walton" /></div>
                <div><img src="images/sponsors/Uniliver.jpg" alt="Unilever" /></div>
                <div><img src="images/sponsors/Polar.jpeg" alt="Polar" /></div>
                <div><img src="images/sponsors/Skino.jpg" alt="Skino" /></div>
                <div><img src="images/sponsors/SR%20dream%20it.jpg" alt="SR Dream IT" /></div>
                <div><img src="images/sponsors/Clemon.jpg" alt="Clemon" /></div>
                <div aria-hidden="true"><img src="images/sponsors/10%20minute%20school.jpg" alt="" /></div>
                <div aria-hidden="true"><img src="images/sponsors/banglalink.jpg" alt="" /></div>
                <div aria-hidden="true"><img src="images/sponsors/Bank%20asia.jpg" alt="" /></div>
                <div aria-hidden="true"><img src="images/sponsors/NCC%20bank.jpg" alt="" /></div>
                <div aria-hidden="true"><img src="images/sponsors/prime_bank.jpeg" alt="" /></div>
                <div aria-hidden="true"><img src="images/sponsors/Somoy%20tv.jpg" alt="" /></div>
                <div aria-hidden="true"><img src="images/sponsors/Walton.jpg" alt="" /></div>
                <div aria-hidden="true"><img src="images/sponsors/Uniliver.jpg" alt="" /></div>
                <div aria-hidden="true"><img src="images/sponsors/Polar.jpeg" alt="" /></div>
                <div aria-hidden="true"><img src="images/sponsors/Skino.jpg" alt="" /></div>
                <div aria-hidden="true"><img src="images/sponsors/SR%20dream%20it.jpg" alt="" /></div>
                <div aria-hidden="true"><img src="images/sponsors/Clemon.jpg" alt="" /></div>
            </div>
        </div>
    </section>

    <footer class="footer">
        <div class="footer-container">
            <div class="footer-left">
                <img src="logo.jpg" alt="Logo" />
                <h3>KUET Business &amp; Entrepreneurship Club</h3>
                <p>The Premier Business And Entrepreneurship Club of KUET.</p>
                <div class="footer-contact">
                    <p>&#128205; SWC-302, Students Welfare Center, KUET</p>
                    <p>&#128222; +880 1822 076 101</p>
                    <p>&#9993; kbec.kuet@gmail.com</p>
                </div>
            </div>
            <div class="footer-right">
                <h4>Follow Us</h4>
                <div class="footer-social">
                    <a href="https://www.facebook.com/KBEC.official/" target="_blank" rel="noopener noreferrer" aria-label="Facebook">F</a>
                    <a href="https://www.instagram.com/kbec.kuet/" target="_blank" rel="noopener noreferrer" aria-label="Instagram">IG</a>
                    <a href="https://www.linkedin.com/company/kuet-business-and-entrepreneurship-club/" target="_blank" rel="noopener noreferrer" aria-label="LinkedIn">in</a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            &copy; 2026 KBEC Official. All Rights Reserved.
            <a href="admin-login.aspx" style="color:#222;font-size:0.7rem;margin-left:20px;">Admin</a>
        </div>
    </footer>

    <script src="kbec.js"></script>

</body>