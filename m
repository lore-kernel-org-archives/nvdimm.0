Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8603C3DEACA
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 13:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779801794; cv=none; b=NElyDczjCDsUqRH2cFuYaakCd4zi12V8qh1wvl9jJm7m7cPIW+4Nr6cIuUdIh89CC02YvTdVJ33lf5Ds9WzWl/aUES02MwMFEufp7RdWlonsB9AHpoJoIuMoyS2YqfxN4LGW0Rh5ZDOQzlR1AGvTrd26dmpCrnXzwTovGfy3qgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779801794; c=relaxed/simple;
	bh=NoP4JhXaZZD9Hby1n1mNL5Hbxom2RCxaXt5YhZeF5JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxb/667kbEX979AzwkKUCGi3D6oxLmLvBUOoBkYef4JfccF93kI4LIqlIgbB8ar/xSOR6WYBmPde43yfYsI87PSkoMkZ/XIQPBuznInwI5SO0Lfnyj+9xEubmSVG2kEIXawYIOnzAZibLdpIJKGMb6P7A84Zzn5crEc3nfDrOyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GStINpQ8; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GStINpQ8"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779801789; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=GkxqfMIzX3XGBqhg6VZbgGas75PRk1/VVYYNqV7y0gM=;
	b=GStINpQ8AAch5l6X9/O0OKI9kgOG9H6mYgz9q+dK8tSgtswgNDOLiSulQdMd7fnjJ6YoZM1SD72kAHff7S/mBkmjeCaxi+gRz7CXGk/R5axYYi0OqGvBQBe9exkVcy6vjxkszpHup1RTRIuqQLls0GvVgB3L2AwEC7xe5KgwyH4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X3gT8oX_1779801787;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X3gT8oX_1779801787 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 26 May 2026 21:23:07 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: alison.schofield@intel.com,
	dave.jiang@intel.com,
	jic23@kernel.org,
	nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	guoren@kernel.org,
	Chen Pei <cp0613@linux.alibaba.com>
Subject: [ndctl PATCH v2 2/2] daxctl, util/sysfs: skip module probe-insert when driver is builtin or live
Date: Tue, 26 May 2026 21:22:51 +0800
Message-ID: <20260526132251.254476-3-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260526132251.254476-1-cp0613@linux.alibaba.com>
References: <20260526132251.254476-1-cp0613@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kmod_module_probe_insert_module() is supposed to return 0 for builtin
modules, but only when libkmod can locate the modules.builtin index. If
the index is missing (e.g. a kernel built with the driver as builtin
but installed without running modules_install), libkmod falls through
to the real init_module() syscall and returns an error such as -ENOENT,
producing a spurious "insert failure" even though the driver is already
part of the running kernel.

Add a helper util_kmod_skip_probe_insert() that returns true when the
module state is KMOD_MODULE_BUILTIN or KMOD_MODULE_LIVE. As an
additional heuristic, treat KMOD_MODULE_COMING as builtin when
/sys/module/<name>/ exists but the initstate file does not - this is
the exact pattern libkmod's sysfs fallback emits for builtin drivers
when the modules.builtin index is unavailable. The pattern mirrors the
KMOD_MODULE_LIVE / KMOD_MODULE_BUILTIN check already used by ndctl's
own test/core.c (see test/core.c:218-236).

The helper also returns the observed libkmod state via an out parameter
so daxctl_insert_kmod_for_mode() can distinguish LIVE (retain the kmod
reference in dev->module) from BUILTIN (drop it, since builtin drivers
cannot be unloaded) without re-reading /sys/module/<name>/initstate.
__util_bind() passes NULL since it does not need the state.

Reported-by: Jonathan Cameron <jic23@kernel.org>
Suggested-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 daxctl/lib/libdaxctl.c | 22 +++++++++++++++++++--
 util/sysfs.c           | 44 +++++++++++++++++++++++++++++++++++++++++-
 util/sysfs.h           | 16 +++++++++++++++
 3 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index ffc81eb..1596dc0 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -910,7 +910,7 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
 	const char *devname = daxctl_dev_get_devname(dev);
 	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
 	struct kmod_module *kmod;
