Return-Path: <SRS0=hiqq=AS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E0DC433DF
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 02:57:46 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E09CE20708
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 02:57:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E09CE20708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id D8CAB1108E908;
	Mon,  6 Jul 2020 19:57:45 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.20; helo=mga02.intel.com; envelope-from=dan.j.williams@intel.com; receiver=<UNKNOWN> 
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id B28F01108E903
	for <linux-nvdimm@lists.01.org>; Mon,  6 Jul 2020 19:57:43 -0700 (PDT)
IronPort-SDR: i/9KsNl3ONLGzTP+QkLv/uFsz/ETva6k2+ylQ/+bdOrY2kxB96GM6/tHmocNF44T4D3clUtnRg
 zwSwnCB+RsnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="135776541"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800";
   d="scan'208";a="135776541"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:57:43 -0700
IronPort-SDR: OkrK1VcA1pLFKeTsUrDh8d+Io97XHowzFoqek732liRbT0pmeGeLl+3W1jAQlol+yRVI66bUfO
 3VLb9w+boDqA==
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800";
   d="scan'208";a="483347700"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 19:57:43 -0700
Subject: [ndctl PATCH 13/16] test: Validate strict iomem protections of pmem
From: Dan Williams <dan.j.williams@intel.com>
To: linux-nvdimm@lists.01.org
Cc: vishal.l.verma@intel.com
Date: Mon, 06 Jul 2020 19:41:27 -0700
Message-ID: <159408968753.2386154.12723753534368313736.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <159408961822.2386154.888266173771881937.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159408961822.2386154.888266173771881937.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Message-ID-Hash: A7IIUAVYRNJECJRX277AEZGJDUTD5DBQ
X-Message-ID-Hash: A7IIUAVYRNJECJRX277AEZGJDUTD5DBQ
X-MailFrom: dan.j.williams@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/A7IIUAVYRNJECJRX277AEZGJDUTD5DBQ/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


---
 test/Makefile.am     |    9 +++
 test/revoke-devmem.c |  143 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 152 insertions(+)
 create mode 100644 test/revoke-devmem.c

diff --git a/test/Makefile.am b/test/Makefile.am
index 1d24a65ded8b..1dcaa1eb6da5 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -56,6 +56,7 @@ TESTS +=\
 	dax-xfs.sh \
 	align.sh \
 	device-dax \
+	revoke-devmem \
 	device-dax-fio.sh \
 	daxctl-devices.sh \
 	dm.sh \
@@ -71,6 +72,7 @@ check_PROGRAMS +=\
 	dax-dev \
 	dax-pmd \
 	device-dax \
+	revoke-devmem \
 	mmap
 endif
 
@@ -154,6 +156,13 @@ device_dax_LDADD = \
                 $(UUID_LIBS) \
 		../libutil.a
 
+revoke_devmem_SOURCES = \
+		revoke-devmem.c \
+		dax-dev.c \
+		$(testcore)
+
+revoke_devmem_LDADD = $(LIBNDCTL_LIB)
+
 smart_notify_SOURCES = smart-notify.c
 smart_notify_LDADD = $(LIBNDCTL_LIB)
 smart_listen_SOURCES = smart-listen.c
diff --git a/test/revoke-devmem.c b/test/revoke-devmem.c
new file mode 100644
index 000000000000..ffa509e2d7d1
--- /dev/null
+++ b/test/revoke-devmem.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2020 Intel Corporation. All rights reserved. */
+#include <fcntl.h>
+#include <stdio.h>
+#include <errno.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <string.h>
+#include <signal.h>
+#include <setjmp.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <util/size.h>
+#include <linux/falloc.h>
+#include <linux/version.h>
+#include <ndctl/libndctl.h>
+#include <ccan/array_size/array_size.h>
+
+#include <builtin.h>
+#include <test.h>
+
+static sigjmp_buf sj_env;
+
+static void sigbus(int sig, siginfo_t *siginfo, void *d)
+{
+	siglongjmp(sj_env, 1);
+}
+
+#define err(fmt, ...) \
+	fprintf(stderr, "%s: " fmt, __func__, ##__VA_ARGS__)
+
+static int test_devmem(int loglevel, struct ndctl_test *test,
+		struct ndctl_ctx *ctx)
+{
+	void *buf;
+	int fd, rc;
+	struct sigaction act;
+	unsigned long long resource;
+	struct ndctl_namespace *ndns;
+
+	ndctl_set_log_priority(ctx, loglevel);
+
+	/* iostrict devmem started in kernel 4.5 */
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 5, 0)))
+		return 77;
+
+	ndns = ndctl_get_test_dev(ctx);
+	if (!ndns) {
+		err("failed to find suitable namespace\n");
+		return 77;
+	}
+
+	resource = ndctl_namespace_get_resource(ndns);
+	if (resource == ULLONG_MAX) {
+		err("failed to retrieve resource base\n");
+		return 77;
+	}
+
+	rc = ndctl_namespace_disable(ndns);
+	if (rc) {
+		err("failed to disable namespace\n");
+		return rc;
+	}
+
+	/* establish a devmem mapping of the namespace memory */
+	fd = open("/dev/mem", O_RDWR);
+	if (fd < 0) {
+		err("failed to open /dev/mem: %s\n", strerror(errno));
+		rc = -errno;
+		goto out_devmem;
+	}
+
+	buf = mmap(NULL, SZ_2M, PROT_READ|PROT_WRITE, MAP_SHARED, fd, resource);
+	if (buf == MAP_FAILED) {
+		err("failed to map /dev/mem: %s\n", strerror(errno));
+		rc = -errno;
+		goto out_mmap;
+	}
+
+	/* populate and write, should not fail */
+	memset(buf, 0, SZ_2M);
+
+	memset(&act, 0, sizeof(act));
+	act.sa_sigaction = sigbus;
+	act.sa_flags = SA_SIGINFO;
+	if (sigaction(SIGBUS, &act, 0)) {
+		perror("sigaction");
+		rc = EXIT_FAILURE;
+		goto out_sigaction;
+	}
+
+	/* test fault due to devmem revocation */
+	if (sigsetjmp(sj_env, 1)) {
+		/* got sigbus, success */
+		fprintf(stderr, "devmem revoked!\n");
+		rc = 0;
+		goto out_sigaction;
+	}
+
+	rc = ndctl_namespace_enable(ndns);
+	if (rc) {
+		err("failed to enable namespace\n");
+		goto out_sigaction;
+	}
+
+	/* write, should sigbus */
+	memset(buf, 0, SZ_2M);
+
+	err("kernel failed to prevent write after namespace enabled\n");
+	rc = -ENXIO;
+
+out_sigaction:
+	munmap(buf, SZ_2M);
+out_mmap:
+	close(fd);
+out_devmem:
+	if (ndctl_namespace_enable(ndns) != 0)
+		err("failed to re-enable namespace\n");
+	return rc;
+}
+
+int main(int argc, char *argv[])
+{
+	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_ctx *ctx;
+	int rc;
+
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
+	rc = ndctl_new(&ctx);
+	if (rc < 0)
+		return ndctl_test_result(test, rc);
+
+	rc = test_devmem(LOG_DEBUG, test, ctx);
+	ndctl_unref(ctx);
+	return ndctl_test_result(test, rc);
+}
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
