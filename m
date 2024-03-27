Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEF114C5B8
	for <nvdimm@lists.linux.dev>; Wed, 27 Mar 2024 19:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711569161; cv=none; b=V/clKkC+95tRl7WhWoGmNCxXErKO60D/P+FK/Oohv/yxA4uSl2ZA7DZdpv0EXraLIsR23ITFurhnHB8FugvWj+jYPTJdjo0diBvjmMBYHouH3tBcQnYzbrtQ3914+Fp9XzJe9pCAvNyuJflrH/3T7dl7W6uAo+JuN7ZjmGBs4Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711569161; c=relaxed/simple;
	bh=Ide0wL1/KddRf7gEM/VRzr7017V2vWCzzXgb9ZEpC+Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HSXcjBMkgL4k8JebCI9GS/7CDbPZx5UXHXnAP1l+QNEIyRjv/LVbqoT8qOwOGN9V4ynsROb8vPs8XunWJd5qKrDByUqjP8Nw891ginJlLZHvyOzy2FziDzQzwJuFEmsXNBdMVLFiUzLA8R2cgzsHeW7W4ZmuowORKreeSrHGZ/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pl8OTHCl; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pl8OTHCl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711569160; x=1743105160;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ide0wL1/KddRf7gEM/VRzr7017V2vWCzzXgb9ZEpC+Q=;
  b=Pl8OTHCli2fPV+G7GrF2TVzxHBO34w1RXDKhIh/WDqkjldYanpyj50Ei
   wfaWeVaWPeBmsd0Hc8f+naNGVnuGRpG/eT5N3S6JpdkUaSSoKCC4lR1Tz
   PnvTTbyQ17UUuqVawwVjx70DrZr/ihpD5jGTAl44n9R/1m4OmYGQMXVQx
   23b8Z3aD6ik2oJ9WdVaPksU0d0t5qmLP3GmBuMJZ9vhtSsOtSskxn0fix
   700KxwUnFww72QlBchX2sZSe18+JK1ErSq9QgsOVKoi+3WjhnP2i0p0Dv
   3seQr+WzqCFO+fk8Ap4GqLrCD8YrUjqBEZKFzqLEQZtIzfK7elZXqOEB7
   A==;
X-CSE-ConnectionGUID: 2mFLBSvjRf+Wf+8XVPJ/VQ==
X-CSE-MsgGUID: VorZo0DWSDGWj4MtzFNOVA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6560218"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="6560218"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="47616336"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.82.250])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 12:52:39 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v12 5/8] libcxl: add interfaces for GET_POISON_LIST mailbox commands
Date: Wed, 27 Mar 2024 12:52:26 -0700
Message-Id: <356a5896046dd38642e54594134c1d3a388cfb28.1711519822.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1711519822.git.alison.schofield@intel.com>
References: <cover.1711519822.git.alison.schofield@intel.com>
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
 cxl/lib/libcxl.c   | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |  2 ++
 cxl/libcxl.h       |  2 ++
 3 files changed, 57 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index ff27cdf7c44a..a8ce521fdcf9 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1761,6 +1761,59 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
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
+
+	if (access(path, F_OK) != 0) {
+		err(ctx, "%s: trigger_poison_list unsupported by device\n",
+		    cxl_memdev_get_devname(memdev));
+		return -ENXIO;
+	}
+
+	rc = sysfs_write_attr(ctx, path, "1\n");
+	if (rc < 0) {
+		err(ctx, "%s: Failed trigger_poison_list\n",
+		    cxl_memdev_get_devname(memdev));
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

