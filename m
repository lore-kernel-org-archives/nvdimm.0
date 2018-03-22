Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A595225E4001
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 11:33:39 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH 1/2] ndctl: complete removal of daxctl io
Date: Thu, 22 Mar 2018 12:40:06 -0600
Message-Id: <20180322184007.25667-1-ross.zwisler@linux.intel.com>
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

commit 0a8dd795b4cf ("ndctl: removing daxctl io")

didn't fully remove all daxctl io, leaving behind a few of the lines which
were added by the original commit:

commit 67b54c1c76e5 ("ndctl: daxctl: Adding io option for daxctl")

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Fixes: commit 0a8dd795b4cf ("ndctl: removing daxctl io")
---
 daxctl/Makefile.am | 1 -
 daxctl/daxctl.c    | 6 ------
 ndctl.spec.in      | 7 -------
 3 files changed, 14 deletions(-)

diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
index e256afd..fe467d0 100644
--- a/daxctl/Makefile.am
+++ b/daxctl/Makefile.am
@@ -9,7 +9,6 @@ daxctl_SOURCES =\
 
 daxctl_LDADD =\
 	lib/libdaxctl.la \
-	../ndctl/lib/libndctl.la \
 	../libutil.a \
 	$(UUID_LIBS) \
 	$(JSON_LIBS)
diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
index cedc847..91a4600 100644
--- a/daxctl/daxctl.c
+++ b/daxctl/daxctl.c
@@ -67,17 +67,11 @@ static int cmd_help(int argc, const char **argv, void *ctx)
 }
 
 int cmd_list(int argc, const char **argv, void *ctx);
-#ifdef ENABLE_DAXIO
-int cmd_io(int argc, const char **argv, void *ctx);
-#endif
 
 static struct cmd_struct commands[] = {
 	{ "version", cmd_version },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
-#ifdef ENABLE_DAXIO
-	{ "io", cmd_io },
-#endif
 };
 
 int main(int argc, const char **argv)
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 3a5edc3..e2c879c 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -20,9 +20,6 @@ BuildRequires:	pkgconfig(libudev)
 BuildRequires:	pkgconfig(uuid)
 BuildRequires:	pkgconfig(json-c)
 BuildRequires:	pkgconfig(bash-completion)
-%ifarch x86_64
-BuildRequires:	pkgconfig(libpmem)
-%endif
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"
@@ -93,11 +90,7 @@ control API for these devices.
 %build
 echo %{version} > version
 ./autogen.sh
-%ifarch x86_64
-%configure --disable-static --disable-silent-rules --with-libpmem
-%else
 %configure --disable-static --disable-silent-rules
-%endif
 make %{?_smp_mflags}
 
 %install
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
