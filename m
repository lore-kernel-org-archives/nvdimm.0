Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931531C69D
	for <nvdimm@lists.linux.dev>; Sat,  6 Jul 2024 06:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720247106; cv=none; b=Gfhmzq1ITzAhPmsomCxSsuiBp3EjYOl6K7mMjhktEtHUTUw5DeAE7q2Y+4m1sh17HGikMq3lyLd26tKouTXa+q2BbF2a4kQV5JKGbf1V01imd6Ze/OR7Wh0efKQx0XgtqmuCTuzl3VJOv/2OfUFnCdNCo0hpsH7zyhGKzcR/cvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720247106; c=relaxed/simple;
	bh=EZaQR/vMZ15Damf1T/EUQAfXuo5XKQ90Ahtx/U2XHeM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SSeOR49d6r81zqMZf0f8wCdFo0fi7IRQN/Gtr7Trj3yTubLIeL+HrMHqNQ0YhfDUYrlBPS8PR9uFEerEXrI4fFBvle1LOB749LeLcntGdcxypRAbVXtAyjuTzfokmMC7svjCxqAhn/qK+9QRf7gLHYAMBoz7P4+aVDjJRaSy6kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OVwQJ8v9; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OVwQJ8v9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720247104; x=1751783104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EZaQR/vMZ15Damf1T/EUQAfXuo5XKQ90Ahtx/U2XHeM=;
  b=OVwQJ8v98UbVxjPPJixHUGGPwYOydSx8BP5bpv+BXt4EytWxXGkkhq0V
   Z+jJUjCG60Y5HsysS9n7QQYu7g1FnUL3FkPaMzpdkARnG2Sw5c5eGzc4Q
   BRCr4b5jyCNBvkafXzP0hVfGNLofOfUohH1HXfYx0B6B2SaCESM50xDjN
   X7UrCI/YxtbbvNWuypDwfAVBoDgDjE3uqDgKfWNU+BeTNSsytiRnqQQ3I
   FcuKu3KXWBgaTLOjywQzxEV5UVo5WuWanxuFMqaBtr/YEsIUERDU5YKhY
   UYpjnyXL74wxvBVidAWd0PgPGgB6FpA0BLOcK83+tXgPlk7dsvdqtNIyZ
   g==;
X-CSE-ConnectionGUID: fiqKcPe0R4+BkEbMkM709g==
X-CSE-MsgGUID: 4uj3KiPfS6yR86a8yIBCkQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="17166942"
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="17166942"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:03 -0700
X-CSE-ConnectionGUID: P3j073hQTq27TCdeoq4uOA==
X-CSE-MsgGUID: RSZMr83wSw6RR9DmF44aIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,187,1716274800"; 
   d="scan'208";a="78172525"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.72.84])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 23:25:03 -0700
From: alison.schofield@intel.com
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v13 5/8] libcxl: add interfaces for GET_POISON_LIST mailbox commands
Date: Fri,  5 Jul 2024 23:24:51 -0700
Message-Id: <ef5503682f5042e68f153824634a751b41d1342a.1720241079.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1720241079.git.alison.schofield@intel.com>
References: <cover.1720241079.git.alison.schofield@intel.com>
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
 cxl/lib/libcxl.sym |  6 ++++++
 cxl/libcxl.h       |  2 ++
 3 files changed, 61 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 91eedd1c4688..63aa4ef3acdc 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1762,6 +1762,59 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
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
index 304d7fa735d4..0c155a40ad47 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -282,3 +282,9 @@ global:
 	cxl_region_qos_class_mismatch;
 	cxl_port_decoders_committed;
 } LIBCXL_6;
+
+LIBECXL_8 {
+global:
+	cxl_memdev_trigger_poison_list;
+	cxl_region_trigger_poison_list;
+} LIBCXL_7;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index fc6dd0085440..0a5fd0e13cc2 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -468,6 +468,8 @@ enum cxl_setpartition_mode {
 
 int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
 		enum cxl_setpartition_mode mode);
+int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
+int cxl_region_trigger_poison_list(struct cxl_region *region);
 
 int cxl_cmd_alert_config_set_life_used_prog_warn_threshold(struct cxl_cmd *cmd,
 							   int threshold);
-- 
2.37.3

