Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C623021F3C194
 for <linux-nvdimm@lists.01.org>; Thu, 12 Oct 2017 17:08:46 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 1/6] libndctl: add APIs to get scrub count and to
 wait for a scrub
Date: Thu, 12 Oct 2017 18:09:59 -0600
Message-Id: <20171013001004.14963-2-vishal.l.verma@intel.com>
In-Reply-To: <20171013001004.14963-1-vishal.l.verma@intel.com>
References: <20171013001004.14963-1-vishal.l.verma@intel.com>
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

The kernel uses sysfs to notify userspace of the number of completed
Address Range Scrubs, as well as any ongoing scrubs. Add libndctl
helpers to get the scrub count, and to wait for an in-progress scrub to
complete.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c   | 100 +++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |   2 +
 ndctl/lib/private.h    |   1 +
 ndctl/libndctl.h.in    |   2 +
 4 files changed, 105 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 60143d9..c878383 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -10,7 +10,9 @@
  * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
  * more details.
  */
+#include <poll.h>
 #include <stdio.h>
+#include <signal.h>
 #include <stdlib.h>
 #include <stddef.h>
 #include <stdarg.h>
@@ -555,6 +557,7 @@ static void free_bus(struct ndctl_bus *bus, struct list_head *head)
 	free(bus->bus_path);
 	free(bus->bus_buf);
 	free(bus->wait_probe_path);
+	free(bus->scrub_path);
 	free(bus);
 }
 
@@ -785,6 +788,11 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
 	if (!bus->wait_probe_path)
 		goto err_read;
 
+	sprintf(path, "%s/device/nfit/scrub", ctl_base);
+	bus->scrub_path = strdup(path);
+	if (!bus->scrub_path)
+		goto err_read;
+
 	bus->bus_path = parent_dev_path("char", bus->major, bus->minor);
 	if (!bus->bus_path)
 		goto err_dev_path;
@@ -810,6 +818,7 @@ static void *add_bus(void *parent, int id, const char *ctl_base)
  err_dev_path:
  err_read:
 	free(bus->wait_probe_path);
+	free(bus->scrub_path);
 	free(bus->provider);
 	free(bus->bus_buf);
 	free(bus);
@@ -1082,6 +1091,97 @@ NDCTL_EXPORT int ndctl_bus_wait_probe(struct ndctl_bus *bus)
 	return rc < 0 ? -ENXIO : 0;
 }
 
+NDCTL_EXPORT unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus)
+{
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	char buf[SYSFS_ATTR_SIZE];
+	unsigned int scrub_count;
+	char in_progress = '\0';
+	int rc;
+
+	rc = sysfs_read_attr(ctx, bus->scrub_path, buf);
+	if (rc < 0)
+		return UINT_MAX;
+
+	rc = sscanf(buf, "%u%c", &scrub_count, &in_progress);
+	if (rc < 0)
+		return UINT_MAX;
+	if (rc == 0) {
+		/* unable to read scrub count */
+		return UINT_MAX;
+	}
+	if (rc >= 1)
+		return scrub_count;
+
+	return UINT_MAX;
+}
+
+/**
+ * ndctl_bus_wait_for_scrub - wait for a scrub to complete
+ * @bus: bus for which to check whether a scrub is in progress
+ *
+ * Upon return this bus has completed any in-progress scrubs. This is
+ * different from ndctl_cmd_ars_in_progress in that the latter checks
+ * the output of an ars_status command to see if the in-progress flag
+ * is set, i.e. provides the firmware's view of whether a scrub is in
+ * progress. ndctl_bus_wait_for_scrub instead checks the kernel's view
+ * of whether a scrub is in progress by looking at the 'scrub' file in
+ * sysfs.
+ */
+NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
+{
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	unsigned int tmo = 120, scrub_count;
+	char buf[SYSFS_ATTR_SIZE];
+	char in_progress = '\0';
+	struct pollfd fds;
+	int fd = 0, rc;
+
+	fd = open(bus->scrub_path, O_RDONLY|O_CLOEXEC);
+	fds.fd = fd;
+	fds.events =  POLLPRI | POLLIN;
+	do {
+		rc = sysfs_read_attr(ctx, bus->scrub_path, buf);
+		if (rc < 0)
+			break;
+
+		rc = sscanf(buf, "%u%c", &scrub_count, &in_progress);
+		if (rc < 0)
+			break;
+		else if (rc <= 1) {
+			/* scrub complete, break successfully */
+			rc = 0;
+			break;
+		} else if (rc == 2 && in_progress == '+') {
+			/* scrub in progress, wait */
+			rc = poll(&fds, 1, tmo);
+			if (rc < 0) {
+				dbg(ctx, "poll error: %d\n", errno);
+				break;
+			} else if (rc == 0) {
+				dbg(ctx, "poll timeout after: %d seconds", tmo);
+				rc = -ENXIO;
+				break;
+			}
+			if (fds.revents & (POLLERR | POLLHUP | POLLNVAL)) {
+				dbg(ctx, "poll error, revents: %d\n",
+					fds.revents);
+				rc = -ENXIO;
+				break;
+			}
+		} else {
+			/* unknown condition */
+			rc = -ENXIO;
+			break;
+		}
+	} while (in_progress);
+
+	dbg(ctx, "bus%d: scrub complete\n", ndctl_bus_get_id(bus));
+	if (fd)
+		close (fd);
+	return rc < 0 ? -ENXIO : 0;
+}
+
 static int ndctl_bind(struct ndctl_ctx *ctx, struct kmod_module *module,
 		const char *devname);
 static int ndctl_unbind(struct ndctl_ctx *ctx, const char *devpath);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 58db669..4c22c0f 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -286,6 +286,8 @@ global:
 	ndctl_bus_get_region_by_physical_address;
 	ndctl_bus_get_dimm_by_physical_address;
 	ndctl_bus_is_nfit_cmd_supported;
+	ndctl_bus_wait_for_scrub_completion;
+	ndctl_bus_get_scrub_count;
 	ndctl_dimm_read_labels;
 	ndctl_dimm_validate_labels;
 	ndctl_dimm_init_labels;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 2de314c..6b909aa 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -152,6 +152,7 @@ struct ndctl_bus {
 	char *bus_buf;
 	size_t buf_len;
 	char *wait_probe_path;
+	char *scrub_path;
 	unsigned long dsm_mask;
 	unsigned long nfit_dsm_mask;
 };
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 42e53c6..a4fbe33 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -113,6 +113,8 @@ unsigned int ndctl_bus_get_revision(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_id(struct ndctl_bus *bus);
 const char *ndctl_bus_get_provider(struct ndctl_bus *bus);
 int ndctl_bus_wait_probe(struct ndctl_bus *bus);
+int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus);
+unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus);
 
 struct ndctl_dimm;
 struct ndctl_dimm *ndctl_dimm_get_first(struct ndctl_bus *bus);
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
