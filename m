Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC5A133419;
	Thu, 15 Feb 2024 16:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708013789; cv=none; b=rSmfGs5J5ktBMK7uY8ze8QBhiWP0oDwlv50ZStzv+4nEuQMSveJsRiMDCMczDrXRhSjHBvdij2FGW+R7jM3U4wfMijdQrQ8bRX9gWaBOjdj8SsWN2zJKPHKDqBUEyM6eLCDevMefCSx7CcSn6k8IMJNks6qj9F3vxgialC6ieos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708013789; c=relaxed/simple;
	bh=TuUUwhc8pyEaKP1tCqFSyykTn9ECMnLWn9Jwk5ujLiw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ht6LabAxg+wr2tp8N+cHvG8qa3BX4EWl4viHYewPmHXtFTmXwD5k1olJjsNfIbrB9NnDTmxKjv/3SD8WZnNt2u9YjogRiVqxAwHdKadaerK4SBiZfmSkD0qaU8F17ku8R6GXkEORozJDec4EmLFTwRwaDX9FSi1hUbLncuV4fp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDCAC433F1;
	Thu, 15 Feb 2024 16:16:28 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	wj28.lee@samsung.com
Subject: [NDCTL PATCH v2] ndctl: cxl: Remove dependency for attributes derived from IDENTIFY command
Date: Thu, 15 Feb 2024 09:16:20 -0700
Message-ID: <20240215161620.2739089-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A memdev may optionally not host a mailbox and therefore not able to execute
the IDENTIFY command. Currently the kernel emits empty strings for some of
the attributes instead of making them invisible in order to keep backward
compatibility for CXL CLI. Remove dependency of CXL CLI on the existance of
these attributes and only expose them if they exist. Without the dependency
the kernel will be able to make the non-existant attributes invisible.

Link: https://lore.kernel.org/all/20230606121534.00003870@Huawei.com/
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v2:
- Add lable size check for action_write(). (Wonjae)
---
 cxl/lib/libcxl.c | 48 ++++++++++++++++++++++++++----------------------
 cxl/memdev.c     | 18 +++++++++++++-----
 2 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 1537a33d370e..f807ec4ed4e6 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1251,28 +1251,30 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	memdev->minor = minor(st.st_rdev);
 
 	sprintf(path, "%s/pmem/size", cxlmem_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-	memdev->pmem_size = strtoull(buf, NULL, 0);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		memdev->pmem_size = strtoull(buf, NULL, 0);
 
 	sprintf(path, "%s/ram/size", cxlmem_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-	memdev->ram_size = strtoull(buf, NULL, 0);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		memdev->ram_size = strtoull(buf, NULL, 0);
 
 	sprintf(path, "%s/payload_max", cxlmem_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-	memdev->payload_max = strtoull(buf, NULL, 0);
-	if (memdev->payload_max < 0)
-		goto err_read;
+	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		memdev->payload_max = strtoull(buf, NULL, 0);
+		if (memdev->payload_max < 0)
+			goto err_read;
+	} else {
+		memdev->payload_max = -1;
+	}
 
 	sprintf(path, "%s/label_storage_size", cxlmem_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-	memdev->lsa_size = strtoull(buf, NULL, 0);
-	if (memdev->lsa_size == ULLONG_MAX)
-		goto err_read;
+	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		memdev->lsa_size = strtoull(buf, NULL, 0);
+		if (memdev->lsa_size == ULLONG_MAX)
+			goto err_read;
+	} else {
+		memdev->lsa_size = ULLONG_MAX;
+	}
 
 	sprintf(path, "%s/serial", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
@@ -1299,12 +1301,11 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	host[0] = '\0';
 
 	sprintf(path, "%s/firmware_version", cxlmem_base);
-	if (sysfs_read_attr(ctx, path, buf) < 0)
-		goto err_read;
-
-	memdev->firmware_version = strdup(buf);
-	if (!memdev->firmware_version)
-		goto err_read;
+	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		memdev->firmware_version = strdup(buf);
+		if (!memdev->firmware_version)
+			goto err_read;
+	}
 
 	memdev->dev_buf = calloc(1, strlen(cxlmem_base) + 50);
 	if (!memdev->dev_buf)
@@ -4543,6 +4544,9 @@ static int lsa_op(struct cxl_memdev *memdev, int op, void *buf,
 	if (length == 0)
 		return 0;
 
+	if (memdev->payload_max < 0)
+		return -EINVAL;
+
 	label_iter_max = memdev->payload_max - sizeof(struct cxl_cmd_set_lsa);
 	while (remaining) {
 		cur_len = min((size_t)label_iter_max, remaining);
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 81f07991da06..08b6aa50175f 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -473,10 +473,13 @@ static int action_zero(struct cxl_memdev *memdev, struct action_context *actx)
 	size_t size;
 	int rc;
 
-	if (param.len)
+	if (param.len) {
 		size = param.len;
-	else
+	} else {
 		size = cxl_memdev_get_label_size(memdev);
+		if (size == ULLONG_MAX)
+			return -EINVAL;
+	}
 
 	if (cxl_memdev_nvdimm_bridge_active(memdev)) {
 		log_err(&ml,
@@ -509,6 +512,9 @@ static int action_write(struct cxl_memdev *memdev, struct action_context *actx)
 	if (!size) {
 		size_t label_size = cxl_memdev_get_label_size(memdev);
 
+		if (label_size == ULONG_MAX)
+			return -EINVAL;
+
 		fseek(actx->f_in, 0L, SEEK_END);
 		size = ftell(actx->f_in);
 		fseek(actx->f_in, 0L, SEEK_SET);
@@ -547,11 +553,13 @@ static int action_read(struct cxl_memdev *memdev, struct action_context *actx)
 	char *buf;
 	int rc;
 
-	if (param.len)
+	if (param.len) {
 		size = param.len;
-	else
+	} else {
 		size = cxl_memdev_get_label_size(memdev);
-
+		if (size == ULLONG_MAX)
+			return -EINVAL;
+	}
 	buf = calloc(1, size);
 	if (!buf)
 		return -ENOMEM;
-- 
2.43.0

