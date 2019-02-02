Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CE11211C649C
 for <linux-nvdimm@lists.01.org>; Fri,  1 Feb 2019 16:39:03 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl,
 rpmbuild: Add a dummy readme file to ndctl_keysdir
Date: Fri,  1 Feb 2019 17:39:00 -0700
Message-Id: <20190202003900.8487-1-vishal.l.verma@intel.com>
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

At build time, ndctl_keysdir (/etc/nddctl/keys/) was empty, and thus
it never gets created. Since the directory is listed in the %files
section of the RPM spec, RPM checks for it and fails since it is not
present.

Fix this by adding a simple 'keys.readme' file to the keys dorectory
that points the user to the setup-passphrase man page, and installing it
during the build.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac      | 2 ++
 ndctl.spec.in     | 1 +
 ndctl/Makefile.am | 2 ++
 ndctl/keys.readme | 1 +
 4 files changed, 6 insertions(+)
 create mode 100644 ndctl/keys.readme

diff --git a/configure.ac b/configure.ac
index b08ddaf..d27a2b1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -179,7 +179,9 @@ AS_IF([test "x$with_keyutils" = "xyes"],
 AM_CONDITIONAL([ENABLE_KEYUTILS], [test "x$with_keyutils" = "xyes"])
 
 ndctl_keysdir=${sysconfdir}/ndctl/keys
+ndctl_keysreadme=keys.readme
 AC_SUBST([ndctl_keysdir])
+AC_SUBST([ndctl_keysreadme])
 
 my_CFLAGS="\
 -Wall \
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 5ceb27a..8abccbf 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -110,6 +110,7 @@ make check
 %{bashcompdir}/
 %{_unitdir}/ndctl-monitor.service
 %dir %{_sysconfdir}/ndctl/keys/
+%{_sysconfdir}/ndctl/keys/keys.readme
 %{_sysconfdir}/modprobe.d/nvdimm-security.conf
 
 %config(noreplace) %{_sysconfdir}/ndctl/monitor.conf
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index cd3312b..3287dbb 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -29,6 +29,8 @@ ndctl_SOURCES = ndctl.c \
 if ENABLE_KEYUTILS
 ndctl_SOURCES += util/keys.c \
 		load-keys.c
+keys_configdir = $(ndctl_keysdir)
+keys_config_DATA = $(ndctl_keysreadme)
 endif
 
 if ENABLE_DESTRUCTIVE
diff --git a/ndctl/keys.readme b/ndctl/keys.readme
new file mode 100644
index 0000000..506678a
--- /dev/null
+++ b/ndctl/keys.readme
@@ -0,0 +1 @@
+See 'ndctl setup-passphrase --help'
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
