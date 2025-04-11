Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE34268C7A;
	Fri, 11 Apr 2025 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744397325; cv=none; b=XPR+WNegFTaTgmEgLTYQ7zhp30HJjZZLwvIc2/ky4I6m1+DnkSqRjWNbNmEdqfMslD0knjm0UUc85bERNxfMZrVQMHVbAJdH5vDVHB2nfNcICn00umY9tfIotj8+gKXxZkYgElebMB5AmftedRSr38KCFi0C4aJz/UVCghrBjqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744397325; c=relaxed/simple;
	bh=zGyW+tJ7qQQkDCYMjAuEix5nN0zb37lBwdL8Md1/QXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0aDNZpthKnv1mGvM9LXJ8mHX/lImImbNsCByK1j06IJxLTvQ91K13J1ikLEz8+JEu7Obm5bVBq68tALI+qBRlPQYvVRuDUxcI+w4pCjI0BYEhFIvUsuic4wF5nsPddbLi5NACyyQVlRt+rgP7/9AQe3qiCAaClqB+f8zVQ0D8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A57C4CEE2;
	Fri, 11 Apr 2025 18:48:45 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com
Subject: [NDCTL PATCH v5 3/3] cxl/test: Add test for cxl features device
Date: Fri, 11 Apr 2025 11:47:37 -0700
Message-ID: <20250411184831.2367464-4-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250411184831.2367464-1-dave.jiang@intel.com>
References: <20250411184831.2367464-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a unit test to verify the features ioctl commands. Test support added
for locating a features device, retrieve and verify the supported features
commands, retrieve specific feature command data, retrieve test feature
data, and write and verify test feature data.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v5:
- Make command prep common. (Alison)
- Rename fwctl.c to cxl-features-control.c.  (Alison)
- Update test code to retrieve cxl_fwctl object.
- Create helper for aligned allocation and zeroing. (Alison)
- Correct check of open() return value. (Alison)
---
 test/cxl-features-control.c | 439 ++++++++++++++++++++++++++++++++++++
 test/cxl-features.sh        |  31 +++
 test/cxl-topology.sh        |   4 +
 test/meson.build            |  45 ++++
 4 files changed, 519 insertions(+)
 create mode 100644 test/cxl-features-control.c
 create mode 100755 test/cxl-features.sh

