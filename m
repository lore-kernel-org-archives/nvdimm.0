Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 861C222620E7A
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 14:24:28 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/2] ndctl, test: add write_cache testing to libndctl
Date: Fri,  6 Apr 2018 15:24:17 -0600
Message-Id: <20180406212417.16227-2-vishal.l.verma@intel.com>
In-Reply-To: <20180406212417.16227-1-vishal.l.verma@intel.com>
References: <20180406212417.16227-1-vishal.l.verma@intel.com>
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

in check_namespaces(), add a step to validate the write_cache status and
controls for the namespaces that support it. Also add a negative test
for the namespaces that don't have a write_cache (blk, sector etc),
making sure the APIs fail as expected.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/libndctl.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/test/libndctl.c b/test/libndctl.c
index a66bcb7..72271f4 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -1614,6 +1614,56 @@ static int validate_bdev(const char *devname, struct ndctl_btt *btt,
 	return rc;
 }
 
+static int validate_write_cache(struct ndctl_namespace *ndns)
+{
+	const char *devname = ndctl_namespace_get_devname(ndns);
+	int wc, mode, type, rc;
+
+	type = ndctl_namespace_get_type(ndns);
+	mode = ndctl_namespace_get_mode(ndns);
+	wc = ndctl_namespace_write_cache_is_enabled(ndns);
+
+	if ((type == ND_DEVICE_NAMESPACE_PMEM || type == ND_DEVICE_NAMESPACE_IO) &&
+			(mode == NDCTL_NS_MODE_FSDAX ||	mode == NDCTL_NS_MODE_RAW)) {
+		if (wc != 1) {
+			fprintf(stderr, "%s: expected write_cache enabled\n",
+				devname);
+			return -ENXIO;
+		}
+		rc = ndctl_namespace_disable_write_cache(ndns);
+		if (rc) {
+			fprintf(stderr, "%s: failed to disable write_cache\n",
+				devname);
+			return rc;
+		}
+		rc = ndctl_namespace_write_cache_is_enabled(ndns);
+		if (rc != 0) {
+			fprintf(stderr, "%s: write_cache could not be disabled\n",
+				devname);
+			return rc;
+		}
+		rc = ndctl_namespace_enable_write_cache(ndns);
+		if (rc) {
+			fprintf(stderr, "%s: failed to re-enable write_cache\n",
+				devname);
+			return rc;
+		}
+		rc = ndctl_namespace_write_cache_is_enabled(ndns);
+		if (rc != 1) {
+			fprintf(stderr, "%s: write_cache could not be re-enabled\n",
+				devname);
+			return rc;
+		}
+	} else {
+		if (wc == 0 || wc == 1) {
+			fprintf(stderr, "%s: expected write_cache to be absent\n",
+				devname);
+			return -ENXIO;
+		}
+	}
+	return 0;
+}
+
 static int check_namespaces(struct ndctl_region *region,
 		struct namespace **namespaces, enum ns_mode mode)
 {
@@ -1787,6 +1837,13 @@ static int check_namespaces(struct ndctl_region *region,
 				break;
 			}
 
+			rc = validate_write_cache(ndns);
+			if (rc) {
+				fprintf(stderr, "%s: %s validate_write_cache failed\n",
+						__func__, devname);
+				break;
+			}
+
 			if (ndctl_namespace_disable_invalidate(ndns) < 0) {
 				fprintf(stderr, "%s: failed to disable\n", devname);
 				rc = -ENXIO;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
