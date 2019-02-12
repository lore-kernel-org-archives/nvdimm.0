Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7BECC21A134A1
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 13:41:47 -0800 (PST)
Subject: [ndctl PATCH 4/8] ndctl/namespace: Add read-info-block command
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 12 Feb 2019 13:29:09 -0800
Message-ID: <155000694931.348282.10012437535725994854.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155000692826.348282.2795434657787204298.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Namespaces may contain an info-block that correlates with the possible
modes of a namespace: 'sector', 'fsdax', or 'devdax'. Provide a command
that can temporarily convert the namespace into 'raw' mode to read the
info-block.

Also, similar to 'read-labels' provide a facility to decode the
info-block into json.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/action.h    |    1 
 ndctl/builtin.h   |    1 
 ndctl/check.c     |   20 ---
 ndctl/namespace.c |  401 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/namespace.h |   51 +++++++
 ndctl/ndctl.c     |    1 
 util/fletcher.h   |    1 
 util/size.h       |    1 
 8 files changed, 456 insertions(+), 21 deletions(-)

diff --git a/ndctl/action.h b/ndctl/action.h
index 1ecad49530d5..01cfce511250 100644
--- a/ndctl/action.h
+++ b/ndctl/action.h
@@ -13,5 +13,6 @@ enum device_action {
 	ACTION_CHECK,
 	ACTION_WAIT,
 	ACTION_START,
+	ACTION_READ_INFOBLOCK,
 };
 #endif /* __NDCTL_ACTION_H__ */
