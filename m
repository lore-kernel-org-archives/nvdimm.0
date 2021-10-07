Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27682CA5
	for <nvdimm@lists.linux.dev>; Thu,  7 Oct 2021 08:22:00 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10129"; a="249511722"
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="249511722"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:56 -0700
X-IronPort-AV: E=Sophos;i="5.85,354,1624345200"; 
   d="scan'208";a="568555114"
Received: from abishekh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.133.239])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 01:21:56 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v4 10/17] libcxl: add label_size to cxl_memdev, and an API to retrieve it
Date: Thu,  7 Oct 2021 02:21:32 -0600
Message-Id: <20211007082139.3088615-11-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007082139.3088615-1-vishal.l.verma@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2551; h=from:subject; bh=o1C6jkiUTlpPWcct6xVgo5MVjoHuL/SHE7mDaFnRkng=; b=owGbwMvMwCHGf25diOft7jLG02pJDIlx6ziX6EszTfrIcGL7XI/c0k+6O38XqX2b4mLzM+PADdnE uMvLO0pZGMQ4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRcHlGhulMChPKtgfPaGc6c+Wm86 21p22TlY9wV0+Z8vrnodqVP48zMmyN++XUEhK6evqPNzPPrBFePHd2n2aCmrrJtzVVRvlFi1kB
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Size of the Label Storage Area (LSA) is available as a sysfs attribute
called 'label_storage_size'. Add that to libcxl's memdev so that it is available
for label related commands.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |  1 +
 cxl/lib/libcxl.c   | 12 ++++++++++++
 cxl/libcxl.h       |  1 +
 cxl/lib/libcxl.sym |  5 +++++
 4 files changed, 19 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 9c6317b..671f12f 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -21,6 +21,7 @@ struct cxl_memdev {
 	unsigned long long pmem_size;
 	unsigned long long ram_size;
 	int payload_max;
+	size_t lsa_size;
 	struct kmod_module *module;
 };
 
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 33cc462..de3a8f7 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -247,6 +247,13 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	if (memdev->payload_max < 0)
 		goto err_read;
 
+	sprintf(path, "%s/label_storage_size", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		goto err_read;
+	memdev->lsa_size = strtoull(buf, NULL, 0);
+	if (memdev->lsa_size == ULLONG_MAX)
+		goto err_read;
+
 	memdev->dev_path = strdup(cxlmem_base);
 	if (!memdev->dev_path)
 		goto err_read;
@@ -350,6 +357,11 @@ CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev
 	return memdev->firmware_version;
 }
 
+CXL_EXPORT size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev)
+{
+	return memdev->lsa_size;
+}
+
 CXL_EXPORT void cxl_cmd_unref(struct cxl_cmd *cmd)
 {
 	if (!cmd)
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 7408745..d3b97a1 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -42,6 +42,7 @@ struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
+size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
 
 #define cxl_memdev_foreach(ctx, memdev) \
         for (memdev = cxl_memdev_get_first(ctx); \
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 1b608d8..b9feb93 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -75,3 +75,8 @@ global:
 	cxl_cmd_new_read_label;
 	cxl_cmd_read_label_get_payload;
 } LIBCXL_2;
+
+LIBCXL_4 {
+global:
+	cxl_memdev_get_label_size;
+} LIBCXL_3;
-- 
2.31.1

