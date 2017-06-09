Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CC7F921A143FE
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 22:33:05 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, namespace: add ndctl_namespace_{set,
 get}_enforce_mode() support
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 08 Jun 2017 22:27:49 -0700
Message-ID: <149698606929.12023.14261270406248582937.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The v1.2 namespace label specification includes an 'abstraction_guid' to
identify that a custom protocol is needed to access a namespace beyond
the base access mechanism (pmem vs blk-aperture). Previously these
custom protocols were discovered by probing for an info block at a
pre-defined location. Now, with this guid, the info block to probe and
the expected protocol to load can be hinted by the guid. This helps
prevent inadvertent access when an info block becomes corrupted or when
a given environment goes not have support for the protocol identified by
the guid.

The kernel's new 'holder_class' attribute is independent of the label
format and enables limiting the claim type for a namespace. For example,
setting holder_class to 'btt' prevents 'dax' and 'pfn' instances from
attaching to a namespace. In the v1.2 label case this setting is
persisted in the label, in the v1.1 label case this setting is
ephemeral / lost when the driver is unloaded.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c   |   59 ++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym |    2 ++
 ndctl/libndctl.h.in    |    7 ++++--
 ndctl/namespace.c      |   11 +++++++++
 test/libndctl.c        |   51 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 128 insertions(+), 2 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 4acebc05d6db..e0b49615aa88 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -268,6 +268,7 @@ struct ndctl_namespace {
 	int type, id, buf_len, raw_mode;
 	int generation;
 	unsigned long long resource, size;
+	enum ndctl_namespace_mode enforce_mode;
 	char *alt_name;
 	uuid_t uuid;
 	struct ndctl_lbasize lbasize;
@@ -2858,6 +2859,31 @@ static char *get_block_device(struct ndctl_ctx *ctx, const char *block_path)
 static int parse_lbasize_supported(struct ndctl_ctx *ctx, const char *devname,
 		const char *buf, struct ndctl_lbasize *lba);
 
+static const char *enforce_id_to_name(enum ndctl_namespace_mode mode)
+{
+	static const char *id_to_name[] = {
+		[NDCTL_NS_MODE_MEMORY] = "pfn",
+		[NDCTL_NS_MODE_SAFE] = "btt", /* TODO: convert to btt2 */
+		[NDCTL_NS_MODE_RAW] = "",
+		[NDCTL_NS_MODE_DAX] = "dax",
+		[NDCTL_NS_MODE_UNKNOWN] = "<unknown>",
+	};
+
+	if (mode < NDCTL_NS_MODE_UNKNOWN && mode >= 0)
+		return id_to_name[mode];
+	return id_to_name[NDCTL_NS_MODE_UNKNOWN];
+}
+
+static enum ndctl_namespace_mode enforce_name_to_id(const char *name)
+{
+	int i;
+
+	for (i = 0; i < NDCTL_NS_MODE_UNKNOWN; i++)
+		if (strcmp(enforce_id_to_name(i), name) == 0)
+			return i;
+	return NDCTL_NS_MODE_UNKNOWN;
+}
+
 static void *add_namespace(void *parent, int id, const char *ndns_base)
 {
 	const char *devname = devpath_to_devname(ndns_base);
@@ -2903,6 +2929,10 @@ static void *add_namespace(void *parent, int id, const char *ndns_base)
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		ndns->numa_node = strtol(buf, NULL, 0);
 
+	sprintf(path, "%s/holder_class", ndns_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		ndns->enforce_mode = enforce_name_to_id(buf);
+
 	switch (ndns->type) {
 	case ND_DEVICE_NAMESPACE_BLK:
 		sprintf(path, "%s/sector_size", ndns_base);
@@ -3150,6 +3180,35 @@ NDCTL_EXPORT enum ndctl_namespace_mode ndctl_namespace_get_mode(
 	return -ENXIO;
 }
 
+NDCTL_EXPORT enum ndctl_namespace_mode ndctl_namespace_get_enforce_mode(
+		struct ndctl_namespace *ndns)
+{
+	return ndns->enforce_mode;
+}
+
+NDCTL_EXPORT int ndctl_namespace_set_enforce_mode(struct ndctl_namespace *ndns,
+		enum ndctl_namespace_mode mode)
+{
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	char *path = ndns->ndns_buf;
+	int len = ndns->buf_len;
+	int rc;
+
+	if (mode < 0 || mode >= NDCTL_NS_MODE_UNKNOWN)
+		return -EINVAL;
+
+	if (snprintf(path, len, "%s/holder_class", ndns->ndns_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_namespace_get_devname(ndns));
+		return -ENOMEM;
+	}
+
+	rc = sysfs_write_attr(ctx, path, enforce_id_to_name(mode));
+	if (rc >= 0)
+		ndns->enforce_mode = mode;
+	return rc;
+}
+
 NDCTL_EXPORT int ndctl_namespace_is_valid(struct ndctl_namespace *ndns)
 {
 	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 9bc36a37a813..0e592435ff70 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -169,6 +169,8 @@ global:
 	ndctl_namespace_get_devname;
 	ndctl_namespace_get_block_device;
 	ndctl_namespace_get_mode;
+	ndctl_namespace_set_enforce_mode;
+	ndctl_namespace_get_enforce_mode;
 	ndctl_region_get_nstype;
 	ndctl_namespace_get_type;
 	ndctl_namespace_get_type_name;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 2c45d2daa81b..3943ad240062 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -489,10 +489,14 @@ enum ndctl_namespace_mode {
 	NDCTL_NS_MODE_SAFE,
 	NDCTL_NS_MODE_RAW,
 	NDCTL_NS_MODE_DAX,
-	NDCTL_NS_MODE_UNKNOWN,
+	NDCTL_NS_MODE_UNKNOWN, /* must be last entry */
 };
 enum ndctl_namespace_mode ndctl_namespace_get_mode(
 		struct ndctl_namespace *ndns);
+enum ndctl_namespace_mode ndctl_namespace_get_enforce_mode(
+		struct ndctl_namespace *ndns);
+int ndctl_namespace_set_enforce_mode(struct ndctl_namespace *ndns,
+		enum ndctl_namespace_mode mode);
 int ndctl_namespace_is_enabled(struct ndctl_namespace *ndns);
 int ndctl_namespace_enable(struct ndctl_namespace *ndns);
 int ndctl_namespace_disable(struct ndctl_namespace *ndns);
@@ -520,7 +524,6 @@ int ndctl_namespace_set_sector_size(struct ndctl_namespace *ndns,
 int ndctl_namespace_get_raw_mode(struct ndctl_namespace *ndns);
 int ndctl_namespace_set_raw_mode(struct ndctl_namespace *ndns, int raw_mode);
 int ndctl_namespace_get_numa_node(struct ndctl_namespace *ndns);
-
 struct ndctl_btt;
 struct ndctl_btt *ndctl_btt_get_first(struct ndctl_region *region);
 struct ndctl_btt *ndctl_btt_get_next(struct ndctl_btt *btt);
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 895e39bb8c7d..8f264c348f51 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -360,6 +360,15 @@ static int setup_namespace(struct ndctl_region *region,
 		try(ndctl_namespace, set_sector_size, ndns, p->sector_size);
 
 	uuid_generate(uuid);
+
+	/*
+	 * Note, this call to ndctl_namespace_set_mode() is not error
+	 * checked since kernels older than 4.13 do not support this
+	 * property of namespaces and it is an opportunistic enforcement
+	 * mechanism.
+	 */
+	ndctl_namespace_set_enforce_mode(ndns, p->mode);
+
 	if (do_setup_pfn(ndns, p)) {
 		struct ndctl_pfn *pfn = ndctl_region_get_pfn_seed(region);
 
@@ -780,6 +789,8 @@ static int namespace_destroy(struct ndctl_region *region,
 			return rc;
 	}
 
+	ndctl_namespace_set_enforce_mode(ndns, NDCTL_NS_MODE_RAW);
+
 	if (pfn || btt || dax) {
 		rc = zero_info_block(ndns);
 		if (rc)
diff --git a/test/libndctl.c b/test/libndctl.c
index 0381ee2cdefb..24aff36fef62 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -736,6 +736,8 @@ static int __check_dax_create(struct ndctl_region *region,
 		enum ndctl_pfn_loc loc, uuid_t uuid)
 {
 	struct ndctl_dax *dax_seed = ndctl_region_get_dax_seed(region);
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	struct ndctl_test *test = ndctl_get_private_data(ctx);
 	enum ndctl_namespace_mode mode;
 	struct ndctl_dax *dax;
 	const char *devname;
@@ -753,6 +755,12 @@ static int __check_dax_create(struct ndctl_region *region,
 	 * alignment is PAGE_SIZE
 	 */
 	ndctl_dax_set_align(dax, SZ_4K);
+
+	rc = ndctl_namespace_set_enforce_mode(ndns, NDCTL_NS_MODE_DAX);
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0)) && rc < 0) {
+		fprintf(stderr, "%s: failed to enforce dax mode\n", devname);
+		return rc;
+	}
 	ndctl_dax_set_namespace(dax, ndns);
 	rc = ndctl_dax_enable(dax);
 	if (rc) {
@@ -838,6 +846,8 @@ static int __check_pfn_create(struct ndctl_region *region,
 		void *buf, enum ndctl_pfn_loc loc, uuid_t uuid)
 {
 	struct ndctl_pfn *pfn_seed = ndctl_region_get_pfn_seed(region);
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	struct ndctl_test *test = ndctl_get_private_data(ctx);
 	enum ndctl_namespace_mode mode;
 	struct ndctl_pfn *pfn;
 	const char *devname;
@@ -857,6 +867,11 @@ static int __check_pfn_create(struct ndctl_region *region,
 	 * alignment is PAGE_SIZE
 	 */
 	ndctl_pfn_set_align(pfn, SZ_4K);
+	rc = ndctl_namespace_set_enforce_mode(ndns, NDCTL_NS_MODE_MEMORY);
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0)) && rc < 0) {
+		fprintf(stderr, "%s: failed to enforce pfn mode\n", devname);
+		return rc;
+	}
 	ndctl_pfn_set_namespace(pfn, ndns);
 	rc = ndctl_pfn_enable(pfn);
 	if (rc) {
@@ -1067,6 +1082,12 @@ static int check_btt_create(struct ndctl_region *region, struct ndctl_namespace
 		devname = ndctl_btt_get_devname(btt);
 		ndctl_btt_set_uuid(btt, btt_s->uuid);
 		ndctl_btt_set_sector_size(btt, btt_s->sector_sizes[i]);
+		rc = ndctl_namespace_set_enforce_mode(ndns, NDCTL_NS_MODE_SAFE);
+		if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0)) && rc < 0) {
+			fprintf(stderr, "%s: failed to enforce btt mode\n", devname);
+			goto err;
+		}
+
 		ndctl_btt_set_namespace(btt, ndns);
 		rc = ndctl_btt_enable(btt);
 		if (namespace->ro == (rc == 0)) {
@@ -1237,9 +1258,12 @@ static int check_pfn_autodetect(struct ndctl_bus *bus,
 		struct namespace *namespace)
 {
 	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
 	const char *devname = ndctl_namespace_get_devname(ndns);
+	struct ndctl_test *test = ndctl_get_private_data(ctx);
 	struct pfn *auto_pfn = namespace->pfn_settings;
 	struct ndctl_pfn *pfn, *found = NULL;
+	enum ndctl_namespace_mode mode;
 	ssize_t rc = -ENXIO;
 	char bdev[50];
 	int fd, ro;
@@ -1265,6 +1289,13 @@ static int check_pfn_autodetect(struct ndctl_bus *bus,
 	if (!found)
 		return -ENXIO;
 
+	mode = ndctl_namespace_get_enforce_mode(ndns);
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0))
+			&& mode != NDCTL_NS_MODE_MEMORY) {
+		fprintf(stderr, "%s expected enforce_mode pfn\n", devname);
+		return -ENXIO;
+	}
+
 	sprintf(bdev, "/dev/%s", ndctl_pfn_get_block_device(pfn));
 	fd = open(bdev, O_RDONLY);
 	if (fd < 0)
@@ -1324,9 +1355,12 @@ static int check_dax_autodetect(struct ndctl_bus *bus,
 		struct namespace *namespace)
 {
 	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
 	const char *devname = ndctl_namespace_get_devname(ndns);
+	struct ndctl_test *test = ndctl_get_private_data(ctx);
 	struct dax *auto_dax = namespace->dax_settings;
 	struct ndctl_dax *dax, *found = NULL;
+	enum ndctl_namespace_mode mode;
 	ssize_t rc = -ENXIO;
 	char bdev[50];
 	int fd;
@@ -1352,6 +1386,13 @@ static int check_dax_autodetect(struct ndctl_bus *bus,
 	if (!found)
 		return -ENXIO;
 
+	mode = ndctl_namespace_get_enforce_mode(ndns);
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0))
+			&& mode != NDCTL_NS_MODE_DAX) {
+		fprintf(stderr, "%s expected enforce_mode dax\n", devname);
+		return -ENXIO;
+	}
+
 	rc = validate_dax(dax);
 	if (rc) {
 		fprintf(stderr, "%s: %s validate_dax failed\n", __func__,
@@ -1399,9 +1440,12 @@ static int check_btt_autodetect(struct ndctl_bus *bus,
 		struct namespace *namespace)
 {
 	struct ndctl_region *region = ndctl_namespace_get_region(ndns);
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
 	const char *devname = ndctl_namespace_get_devname(ndns);
+	struct ndctl_test *test = ndctl_get_private_data(ctx);
 	struct btt *auto_btt = namespace->btt_settings;
 	struct ndctl_btt *btt, *found = NULL;
+	enum ndctl_namespace_mode mode;
 	ssize_t rc = -ENXIO;
 	char bdev[50];
 	int fd, ro;
@@ -1427,6 +1471,13 @@ static int check_btt_autodetect(struct ndctl_bus *bus,
 	if (!found)
 		return -ENXIO;
 
+	mode = ndctl_namespace_get_enforce_mode(ndns);
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 13, 0))
+			&& mode != NDCTL_NS_MODE_SAFE) {
+		fprintf(stderr, "%s expected enforce_mode btt\n", devname);
+		return -ENXIO;
+	}
+
 	sprintf(bdev, "/dev/%s", ndctl_btt_get_block_device(btt));
 	fd = open(bdev, O_RDONLY);
 	if (fd < 0)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