diff --git a/ndctl/builtin.h b/ndctl/builtin.h
index 681a69ff3770..985b7937d884 100644
--- a/ndctl/builtin.h
+++ b/ndctl/builtin.h
@@ -8,6 +8,7 @@ int cmd_create_nfit(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_enable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_create_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_destroy_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
+int cmd_read_infoblock(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_disable_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_check_namespace(int argc, const char **argv, struct ndctl_ctx *ctx);
 int cmd_enable_region(int argc, const char **argv, struct ndctl_ctx *ctx);
diff --git a/ndctl/check.c b/ndctl/check.c
index 8a7125053865..3b384c091af5 100644
--- a/ndctl/check.c
+++ b/ndctl/check.c
@@ -297,24 +297,6 @@ static int btt_log_read(struct arena_info *a, u32 lane, struct log_entry *ent)
 	return 0;
 }
 
-static int btt_checksum_verify(struct btt_sb *btt_sb)
-{
-	uint64_t sum;
-	le64 sum_save;
-
-	BUILD_BUG_ON(sizeof(struct btt_sb) != SZ_4K);
-
-	sum_save = btt_sb->checksum;
-	btt_sb->checksum = 0;
-	sum = fletcher64(btt_sb, sizeof(*btt_sb), 1);
-	if (sum != sum_save)
-		return 1;
-	/* restore the checksum in the buffer */
-	btt_sb->checksum = sum_save;
-
-	return 0;
-}
-
 /*
  * Never pass a mmapped buffer to this as it will attempt to write to
  * the buffer, and we want writes to only happened in a controlled fashion.
@@ -330,7 +312,7 @@ static int btt_info_verify(struct btt_chk *bttc, struct btt_sb *btt_sb)
 		if (uuid_compare(bttc->parent_uuid, btt_sb->parent_uuid) != 0)
 			return -ENXIO;
 
-	if (btt_checksum_verify(btt_sb))
+	if (!verify_infoblock_checksum((union info_block *) btt_sb))
 		return -ENXIO;
 
 	return 0;
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 03d805a69ce4..6e42acb695aa 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -21,6 +21,7 @@
 
 #include <ndctl.h>
 #include "action.h"
+#include "namespace.h"
 #include <sys/stat.h>
 #include <uuid/uuid.h>
 #include <sys/types.h>
@@ -40,6 +41,9 @@ static struct parameters {
 	bool do_scan;
 	bool mode_default;
 	bool autolabel;
+	bool no_verify;
+	bool human;
+	bool json;
 	const char *bus;
 	const char *map;
 	const char *type;
@@ -51,6 +55,8 @@ static struct parameters {
 	const char *reconfig;
 	const char *sector_size;
 	const char *align;
+	const char *outfile;
+	const char *infile;
 } param = {
 	.autolabel = true,
 };
@@ -79,6 +85,13 @@ struct parsed_parameters {
 	bool autolabel;
 };
 
+#define pr_verbose(fmt, ...) \
+	({if (verbose) { \
+		fprintf(stderr, fmt, ##__VA_ARGS__); \
+	} else { \
+		do { } while (0); \
+	}})
+
 #define debug(fmt, ...) \
 	({if (verbose) { \
 		fprintf(stderr, "%s:%d: " fmt, __func__, __LINE__, ##__VA_ARGS__); \
@@ -120,6 +133,16 @@ OPT_BOOLEAN('R', "repair", &repair, "perform metadata repairs"), \
 OPT_BOOLEAN('L', "rewrite-log", &logfix, "regenerate the log"), \
 OPT_BOOLEAN('f', "force", &force, "check namespace even if currently active")
 
+#define READ_INFOBLOCK_OPTIONS() \
+OPT_FILENAME('o', "output", &param.outfile, "output-file", \
+	"filename to write label area contents"), \
+OPT_FILENAME('f', "file", &param.infile, "input-file", \
+	"filename to readinfo block instead of a namespace"), \
+OPT_BOOLEAN('n', "no-verify", &param.no_verify, \
+	"skip parent uuid, and checksum validation"), \
+OPT_BOOLEAN('j', "json", &param.json, "parse label data into json"), \
+OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats ")
+
 static const struct option base_options[] = {
 	BASE_OPTIONS(),
 	OPT_END(),
@@ -144,6 +167,12 @@ static const struct option check_options[] = {
 	OPT_END(),
 };
 
+static const struct option read_infoblock_options[] = {
+	BASE_OPTIONS(),
+	READ_INFOBLOCK_OPTIONS(),
+	OPT_END(),
+};
+
 static int set_defaults(enum device_action mode)
 {
 	int rc = 0;
@@ -285,18 +314,30 @@ static const char *parse_namespace_options(int argc, const char **argv,
 			case ACTION_CHECK:
 				action_string = "check";
 				break;
+			case ACTION_READ_INFOBLOCK:
+				action_string = "read-infoblock";
+				break;
 			default:
 				action_string = "<>";
 				break;
 		}
-		error("specify a namespace to %s, or \"all\"\n", action_string);
-		rc = -EINVAL;
+
+		if ((mode == ACTION_READ_INFOBLOCK && !param.infile)
+				|| mode != ACTION_READ_INFOBLOCK) {
+			error("specify a namespace to %s, or \"all\"\n", action_string);
+			rc = -EINVAL;
+		}
 	}
 	for (i = mode == ACTION_CREATE ? 0 : 1; i < argc; i++) {
 		error("unknown extra parameter \"%s\"\n", argv[i]);
 		rc = -EINVAL;
 	}
 
+	if (mode == ACTION_READ_INFOBLOCK && param.infile && argc) {
+		error("specify a namespace, or --file, not both\n");
+		rc = -EINVAL;
+	}
+
 	if (rc) {
 		usage_with_options(u, options);
 		return NULL; /* we won't return from usage_with_options() */
@@ -1051,10 +1092,319 @@ static int namespace_reconfig(struct ndctl_region *region,
 int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
 		bool repair, bool logfix);
 
+struct read_infoblock_ctx {
+	struct json_object *jblocks;
+	FILE *f_out;
+};
+
+#define parse_field(sb, field)						\
+	jobj = json_object_new_int(le32_to_cpu((sb)->field));		\
+	if (!jobj)							\
+		goto err;						\
+	json_object_object_add(jblock, #field, jobj);
+
+#define parse_hex(sb, field, sz)						\
+	jobj = util_json_object_hex(le##sz##_to_cpu((sb)->field), flags);	\
+	if (!jobj)								\
+		goto err;							\
+	json_object_object_add(jblock, #field, jobj);
+
+
+static json_object *btt_parse(struct btt_sb *btt_sb, struct ndctl_namespace *ndns,
+		const char *path, unsigned long flags)
+{
+	uuid_t uuid;
+	char str[40];
+	struct json_object *jblock, *jobj;
+	const char *cmd = "read-info-block";
+	const bool verify = !param.no_verify;
+
+	if (verify && !verify_infoblock_checksum((union info_block *) btt_sb)) {
+		pr_verbose("%s: %s checksum verification failed\n", cmd, __func__);
+		return NULL;
+	}
+
+	if (ndns) {
+		ndctl_namespace_get_uuid(ndns, uuid);
+		if (verify && !uuid_is_null(uuid) && memcmp(uuid, btt_sb->parent_uuid,
+					sizeof(uuid) != 0)) {
+			pr_verbose("%s: %s uuid verification failed\n", cmd, __func__);
+			return NULL;
+		}
+	}
+
+	jblock = json_object_new_object();
+	if (!jblock)
+		return NULL;
+
+	if (ndns) {
+		jobj = json_object_new_string(ndctl_namespace_get_devname(ndns));
+		if (!jobj)
+			goto err;
+		json_object_object_add(jblock, "dev", jobj);
+	} else {
+		jobj = json_object_new_string(path);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jblock, "file", jobj);
+	}
+
+	jobj = json_object_new_string((char *) btt_sb->signature);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jblock, "signature", jobj);
+
+	uuid_unparse((void *) btt_sb->uuid, str);
+	jobj = json_object_new_string(str);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jblock, "uuid", jobj);
+
+	uuid_unparse((void *) btt_sb->parent_uuid, str);
+	jobj = json_object_new_string(str);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jblock, "parent_uuid", jobj);
+
+	jobj = util_json_object_hex(le32_to_cpu(btt_sb->flags), flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jblock, "flags", jobj);
+
+	if (snprintf(str, 4, "%d.%d", btt_sb->version_major,
+				btt_sb->version_minor) >= 4)
+		goto err;
+	jobj = json_object_new_string(str);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jblock, "version", jobj);
+
+	parse_field(btt_sb, external_lbasize);
+	parse_field(btt_sb, external_nlba);
+	parse_field(btt_sb, internal_lbasize);
+	parse_field(btt_sb, internal_nlba);
+	parse_field(btt_sb, nfree);
+	parse_field(btt_sb, infosize);
+	parse_hex(btt_sb, nextoff, 64);
+	parse_hex(btt_sb, dataoff, 64);
+	parse_hex(btt_sb, mapoff, 64);
+	parse_hex(btt_sb, logoff, 64);
+	parse_hex(btt_sb, info2off, 64);
+
+	return jblock;
+err:
+	pr_verbose("%s: failed to create json representation\n", cmd);
+	json_object_put(jblock);
+	return NULL;
+}
+
+static json_object *pfn_parse(struct pfn_sb *pfn_sb, struct ndctl_namespace *ndns,
+		const char *path, unsigned long flags)
+{
+	uuid_t uuid;
+	char str[40];
+	struct json_object *jblock, *jobj;
+	const char *cmd = "read-info-block";
+	const bool verify = !param.no_verify;
+
+	if (verify && !verify_infoblock_checksum((union info_block *) pfn_sb)) {
+		pr_verbose("%s: %s checksum verification failed\n", cmd, __func__);
+		return NULL;
+	}
+
+	if (ndns) {
+		ndctl_namespace_get_uuid(ndns, uuid);
+		if (verify && !uuid_is_null(uuid) && memcmp(uuid, pfn_sb->parent_uuid,
+					sizeof(uuid) != 0)) {
+			pr_verbose("%s: %s uuid verification failed\n", cmd, __func__);
+			return NULL;
+		}
+	}
+
+	jblock = json_object_new_object();
+	if (!jblock)
+		return NULL;
+
+	if (ndns) {
+		jobj = json_object_new_string(ndctl_namespace_get_devname(ndns));
+		if (!jobj)
+			goto err;
+		json_object_object_add(jblock, "dev", jobj);
+	} else {
+		jobj = json_object_new_string(path);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jblock, "file", jobj);
+	}
+
+	jobj = json_object_new_string((char *) pfn_sb->signature);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jblock, "signature", jobj);
+
+	uuid_unparse((void *) pfn_sb->uuid, str);
+	jobj = json_object_new_string(str);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jblock, "uuid", jobj);
+
+	uuid_unparse((void *) pfn_sb->parent_uuid, str);
+	jobj = json_object_new_string(str);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jblock, "parent_uuid", jobj);
+
+	jobj = util_json_object_hex(le32_to_cpu(pfn_sb->flags), flags);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jblock, "flags", jobj);
+
+	if (snprintf(str, 4, "%d.%d", pfn_sb->version_major,
+				pfn_sb->version_minor) >= 4)
+		goto err;
+	jobj = json_object_new_string(str);
+	if (!jobj)
+		goto err;
+	json_object_object_add(jblock, "version", jobj);
+
+	parse_hex(pfn_sb, dataoff, 64);
+	parse_hex(pfn_sb, npfns, 64);
+	parse_field(pfn_sb, mode);
+	parse_hex(pfn_sb, start_pad, 32);
+	parse_hex(pfn_sb, end_trunc, 32);
+	parse_hex(pfn_sb, align, 32);
+
+	return jblock;
+err:
+	pr_verbose("%s: failed to create json representation\n", cmd);
+	json_object_put(jblock);
+	return NULL;
+}
+
+#define INFOBLOCK_SZ SZ_8K
+
+static int parse_namespace_infoblock(char *_buf, struct ndctl_namespace *ndns,
+		const char *path, struct read_infoblock_ctx *ri_ctx)
+{
+	int rc;
+	void *buf = _buf;
+	unsigned long flags = param.human ? UTIL_JSON_HUMAN : 0;
+	struct btt_sb *btt1_sb = buf + SZ_4K, *btt2_sb = buf;
+	struct json_object *jblock = NULL, *jblocks = ri_ctx->jblocks;
+	struct pfn_sb *pfn_sb = buf + SZ_4K, *dax_sb = buf + SZ_4K;
+
+	if (!param.json) {
+		rc = fwrite(buf, 1, INFOBLOCK_SZ, ri_ctx->f_out);
+		if (rc != INFOBLOCK_SZ)
+			return -EIO;
+		fflush(ri_ctx->f_out);
+		return 0;
+	}
+
+	if (!jblocks) {
+		jblocks = json_object_new_array();
+		if (!jblocks)
+			return -ENOMEM;
+		ri_ctx->jblocks = jblocks;
+	}
+
+	if (memcmp(btt1_sb->signature, BTT_SIG, BTT_SIG_LEN) == 0) {
+		jblock = btt_parse(btt1_sb, ndns, path, flags);
+		if (jblock)
+			json_object_array_add(jblocks, jblock);
+	}
+
+	if (memcmp(btt2_sb->signature, BTT_SIG, BTT_SIG_LEN) == 0) {
+		jblock = btt_parse(btt2_sb, ndns, path, flags);
+		if (jblock)
+			json_object_array_add(jblocks, jblock);
+	}
+
+	if (memcmp(pfn_sb->signature, PFN_SIG, PFN_SIG_LEN) == 0) {
+		jblock = pfn_parse(pfn_sb, ndns, path, flags);
+		if (jblock)
+			json_object_array_add(jblocks, jblock);
+	}
+
+	if (memcmp(dax_sb->signature, DAX_SIG, PFN_SIG_LEN) == 0) {
+		jblock = pfn_parse(dax_sb, ndns, path, flags);
+		if (jblock)
+			json_object_array_add(jblocks, jblock);
+	}
+
+	return 0;
+}
+
+static int file_read_infoblock(const char *path, struct ndctl_namespace *ndns,
+		struct read_infoblock_ctx *ri_ctx)
+{
+	const char *devname = ndns ? ndctl_namespace_get_devname(ndns) : "";
+	const char *cmd = "read-info-block";
+	void *buf = NULL;
+	int fd = -1, rc;
+
+	buf = calloc(1, INFOBLOCK_SZ);
+	if (!buf)
+		return -ENOMEM;
+
+	fd = open(path, O_RDONLY|O_EXCL);
+	if (fd < 0) {
+		pr_verbose("%s: %s failed to open %s: %s\n",
+				cmd, devname, path, strerror(errno));
+		rc = -errno;
+		goto out;
+	}
+
+	rc = read(fd, buf, INFOBLOCK_SZ);
+	if (rc < 0) {
+		pr_verbose("%s: %s failed to read %s: %s\n",
+				cmd, devname, path, strerror(errno));
+		rc = -errno;
+		goto out;
+	}
+
+	rc = parse_namespace_infoblock(buf, ndns, path, ri_ctx);
+out:
+	free(buf);
+	if (fd >= 0)
+		close(fd);
+	return rc;
+}
+
+static int namespace_read_infoblock(struct ndctl_namespace *ndns,
+		struct read_infoblock_ctx *ri_ctx)
+{
+	int rc;
+	char path[50];
+	const char *cmd = "read-info-block";
+	const char *devname = ndctl_namespace_get_devname(ndns);
+
+	if (ndctl_namespace_is_active(ndns)) {
+		pr_verbose("%s: %s enabled, must be disabled\n", cmd, devname);
+		return -EBUSY;
+	}
+
+	ndctl_namespace_set_raw_mode(ndns, 1);
+	rc = ndctl_namespace_enable(ndns);
+	if (rc < 0) {
+		pr_verbose("%s: %s failed to enable\n", cmd, devname);
+		goto out;
+	}
+
+	sprintf(path, "/dev/%s", ndctl_namespace_get_block_device(ndns));
+	rc = file_read_infoblock(path, ndns, ri_ctx);
+
+out:
+	ndctl_namespace_set_raw_mode(ndns, 0);
+	ndctl_namespace_disable_invalidate(ndns);
+	return rc;
+}
+
 static int do_xaction_namespace(const char *namespace,
 		enum device_action action, struct ndctl_ctx *ctx,
 		int *processed)
 {
+	struct read_infoblock_ctx ri_ctx = { 0 };
 	struct ndctl_namespace *ndns, *_n;
 	struct ndctl_region *region;
 	const char *ndns_name;
@@ -1063,6 +1413,26 @@ static int do_xaction_namespace(const char *namespace,
 
 	*processed = 0;
 
+	if (action == ACTION_READ_INFOBLOCK) {
+		if (!param.outfile)
+			ri_ctx.f_out = stdout;
+		else {
+			ri_ctx.f_out = fopen(param.outfile, "w+");
+			if (!ri_ctx.f_out) {
+				fprintf(stderr, "failed to open: %s: (%s)\n",
+						param.outfile, strerror(errno));
+				return -errno;
+			}
+		}
+
+		if (param.infile) {
+			rc = file_read_infoblock(param.infile, NULL, &ri_ctx);
+			if (ri_ctx.jblocks)
+				util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
+			return rc;
+		}
+	}
+
 	if (!namespace && action != ACTION_CREATE)
 		return rc;
 
@@ -1136,6 +1506,11 @@ static int do_xaction_namespace(const char *namespace,
 					if (rc == 0)
 						*processed = 1;
 					return rc;
+				case ACTION_READ_INFOBLOCK:
+					rc = namespace_read_infoblock(ndns, &ri_ctx);
+					if (rc == 0)
+						(*processed)++;
+					break;
 				default:
 					rc = -EINVAL;
 					break;
@@ -1144,6 +1519,12 @@ static int do_xaction_namespace(const char *namespace,
 		}
 	}
 
+	if (ri_ctx.jblocks)
+		util_display_json_array(ri_ctx.f_out, ri_ctx.jblocks, 0);
+
+	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
+		fclose(ri_ctx.f_out);
+
 	return rc;
 }
 
@@ -1240,3 +1621,19 @@ int cmd_check_namespace(int argc , const char **argv, struct ndctl_ctx *ctx)
 			checked == 1 ? "" : "s");
 	return rc;
 }
