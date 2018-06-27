Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7DCA2202E53DB
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 22:25:14 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 3358DAC0289
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 14:25:09 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH v8 3/3] ndctl,
 monitor: add the unit file of systemd for ndctl-monitor service
Date: Wed, 27 Jun 2018 14:24:26 +0900
Message-Id: <20180627052426.26020-4-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180627052426.26020-1-qi.fuli@jp.fujitsu.com>
References: <20180627052426.26020-1-qi.fuli@jp.fujitsu.com>
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

A monitor daemon can be started as a system service:
   # systemctl start ndctl-monitor.service

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 autogen.sh                  |  3 ++-
 configure.ac                | 22 ++++++++++++++++++++++
 ndctl/Makefile.am           |  4 ++++
 ndctl/ndctl-monitor.service |  7 +++++++
 4 files changed, 35 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/ndctl-monitor.service

diff --git a/autogen.sh b/autogen.sh
index 2a52688..21b0e25 100755
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
index cf44260..a5ba9a1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -143,6 +143,27 @@ AC_CHECK_FUNCS([ \
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
+	[AC_SUBST([systemd_unitdir], [$with_systemd_unit_dir])])
+AM_CONDITIONAL([ENABLE_SYSTEMD_UNIT_DIR], [test "x$with_systemd_unit_dir" != "xno"])
+
 my_CFLAGS="\
 -Wall \
 -Wchar-subscripts \
@@ -184,6 +205,7 @@ AC_MSG_RESULT([
         sysconfdir:             ${sysconfdir}
         libdir:                 ${libdir}
         includedir:             ${includedir}
+	systemd-unit-dir:	${systemd_unitdir}
 
         compiler:               ${CC}
         cflags:                 ${CFLAGS}
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index ae3d894..9d008d5 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -47,3 +47,7 @@ monitor_config_file = monitor.conf
 monitor_configdir = /etc/ndctl/
 monitor_config_DATA = $(monitor_config_file)
 EXTRA_DIST += $(monitor_config_file)
+
+if ENABLE_SYSTEMD_UNIT_DIR
+systemd_unit_DATA = ndctl-monitor.service
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
2.17.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
