Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 99B6621198CC2
 for <linux-nvdimm@lists.01.org>; Thu, 27 Dec 2018 19:42:56 -0800 (PST)
Subject: [ndctl PATCH 4/7] ndctl/monitor: Unify definition of default
 monitor configfile path
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Dec 2018 19:30:19 -0800
Message-ID: <154596781985.164521.10399375562523595499.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154596779833.164521.12632457592535372923.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The definition of the monitor configuration file can get out of sync
with current duplication between configure.ac and ndctl/Makefile.am.
Instead, define all the variables in configure.ac and just reference
them in ndctl/Makefile.am.

Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac      |    8 +++++++-
 ndctl/Makefile.am |    6 ++----
 ndctl/monitor.c   |    2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index de5b84cec670..aa07ec7bc870 100644
--- a/configure.ac
+++ b/configure.ac
@@ -154,8 +154,14 @@ fi
 AC_SUBST([systemd_unitdir])
 AM_CONDITIONAL([ENABLE_SYSTEMD_UNITS], [test "x$with_systemd" = "xyes"])
 
+ndctl_monitorconfdir=${sysconfdir}/ndctl
+ndctl_monitorconf=monitor.conf
+AC_SUBST([ndctl_monitorconfdir])
+AC_SUBST([ndctl_monitorconf])
+AC_DEFINE_UNQUOTED(NDCTL_CONF_FILE, ["$ndctl_monitorconfdir/$ndctl_monitorconf"],
+	[default ndctl monitor conf path])
+
 my_CFLAGS="\
--D DEF_CONF_FILE='\"${sysconfdir}/ndctl/monitor.conf\"' \
 -Wall \
 -Wchar-subscripts \
 -Wformat-security \
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 8a5e5f87e6c5..ff01e0688afd 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -43,10 +43,8 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 test.c
 endif
 
-monitor_config_file = monitor.conf
-monitor_configdir = $(sysconfdir)/ndctl/
-monitor_config_DATA = $(monitor_config_file)
-EXTRA_DIST += $(monitor_config_file)
+monitor_configdir = $(ndctl_monitorconfdir)
+monitor_config_DATA = $(ndctl_monitorconf)
 
 if ENABLE_SYSTEMD_UNITS
 systemd_unit_DATA = ndctl-monitor.service
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 08219f99b12b..cef70d06beae 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -503,7 +503,7 @@ static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
 	if (_monitor->config_file)
 		config_file = strdup(_monitor->config_file);
 	else
-		config_file = strdup(DEF_CONF_FILE);
+		config_file = strdup(NDCTL_CONF_FILE);
 	if (!config_file) {
 		fail("strdup default config file failed\n");
 		rc = -ENOMEM;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