+
+int cmd_read_infoblock(int argc , const char **argv, struct ndctl_ctx *ctx)
+{
+	char *xable_usage = "ndctl read-info-block <namespace> [<options>]";
+	const char *namespace = parse_namespace_options(argc, argv,
+			ACTION_READ_INFOBLOCK, read_infoblock_options,
+			xable_usage);
+	int read, rc;
+
+	rc = do_xaction_namespace(namespace, ACTION_READ_INFOBLOCK, ctx, &read);
+	if (rc < 0)
+		fprintf(stderr, "error checking namespaces: %s\n",
+				strerror(-rc));
+	fprintf(stderr, "read %d namespace%s\n", read, read == 1 ? "" : "s");
+	return rc;
+}
diff --git a/ndctl/namespace.h b/ndctl/namespace.h
index bc210857642f..861dfbfa5127 100644
--- a/ndctl/namespace.h
+++ b/ndctl/namespace.h
@@ -13,7 +13,9 @@
 #ifndef __NDCTL_NAMESPACE_H__
 #define __NDCTL_NAMESPACE_H__
 #include <sys/types.h>
+#include <util/util.h>
 #include <util/size.h>
+#include <util/fletcher.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
 
@@ -202,4 +204,53 @@ struct arena_map {
 	struct btt_sb *info2;
 	size_t info2_len;
 };
