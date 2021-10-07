Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2142CA1
	for <nvdimm@lists.linux.dev>; Thu,  7 Oct 2021 08:22:00 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="249511723"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="249511723"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:57 -0700
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="568555118"
Received: from abishekh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.239])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:56 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v4 11/17] libcxl: add a stub interface to determine whether a memdev is active
Date: Thu,  7 Oct 2021 02:21:33 -0600
Message-Id: <20211007082139.3088615-12-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007082139.3088615-1-vishal.l.verma@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1964; h=from:subject; bh=NPfWs2gFlIShVnWwf2ZzJSQqfH909RKCgpKdC2hastM=; b=owGbwMvMwCHGf25diOft7jLG02pJDIlx67h2+Fr9yXiUf13ng+c7H8UnRVkWUX2raw/trlPbYqfd UbGwo5SFQYyDQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABNZeoSR4dybwHdrMyzOGe8TNFgwzS JA7Ya4qfIJC92Je5+4dFrcSmBkOMwgkN12vfSmcqnbPVHDczNyNrLkXA3v3Ljm3GeHb/EiXAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add an interface to determine whether a memdev is bound to a region
driver and therefore is currently active.

For now, this just returns '0' all the time - i.e. devices are always
considered inactive. Flesh this out fully once the region driver is
available.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/libcxl.c   | 10 ++++++++++
 cxl/libcxl.h       |  1 +
 cxl/lib/libcxl.sym |  1 +
 3 files changed, 12 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index de3a8f7..59d091c 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -362,6 +362,16 @@ CXL_EXPORT size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev)
 	return memdev->lsa_size;
 }
 
+CXL_EXPORT int cxl_memdev_is_active(struct cxl_memdev *memdev)
+{
+	/*
+	 * TODO: Currently memdevs are always considered inactive. Once we have
+	 * cxl_bus drivers that are bound/unbound to memdevs, we'd use that to
+	 * determine the active/inactive state.
+	 */
+	return 0;
+}
+
 CXL_EXPORT void cxl_cmd_unref(struct cxl_cmd *cmd)
 {
 	if (!cmd)
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index d3b97a1..2e24371 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -43,6 +43,7 @@ unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
 size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
+int cxl_memdev_is_active(struct cxl_memdev *memdev);
 
 #define cxl_memdev_foreach(ctx, memdev) \
         for (memdev = cxl_memdev_get_first(ctx); \
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index b9feb93..0e82030 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -79,4 +79,5 @@ global:
 LIBCXL_4 {
 global:
 	cxl_memdev_get_label_size;
+	cxl_memdev_is_active;
 } LIBCXL_3;
-- 
2.31.1

