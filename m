Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FE746554
	for <nvdimm@lists.linux.dev>; Fri, 17 Nov 2023 22:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EiejL82+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700260530; x=1731796530;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hZ0XT3zGZ13N2t/d/jXTzV4fQS2xTLRryKNuiKfor1c=;
  b=EiejL82+t/szGzircM3pR1eXDFx/JEQWdItmAJ91Veoyr3sBd8nkuWUA
   /BCGIhm43iikPv4E/03zzWTJdYgexiU4yA/uyrgNOlVeEQMtoXOyj9tc7
   WppQKsBU+1QNxeySx8bpOZoSbvf2zrS3lb4ul4aDOFKiuiwTDQurvXg36
   Bd4SSbDG/GJMSvCUwRHR/+XV7fM3VfvDZHppoXdkANGZqeBYTx8Nz2Tvm
   k3vkyFgub69/b1u7w+x+A7gUD4BjD5QDgxD805YOswd57NoZlZJ5MhbCG
   6MDtPVG1VDUnFtfORPsVfZjXZzUPuajdbBt0kOmicuD6mqzWczmgPe55F
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="376428416"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="376428416"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 14:35:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="831732242"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="831732242"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.86.159])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 14:35:28 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v3 1/5] libcxl: add interfaces for GET_POISON_LIST mailbox commands
Date: Fri, 17 Nov 2023 14:35:20 -0800
Message-Id: <22d01bd1af9af5370d1e35094176dbd66ef20dac.1700258145.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1700258145.git.alison.schofield@intel.com>
References: <cover.1700258145.git.alison.schofield@intel.com>
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

Per the spec (CXL 3.1 8.2.9.9.4.1), the device returns the Poison
List as a set of  Media Error Records that include the source of the
error, the starting device physical address and length.

Trigger the retrieval of the poison list by writing to the memory
device sysfs attribute: trigger_poison_list. The CXL driver only
offers triggering per memdev, so the trigger by region interface
offered here is a convenience API that triggers a poison list
retrieval for each memdev contributing to a region.

int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
int cxl_region_trigger_poison_list(struct cxl_region *region);

The resulting poison records are logged as kernel trace events
named 'cxl_poison'.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/lib/libcxl.c   | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  6 ++++++
 cxl/libcxl.h       |  2 ++
 3 files changed, 55 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index af4ca44eae19..cc95c2d7c94a 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1647,6 +1647,53 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
 	return 0;
 }
 
+CXL_EXPORT int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev)
+{
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	char *path = memdev->dev_buf;
+	int len = memdev->buf_len, rc;
+
+	if (snprintf(path, len, "%s/trigger_poison_list",
+		     memdev->dev_path) >= len) {
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
+	struct cxl_memdev_mapping *mapping;
+	int rc;
+
+	cxl_mapping_foreach(region, mapping) {
+		struct cxl_decoder *decoder;
+		struct cxl_memdev *memdev;
+
+		decoder = cxl_mapping_get_decoder(mapping);
+		if (!decoder)
+			continue;
+
+		memdev = cxl_decoder_get_memdev(decoder);
+		if (!memdev)
+			continue;
+
+		rc = cxl_memdev_trigger_poison_list(memdev);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 CXL_EXPORT int cxl_memdev_enable(struct cxl_memdev *memdev)
 {
 	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 8fa1cca3d0d7..277b7e21d6a6 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -264,3 +264,9 @@ global:
 	cxl_memdev_update_fw;
 	cxl_memdev_cancel_fw_update;
 } LIBCXL_5;
+
+LIBCXL_7 {
+global:
+	cxl_memdev_trigger_poison_list;
+	cxl_region_trigger_poison_list;
+} LIBCXL_6;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 0f4f4b2648fb..ecdffe36df2c 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -460,6 +460,8 @@ enum cxl_setpartition_mode {
 
 int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
 		enum cxl_setpartition_mode mode);
+int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
+int cxl_region_trigger_poison_list(struct cxl_region *region);
 
 #ifdef __cplusplus
 } /* extern "C" */
-- 
2.37.3

