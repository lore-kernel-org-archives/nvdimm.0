Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4BFFB1A1ED6
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 06:28:32 -0800 (PST)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [ndctl PATCH] ndctl: Grab kernel version from utsname()
Date: Thu, 10 Mar 2016 15:28:09 +0100
Message-Id: <1457620089-28984-1-git-send-email-jthumshirn@suse.de>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Grab the kernel version used for tests dynamically via utsname() instead of
hardcoding the version of the build host.

Otherwise tests will be skipped if the build host had a too old kernel
version.

flodin:~ # ./ndctl test
__ndctl_test_attempt: skip test_libndctl:1950 requires: 4.2.0 current: 4.1.0
test-libndctl: SKIP
__ndctl_test_attempt: skip test_dpa_alloc:300 requires: 4.2.0 current: 4.1.0
test-dpa-alloc: SKIP
__ndctl_test_attempt: skip test_parent_uuid:230 requires: 4.3.0 current: 4.1.0
test-parent-uuid: SKIP
attempted: 3 skipped: 3

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 test/core.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/test/core.c
+++ b/test/core.c
@@ -1,4 +1,5 @@
 #include <linux/version.h>
+#include <sys/utsname.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <test.h>
@@ -11,6 +12,18 @@ struct ndctl_test {
 	int skip;
 };
 
+static unsigned int get_system_kver(void)
+{
+	struct utsname utsname;
+	int a, b, c;
+
+	uname(&utsname);
+
+	sscanf(utsname.version, "%d.%d.%d", &a, &b, &c);
+
+	return KERNEL_VERSION(a,b,c);
+}
+
 struct ndctl_test *ndctl_test_new(unsigned int kver)
 {
 	struct ndctl_test *test = calloc(1, sizeof(*test));
@@ -19,7 +32,7 @@ struct ndctl_test *ndctl_test_new(unsign
 		return NULL;
 
 	if (!kver)
-		test->kver = LINUX_VERSION_CODE;
+		test->kver = get_system_kver();
 	else
 		test->kver = kver;
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
