Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D88C62035D6CC
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 04:33:33 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id F2AA8AC03BC
 for <linux-nvdimm@lists.01.org>; Thu, 26 Apr 2018 20:33:26 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH v5 4/4] ndctl,
 monitor: add the unit file of systemd for ndctl-monitor service
Date: Thu, 26 Apr 2018 20:30:50 +0900
Message-Id: <20180426113050.11424-5-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180426113050.11424-1-qi.fuli@jp.fujitsu.com>
References: <20180426113050.11424-1-qi.fuli@jp.fujitsu.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch adds the systemd unit file for ndctl-monitor service.
The systemd unit directory can be configured by setting environment
variable "--with-systemd-unit-dir[=DIR]".

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>

---
 autogen.sh                  |  3 ++-
 configure.ac                | 22 ++++++++++++++++++++++
 ndctl/Makefile.am           |  4 ++++
 ndctl/ndctl-monitor.service |  7 +++++++
 4 files changed, 35 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/ndctl-monitor.service

diff --git a/autogen.sh b/autogen.sh
index a23cf53..b226c7a 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -17,7 +17,8 @@ libdir() {
 
 args="--prefix=/usr \
 --sysconfdir=/etc \
---libdir=$(libdir /usr/lib)"
+--libdir=$(libdir /usr/lib) \
+--with-systemd-unit-dir"
 
 echo
 echo "----------------------------------------------------------------"
diff --git a/configure.ac b/configure.ac
index cddad16..60c6537 100644
--- a/configure.ac
+++ b/configure.ac
@@ -135,6 +135,27 @@ AC_CHECK_FUNCS([ \
 	secure_getenv\
 ])
 
+PKG_PROG_PKG_CONFIG
+AC_ARG_WITH([systemd-unit-dir],
+	AS_HELP_STRING([--with-systemd-unit-dir[=DIR]],
+		[Directory for systemd service files]),
+	[],
+	[with_systemd_unit_dir=yes])
+
+if test "x$with_systemd_unit_dir" = "xyes"; then
+	def_systemd_unit_dir=$($PKG_CONFIG --variable=systemdsystemunitdir systemd)
+	if test "x$def_systemd_unit_dir" = "x"; then
+		AC_MSG_ERROR([systemd support requested but pkg-config unable to query systemd package])
+		with_systemd_unit_dir=no
+	else
+		with_systemd_unit_dir="$def_systemd_unit_dir"
+	fi
+fi
+
+AS_IF([test "x$with_systemd_unit_dir" != "xno"],
+	[AC_SUBST([SYSTEMD_UNIT_DIR], [$with_systemd_unit_dir])])
+AM_CONDITIONAL([ENABLE_SYSTEMD_UNIT_DIR], [test "x$with_systemd_unit_dir" != "xno"])
+
 my_CFLAGS="\
 -Wall \
 -Wchar-subscripts \
@@ -172,6 +193,7 @@ AC_MSG_RESULT([
         sysconfdir:             ${sysconfdir}
         libdir:                 ${libdir}
         includedir:             ${includedir}
+	systemd-unit-dir:	${SYSTEMD_UNIT_DIR}
 
         compiler:               ${CC}
         cflags:                 ${CFLAGS}
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index ae3d894..b3053d0 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -47,3 +47,7 @@ monitor_config_file = monitor.conf
 monitor_configdir = /etc/ndctl/
 monitor_config_DATA = $(monitor_config_file)
 EXTRA_DIST += $(monitor_config_file)
+
+if ENABLE_SYSTEMD_UNIT_DIR
+systemd_unitDATA = ndctl-monitor.service
+endif
diff --git a/ndctl/ndctl-monitor.service b/ndctl/ndctl-monitor.service
new file mode 100644
index 0000000..44f9326
--- /dev/null
+++ b/ndctl/ndctl-monitor.service
@@ -0,0 +1,7 @@
+[Unit]
+Description=Ndctl Monitor Daemon
+
+[Service]
+Type=forking
+ExecStart=/usr/bin/ndctl monitor --daemon
+ExecStop=/bin/kill ${MAINPID}
-- 
2.17.0.140.g0b0cc9f86


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
