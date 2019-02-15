Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7C232194EB78
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 12:01:19 -0800 (PST)
Subject: [ndctl PATCH] ndctl/bus: Add poll interval to wait-scrub
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Feb 2019 11:48:41 -0800
Message-ID: <155026012115.1043468.1735826075932191012.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Erwin Tsaur <erwin.tsaur@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

The kernel ARS state machine implements an exponential backoff timeout
to not spam the platform ARS interface, a potentially high overhead
interface. Recent kernel changes allow root to bypass / reset the
polling interval. Add an option to 'ndctl wait-scrub' to attempt to poll
at a user-specified frequency (when that user is root).

As part of the implementation of the 'wait-scrub' enhancement take the
opportunity to refactor the exported
ndctl_bus_wait_for_scrub_completion() helper function into the more
capable ndctl_bus_poll_scrub_completion().

Reported-by: Erwin Tsaur <erwin.tsaur@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/bus.c            |   25 +++++++++++---
 ndctl/lib/libndctl.c   |   88 ++++++++++++++++++++++++++++++++++++++----------
 ndctl/lib/libndctl.sym |    6 +++
 ndctl/libndctl.h       |    2 +
 4 files changed, 97 insertions(+), 24 deletions(-)

diff --git a/ndctl/bus.c b/ndctl/bus.c
index ce7f76add777..86bbd5178df9 100644
--- a/ndctl/bus.c
+++ b/ndctl/bus.c
@@ -16,10 +16,24 @@
 
 static struct {
 	bool verbose;
+	unsigned int poll_interval;
 } param;
 
