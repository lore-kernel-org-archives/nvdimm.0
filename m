Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 79992802D3
 for <linux-nvdimm@lists.01.org>; Fri,  3 Mar 2017 22:14:25 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 2/7] libndctl: add a ndctl_namespace_disable_safe()
 API
Date: Fri,  3 Mar 2017 23:13:02 -0700
Message-Id: <20170304061307.13530-3-vishal.l.verma@intel.com>
In-Reply-To: <20170304061307.13530-1-vishal.l.verma@intel.com>
References: <20170304061307.13530-1-vishal.l.verma@intel.com>
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

Disabling a namespace which has a filesystem mounted on it is unsafe as
filesystems are not prepared for a block device to be yanked from under
them. The destroy_namespace routine checked for an active mount by
performing an O_EXCL open of the backing block device, but many other
callers of ndctl_namespace_disable* could benefit from this checking.

Codify the mounted filesystem check in a new libndctl API -
ndctl_namespace_disable_safe(), and use it for the destroy/disable
namespace ndctl commands as well as the upcoming check-namespace
command.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/builtin-xaction-namespace.c | 46 +++++++--------------------------------
 ndctl/lib/libndctl.c              | 44 +++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym            |  1 +
 ndctl/libndctl.h.in               |  1 +
 4 files changed, 54 insertions(+), 38 deletions(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 46d651e..d6b0c37 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -731,10 +731,7 @@ static int namespace_destroy(struct ndctl_region *region,
 	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
 	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
 	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
-	const char *bdev = NULL;
-	bool dax_active = false;
-	char path[50];
-	int fd, rc;
+	int rc;
 
 	if (ndctl_region_get_ro(region)) {
 		error("%s: read-only, re-configuration disabled\n",
@@ -742,42 +739,15 @@ static int namespace_destroy(struct ndctl_region *region,
 		return -ENXIO;
 	}
 
-	if (pfn && ndctl_pfn_is_enabled(pfn))
-		bdev = ndctl_pfn_get_block_device(pfn);
-	else if (dax && ndctl_dax_is_enabled(dax))
-		dax_active = true;
-	else if (btt && ndctl_btt_is_enabled(btt))
-		bdev = ndctl_btt_get_block_device(btt);
-	else if (ndctl_namespace_is_enabled(ndns))
-		bdev = ndctl_namespace_get_block_device(ndns);
-
-	if ((bdev || dax_active) && !force) {
+	if (ndctl_namespace_is_active(ndns) && !force) {
 		error("%s is active, specify --force for re-configuration\n",
 				devname);
 		return -EBUSY;
-	} else if (bdev) {
-		sprintf(path, "/dev/%s", bdev);
-		fd = open(path, O_RDWR|O_EXCL);
-		if (fd >= 0) {
-			/*
-			 * Got it, now block new mounts while we have it
-			 * pinned.
-			 */
-			ndctl_namespace_disable_invalidate(ndns);
-			close(fd);
-		} else {
-			/*
-			 * Yes, TOCTOU hole, but if you're racing namespace
-			 * creation you have other problems, and there's nothing
-			 * stopping the !bdev case from racing to mount an fs or
-			 * re-enabling the namepace.
-			 */
-			error("%s: %s failed exlusive open: %s\n",
-					devname, bdev, strerror(errno));
-			return -errno;
-		}
-	} else if (dax_active)
-		ndctl_namespace_disable_invalidate(ndns);
+	} else {
+		rc = ndctl_namespace_disable_safe(ndns);
+		if (rc)
+			return rc;
+	}
 
 	if (pfn || btt || dax) {
 		rc = zero_info_block(ndns);
@@ -869,7 +839,7 @@ static int do_xaction_namespace(const char *namespace,
 					continue;
 				switch (action) {
 				case ACTION_DISABLE:
-					rc = ndctl_namespace_disable_invalidate(ndns);
+					rc = ndctl_namespace_disable_safe(ndns);
 					break;
 				case ACTION_ENABLE:
 					rc = ndctl_namespace_enable(ndns);
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 8396e48..a53e953 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -3320,6 +3320,50 @@ NDCTL_EXPORT int ndctl_namespace_disable_invalidate(struct ndctl_namespace *ndns
 	return ndctl_namespace_disable(ndns);
 }
 
+NDCTL_EXPORT int ndctl_namespace_disable_safe(struct ndctl_namespace *ndns)
+{
+	const char *devname = ndctl_namespace_get_devname(ndns);
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
+	const char *bdev = NULL;
+	char path[50];
+	int fd;
+
+	if (pfn && ndctl_pfn_is_enabled(pfn))
+		bdev = ndctl_pfn_get_block_device(pfn);
+	else if (btt && ndctl_btt_is_enabled(btt))
+		bdev = ndctl_btt_get_block_device(btt);
+	else if (ndctl_namespace_is_enabled(ndns))
+		bdev = ndctl_namespace_get_block_device(ndns);
+
+	if (bdev) {
+		sprintf(path, "/dev/%s", bdev);
+		fd = open(path, O_RDWR|O_EXCL);
+		if (fd >= 0) {
+			/*
+			 * Got it, now block new mounts while we have it
+			 * pinned.
+			 */
+			ndctl_namespace_disable_invalidate(ndns);
+			close(fd);
+		} else {
+			/*
+			 * Yes, TOCTOU hole, but if you're racing namespace
+			 * creation you have other problems, and there's nothing
+			 * stopping the !bdev case from racing to mount an fs or
+			 * re-enabling the namepace.
+			 */
+			dbg(ctx, "%s: %s failed exclusive open: %s\n",
+					devname, bdev, strerror(errno));
+			return -errno;
+		}
+	} else
+		ndctl_namespace_disable_invalidate(ndns);
+
+	return 0;
+}
+
 static int pmem_namespace_is_configured(struct ndctl_namespace *ndns)
 {
 	if (ndctl_namespace_get_size(ndns) < ND_MIN_NAMESPACE_SIZE)
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 5f47a22..2163a09 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -171,6 +171,7 @@ global:
 	ndctl_namespace_enable;
 	ndctl_namespace_disable;
 	ndctl_namespace_disable_invalidate;
+	ndctl_namespace_disable_safe;
 	ndctl_namespace_is_active;
 	ndctl_namespace_is_valid;
 	ndctl_namespace_is_configured;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index c70215c..06e6d49 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -484,6 +484,7 @@ int ndctl_namespace_is_enabled(struct ndctl_namespace *ndns);
 int ndctl_namespace_enable(struct ndctl_namespace *ndns);
 int ndctl_namespace_disable(struct ndctl_namespace *ndns);
 int ndctl_namespace_disable_invalidate(struct ndctl_namespace *ndns);
+int ndctl_namespace_disable_safe(struct ndctl_namespace *ndns);
 bool ndctl_namespace_is_active(struct ndctl_namespace *ndns);
 int ndctl_namespace_is_valid(struct ndctl_namespace *ndns);
 int ndctl_namespace_is_configured(struct ndctl_namespace *ndns);
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
