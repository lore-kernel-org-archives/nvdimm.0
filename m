Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A35A27FB25
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 17:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649224; cv=none; b=fjXWtQoG24iuEhlDKOM0Ol2YANbN/3qakhkEIzEBS5VwEuHO2tyI/Rrq39CESsQ85qi8zTLo/i1cT4MQk2Y7pZ98F50r2shGzwPvjSu/XVXklzhYzhCx8bnM1PZOtWKKvg+aTe7/fKdadEnJuSoSwmaUOLBNhNNl2EsuPKnw1Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649224; c=relaxed/simple;
	bh=mgw+7D1634goOMrQY1vwGtAMiS3bbHAuVb18Q0Sj+DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baeIiBq5uIImabFi81G0OLVfwNK+Gi+p6W1KSQE7kWRJeD0XgPd1cVP5cJBsEA7VoZs0XfemAnJFcJSkuwy+fggwkwmrWr39cPSL1cOGMI/sDzv+2ECTkyrw4i7oKUNxwNohwAzRzrmVANFnF1AhwzTGx9tiB6LkvpNf3WVnkAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D546EC4CEF5;
	Tue, 23 Sep 2025 17:40:23 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev
Cc: ira.weiny@intel.com,
	vishal.l.verma@intel.com,
	dan.j.williams@intel.com,
	jonathan.cameron@huawei.com,
	s.neeraj@samsung.com
Subject: [PATCH v2 2/2] nvdimm: Clean up __nd_ioctl() and remove gotos
Date: Tue, 23 Sep 2025 10:40:13 -0700
Message-ID: <20250923174013.3319780-3-dave.jiang@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250923174013.3319780-1-dave.jiang@intel.com>
References: <20250923174013.3319780-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Utilize scoped based resource management to clean up the code and
and remove gotos for the __nd_ioctl() function.

Change allocation of 'buf' to use kvzalloc() in order to use
vmalloc() memory when needed and also zero out the allocated
memory.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/bus.c | 65 +++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 43 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index e57d5677d44b..ad3a0493f474 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -5,7 +5,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/libnvdimm.h>
 #include <linux/sched/mm.h>
-#include <linux/vmalloc.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/blkdev.h>
@@ -1029,14 +1029,12 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	unsigned int cmd = _IOC_NR(ioctl_cmd);
 	struct device *dev = &nvdimm_bus->dev;
 	void __user *p = (void __user *) arg;
-	char *out_env = NULL, *in_env = NULL;
 	const char *cmd_name, *dimm_name;
 	u32 in_len = 0, out_len = 0;
 	unsigned int func = cmd;
 	unsigned long cmd_mask;
 	struct nd_cmd_pkg pkg;
 	int rc, i, cmd_rc;
-	void *buf = NULL;
 	u64 buf_len = 0;
 
 	if (nvdimm) {
@@ -1095,7 +1093,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		}
 
 	/* process an input envelope */
-	in_env = kzalloc(ND_CMD_MAX_ENVELOPE, GFP_KERNEL);
+	char *in_env __free(kfree) = kzalloc(ND_CMD_MAX_ENVELOPE, GFP_KERNEL);
 	if (!in_env)
 		return -ENOMEM;
 	for (i = 0; i < desc->in_num; i++) {
@@ -1105,17 +1103,14 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		if (in_size == UINT_MAX) {
 			dev_err(dev, "%s:%s unknown input size cmd: %s field: %d\n",
 					__func__, dimm_name, cmd_name, i);
-			rc = -ENXIO;
-			goto out;
+			return -ENXIO;
 		}
 		if (in_len < ND_CMD_MAX_ENVELOPE)
 			copy = min_t(u32, ND_CMD_MAX_ENVELOPE - in_len, in_size);
 		else
 			copy = 0;
-		if (copy && copy_from_user(&in_env[in_len], p + in_len, copy)) {
-			rc = -EFAULT;
-			goto out;
-		}
+		if (copy && copy_from_user(&in_env[in_len], p + in_len, copy))
+			return -EFAULT;
 		in_len += in_size;
 	}
 
@@ -1127,11 +1122,9 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	}
 
 	/* process an output envelope */
-	out_env = kzalloc(ND_CMD_MAX_ENVELOPE, GFP_KERNEL);
-	if (!out_env) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	char *out_env __free(kfree) = kzalloc(ND_CMD_MAX_ENVELOPE, GFP_KERNEL);
+	if (!out_env)
+		return -ENOMEM;
 
 	for (i = 0; i < desc->out_num; i++) {
 		u32 out_size = nd_cmd_out_size(nvdimm, cmd, desc, i,
@@ -1141,8 +1134,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 		if (out_size == UINT_MAX) {
 			dev_dbg(dev, "%s unknown output size cmd: %s field: %d\n",
 					dimm_name, cmd_name, i);
-			rc = -EFAULT;
-			goto out;
+			return -EFAULT;
 		}
 		if (out_len < ND_CMD_MAX_ENVELOPE)
 			copy = min_t(u32, ND_CMD_MAX_ENVELOPE - out_len, out_size);
@@ -1150,8 +1142,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 			copy = 0;
 		if (copy && copy_from_user(&out_env[out_len],
 					p + in_len + out_len, copy)) {
-			rc = -EFAULT;
-			goto out;
+			return -EFAULT;
 		}
 		out_len += out_size;
 	}
@@ -1160,30 +1151,25 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	if (buf_len > ND_IOCTL_MAX_BUFLEN) {
 		dev_dbg(dev, "%s cmd: %s buf_len: %llu > %d\n", dimm_name,
 				cmd_name, buf_len, ND_IOCTL_MAX_BUFLEN);
-		rc = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
-	buf = vmalloc(buf_len);
-	if (!buf) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	void *buf __free(kvfree) = kvzalloc(buf_len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
 
-	if (copy_from_user(buf, p, buf_len)) {
-		rc = -EFAULT;
-		goto out;
-	}
+	if (copy_from_user(buf, p, buf_len))
+		return -EFAULT;
 
-	device_lock(dev);
-	nvdimm_bus_lock(dev);
+	guard(device)(dev);
+	guard(nvdimm_bus)(dev);
 	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, func, buf);
 	if (rc)
-		goto out_unlock;
+		return rc;
 
 	rc = nd_desc->ndctl(nd_desc, nvdimm, cmd, buf, buf_len, &cmd_rc);
 	if (rc < 0)
-		goto out_unlock;
+		return rc;
 
 	if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR && cmd_rc >= 0) {
 		struct nd_cmd_clear_error *clear_err = buf;
@@ -1193,16 +1179,9 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	}
 
 	if (copy_to_user(p, buf, buf_len))
-		rc = -EFAULT;
+		return -EFAULT;
 
-out_unlock:
-	nvdimm_bus_unlock(dev);
-	device_unlock(dev);
-out:
-	kfree(in_env);
-	kfree(out_env);
-	vfree(buf);
-	return rc;
+	return 0;
 }
 
 enum nd_ioctl_mode {
-- 
2.51.0

