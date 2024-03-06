Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179BB137C4A
	for <nvdimm@lists.linux.dev>; Wed,  6 Mar 2024 18:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709750552; cv=none; b=bcncPZuiyC2cXCGLN43+2qtx0h5d7fRzIjt3R6yWaqgbCkoa6exFpy6s2LdpWRARa6O9ZtBdgORkD4XFSMa7cBOa56dvHypxxaoAXbz9w6wvM0XVCj+7qXHycLdfrTT1xm8/XRW/D2emk+N/bTHrdGKQqN3ZCexRhMdtbXJV9rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709750552; c=relaxed/simple;
	bh=w2PzexwB2loTJZ+xDVTgYJmA2I7IIdSALPdEyuLuCjI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iQiJBwNdtH6qFOmPxqhgEIEur/PVN6Hgya69gGjW2mKhxwU3YcG3TZSonH7rrI+1LThPlseusqKevhLkz1tGx5327AI7ygygoFkUWR4Gm9TQBAMgkpStHLNDbAdWbMEpSwtyEDYMuoyzHpTp9ONIt3aE1lmNVWeus30/jdkOExQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YqanpK9E; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YqanpK9E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709750551; x=1741286551;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w2PzexwB2loTJZ+xDVTgYJmA2I7IIdSALPdEyuLuCjI=;
  b=YqanpK9EhyrT+ini45ItBNtUS6mrAFHB7CToarqbN8m/hH7mPWUazuX7
   noG3KhHf8L+p30NKI0C16phJbRqpv+xcvNRUK48FrTYXq/KipMIv8gO5z
   JILHUdRQ7hq3zWqZAtXJLVakz8c2neZNzvqcplvYA0nR605ZObX4ZZ5z4
   cr4Y24x9xuL5vJ01NBaBNH7Wz+zgb4qIbNZ3Uz9d89dtbTffPG/oK4xV6
   IdKx8c4vKAriJHQFE+k0HYBAPnz3hhXnDDHg0yMV/smOPxG5N/SWLypli
   psT47Tx4YFmhSowx6QXb/UJXvJ+nTSaIJfgmMY0v6wkmL+gy71lztWPlv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="15819821"
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="15819821"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,209,1705392000"; 
   d="scan'208";a="9925962"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.251.9.155])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 10:42:30 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v10 1/7] libcxl: add interfaces for GET_POISON_LIST mailbox commands
Date: Wed,  6 Mar 2024 10:42:20 -0800
Message-Id: <c43e12c5bafca30d3194ebb11d9817b9a05eaad0.1709748564.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1709748564.git.alison.schofield@intel.com>
References: <cover.1709748564.git.alison.schofield@intel.com>
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
index ff27cdf7c44a..73db8f15c704 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1761,6 +1761,53 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
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
index de2cd84b2960..3f709c60db3d 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -280,4 +280,6 @@ global:
 	cxl_memdev_get_pmem_qos_class;
 	cxl_memdev_get_ram_qos_class;
 	cxl_region_qos_class_mismatch;
+	cxl_memdev_trigger_poison_list;
+	cxl_region_trigger_poison_list;
 } LIBCXL_6;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index a6af3fb04693..29165043ca3f 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -467,6 +467,8 @@ enum cxl_setpartition_mode {
 
 int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
 		enum cxl_setpartition_mode mode);
+int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
+int cxl_region_trigger_poison_list(struct cxl_region *region);
 
 int cxl_cmd_alert_config_set_life_used_prog_warn_threshold(struct cxl_cmd *cmd,
 							   int threshold);
-- 
2.37.3

