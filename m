Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF35523D7FB
	for <nvdimm@lists.linux.dev>; Fri,  3 Apr 2026 21:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775252851; cv=none; b=tIgKg8Uz7063kOglIza7mBWiCUzAnpty+7Ze5UC7OYyZChakKPliuynB7zVRyWS+AxuXBc/wP/T6F1cqvN8dVn7UXwQ6bp/xR1A3gCSPha/XAytdWyT2yTZfHXL3BUeLpNoW6ESQOnwsMTsjUTjSiiIE2lPG1rrhI66Xgzc/1Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775252851; c=relaxed/simple;
	bh=tXOA2biVO6h2U48phhReNc4RvNpsVlmDLuWKlxiO68M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TULQISW1qhSS0PDRI9BiMp3DTgis+u86Fgn89zNuTwC6bpIHBOiQyO6W1F0CMxyDScJ3oBW5Xd4F4OOTWBCyzYCYmWs5POSdI5kRk2pg+knjx9YiG2aC2BzbPhI/JqynmylpoR155mGvzLCD2ASSoqUcsKROj8AATOkVTFsUXOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FS8zUUzg; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FS8zUUzg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775252849; x=1806788849;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tXOA2biVO6h2U48phhReNc4RvNpsVlmDLuWKlxiO68M=;
  b=FS8zUUzgcpy7kYMcbmk2d6qYMDOIMMpMBkHVJ61caMWo7fOo0KSFUA/q
   71eaowhFdaAVSEQ+IO78oPB051V7zMBxGTYcc6DtpU1+/RdzHycn4CTER
   473e47QXd1zl3cYxrcmyVROf4MRAC8l/GiUKM3Y2dvFtX5dhLAvUMX2B/
   oMTKWMq5vah63hTscqInVfCzui5L6PXD4JC7ZpGPDetZ9ZmnXaCSJ/nA5
   VCeR9+HftfJsZhic6WEZYlYEE9MEwJleD+QlisHFrsgFlD/BoIDWqP5m2
   oLgxtOexZLgp/r2W15XHrcXXr2S7Zns9esbm8L1C02kPi/iLVd+pVPhqf
   w==;
X-CSE-ConnectionGUID: lLpx7sCGT3GtVSejiKKZxg==
X-CSE-MsgGUID: 7O6JpaizTDeBUctqQEt20w==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76334414"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76334414"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 14:47:29 -0700
X-CSE-ConnectionGUID: 7Auq3cHmSVWZjhkIo5RGiw==
X-CSE-MsgGUID: gPn5BdVJSZ6Y/o++VldIow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="265292562"
Received: from dwillia2-desk.jf.intel.com ([10.88.27.145])
  by orviesa001.jf.intel.com with ESMTP; 03 Apr 2026 14:47:28 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH] MAINTAINERS: Update address for Dan Williams
Date: Fri,  3 Apr 2026 14:48:46 -0700
Message-ID: <20260403214846.1062341-1-dan.j.williams@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update MAINTAINERS and .mailmap to point to my kernel.org address:
djbw@kernel.org.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .mailmap    |  1 +
 MAINTAINERS | 18 +++++++++---------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/.mailmap b/.mailmap
index 2d04aeba68b4..a4ad593b5ed8 100644
--- a/.mailmap
+++ b/.mailmap
@@ -204,6 +204,7 @@ Colin Ian King <colin.i.king@gmail.com> <colin.king@canonical.com>
 Corey Minyard <minyard@acm.org>
 Damian Hobson-Garcia <dhobsong@igel.co.jp>
 Dan Carpenter <error27@gmail.com> <dan.carpenter@oracle.com>
+Dan Williams <djbw@kernel.org> <dan.j.williams@intel.com>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@googlemail.com>
 Daniel Borkmann <daniel@iogearbox.net> <danborkmann@iogearbox.net>
 Daniel Borkmann <daniel@iogearbox.net> <daniel.borkmann@tik.ee.ethz.ch>
diff --git a/MAINTAINERS b/MAINTAINERS
index c3fe46d7c4bc..150784b8febc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4058,7 +4058,7 @@ S:	Maintained
 F:	crypto/rsa*
 
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
-R:	Dan Williams <dan.j.williams@intel.com>
+R:	Dan Williams <djbw@kernel.org>
 S:	Odd fixes
 W:	http://sourceforge.net/projects/xscaleiop
 F:	Documentation/crypto/async-tx-api.rst
@@ -6429,7 +6429,7 @@ M:	Dave Jiang <dave.jiang@intel.com>
 M:	Alison Schofield <alison.schofield@intel.com>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Ira Weiny <ira.weiny@intel.com>
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@kernel.org>
 L:	linux-cxl@vger.kernel.org
 S:	Maintained
 F:	Documentation/driver-api/cxl
@@ -7290,7 +7290,7 @@ S:	Maintained
 F:	scripts/dev-needs.sh
 
 DEVICE DIRECT ACCESS (DAX)
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 L:	nvdimm@lists.linux.dev
@@ -9816,7 +9816,7 @@ F:	include/linux/fcntl.h
 F:	include/uapi/linux/fcntl.h
 
 FILESYSTEM DIRECT ACCESS (DAX)
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@kernel.org>
 R:	Matthew Wilcox <willy@infradead.org>
 R:	Jan Kara <jack@suse.cz>
 L:	linux-fsdevel@vger.kernel.org
@@ -12872,7 +12872,7 @@ F:	drivers/platform/x86/intel/hid.c
 
 INTEL I/OAT DMA DRIVER
 M:	Dave Jiang <dave.jiang@intel.com>
-R:	Dan Williams <dan.j.williams@intel.com>
+R:	Dan Williams <djbw@kernel.org>
 L:	dmaengine@vger.kernel.org
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
@@ -14575,7 +14575,7 @@ K:	libie
 
 LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
 M:	Vishal Verma <vishal.l.verma@intel.com>
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@kernel.org>
 M:	Dave Jiang <dave.jiang@intel.com>
 L:	nvdimm@lists.linux.dev
 S:	Supported
@@ -14584,7 +14584,7 @@ P:	Documentation/nvdimm/maintainer-entry-profile.rst
 F:	drivers/nvdimm/btt*
 
 LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 L:	nvdimm@lists.linux.dev
@@ -14602,7 +14602,7 @@ F:	Documentation/devicetree/bindings/pmem/pmem-region.yaml
 F:	drivers/nvdimm/of_pmem.c
 
 LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@kernel.org>
 M:	Vishal Verma <vishal.l.verma@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
 M:	Ira Weiny <ira.weiny@intel.com>
@@ -26869,7 +26869,7 @@ S:	Maintained
 F:	Documentation/devicetree/bindings/trigger-source/*
 
 TRUSTED EXECUTION ENVIRONMENT SECURITY MANAGER (TSM)
-M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dan Williams <djbw@kernel.org>
 L:	linux-coco@lists.linux.dev
 S:	Maintained
 F:	Documentation/ABI/testing/configfs-tsm-report

base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
-- 
2.53.0

