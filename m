Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58DC25B2F4
	for <nvdimm@lists.linux.dev>; Thu,  6 Aug 2026 22:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786055559; cv=none; b=JHrWYvQR7n3baJ1xDxS8U0azAPyX6BueLDPr/+inBf5U/Q5/oO+ptkN+dam2p8otlAjTCN6jFvmsKrzVTAwp5xiveWq6EzIUhe7Ix+33geRFYkP/8zzDvn+M33Y9fr1flk2COXtKqkqv6TRfrAuP1bzbb6PcFIxh6kYkNdhb2x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786055559; c=relaxed/simple;
	bh=Dk6d6KTI5vtbRefIXYdK2zKg98jotDykzopPgvESPoU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uJUblv/9yeS/Kk7wqrUvtYZkPcBD2PftZ1c7VVk4pd966JU8DRoPrFiL5zOE8m0DpjPr1zFTr0+83bAOBY96E5A9CEekDWrcnbCCIBuQTFnb1KumeZxCilYHEulW0FOruhDuNxhzEJjzVp0pI4bmsUzqKEphahubSifyqihK0sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QeaZA6x7; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QeaZA6x7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786055555; x=1817591555;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Dk6d6KTI5vtbRefIXYdK2zKg98jotDykzopPgvESPoU=;
  b=QeaZA6x7nwd7/bzM0MGKhjO+jtsGgmNPLaBEzrCnZVH8MCoiMz7ael2d
   BpAmM41bX0wwq8kc7ddaM7vH3E5+1XE3yjzY7ULbIujZzPs2K0QCaj1eu
   Y8BIPrBEOFVuJL1C+5zUYmUQnnX01l0BxwEfD+8ji1r5CpLDIjbWHqOGG
   vGidK1/RwUoydEmJpj55S/siYnwqdXmNyOEP38Pz+bmVASlHnhGsGZLD3
   exZrdVNaLR5j7XVEUmZYn49fycSd2+ynrAwOJbvEmG7Jq+SW61ZL5cv7E
   iq7iNDRFsXplqD6T4LLw1UktmLzM8uXvGHJevqO6Tyroj9wWbq0fKnfXi
   w==;
X-CSE-ConnectionGUID: IOyl6ATITkm8HeL6Rntk6Q==
X-CSE-MsgGUID: 19hWT2THT/e4YXgcpFDkRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11867"; a="86513345"
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="86513345"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 15:32:31 -0700
X-CSE-ConnectionGUID: E9QjSI28SxWCevUyBrFnAQ==
X-CSE-MsgGUID: 8NF06fbkQaKdmNAyruE9bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="285605533"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.8])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 15:31:20 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Tao Xu <xutao323@gmail.com>,
	linux-cxl@vger.kernel.org,
	Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] util/sysfs: do not fail on missing bind attributes
Date: Thu,  6 Aug 2026 15:31:11 -0700
Message-ID: <20260806223116.2354715-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Xu <xutao323@gmail.com>

Kernel commit cb9cfff82f6a ("cxl/acpi: Simplify cxl_nvdimm_bridge
probing") removed bind attrributes for cxl_pmem_region and
cxl_nvdimm* objects.

__util_bind() currently attempts to write to the bind attribute of
every entry under /sys/bus/cxl/drivers/. On kernels where some driver
directories no longer provide that attribute, these attempts fail with
ENOENT and produce misleading bind errors.

Check that the bind attribute exists before attempting the write.

[ as: commit log edited ]

Reported-by: Tao Xu <xutao323@gmail.com>
Closes: https://github.com/pmem/ndctl/issues/298
Signed-off-by: Tao Xu <xutao323@gmail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 util/sysfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/util/sysfs.c b/util/sysfs.c
index eaf4b60aacee..2dd4b48b4459 100644
--- a/util/sysfs.c
+++ b/util/sysfs.c
@@ -258,6 +258,11 @@ int __util_bind(const char *devname, struct kmod_module *module,
 			continue;
 		}
 
+		if (access(drv_path, F_OK) != 0) {
+			free(drv_path);
+			continue;
+		}
+
 		rc = __sysfs_write_attr_quiet(ctx, drv_path, devname);
 		free(drv_path);
 		if (rc == 0)
-- 
2.37.3

