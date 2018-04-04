Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D126E22526491
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 14:21:57 -0700 (PDT)
Subject: [ndctl PATCH 1/5] ndctl,
 scrub: fix ndctl_bus_wait_for_scrub_completion()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Apr 2018 14:12:01 -0700
Message-ID: <152287632145.29230.18008700588119765698.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152287631592.29230.11531789298631204393.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152287631592.29230.11531789298631204393.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Given that we trust the kernel to increment the scrub count when
transitioning from in-progress to idle it is safe to wait forever.
Previously this routine was mistakenly waiting 120ms when it thought it
was waiting 120 seconds, was not verifying the in-progress was
cleared after a wakeup, and was not checking for the POLLMSG events that
sysfs files emit.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c |   45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 580a450e837c..743863b5c7e7 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1154,55 +1154,50 @@ NDCTL_EXPORT unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus)
 NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
 {
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
-	unsigned int tmo = 120, scrub_count;
+	unsigned int scrub_count;
 	char buf[SYSFS_ATTR_SIZE];
-	char in_progress = '\0';
 	struct pollfd fds;
+	char in_progress;
 	int fd = 0, rc;
 
 	fd = open(bus->scrub_path, O_RDONLY|O_CLOEXEC);
+	memset(&fds, 0, sizeof(fds));
 	fds.fd = fd;
-	fds.events =  POLLPRI | POLLIN;
-	do {
+	for (;;) {
 		rc = sysfs_read_attr(ctx, bus->scrub_path, buf);
-		if (rc < 0)
+		if (rc < 0) {
+			rc = -EOPNOTSUPP;
 			break;
+		}
 
 		rc = sscanf(buf, "%u%c", &scrub_count, &in_progress);
-		if (rc < 0)
+		if (rc < 0) {
+			rc = -EOPNOTSUPP;
 			break;
-		else if (rc <= 1) {
+		}
+
+		if (rc == 1) {
 			/* scrub complete, break successfully */
 			rc = 0;
 			break;
 		} else if (rc == 2 && in_progress == '+') {
 			/* scrub in progress, wait */
-			rc = poll(&fds, 1, tmo);
+			rc = poll(&fds, 1, -1);
 			if (rc < 0) {
-				dbg(ctx, "poll error: %d\n", errno);
-				break;
-			} else if (rc == 0) {
-				dbg(ctx, "poll timeout after: %d seconds", tmo);
-				rc = -ENXIO;
+				rc = -errno;
+				dbg(ctx, "poll error: %s\n", strerror(errno));
 				break;
 			}
-			if (fds.revents & (POLLERR | POLLHUP | POLLNVAL)) {
-				dbg(ctx, "poll error, revents: %d\n",
-					fds.revents);
-				rc = -ENXIO;
-				break;
-			}
-		} else {
-			/* unknown condition */
-			rc = -ENXIO;
-			break;
+			dbg(ctx, "poll wake: revents: %d\n", fds.revents);
+			pread(fd, buf, 1, 0);
+			fds.revents = 0;
 		}
-	} while (in_progress);
+	}
 
 	dbg(ctx, "bus%d: scrub complete\n", ndctl_bus_get_id(bus));
 	if (fd)
 		close (fd);
-	return rc < 0 ? -ENXIO : 0;
+	return rc;
 }
 
 static int ndctl_bind(struct ndctl_ctx *ctx, struct kmod_module *module,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
