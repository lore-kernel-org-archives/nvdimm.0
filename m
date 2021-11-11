Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2B22CA2
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 20:44:59 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233253834"
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="233253834"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:55 -0800
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="504579078"
Received: from dmamols-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.255.92.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:55 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v5 09/16] libcxl: add label_size to cxl_memdev, and an API to retrieve it
Date: Thu, 11 Nov 2021 13:44:29 -0700
Message-Id: <20211111204436.1560365-10-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211111204436.1560365-1-vishal.l.verma@intel.com>
References: <20211111204436.1560365-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2659; h=from:subject; bh=5YV7bznFT8CiW378WMH3ttwGTr9y5KQcVzO9zFliIEA=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm9DZum5J73X1Lv8uB45bJdgr9XHv6cpTbBNdz/rdGd5SUu 0oq/OkpZGMQ4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRx8aMDKv28SQyszMwB/w3aaz/Kr Dkxub+D/amS17fWndlb4LPaWeGv1JZDkKf+O13H2g+03jlzGbrOsbpCdapD4VcXQSWe9XzswMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Size of the Label Storage Area (LSA) is available as a sysfs attribute
called 'label_storage_size'. Add that to libcxl's memdev so that it is available
for label related commands.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  |  1 +
 cxl/lib/libcxl.c   | 12 ++++++++++++
 cxl/libcxl.h       |  1 +
 cxl/lib/libcxl.sym |  1 +
 4 files changed, 15 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index bf3a897..c4ed741 100644
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
index 76913a2..def3a97 100644
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
index 629322c..858e953 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -64,6 +64,7 @@ global:
 	cxl_cmd_health_info_get_pmem_errors;
 	cxl_cmd_new_read_label;
 	cxl_cmd_read_label_get_payload;
+	cxl_memdev_get_label_size;
 local:
         *;
 };
-- 
2.31.1

