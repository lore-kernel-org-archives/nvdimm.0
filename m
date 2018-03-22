Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8106E225E400C
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 11:33:39 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH 2/2] ndctl: fail NUMA filtering when unavailable
Date: Thu, 22 Mar 2018 12:40:07 -0600
Message-Id: <20180322184007.25667-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180322184007.25667-1-ross.zwisler@linux.intel.com>
References: <20180322184007.25667-1-ross.zwisler@linux.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, "Jiang, Dave" <dave.jiang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Instead of just failing to find namespaces when trying to filter by NUMA
node when CONFIG_NUMA wasn't enabled in the kernel, instead fail loudly as
numactl does:

  # numactl --cpunodebind=0 ls
  numactl: This system does not support NUMA policy

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---

This enabling requires numactl to create a pkg-config file, which it
currently does not.  This support is added by the following patch which
I just sent out:

https://patchwork.kernel.org/patch/10302135/

---
 Makefile.am.in    |  3 ++-
 autogen.sh        |  3 ++-
 configure.ac      | 12 ++++++++++++
 ndctl.spec.in     |  3 ++-
 ndctl/Makefile.am |  3 ++-
 util/filter.c     | 11 +++++++++++
 6 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/Makefile.am.in b/Makefile.am.in
index 6c5229d..b927e17 100644
--- a/Makefile.am.in
+++ b/Makefile.am.in
@@ -15,7 +15,8 @@ AM_CPPFLAGS = \
 	$(KMOD_CFLAGS) \
 	$(UDEV_CFLAGS) \
 	$(UUID_CFLAGS) \
-	$(JSON_CFLAGS)
+	$(JSON_CFLAGS) \
+	$(NUMA_CFLAGS)
 
 AM_CFLAGS = ${my_CFLAGS} \
 	-fvisibility=hidden \
diff --git a/autogen.sh b/autogen.sh
index a23cf53..46515b2 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -17,7 +17,8 @@ libdir() {
 
 args="--prefix=/usr \
 --sysconfdir=/etc \
---libdir=$(libdir /usr/lib)"
+--libdir=$(libdir /usr/lib) \
+--with-numa"
 
 echo
 echo "----------------------------------------------------------------"
diff --git a/configure.ac b/configure.ac
index 3eaac32..af21cb6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -94,6 +94,18 @@ PKG_CHECK_MODULES([UDEV], [libudev])
 PKG_CHECK_MODULES([UUID], [uuid])
 PKG_CHECK_MODULES([JSON], [json-c])
 
+AC_ARG_WITH([numa],
+	AS_HELP_STRING([--with-numa],
+		       [Install with NUMA support. @<:@default=no@:>@]),
+	[],
+	[with_numa=no])
+
+if test "x$with_numa" = "xyes"; then
+	PKG_CHECK_MODULES([NUMA], [numa])
+	AC_DEFINE([WITH_NUMA], [1], [with NUMA support])
+fi
+AM_CONDITIONAL([WITH_NUMA], [test "x$with_numa" = "xyes"])
+
 AC_ARG_WITH([bash-completion-dir],
 	AS_HELP_STRING([--with-bash-completion-dir[=PATH]],
 		[Install the bash auto-completion script in this directory. @<:@default=yes@:>@]),
diff --git a/ndctl.spec.in b/ndctl.spec.in
index e2c879c..3fcb4d8 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -20,6 +20,7 @@ BuildRequires:	pkgconfig(libudev)
 BuildRequires:	pkgconfig(uuid)
 BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
+BuildRequires:	pkgconfig(numa)
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -90,7 +91,7 @@ control API for these devices.
 %build
 echo %{version} > version
 ./autogen.sh
-%configure --disable-static --disable-silent-rules
+%configure --disable-static --disable-silent-rules --with-numa
 make %{?_smp_mflags}
 
 %install
diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 213cabd..6b891f8 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -29,7 +29,8 @@ ndctl_LDADD =\
 	../libutil.a \
 	$(UUID_LIBS) \
 	$(KMOD_LIBS) \
-	$(JSON_LIBS)
+	$(JSON_LIBS) \
+	$(NUMA_LIBS)
 
 if ENABLE_TEST
 ndctl_SOURCES += ../test/libndctl.c \
diff --git a/util/filter.c b/util/filter.c
index 291d7ed..512f927 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -10,6 +10,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
+#include <numa.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -328,6 +329,16 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
 	}
 
 	if (param->numa_node && strcmp(param->numa_node, "all") != 0) {
+#ifdef WITH_NUMA
+		if (numa_available() < 0) {
+			error("This system does not support NUMA");
+#else
+		{
+			error("ndctl was not configured with NUMA support");
+#endif
+			return -EINVAL;
+		}
+
 		numa_node = strtol(param->numa_node, &end, 0);
 		if (end == param->numa_node || end[0]) {
 			error("invalid numa_node: '%s'\n", param->numa_node);
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
