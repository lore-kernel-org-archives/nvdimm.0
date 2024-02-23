Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA64BA30
	for <nvdimm@lists.linux.dev>; Fri, 23 Feb 2024 02:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708654550; cv=none; b=gUOCZPINfJkW9dKGwfoxIjslOz0fXCtTea7CfiRHd9chBr1FxFyhbyfXza0PmVxsOPEJcBeKXwI3Pqn8gz9NXnpGw42S3M+kBQJM5kaoy47YCwI8EJhz4cWpb6NmQazo6x6MAB/zYpDQ/TuNri/OAw4ueWMSZNOpflWGMgBZJ94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708654550; c=relaxed/simple;
	bh=TVx9IeXgQLRLu1JF0qCJbumBV4fjmWg+KAIK17Za3jw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bqXUTLvzFwM5ap6+PMTYYgHxL3IFfv9vT+I9e2/4CUqQ5b4W2o0wKaFtHgmTb/Ohltn4vtUqxYUAVR3hbDOR+4BjW8gi6Dl86Twt7OGfMosrBFDn4cNarLNJz27v/vwV1BzgEpzb7mxKWHg8XtxDOA1PSAmxxnl7yvIlwdoAE/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OCIa+OSv; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OCIa+OSv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708654548; x=1740190548;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TVx9IeXgQLRLu1JF0qCJbumBV4fjmWg+KAIK17Za3jw=;
  b=OCIa+OSvTmQ4c/TFhEn+g9GMiN2bL07DBKDP/BqPkA/DSwTasq5302EX
   bm/sIGA6ECLBi4lkmwtgNtIIE7wVq9DLicQ+O0q999HY8pesJySFmdR8k
   h9r64KvTPkmodOIaglHDDVDb48sp4OkoUQ5NQMJmmROAGqcFem2zpUNCt
   600b4ekzQixRJYsIjPE2ZCUAVpPuDgaklY54KjeOrJ7q8gtIZMF04W9gU
   X+weB6nbSvK4SqbpqGYy83Axvdo7YNxCiJ3M/3cIZaljWW5brS88xXp4l
   /7jF1yLs/5AHLNprfIduwG6b+sXarLBEZLeAKJ8l3Somnap1phMqahsDp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="14364240"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="14364240"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="10410090"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.29.102])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 18:15:47 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v8 1/7] libcxl: add interfaces for GET_POISON_LIST mailbox commands
Date: Thu, 22 Feb 2024 18:15:38 -0800
Message-Id: <d84de6cf5e8ec98cefbdf749ef8c165b949c9fc2.1708653303.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1708653303.git.alison.schofield@intel.com>
References: <cover.1708653303.git.alison.schofield@intel.com>
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
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 cxl/lib/libcxl.c   | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  2 ++
 cxl/libcxl.h       |  2 ++
 3 files changed, 51 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 725240a17473..1537a33d370e 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1710,6 +1710,53 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
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
index 2cbceb3a95da..72a50be7601f 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -276,4 +276,6 @@ global:
 	cxl_cmd_alert_config_set_enable_alert_actions;
 	cxl_cmd_new_set_alert_config;
 	cxl_memdev_wait_sanitize;
+	cxl_memdev_trigger_poison_list;
+	cxl_region_trigger_poison_list;
 } LIBCXL_6;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 98612ba71b29..352b3a866f63 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -461,6 +461,8 @@ enum cxl_setpartition_mode {
 
 int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
 		enum cxl_setpartition_mode mode);
+int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
+int cxl_region_trigger_poison_list(struct cxl_region *region);
 
 int cxl_cmd_alert_config_set_life_used_prog_warn_threshold(struct cxl_cmd *cmd,
 							   int threshold);
-- 
2.37.3

