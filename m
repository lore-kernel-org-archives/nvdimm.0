Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DECC2FB7
	for <nvdimm@lists.linux.dev>; Thu,  1 Jul 2021 20:10:30 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="205606945"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="205606945"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:22 -0700
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409271385"
Received: from anandvig-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.38.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 13:10:21 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v3 14/21] libcxl: add lsa_size to cxl_memdev, and an API to retrieve it
Date: Thu,  1 Jul 2021 14:09:58 -0600
Message-Id: <20210701201005.3065299-15-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210701201005.3065299-1-vishal.l.verma@intel.com>
References: <20210701201005.3065299-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Size of the Label Storage Area (LSA) is available as a sysfs attribute
called 'lsa_size'. Add that to libcxl's memdev so that it is available
for label related commands.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |  1 +
 cxl/lib/libcxl.c   | 12 ++++++++++++
 cxl/libcxl.h       |  1 +
 cxl/lib/libcxl.sym |  5 +++++
 4 files changed, 19 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index fb1dd8e..1bce3b5 100644
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
index d2c38c9..ae03e03 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -246,6 +246,13 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
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
@@ -349,6 +356,11 @@ CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev
 	return memdev->firmware_version;
 }
 
+CXL_EXPORT size_t cxl_memdev_get_lsa_size(struct cxl_memdev *memdev)
+{
+	return memdev->lsa_size;
+}
+
 CXL_EXPORT void cxl_cmd_unref(struct cxl_cmd *cmd)
 {
 	if (!cmd)
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 6edbd8d..eeace11 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -42,6 +42,7 @@ struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
+size_t cxl_memdev_get_lsa_size(struct cxl_memdev *memdev);
 
 #define cxl_memdev_foreach(ctx, memdev) \
         for (memdev = cxl_memdev_get_first(ctx); \
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 2c6193b..a5a1371 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -55,3 +55,8 @@ global:
 	cxl_cmd_new_get_lsa;
 	cxl_cmd_get_lsa_get_payload;
 } LIBCXL_2;
+
+LIBCXL_4 {
+global:
+	cxl_memdev_get_lsa_size;
+} LIBCXL_3;
-- 
2.31.1

