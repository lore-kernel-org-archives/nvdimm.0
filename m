Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA3A71A1E28
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 16:07:47 -0700 (PDT)
Subject: [ndctl PATCH 3/3] test: validate ndctl_dimm_get_health_eventfd()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 16:05:16 -0700
Message-ID: <147199351684.5587.16250471768753432150.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147199350116.5587.2852255825958647760.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147199350116.5587.2852255825958647760.stgit@dwillia2-desk3.amr.corp.intel.com>
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

nfit_test simulates a dimm notification event each time the smart-threshold DSM
is invoked.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 7c81531a03c2..5f86addc5c7e 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -21,8 +21,11 @@
 #include <limits.h>
 #include <syslog.h>
 #include <libkmod.h>
+#include <sys/wait.h>
 #include <uuid/uuid.h>
+#include <sys/types.h>
 #include <sys/ioctl.h>
+#include <sys/select.h>
 #include <linux/version.h>
 
 #include <ccan/array_size/array_size.h>
@@ -1783,6 +1786,7 @@ static int check_btts(struct ndctl_region *region, struct btt **btts)
 struct check_cmd {
 	int (*check_fn)(struct ndctl_bus *bus, struct ndctl_dimm *dimm, struct check_cmd *check);
 	struct ndctl_cmd *cmd;
+	struct ndctl_test *test;
 };
 
 static struct check_cmd *check_cmds;
@@ -2005,7 +2009,9 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		.spares = 5,
 	};
 	struct ndctl_cmd *cmd = ndctl_dimm_cmd_new_smart_threshold(dimm);
-	int rc;
+	struct timeval tm;
+	fd_set fds;
+	int rc, fd;
 
 	if (!cmd) {
 		fprintf(stderr, "%s: dimm: %#x failed to create cmd\n",
@@ -2013,6 +2019,36 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		return -ENXIO;
 	}
 
+	fd = ndctl_dimm_get_health_eventfd(dimm);
+	FD_ZERO(&fds);
+	tm.tv_sec = 0;
+	tm.tv_usec = 500;
+	rc = select(fd + 1, NULL, NULL, &fds, &tm);
+	if (rc) {
+		fprintf(stderr, "%s: expected health event timeout\n",
+				ndctl_dimm_get_devname(dimm));
+		return -ENXIO;
+	}
+
+	/*
+	 * Starting with v4.9 smart threshold requests trigger the file
+	 * descriptor returned by ndctl_dimm_get_health_eventfd().
+	 */
+	if (ndctl_test_attempt(check->test, KERNEL_VERSION(4, 9, 0))) {
+		int pid = fork();
+
+		if (pid == 0) {
+			FD_ZERO(&fds);
+			FD_SET(fd, &fds);
+			tm.tv_sec = 1;
+			tm.tv_usec = 0;
+			rc = select(fd + 1, NULL, NULL, &fds, &tm);
+			if (rc != 1 || !FD_ISSET(fd, &fds))
+				exit(EXIT_FAILURE);
+			exit(EXIT_SUCCESS);
+		}
+	}
+
 	rc = ndctl_cmd_submit(cmd);
 	if (rc) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
@@ -2021,6 +2057,15 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		return rc;
 	}
 
+	if (ndctl_test_attempt(check->test, KERNEL_VERSION(4, 9, 0))) {
+		wait(&rc);
+		if (WEXITSTATUS(rc) == EXIT_FAILURE) {
+			fprintf(stderr, "%s: expect health event trigger\n",
+					ndctl_dimm_get_devname(dimm));
+			return -ENXIO;
+		}
+	}
+
 	__check_smart_threshold(dimm, cmd, alarm_control);
 	__check_smart_threshold(dimm, cmd, temperature);
 	__check_smart_threshold(dimm, cmd, spares);
@@ -2235,12 +2280,15 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	 * check_set_config_data can assume that both
 	 * check_get_config_size and check_get_config_data have run
 	 */
-	static struct check_cmd __check_dimm_cmds[] = {
+	struct check_cmd __check_dimm_cmds[] = {
 		[ND_CMD_GET_CONFIG_SIZE] = { check_get_config_size },
 		[ND_CMD_GET_CONFIG_DATA] = { check_get_config_data },
 		[ND_CMD_SET_CONFIG_DATA] = { check_set_config_data },
 		[ND_CMD_SMART] = { check_smart },
-		[ND_CMD_SMART_THRESHOLD] = { check_smart_threshold },
+		[ND_CMD_SMART_THRESHOLD] = {
+			.check_fn = check_smart_threshold,
+			.test = test,
+		},
 	};
 	static struct check_cmd __check_bus_cmds[] = {
 #ifdef HAVE_NDCTL_ARS

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