-	int rc;
+	int state, rc;
 
 	rc = kmod_module_new_from_name(ctx->kmod_ctx, mod_name, &kmod);
 	if (rc < 0) {
@@ -919,7 +919,25 @@ static int daxctl_insert_kmod_for_mode(struct daxctl_dev *dev,
 		return rc;
 	}
 
-	/* if the driver is builtin, this Just Works */
+	/*
+	 * If the driver is builtin or already live, skip probe-insert.
+	 * For live modules retain the local reference in dev->module so
+	 * the module can be unreffed alongside the device; for builtin
+	 * drivers drop it because builtin modules cannot be unloaded.
+	 */
+	if (util_kmod_skip_probe_insert(kmod, ctx, &state)) {
+		if (state == KMOD_MODULE_LIVE) {
+			dbg(ctx, "%s: module %s already loaded\n", devname,
+				kmod_module_get_name(kmod));
+			dev->module = kmod;
+		} else {
+			dbg(ctx, "%s: module %s is builtin\n", devname,
+				kmod_module_get_name(kmod));
+			kmod_module_unref(kmod);
+		}
+		return 0;
+	}
+
 	dbg(ctx, "%s inserting module: %s\n", devname,
 		kmod_module_get_name(kmod));
 	rc = kmod_module_probe_insert_module(kmod,
diff --git a/util/sysfs.c b/util/sysfs.c
index e027e38..eaf4b60 100644
--- a/util/sysfs.c
+++ b/util/sysfs.c
@@ -6,6 +6,7 @@
 #include <stdarg.h>
 #include <unistd.h>
 #include <errno.h>
+#include <limits.h>
 #include <string.h>
 #include <ctype.h>
 #include <fcntl.h>
@@ -168,6 +169,47 @@ struct kmod_module *__util_modalias_to_module(struct kmod_ctx *kmod_ctx,
 	return mod;
 }
 
+bool __util_kmod_skip_probe_insert(struct kmod_module *module,
+				   struct log_ctx *ctx, int *state_out)
+{
+	const char *name = kmod_module_get_name(module);
+	int state = kmod_module_get_initstate(module);
+	char path[PATH_MAX];
+	struct stat st;
+
+	if (state_out)
+		*state_out = state;
+
+	if (state == KMOD_MODULE_BUILTIN || state == KMOD_MODULE_LIVE)
+		return true;
+
+	/*
+	 * When modules.builtin is missing (e.g. a kernel installed
+	 * without modules_install), libkmod's sysfs fallback returns
+	 * KMOD_MODULE_COMING for builtin drivers because /sys/module/<name>/
+	 * exists but the initstate file does not. Treat that pattern as
+	 * builtin to avoid a spurious "insert failure" message.
+	 */
+	if (state != KMOD_MODULE_COMING)
+		return false;
+
+	if (snprintf(path, sizeof(path), "/sys/module/%s/initstate", name)
+			>= (int)sizeof(path))
+		return false;
+	if (stat(path, &st) == 0 || errno != ENOENT)
+		return false;
+
+	if (snprintf(path, sizeof(path), "/sys/module/%s", name)
+			>= (int)sizeof(path))
+		return false;
+	if (stat(path, &st) != 0 || !S_ISDIR(st.st_mode))
+		return false;
+
+	log_dbg(ctx, "module %s appears builtin (no modules.builtin index)\n",
+			name);
+	return true;
+}
+
 int __util_bind(const char *devname, struct kmod_module *module,
 		const char *bus, struct log_ctx *ctx)
 {
@@ -182,7 +224,7 @@ int __util_bind(const char *devname, struct kmod_module *module,
 		return -EINVAL;
 	}
 
-	if (module) {
+	if (module && !__util_kmod_skip_probe_insert(module, ctx, NULL)) {
 		rc = kmod_module_probe_insert_module(module,
 						     KMOD_PROBE_APPLY_BLACKLIST,
 						     NULL, NULL, NULL, NULL);
diff --git a/util/sysfs.h b/util/sysfs.h
index 4c95c70..e4f6115 100644
--- a/util/sysfs.h
+++ b/util/sysfs.h
@@ -3,6 +3,7 @@
 #ifndef __UTIL_SYSFS_H__
 #define __UTIL_SYSFS_H__
 
+#include <stdbool.h>
 #include <string.h>
 
 typedef void *(*add_dev_fn)(void *parent, int id, const char *dev_path);
@@ -36,6 +37,21 @@ struct kmod_module *__util_modalias_to_module(struct kmod_ctx *kmod_ctx,
 #define util_modalias_to_module(ctx, buf)                                      \
 	__util_modalias_to_module((ctx)->kmod_ctx, buf, &(ctx)->ctx)
 
+/*
+ * __util_kmod_skip_probe_insert - true when kmod_module_probe_insert_module()
+ * should be skipped because @module is already part of the running kernel:
+ * KMOD_MODULE_BUILTIN, KMOD_MODULE_LIVE, or KMOD_MODULE_COMING with
+ * /sys/module/<name>/ existing but no initstate file (the fingerprint
+ * libkmod's sysfs fallback emits for builtin drivers when the
+ * modules.builtin index is missing). If @state_out is non-NULL, the
+ * libkmod state actually observed is stored there so callers can avoid
+ * an extra kmod_module_get_initstate() call.
+ */
+bool __util_kmod_skip_probe_insert(struct kmod_module *module,
+				   struct log_ctx *ctx, int *state_out);
+#define util_kmod_skip_probe_insert(m, c, s)                                   \
+	__util_kmod_skip_probe_insert((m), &(c)->ctx, (s))
+
 int __util_bind(const char *devname, struct kmod_module *module, const char *bus,
 	      struct log_ctx *ctx);
 #define util_bind(n, m, b, c) __util_bind(n, m, b, &(c)->ctx)
-- 
2.50.1