diff --git a/test/cxl-features-control.c b/test/cxl-features-control.c
new file mode 100644
index 000000000000..9f2af0258a0e
--- /dev/null
+++ b/test/cxl-features-control.c
@@ -0,0 +1,439 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (C) 2024-2025 Intel Corporation. All rights reserved.
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <endian.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <cxl/libcxl.h>
+#include <cxl/features.h>
+#include <fwctl/fwctl.h>
+#include <fwctl/cxl.h>
+#include <linux/uuid.h>
+#include <uuid/uuid.h>
+#include <util/bitmap.h>
+
+static const char provider[] = "cxl_test";
+
+UUID_DEFINE(test_uuid,
+	    0xff, 0xff, 0xff, 0xff,
+	    0xff, 0xff,
+	    0xff, 0xff,
+	    0xff, 0xff,
+	    0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+);
+
+#define CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES	0x0500
+#define CXL_MBOX_OPCODE_GET_FEATURE		0x0501
+#define CXL_MBOX_OPCODE_SET_FEATURE		0x0502
+
+#define GET_FEAT_SIZE	4
+#define SET_FEAT_SIZE	4
+#define EFFECTS_MASK	(BIT(0) | BIT(9))
+
+#define MAX_TEST_FEATURES	1
+#define DEFAULT_TEST_DATA	0xdeadbeef
+#define DEFAULT_TEST_DATA2	0xabcdabcd
+
+struct test_feature {
+	uuid_t uuid;
+	size_t get_size;
+	size_t set_size;
+};
+
+static int send_command(int fd, struct fwctl_rpc *rpc, struct fwctl_rpc_cxl_out *out)
+{
+	if (ioctl(fd, FWCTL_RPC, rpc) == -1) {
+		fprintf(stderr, "RPC ioctl error: %s\n", strerror(errno));
+		return -errno;
+	}
+
+	if (out->retval) {
+		fprintf(stderr, "operation returned failure: %d\n", out->retval);
+		return -ENXIO;
+	}
+
+	return 0;
+}
+
+static int get_scope(u16 opcode)
+{
+	switch (opcode) {
+	case CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES:
+	case CXL_MBOX_OPCODE_GET_FEATURE:
+		return FWCTL_RPC_CONFIGURATION;
+	case CXL_MBOX_OPCODE_SET_FEATURE:
+		return FWCTL_RPC_DEBUG_WRITE_FULL;
+	default:
+		return -EINVAL;
+	}
+}
+
+static size_t hw_op_size(u16 opcode)
+{
+	switch (opcode) {
+	case CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES:
+		return sizeof(struct cxl_mbox_get_sup_feats_in);
+	case CXL_MBOX_OPCODE_GET_FEATURE:
+		return sizeof(struct cxl_mbox_get_feat_in);
+	case CXL_MBOX_OPCODE_SET_FEATURE:
+		return sizeof(struct cxl_mbox_set_feat_in) + sizeof(u32);
+	default:
+		return SIZE_MAX;
+	}
+}
+
+static void free_rpc(struct fwctl_rpc *rpc)
+{
+	void *in, *out;
+
+	in = (void *)rpc->in;
+	out = (void *)rpc->out;
+	free(in);
+	free(out);
+	free(rpc);
+}
+
+static void *zmalloc_aligned(size_t align, size_t size)
+{
+	void *ptr;
+	int rc;
+
+	rc = posix_memalign((void **)&ptr, align, size);
+	if (rc)
+		return NULL;
+	memset(ptr, 0, size);
+
+	return ptr;
+}
+
+static struct fwctl_rpc *get_prepped_command(size_t in_size, size_t out_size,
+					     u16 opcode)
+{
+	struct fwctl_rpc_cxl_out *out;
+	struct fwctl_rpc_cxl *in;
+	struct fwctl_rpc *rpc;
+	size_t op_size;
+	int scope;
+
+	rpc = zmalloc_aligned(16, sizeof(*rpc));
+	if (!rpc)
+		return NULL;
+
+	in = zmalloc_aligned(16, in_size);
+	if (!in)
+		goto free_rpc;
+
+	out = zmalloc_aligned(16, out_size);
+	if (!out)
+		goto free_in;
+
+	in->opcode = opcode;
+
+	op_size = hw_op_size(opcode);
+	if (op_size == SIZE_MAX)
+		goto free_in;
+
+	in->op_size = op_size;
+
+	rpc->size = sizeof(*rpc);
+	scope = get_scope(opcode);
+	if (scope < 0)
+		goto free_all;
+
+	rpc->scope = scope;
+
+	rpc->in_len = in_size;
+	rpc->out_len = out_size;
+	rpc->in = (uint64_t)(uint64_t *)in;
+	rpc->out = (uint64_t)(uint64_t *)out;
+
+	return rpc;
+
+free_all:
+	free(out);
+free_in:
+	free(in);
+free_rpc:
+	free(rpc);
+	return NULL;
+}
+
+static int cxl_fwctl_rpc_get_test_feature(int fd, struct test_feature *feat_ctx,
+					  const uint32_t expected_data)
+{
+	struct cxl_mbox_get_feat_in *feat_in;
+	struct fwctl_rpc_cxl_out *out;
+	size_t out_size, in_size;
+	struct fwctl_rpc_cxl *in;
+	struct fwctl_rpc *rpc;
+	uint32_t val;
+	void *data;
+	int rc;
+
+	in_size = sizeof(*in) + sizeof(*feat_in);
+	out_size = sizeof(*out) + feat_ctx->get_size;
+
+	rpc = get_prepped_command(in_size, out_size,
+				  CXL_MBOX_OPCODE_GET_FEATURE);
+	if (!rpc)
+		return -ENXIO;
+
+	in = (struct fwctl_rpc_cxl *)rpc->in;
+	out = (struct fwctl_rpc_cxl_out *)rpc->out;
+
+	feat_in = &in->get_feat_in;
+	uuid_copy(feat_in->uuid, feat_ctx->uuid);
+	feat_in->count = feat_ctx->get_size;
+
+	rc = send_command(fd, rpc, out);
+	if (rc)
+		goto out;
+
+	data = out->payload;
+	val = le32toh(*(__le32 *)data);
+	if (memcmp(&val, &expected_data, sizeof(val)) != 0) {
+		rc = -ENXIO;
+		goto out;
+	}
+
+out:
+	free_rpc(rpc);
+	return rc;
+}
+
+static int cxl_fwctl_rpc_set_test_feature(int fd, struct test_feature *feat_ctx)
+{
+	struct cxl_mbox_set_feat_in *feat_in;
+	struct fwctl_rpc_cxl_out *out;
+	size_t in_size, out_size;
+	struct fwctl_rpc_cxl *in;
+	struct fwctl_rpc *rpc;
+	uint32_t val;
+	void *data;
+	int rc;
+
+	in_size = sizeof(*in) + sizeof(*feat_in) + sizeof(val);
+	out_size = sizeof(*out) + sizeof(val);
+	rpc = get_prepped_command(in_size, out_size,
+				  CXL_MBOX_OPCODE_SET_FEATURE);
+	if (!rpc)
+		return -ENXIO;
+
+	in = (struct fwctl_rpc_cxl *)rpc->in;
+	out = (struct fwctl_rpc_cxl_out *)rpc->out;
+	feat_in = &in->set_feat_in;
+	uuid_copy(feat_in->uuid, feat_ctx->uuid);
+	data = feat_in->feat_data;
+	val = DEFAULT_TEST_DATA2;
+	*(uint32_t *)data = htole32(val);
+	feat_in->flags = CXL_SET_FEAT_FLAG_FULL_DATA_TRANSFER;
+
+	rc = send_command(fd, rpc, out);
+	if (rc)
+		goto out;
+
+	rc = cxl_fwctl_rpc_get_test_feature(fd, feat_ctx, DEFAULT_TEST_DATA2);
+	if (rc) {
+		fprintf(stderr, "Failed ioctl to get feature verify: %d\n", rc);
+		goto out;
+	}
+
+out:
+	free_rpc(rpc);
+	return rc;
+}
+
+static int cxl_fwctl_rpc_get_supported_features(int fd, struct test_feature *feat_ctx)
+{
+	struct cxl_mbox_get_sup_feats_out *feat_out;
+	struct cxl_mbox_get_sup_feats_in *feat_in;
+	struct fwctl_rpc_cxl_out *out;
+	struct cxl_feat_entry *entry;
+	size_t out_size, in_size;
+	struct fwctl_rpc_cxl *in;
+	struct fwctl_rpc *rpc;
+	int feats, rc;
+
+	in_size = sizeof(*in) + sizeof(*feat_in);
+	out_size = sizeof(*out) + sizeof(*feat_out);
+	/* First query, to get number of features w/o per feature data */
+	rpc = get_prepped_command(in_size, out_size,
+				  CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES);
+	if (!rpc)
+		return -ENXIO;
+
+	/* No need to fill in feat_in first go as we are passing in all 0's */
+
+	out = (struct fwctl_rpc_cxl_out *)rpc->out;
+	rc = send_command(fd, rpc, out);
+	if (rc)
+		goto out;
+
+	feat_out = &out->get_sup_feats_out;
+	feats = le16toh(feat_out->supported_feats);
+	if (feats != MAX_TEST_FEATURES) {
+		fprintf(stderr, "Test device has greater than %d test features.\n",
+			MAX_TEST_FEATURES);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	free_rpc(rpc);
+
+	/* Going second round to retrieve each feature details */
+	in_size = sizeof(*in) + sizeof(*feat_in);
+	out_size = sizeof(*out) + sizeof(*feat_out);
+	out_size += feats * sizeof(*entry);
+	rpc = get_prepped_command(in_size, out_size,
+				  CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES);
+	if (!rpc)
+		return -ENXIO;
+
+	in = (struct fwctl_rpc_cxl *)rpc->in;
+	out = (struct fwctl_rpc_cxl_out *)rpc->out;
+	feat_in = &in->get_sup_feats_in;
+	feat_in->count = htole32(feats * sizeof(*entry));
+
+	rc = send_command(fd, rpc, out);
+	if (rc)
+		goto out;
+
+	feat_out = &out->get_sup_feats_out;
+	feats = le16toh(feat_out->supported_feats);
+	if (feats != MAX_TEST_FEATURES) {
+		fprintf(stderr, "Test device has greater than %u test features.\n",
+			MAX_TEST_FEATURES);
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (le16toh(feat_out->num_entries) != MAX_TEST_FEATURES) {
+		fprintf(stderr, "Test device did not return expected entries. %u\n",
+			le16toh(feat_out->num_entries));
+		rc = -ENXIO;
+		goto out;
+	}
+
+	entry = &feat_out->ents[0];
+	if (uuid_compare(test_uuid, entry->uuid) != 0) {
+		fprintf(stderr, "Test device did not export expected test feature.\n");
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (le16toh(entry->get_feat_size) != GET_FEAT_SIZE ||
+	    le16toh(entry->set_feat_size) != SET_FEAT_SIZE) {
+		fprintf(stderr, "Test device feature in/out size incorrect.\n");
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (le16toh(entry->effects) != EFFECTS_MASK) {
+		fprintf(stderr, "Test device set effects incorrect\n");
+		rc = -ENXIO;
+		goto out;
+	}
+
+	uuid_copy(feat_ctx->uuid, entry->uuid);
+	feat_ctx->get_size = le16toh(entry->get_feat_size);
+	feat_ctx->set_size = le16toh(entry->set_feat_size);
+
+out:
+	free_rpc(rpc);
+	return rc;
+}
+
+static int test_fwctl_features(struct cxl_memdev *memdev)
+{
+	struct test_feature feat_ctx;
+	unsigned int major, minor;
+	struct cxl_fwctl *fwctl;
+	int fd, rc;
+	char path[256];
+
+	fwctl = cxl_memdev_get_fwctl(memdev);
+	if (!fwctl)
+		return -ENODEV;
+
+	major = cxl_fwctl_get_major(fwctl);
+	minor = cxl_fwctl_get_minor(fwctl);
+
+	if (!major && !minor)
+		return -ENODEV;
+
+	sprintf(path, "/dev/char/%d:%d", major, minor);
+
+	fd = open(path, O_RDONLY, 0644);
+	if (fd < 0) {
+		fprintf(stderr, "Failed to open: %d\n", -errno);
+		return -errno;
+	}
+
+	rc = cxl_fwctl_rpc_get_supported_features(fd, &feat_ctx);
+	if (rc) {
+		fprintf(stderr, "Failed ioctl to get supported features: %d\n", rc);
+		goto out;
+	}
+
+	rc = cxl_fwctl_rpc_get_test_feature(fd, &feat_ctx, DEFAULT_TEST_DATA);
+	if (rc) {
+		fprintf(stderr, "Failed ioctl to get feature: %d\n", rc);
+		goto out;
+	}
+
+	rc = cxl_fwctl_rpc_set_test_feature(fd, &feat_ctx);
+	if (rc) {
+		fprintf(stderr, "Failed ioctl to set feature: %d\n", rc);
+		goto out;
+	}
+
+out:
+	close(fd);
+	return rc;
+}
+
+static int test_fwctl(struct cxl_ctx *ctx, struct cxl_bus *bus)
+{
+	struct cxl_memdev *memdev;
+
+	cxl_memdev_foreach(ctx, memdev) {
+		if (cxl_memdev_get_bus(memdev) != bus)
+			continue;
+		return test_fwctl_features(memdev);
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct cxl_ctx *ctx;
+	struct cxl_bus *bus;
+	int rc;
+
+	rc = cxl_new(&ctx);
+	if (rc < 0)
+		return rc;
+
+	cxl_set_log_priority(ctx, LOG_DEBUG);
+
+	bus = cxl_bus_get_by_provider(ctx, provider);
+	if (!bus) {
+		fprintf(stderr, "%s: unable to find bus (%s)\n",
+			argv[0], provider);
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = test_fwctl(ctx, bus);
+
+out:
+	cxl_unref(ctx);
+	return rc;
+}
diff --git a/test/cxl-features.sh b/test/cxl-features.sh
new file mode 100755
index 000000000000..e648242a4a01
--- /dev/null
+++ b/test/cxl-features.sh
@@ -0,0 +1,31 @@
+#!/bin/bash -Ex
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2025 Intel Corporation. All rights reserved.
+
+rc=77
+# 237 is -ENODEV
+ERR_NODEV=237
+
+. $(dirname $0)/common
+FEATURES="$TEST_PATH"/cxl-features-control
+
+trap 'err $LINENO' ERR
+
+modprobe cxl_test
+
+test -x "$FEATURES" || do_skip "no CXL Features Contrl"
+# disable trap
+trap - $(compgen -A signal)
+"$FEATURES"
+rc=$?
+
+echo "error: $rc"
+if [ "$rc" -eq "$ERR_NODEV" ]; then
+	do_skip "no CXL FWCTL char dev"
+elif [ "$rc" -ne 0 ]; then
+	echo "fail: $LINENO" && exit 1
+fi
+
+trap 'err $LINENO' ERR
+
+_cxl_cleanup
diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index e8b9f56543b5..90b9c98273db 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -172,11 +172,15 @@ done
 # validate host bridge tear down for the first 2 bridges
 for b in ${bridge[0]} ${bridge[1]}
 do
+	echo "XXX SHELL disable port $b to validate teardown" > /dev/kmsg
+
 	$CXL disable-port $b -f
 	json=$($CXL list -M -i -p $b)
 	count=$(jq "map(select(.state == \"disabled\")) | length" <<< $json)
 	((count == 4)) || err "$LINENO"
 
+	echo "XXX SHELL enable port $b to validate teardown" > /dev/kmsg
+
 	$CXL enable-port $b -m
 	json=$($CXL list -M -p $b)
 	count=$(jq "length" <<< $json)
diff --git a/test/meson.build b/test/meson.build
index d871e28e17ce..89e73c2575f6 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -17,6 +17,13 @@ ndctl_deps = libndctl_deps + [
   versiondep,
 ]
 
+libcxl_deps = [
+  cxl_dep,
+  ndctl_dep,
+  uuid,
+  kmod,
+]
+
 libndctl = executable('libndctl', testcore + [ 'libndctl.c'],
   dependencies : libndctl_deps,
   include_directories : root_inc,
@@ -130,6 +137,33 @@ revoke_devmem = executable('revoke_devmem', testcore + [
   include_directories : root_inc,
 )
 
+fs = import('fs')
+
+feature_hdrs = [
+  '/usr/include/cxl/features.h',
+  '/usr/include/fwctl/cxl.h',
+  '/usr/include/fwctl/fwctl.h',
+]
+
+feat_hdrs_exist = true
+foreach file : feature_hdrs
+  if not fs.exists(file)
+    feat_hdrs_exist = false
+    break
+  endif
+endforeach
+
+if feat_hdrs_exist
+    features = executable('cxl-features-control', [
+        'cxl-features-control.c',
+    ],
+    include_directories : root_inc,
+    dependencies : libcxl_deps,
+    )
+else
+    features = []
+endif
+
 mmap = executable('mmap', 'mmap.c',)
 
 create = find_program('create.sh')
@@ -162,6 +196,10 @@ cxl_destroy_region = find_program('cxl-destroy-region.sh')
 cxl_qos_class = find_program('cxl-qos-class.sh')
 cxl_poison = find_program('cxl-poison.sh')
 
+if feat_hdrs_exist
+  cxl_features = find_program('cxl-features.sh')
+endif
+
 tests = [
   [ 'libndctl',               libndctl,		  'ndctl' ],
   [ 'dsm-fail',               dsm_fail,	      	  'ndctl' ],
@@ -196,6 +234,12 @@ tests = [
   [ 'cxl-poison.sh',          cxl_poison,         'cxl'   ],
 ]
 
+if feat_hdrs_exist
+  tests += [
+    [ 'cxl-features.sh',        cxl_features,       'cxl'   ],
+  ]
+endif
+
 if get_option('destructive').enabled()
   sub_section = find_program('sub-section.sh')
   dax_ext4 = find_program('dax-ext4.sh')
@@ -249,6 +293,7 @@ foreach t : tests
       daxdev_errors,
       dax_dev,
       mmap,
+      features,
     ],
     suite: t[2],
     timeout : 600,
-- 
2.49.0

