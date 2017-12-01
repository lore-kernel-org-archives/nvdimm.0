Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 58EC721A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:29:42 -0800 (PST)
Subject: [ndctl PATCH 16/17] ndctl, test: listen for smart notifications
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:25:54 -0800
Message-ID: <151217075457.28402.11798467193749443320.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Watch all DIMMs on a given nvdimm bus for smart events and report if
they trigger.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am    |    3 +
 test/smart-listen.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+)
 create mode 100644 test/smart-listen.c

diff --git a/test/Makefile.am b/test/Makefile.am
index 85736c3cce09..d4c2bd6b2640 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -26,6 +26,7 @@ check_PROGRAMS =\
 	multi-pmem \
 	dax-errors \
 	smart-notify \
+	smart-listen \
 	daxdev-errors
 
 if ENABLE_DESTRUCTIVE
@@ -103,6 +104,8 @@ device_dax_LDADD = \
 
 smart_notify_SOURCES = smart-notify.c
 smart_notify_LDADD = $(LIBNDCTL_LIB)
+smart_listen_SOURCES = smart-listen.c
+smart_listen_LDADD = $(LIBNDCTL_LIB)
 
 multi_pmem_SOURCES = \
 		multi-pmem.c \
diff --git a/test/smart-listen.c b/test/smart-listen.c
new file mode 100644
index 000000000000..e365ce54c7bd
--- /dev/null
+++ b/test/smart-listen.c
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2017 Intel Corporation. All rights reserved. */
+#include <poll.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <ndctl/libndctl.h>
+
+static void dimm_listen(struct ndctl_bus *bus)
+{
+	struct ndctl_dimm *dimm, **dimms;
+	int count = 0, maxfd = -1, i, rc;
+	struct pollfd *poll_ents, *p;
+	char buf;
+
+	ndctl_dimm_foreach(bus, dimm) {
+		int fd = ndctl_dimm_get_health_eventfd(dimm);
+
+		if (fd > maxfd)
+			maxfd = fd;
+		count++;
+	}
+
+	if (!count) {
+		fprintf(stderr, "no dimms on bus: %s\n",
+				ndctl_bus_get_provider(bus));
+		return;
+	}
+
+	poll_ents = calloc(count, sizeof(struct pollfd));
+	dimms = calloc(maxfd + 1, sizeof(struct ndctl_dimm *));
+
+	if (!poll_ents)
+		goto out;
+	if (!dimms)
+		goto out;
+
+	i = 0;
+	ndctl_dimm_foreach(bus, dimm) {
+		int fd = ndctl_dimm_get_health_eventfd(dimm);
+
+		p = &poll_ents[i++];
+		p->fd = fd;
+		dimms[fd] = dimm;
+		if (i > count) {
+			fprintf(stderr, "dimm count changed!?\n");
+			goto out;
+		}
+	}
+
+retry:
+	for (i = 0; i < count; i++) {
+		p = &poll_ents[i];
+		dimm = dimms[p->fd];
+		if (pread(p->fd, &buf, 1, 0) != 1) {
+			fprintf(stderr, "%s: failed to read\n",
+					ndctl_dimm_get_devname(dimm));
+			goto out;
+		}
+		if (p->revents)
+			fprintf(stderr, "%s: smart event: %d\n",
+					ndctl_dimm_get_devname(dimm),
+					p->revents);
+		p->revents = 0;
+	}
+
+	rc = poll(poll_ents, count, -1);
+	if (rc <= 0) {
+		fprintf(stderr, "failed to poll\n");
+		goto out;
+	}
+	goto retry;
+
+out:
+	free(poll_ents);
+	free(dimms);
+}
+
+int main(int argc, char *argv[])
+{
+	struct ndctl_ctx *ctx;
+	struct ndctl_bus *bus;
+	int rc = EXIT_FAILURE;
+	const char *provider;
+
+	rc = ndctl_new(&ctx);
+	if (rc < 0)
+		return EXIT_FAILURE;
+
+	if (argc != 2) {
+		fprintf(stderr, "usage: smart-notify <nvdimm-bus-provider>\n");
+		goto out;
+	}
+
+	provider = argv[1];
+	bus = ndctl_bus_get_by_provider(ctx, provider);
+	if (!bus) {
+		fprintf(stderr, "smart-notify: unable to find bus (%s)\n",
+				provider);
+		goto out;
+	}
+
+	rc = EXIT_SUCCESS;
+	dimm_listen(bus);
+out:
+	ndctl_unref(ctx);
+	return rc;
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
