Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 823C0225501D9
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 16:12:12 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/3] ndctl: replace direct errno prints with strerror
 strings
Date: Thu, 29 Mar 2018 17:18:36 -0600
Message-Id: <20180329231836.29453-3-vishal.l.verma@intel.com>
In-Reply-To: <20180329231836.29453-1-vishal.l.verma@intel.com>
References: <20180329231836.29453-1-vishal.l.verma@intel.com>
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

Make error messages reported to the user friendlier by replacing errno
codes wih strerror strings throughout the various ndctl utilities.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/check.c        | 32 ++++++++++++++++----------------
 ndctl/inject-error.c |  9 ++++++---
 ndctl/namespace.c    |  5 +++--
 3 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/ndctl/check.c b/ndctl/check.c
index d2d74a2..8a71250 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -872,8 +872,8 @@ static int btt_discover_arenas(struct btt_chk *bttc)
 			}
 			ret = btt_write_info(bttc, btt_sb, cur_off);
 			if (ret) {
-				err(bttc, "Restoration of the info block failed: %d\n",
-					ret);
+				err(bttc, "Restoration of the info block failed: %s (%d)\n",
+					strerror(abs(ret)), ret);
 				goto out;
 			}
 		}
@@ -924,8 +924,8 @@ static int btt_create_mappings(struct btt_chk *bttc)
 		a->map.info = mmap(NULL, a->map.info_len, mmap_flags,
 			MAP_SHARED, bttc->fd, a->infooff);
 		if (a->map.info == MAP_FAILED) {
-			err(bttc, "mmap arena[%d].info [sz = %#lx, off = %#lx] failed: %d\n",
-				i, a->map.info_len, a->infooff, errno);
+			err(bttc, "mmap arena[%d].info [sz = %#lx, off = %#lx] failed: %s\n",
+				i, a->map.info_len, a->infooff, strerror(errno));
 			return -errno;
 		}
 
@@ -933,8 +933,8 @@ static int btt_create_mappings(struct btt_chk *bttc)
 		a->map.data = mmap(NULL, a->map.data_len, mmap_flags,
 			MAP_SHARED, bttc->fd, a->dataoff);
 		if (a->map.data == MAP_FAILED) {
-			err(bttc, "mmap arena[%d].data [sz = %#lx, off = %#lx] failed: %d\n",
-				i, a->map.data_len, a->dataoff, errno);
+			err(bttc, "mmap arena[%d].data [sz = %#lx, off = %#lx] failed: %s\n",
+				i, a->map.data_len, a->dataoff, strerror(errno));
 			return -errno;
 		}
 
@@ -942,8 +942,8 @@ static int btt_create_mappings(struct btt_chk *bttc)
 		a->map.map = mmap(NULL, a->map.map_len, mmap_flags,
 			MAP_SHARED, bttc->fd, a->mapoff);
 		if (a->map.map == MAP_FAILED) {
-			err(bttc, "mmap arena[%d].map [sz = %#lx, off = %#lx] failed: %d\n",
-				i, a->map.map_len, a->mapoff, errno);
+			err(bttc, "mmap arena[%d].map [sz = %#lx, off = %#lx] failed: %s\n",
+				i, a->map.map_len, a->mapoff, strerror(errno));
 			return -errno;
 		}
 
@@ -951,8 +951,8 @@ static int btt_create_mappings(struct btt_chk *bttc)
 		a->map.log = mmap(NULL, a->map.log_len, mmap_flags,
 			MAP_SHARED, bttc->fd, a->logoff);
 		if (a->map.log == MAP_FAILED) {
-			err(bttc, "mmap arena[%d].log [sz = %#lx, off = %#lx] failed: %d\n",
-				i, a->map.log_len, a->logoff, errno);
+			err(bttc, "mmap arena[%d].log [sz = %#lx, off = %#lx] failed: %s\n",
+				i, a->map.log_len, a->logoff, strerror(errno));
 			return -errno;
 		}
 
@@ -960,8 +960,8 @@ static int btt_create_mappings(struct btt_chk *bttc)
 		a->map.info2 = mmap(NULL, a->map.info2_len, mmap_flags,
 			MAP_SHARED, bttc->fd, a->info2off);
 		if (a->map.info2 == MAP_FAILED) {
-			err(bttc, "mmap arena[%d].info2 [sz = %#lx, off = %#lx] failed: %d\n",
-				i, a->map.info2_len, a->info2off, errno);
+			err(bttc, "mmap arena[%d].info2 [sz = %#lx, off = %#lx] failed: %s\n",
+				i, a->map.info2_len, a->info2off, strerror(errno));
 			return -errno;
 		}
 	}
@@ -1219,8 +1219,8 @@ int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 	 */
 	rc = ndctl_namespace_set_raw_mode(ndns, 1);
 	if (rc < 0) {
-		err(bttc, "%s: failed to set the raw mode flag: %d\n",
-			devname, rc);
+		err(bttc, "%s: failed to set the raw mode flag: %s (%d)\n",
+			devname, strerror(abs(rc)), rc);
 		goto out_ns;
 	}
 	/*
@@ -1229,8 +1229,8 @@ int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 	 */
 	rc = ndctl_namespace_enable(ndns);
 	if (rc != 0) {
-		err(bttc, "%s: failed to enable in raw mode: %d\n",
-			devname, rc);
+		err(bttc, "%s: failed to enable in raw mode: %s (%d)\n",
+			devname, strerror(abs(rc)), rc);
 		goto out_ns;
 	}
 
diff --git a/ndctl/inject-error.c b/ndctl/inject-error.c
index efa9f92..32a58a5 100644
--- a/ndctl/inject-error.c
+++ b/ndctl/inject-error.c
@@ -199,7 +199,8 @@ static int inject_error(struct ndctl_namespace *ndns, u64 offset, u64 length,
 
 	rc = ndctl_namespace_inject_error(ndns, offset, length, notify);
 	if (rc) {
-		fprintf(stderr, "Unable to inject error: %d\n", rc);
+		fprintf(stderr, "Unable to inject error: %s (%d)\n",
+			strerror(abs(rc)), rc);
 		return rc;
 	}
 
@@ -212,7 +213,8 @@ static int uninject_error(struct ndctl_namespace *ndns, u64 offset, u64 length)
 
 	rc = ndctl_namespace_uninject_error(ndns, offset, length);
 	if (rc) {
-		fprintf(stderr, "Unable to uninject error: %d\n", rc);
+		fprintf(stderr, "Unable to uninject error: %s (%d)\n",
+			strerror(abs(rc)), rc);
 		return rc;
 	}
 
@@ -232,7 +234,8 @@ static int injection_status(struct ndctl_namespace *ndns)
 
 	rc = ndctl_namespace_injection_status(ndns);
 	if (rc) {
-		fprintf(stderr, "Unable to get injection status: %d\n", rc);
+		fprintf(stderr, "Unable to get injection status: %s (%d)\n",
+			strerror(abs(rc)), rc);
 		return rc;
 	}
 
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index aef356a..1ff54e6 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -312,8 +312,9 @@ static const char *parse_namespace_options(int argc, const char **argv,
 do { \
 	int __rc = prefix##_##op(dev, p); \
 	if (__rc) { \
-		debug("%s: " #op " failed: %d\n", \
-				prefix##_get_devname(dev), __rc); \
+		debug("%s: " #op " failed: %s\n", \
+				prefix##_get_devname(dev), \
+				strerror(abs(__rc))); \
 		return __rc; \
 	} \
 } while (0)
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
