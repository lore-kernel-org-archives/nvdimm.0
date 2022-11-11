Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800D762E
	for <nvdimm@lists.linux.dev>; Fri, 11 Nov 2022 03:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668136814; x=1699672814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2L3oHReSuQCpClXWNtrrvwtAMs5qrMUwLJZ+JgDDIRs=;
  b=KFSzuHGG/ZlFF9kvfZIG0BZeoZjCpGkbS+DK1HUUqCWsWfj2COuamd7i
   PuBZMx5ZGF4re3LwinAK8TiVCKjU49dcSJN66udJFGQJAdIbSmgW0TlyH
   UO3dwiU4VlkSrAaDZ+1s/gykagN7WTgPhS95r67zDwvSFIefBbU0TtV/H
   haiF60MC8WDyHlaJIs+eNeO5LrzPl7GE0MmquNGn/brYuvhmDMnJy2T7K
   KW8TQ3KdplvTdrXHfnGqYn61SxLmuk7f56jkPqOFueecCkblpxGO1wBy2
   OPRYx3J/yT2R+vQuEvr4TcGVxPCHjr9Mkxq4/ryXvGHnUxYVQOuTNgHS3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="373638348"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="373638348"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="743129956"
X-IronPort-AV: E=Sophos;i="5.96,155,1665471600"; 
   d="scan'208";a="743129956"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.161.45])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 19:20:12 -0800
From: alison.schofield@intel.com
To: Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 1/5] libcxl: add interfaces for GET_POISON_LIST mailbox commands
Date: Thu, 10 Nov 2022 19:20:04 -0800
Message-Id: <73b2edf5ded979cb3164bcf2b76c4f300cdf2250.1668133294.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1668133294.git.alison.schofield@intel.com>
References: <cover.1668133294.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

CXL devices maintain a list of locations that are poisoned or result
in poison if the addresses are accessed by the host.

Per the spec (CXL 3.0 8.2.9.8.4.1), the device returns this Poison
list as a set of  Media Error Records that include the source of the
error, the starting device physical address and length.

Trigger the retrieval of the poison list by writing to the device
sysfs attribute: trigger_poison_list.

Retrieval is offered by memdev or by region:
int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
int cxl_region_trigger_poison_list(struct cxl_region *region);

This interface triggers the retrieval of the poison list from the
devices and logs the error records as kernel trace events named
'cxl_poison'.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/lib/libcxl.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  6 ++++++
 cxl/libcxl.h       |  2 ++
 3 files changed, 52 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index e8c5d4444dd0..1a8a8eb0ffcb 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1331,6 +1331,50 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
 	return 0;
 }
 
+CXL_EXPORT int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev)
+{
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	char *path = memdev->dev_buf;
+	int len = memdev->buf_len, rc;
+
+	if (snprintf(path, len, "%s/trigger_poison_list", memdev->dev_path) >=
+	    len) {
+		err(ctx, "%s: buffer too small\n",
+		    cxl_memdev_get_devname(memdev));
+		return -ENXIO;
+	}
+	rc = sysfs_write_attr(ctx, path, "1\n");
+	if (rc < 0) {
+		fprintf(stderr,
+			"%s: Failed write sysfs attr trigger_poison_list\n",
+			cxl_memdev_get_devname(memdev));
+		return rc;
+	}
+	return 0;
+}
+
+CXL_EXPORT int cxl_region_trigger_poison_list(struct cxl_region *region)
+{
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	char *path = region->dev_buf;
+	int len = region->buf_len, rc;
+
+	if (snprintf(path, len, "%s/trigger_poison_list", region->dev_path) >=
+	    len) {
+		err(ctx, "%s: buffer too small\n",
+		    cxl_region_get_devname(region));
+		return -ENXIO;
+	}
+	rc = sysfs_write_attr(ctx, path, "1\n");
+	if (rc < 0) {
+		fprintf(stderr,
+			"%s: Failed write sysfs attr trigger_poison_list\n",
+			cxl_region_get_devname(region));
+		return rc;
+	}
+	return 0;
+}
+
 CXL_EXPORT int cxl_memdev_enable(struct cxl_memdev *memdev)
 {
 	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 8bb91e05638b..ecf98e6c7af2 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -217,3 +217,9 @@ global:
 	cxl_decoder_get_max_available_extent;
 	cxl_decoder_get_region;
 } LIBCXL_2;
+
+LIBCXL_4 {
+global:
+	cxl_memdev_trigger_poison_list;
+	cxl_region_trigger_poison_list;
+} LIBCXL_3;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 9fe4e99263dd..5ebdf0879325 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -375,6 +375,8 @@ enum cxl_setpartition_mode {
 
 int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
 		enum cxl_setpartition_mode mode);
+int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
+int cxl_region_trigger_poison_list(struct cxl_region *region);
 
 #ifdef __cplusplus
 } /* extern "C" */
-- 
2.37.3