+
+#define PFN_SIG_LEN 16
+#define PFN_SIG "NVDIMM_PFN_INFO\0"
+#define DAX_SIG "NVDIMM_DAX_INFO\0"
+
+struct pfn_sb {
+	u8 signature[PFN_SIG_LEN];
+	u8 uuid[16];
+	u8 parent_uuid[16];
+	le32 flags;
+	le16 version_major;
+	le16 version_minor;
+	le64 dataoff; /* relative to namespace_base + start_pad */
+	le64 npfns;
+	le32 mode;
+	/* minor-version-1 additions for section alignment */
+	le32 start_pad;
+	le32 end_trunc;
+	/* minor-version-2 record the base alignment of the mapping */
+	le32 align;
+	u8 padding[4000];
+	le64 checksum;
+};
+
+union info_block {
+	struct pfn_sb pfn_sb;
+	struct btt_sb btt_sb;
+};
+
+static inline bool verify_infoblock_checksum(union info_block *sb)
+{
+	uint64_t sum;
+	le64 sum_save;
+
+	BUILD_BUG_ON(sizeof(union info_block) != SZ_4K);
+
+	/* all infoblocks share the btt_sb layout for checksum */
+	sum_save = sb->btt_sb.checksum;
+	sb->btt_sb.checksum = 0;
+	sum = fletcher64(&sb->btt_sb, sizeof(*sb), 1);
+	if (sum != sum_save)
+		return false;
+	/* restore the checksum in the buffer */
+	sb->btt_sb.checksum = sum_save;
+
+	return true;
+}
+
+
 #endif /* __NDCTL_NAMESPACE_H__ */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index bd333b292743..5018d486e2c1 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -73,6 +73,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-namespace", { cmd_disable_namespace } },
 	{ "create-namespace", { cmd_create_namespace } },
 	{ "destroy-namespace", { cmd_destroy_namespace } },
+	{ "read-infoblock",  { cmd_read_infoblock } },
 	{ "check-namespace", { cmd_check_namespace } },
 	{ "enable-region", { cmd_enable_region } },
 	{ "disable-region", { cmd_disable_region } },
diff --git a/util/fletcher.h b/util/fletcher.h
index 54e2ecf5d6ed..8fccac4ec758 100644
--- a/util/fletcher.h
+++ b/util/fletcher.h
@@ -1,6 +1,7 @@
 #ifndef _NDCTL_FLETCHER_H_
 #define _NDCTL_FLETCHER_H_
 
+#include <stdbool.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
 
diff --git a/util/size.h b/util/size.h
index 34fac58d6945..2426fef74b3c 100644
--- a/util/size.h
+++ b/util/size.h
@@ -16,6 +16,7 @@
 
 #define SZ_1K     0x00000400
 #define SZ_4K     0x00001000
+#define SZ_8K     0x00002000
 #define SZ_1M     0x00100000
 #define SZ_2M     0x00200000
 #define SZ_4M     0x00400000

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