-static const struct option bus_options[] = {
-	OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug"),
+
+#define BASE_OPTIONS() \
+	OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug")
+
+#define WAIT_OPTIONS() \
+	OPT_UINTEGER('p', "poll", &param.poll_interval, "poll interval (seconds)")
+
+static const struct option start_options[] = {
+	BASE_OPTIONS(),
+	OPT_END(),
+};
+
+static const struct option wait_options[] = {
+	BASE_OPTIONS(),
+	WAIT_OPTIONS(),
 	OPT_END(),
 };
 
@@ -27,7 +41,8 @@ static int scrub_action(struct ndctl_bus *bus, enum device_action action)
 {
 	switch (action) {
 	case ACTION_WAIT:
-		return ndctl_bus_wait_for_scrub_completion(bus);
+		return ndctl_bus_poll_scrub_completion(bus,
+				param.poll_interval, 0);
 	case ACTION_START:
 		return ndctl_bus_start_scrub(bus);
 	default:
@@ -100,7 +115,7 @@ static int bus_action(int argc, const char **argv, const char *usage,
 int cmd_start_scrub(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *usage = "ndctl start-scrub [<bus-id> <bus-id2> ... <bus-idN>] [<options>]";
-	int start = bus_action(argc, argv, usage, bus_options,
+	int start = bus_action(argc, argv, usage, start_options,
 			ACTION_START, ctx);
 
 	if (start <= 0) {
@@ -115,7 +130,7 @@ int cmd_start_scrub(int argc, const char **argv, struct ndctl_ctx *ctx)
 int cmd_wait_scrub(int argc, const char **argv, struct ndctl_ctx *ctx)
 {
 	char *usage = "ndctl wait-scrub [<bus-id> <bus-id2> ... <bus-idN>] [<options>]";
-	int wait = bus_action(argc, argv, usage, bus_options,
+	int wait = bus_action(argc, argv, usage, wait_options,
 			ACTION_WAIT, ctx);
 
 	if (wait <= 0) {
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index c9e2875d6011..fd36aa0662f4 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1273,22 +1273,33 @@ NDCTL_EXPORT unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus)
 }
 
 /**
- * ndctl_bus_wait_for_scrub - wait for a scrub to complete
+ * ndctl_bus_poll_scrub_completion - wait for a scrub to complete
  * @bus: bus for which to check whether a scrub is in progress
+ * @poll_interval: nr seconds between wake up and re-read the status
+ * @timeout: total number of seconds to wait
  *
- * Upon return this bus has completed any in-progress scrubs. This is
- * different from ndctl_cmd_ars_in_progress in that the latter checks
- * the output of an ars_status command to see if the in-progress flag
- * is set, i.e. provides the firmware's view of whether a scrub is in
- * progress. ndctl_bus_wait_for_scrub instead checks the kernel's view
- * of whether a scrub is in progress by looking at the 'scrub' file in
- * sysfs.
+ * Upon return this bus has completed any in-progress scrubs if @timeout
+ * is 0 otherwise -ETIMEDOUT when @timeout seconds have expired. This
+ * is different from ndctl_cmd_ars_in_progress in that the latter checks
+ * the output of an ars_status command to see if the in-progress flag is
+ * set, i.e. provides the firmware's view of whether a scrub is in
+ * progress. ndctl_bus_wait_for_scrub_completion() instead checks the
+ * kernel's view of whether a scrub is in progress by looking at the
+ * 'scrub' file in sysfs.
+ *
+ * The @poll_interval option changes the frequency at which the kernel
+ * status is polled, but it requires a supporting kernel for that poll
+ * interval to be reflected to the kernel's polling of the ARS
+ * interface. Kernel's with poll interval support limit that polling to
+ * root (CAP_SYS_RAWIO) processes.
  */
-NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
+NDCTL_EXPORT int ndctl_bus_poll_scrub_completion(struct ndctl_bus *bus,
+		unsigned int poll_interval, unsigned int timeout)
 {
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	const char *provider = ndctl_bus_get_provider(bus);
+	char buf[SYSFS_ATTR_SIZE] = { 0 };
 	unsigned int scrub_count;
-	char buf[SYSFS_ATTR_SIZE];
 	struct pollfd fds;
 	char in_progress;
 	int fd = 0, rc;
@@ -1314,32 +1325,71 @@ NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
 			rc = 0;
 			break;
 		} else if (rc == 2 && in_progress == '+') {
+			long tmo;
+
+			if (!timeout)
+				tmo = poll_interval;
+			else if (!poll_interval)
+				tmo = timeout;
+			else
+				tmo = min(poll_interval, timeout);
+
+			tmo *= 1000;
+			if (tmo == 0)
+				tmo = -1;
+
 			/* scrub in progress, wait */
-			rc = poll(&fds, 1, -1);
-			if (rc < 0) {
+			rc = poll(&fds, 1, tmo);
+			dbg(ctx, "%s: poll wake: rc: %d status: \'%s\'\n",
+					provider, rc, buf);
+			if (rc > 0)
+				fds.revents = 0;
+			if (pread(fd, buf, 1, 0) == -1) {
 				rc = -errno;
-				dbg(ctx, "poll error: %s\n", strerror(errno));
 				break;
 			}
-			dbg(ctx, "poll wake: revents: %d\n", fds.revents);
-			if (pread(fd, buf, 1, 0) == -1) {
+
+			if (rc < 0) {
 				rc = -errno;
+				dbg(ctx, "%s: poll error: %s\n", provider,
+						strerror(errno));
 				break;
+			} else if (rc == 0) {
+				dbg(ctx, "%s: poll timeout: interval: %d timeout: %d\n",
+						provider, poll_interval, timeout);
+				if (!timeout)
+					continue;
+
+				if (!poll_interval || poll_interval > timeout) {
+					rc = -ETIMEDOUT;
+					break;
+				}
+
+				if (timeout > poll_interval)
+					timeout -= poll_interval;
+				else if (timeout == poll_interval) {
+					timeout = 1;
+					poll_interval = 0;
+				}
 			}
-			fds.revents = 0;
 		}
 	}
 
 	if (rc == 0)
-		dbg(ctx, "bus%d: scrub complete\n", ndctl_bus_get_id(bus));
+		dbg(ctx, "%s: scrub complete, status: \'%s\'\n", provider, buf);
 	else
-		dbg(ctx, "bus%d: error waiting for scrub completion: %s\n",
-			ndctl_bus_get_id(bus), strerror(-rc));
+		dbg(ctx, "%s: error waiting for scrub completion: %s\n",
+			provider, strerror(-rc));
 	if (fd)
 		close (fd);
 	return rc;
 }
 
+NDCTL_EXPORT int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus)
+{
+	return ndctl_bus_poll_scrub_completion(bus, 0, 0);
+}
+
 static int ndctl_bind(struct ndctl_ctx *ctx, struct kmod_module *module,
 		const char *devname);
 static int ndctl_unbind(struct ndctl_ctx *ctx, const char *devpath);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index cb9f769fbbca..297f03d7ae39 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -404,3 +404,9 @@ global:
 	ndctl_dimm_update_master_passphrase;
 	ndctl_dimm_master_secure_erase;
 } LIBNDCTL_18;
+
+
+LIBNDCTL_20 {
+global:
+	ndctl_bus_poll_scrub_completion;
+} LIBNDCTL_19;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 0debdb61b0ac..e378802ee4c1 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -133,6 +133,8 @@ enum ndctl_persistence_domain ndctl_bus_get_persistence_domain(
 		struct ndctl_bus *bus);
 int ndctl_bus_wait_probe(struct ndctl_bus *bus);
 int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus);
+int ndctl_bus_poll_scrub_completion(struct ndctl_bus *bus,
+		unsigned int poll_interval, unsigned int timeout);
 unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus);
 int ndctl_bus_get_scrub_state(struct ndctl_bus *bus);
 int ndctl_bus_start_scrub(struct ndctl_bus *bus);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
