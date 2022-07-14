Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6976003
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657818165; x=1689354165;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u7l+qE05EyPGBjp2Bg9ejGd8ChU7Kpr9hP8IMycY+WY=;
  b=UFsUgmidm0iTOAiCFJNrTfFA51qaWb0+RcX82WcutQ0LHTSuLaXeBbhp
   j3MHpHkGOV6iF14O0gkejbLljFmlhO0bqOk1/MA52Av5s1FBFNL/BgHv1
   34+yQbfWpq0a/ryI9J3sY+5RlDWKx4G/ZsYxNzXJ/GBAfjixqD66/Xu65
   IU0xtUUMuyz1SVGiIWO4MS7AclcFd0FGKQle67Ku1V11kL0nl9s8BEwvy
   UeagfXI9M70r1SMCgW+Gb8OaHQOKt+aQOw8KpRfh0a/I2dJaWy0epZTsS
   goCOaRfmtsVMWMHY8mBIGwJVIvNsyj/nxH9ccAFS6ci0SYIF4wEA5strl
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="268602796"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="268602796"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:44 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="772694169"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:44 -0700
Subject: [ndctl PATCH v2 10/12] cxl/memdev: Add {reserve,free}-dpa commands
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Thu, 14 Jul 2022 10:02:44 -0700
Message-ID: <165781816425.1555691.17958897857798325111.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
References: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add helper commands for managing allocations of DPA (device physical
address) capacity on a set of CXL memory devices.

The main convenience this command affords is automatically picking the next
decoder to allocate per-memdev.

For example, to allocate 256MiB from all endpoints that are covered by a
given root decoder, and collect those resulting endpoint-decoders into an
array:

  readarray -t mem < <(cxl list -M -d $decoder | jq -r ".[].memdev")
  readarray -t endpoint < <(cxl reserve-dpa -t pmem ${mem[*]} -s $((256<<20)) |
                            jq -r ".[] | .decoder.decoder")

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 .clang-format                         |    1 
 Documentation/cxl/cxl-free-dpa.txt    |   53 ++++++
 Documentation/cxl/cxl-reserve-dpa.txt |   67 ++++++++
 Documentation/cxl/lib/libcxl.txt      |    2 
 Documentation/cxl/meson.build         |    2 
 cxl/builtin.h                         |    2 
 cxl/cxl.c                             |    2 
 cxl/filter.c                          |    4 
 cxl/filter.h                          |    2 
 cxl/lib/libcxl.c                      |   86 ++++++++++
 cxl/lib/libcxl.sym                    |    4 
 cxl/libcxl.h                          |    9 +
 cxl/memdev.c                          |  280 +++++++++++++++++++++++++++++++++
 13 files changed, 511 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/cxl/cxl-free-dpa.txt
 create mode 100644 Documentation/cxl/cxl-reserve-dpa.txt

diff --git a/.clang-format b/.clang-format
index 6aabcb68e6a9..7254a1b15738 100644
--- a/.clang-format
+++ b/.clang-format
@@ -81,6 +81,7 @@ ForEachMacros:
   - 'cxl_bus_foreach'
   - 'cxl_port_foreach'
   - 'cxl_decoder_foreach'
+  - 'cxl_decoder_foreach_reverse'
   - 'cxl_target_foreach'
   - 'cxl_dport_foreach'
   - 'cxl_endpoint_foreach'
diff --git a/Documentation/cxl/cxl-free-dpa.txt b/Documentation/cxl/cxl-free-dpa.txt
new file mode 100644
index 000000000000..73fb048fdee3
--- /dev/null
+++ b/Documentation/cxl/cxl-free-dpa.txt
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-free-dpa(1)
+===============
+
+NAME
+----
+cxl-free-dpa - release device-physical address space
+
+SYNOPSIS
+--------
+[verse]
+'cxl free-dpa' <mem0> [<mem1>..<memN>] [<options>]
+
+The CXL region provisioning process proceeds in multiple steps. One of
+the steps is identifying and reserving the DPA span that each member of
+the interleave-set (region) contributes in advance of attaching that
+allocation to a region. For development, test, and debug purposes this
+command is a helper to find the last allocated decoder on a device and
+zero-out / free its DPA allocation.
+
+OPTIONS
+-------
+<memory device(s)>::
+include::memdev-option.txt[]
+
+-d::
+--decoder::
+	Specify the decoder to free. The CXL specification
+	mandates that DPA must be released in the reverse order it was
+	allocated. See linkcxl:cxl-reserve-dpa[1]
+
+-t::
+--type::
+	Constrain the search for "last allocated decoder" to decoders targeting
+	the given partition.
+
+-f::
+--force::
+	The kernel enforces CXL DPA ordering constraints on deallocation events,
+	and the tool anticipates those and fails operations that are expected to
+	fail without sending them to the kernel. For test purposes, continue to
+	attempt "expected to fail" operations to exercise the driver.
+
+-v::
+	Turn on verbose debug messages in the library (if libcxl was built with
+	logging and debug enabled).
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-reserve-dpa[1]
diff --git a/Documentation/cxl/cxl-reserve-dpa.txt b/Documentation/cxl/cxl-reserve-dpa.txt
new file mode 100644
index 000000000000..560daf0cb277
--- /dev/null
+++ b/Documentation/cxl/cxl-reserve-dpa.txt
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-reserve-dpa(1)
+==================
+
+NAME
+----
+cxl-reserve-dpa - allocate device-physical address space
+
+SYNOPSIS
+--------
+[verse]
+'cxl reserve-dpa' <mem0> [<mem1>..<memN>] [<options>]
+
+The CXL region provisioning process proceeds in multiple steps. One of
+the steps is identifying and reserving the DPA span that each member of
+the interleave-set (region) contributes in advance of attaching that
+allocation to a region. For development, test, and debug purposes this
+command is a helper to find the next available decoder on endpoint
+(memdev) and mark a span of DPA as busy.
+
+OPTIONS
+-------
+<memory device(s)>::
+include::memdev-option.txt[]
+
+-d::
+--decoder::
+	Specify the decoder to attempt the allocation. The CXL specification
+	mandates that allocations must be ordered by DPA and decoder instance.
+	I.e. the lowest DPA allocation on the device is covered by deocder0, and
+	the last / highest DPA allocation is covered by the last decoder. This
+	ordering is enforced by the kernel. By default the tool picks the 'next
+	available' decoder.
+
+-t::
+--type::
+	Select the partition for the allocation. CXL devices implement a
+	partition that divdes 'ram' and 'pmem' capacity, where 'pmem' capacity
+	consumes the higher DPA capacity above the partition boundary. The type
+	defaults to 'pmem'. Note that given CXL DPA allocation constraints, once
+	any 'pmem' allocation is established then all remaining 'ram' capacity
+	becomes reserved (skipped).
+
+-f::
+--force::
+	The kernel enforces CXL DPA allocation ordering constraints, and
+	the tool anticipates those and fails operations that are expected to
+	fail without sending them to the kernel. For test purposes, continue to
+	attempt "expected to fail" operations to exercise the driver.
+
+-s::
+--size::
+	Specify the size of the allocation. This option supports the suffixes
+	"k" or "K" for KiB, "m" or "M" for MiB, "g" or "G" for GiB and "t" or
+	"T" for TiB. This defaults to "all available capacity of the specified
+	type".
+
+-v::
+	Turn on verbose debug messages in the library (if libcxl was built with
+	logging and debug enabled).
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-free-dpa[1]
diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 90fe33887821..7a38ce4a54e2 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -394,6 +394,7 @@ unsigned long long cxl_decoder_get_resource(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_size(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_dpa_resource(struct cxl_decoder *decoder);
 unsigned long long cxl_decoder_get_dpa_size(struct cxl_decoder *decoder);
+int cxl_decoder_set_dpa_size(struct cxl_decoder *decoder, unsigned long long size);
 const char *cxl_decoder_get_devname(struct cxl_decoder *decoder);
 int cxl_decoder_get_id(struct cxl_decoder *decoder);
 int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder);
@@ -413,6 +414,7 @@ enum cxl_decoder_mode {
 	CXL_DECODER_MODE_RAM,
 };
 enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
+int cxl_decoder_set_mode(struct cxl_decoder *decoder, enum cxl_decoder_mode mode);
 
 bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index 974a5a41d169..d019dfc23659 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -36,6 +36,8 @@ cxl_manpages = [
   'cxl-disable-port.txt',
   'cxl-disable-bus.txt',
   'cxl-set-partition.txt',
+  'cxl-reserve-dpa.txt',
+  'cxl-free-dpa.txt',
 ]
 
 foreach man : cxl_manpages
diff --git a/cxl/builtin.h b/cxl/builtin.h
index a437bc314a30..9e6fc624e86c 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -12,6 +12,8 @@ int cmd_init_labels(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_check_labels(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_reserve_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_free_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx);
diff --git a/cxl/cxl.c b/cxl/cxl.c
index aa4ce61b7c87..ef4cda9e7c23 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -66,6 +66,8 @@ static struct cmd_struct commands[] = {
 	{ "write-labels", .c_fn = cmd_write_labels },
 	{ "disable-memdev", .c_fn = cmd_disable_memdev },
 	{ "enable-memdev", .c_fn = cmd_enable_memdev },
+	{ "reserve-dpa", .c_fn = cmd_reserve_dpa },
+	{ "free-dpa", .c_fn = cmd_free_dpa },
 	{ "disable-port", .c_fn = cmd_disable_port },
 	{ "enable-port", .c_fn = cmd_enable_port },
 	{ "set-partition", .c_fn = cmd_set_partition },
diff --git a/cxl/filter.c b/cxl/filter.c
index 2f88a9d2f398..e5fab19ec47f 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -380,8 +380,8 @@ struct cxl_port *util_cxl_port_filter_by_memdev(struct cxl_port *port,
 	return NULL;
 }
 
-static struct cxl_decoder *util_cxl_decoder_filter(struct cxl_decoder *decoder,
-						   const char *__ident)
+struct cxl_decoder *util_cxl_decoder_filter(struct cxl_decoder *decoder,
+					    const char *__ident)
 {
 	struct cxl_port *port = cxl_decoder_get_port(decoder);
 	int pid, did;
diff --git a/cxl/filter.h b/cxl/filter.h
index 955794366d5c..c913dafd85ba 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -50,6 +50,8 @@ struct cxl_target *util_cxl_target_filter_by_memdev(struct cxl_target *target,
 struct cxl_dport *util_cxl_dport_filter_by_memdev(struct cxl_dport *dport,
 						  const char *ident,
 						  const char *serial);
+struct cxl_decoder *util_cxl_decoder_filter(struct cxl_decoder *decoder,
+					    const char *__ident);
 int cxl_filter_walk(struct cxl_ctx *ctx, struct cxl_filter_params *param);
 bool cxl_filter_has(const char *needle, const char *__filter);
 #endif /* _CXL_UTIL_FILTER_H_ */
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index a4709175678d..be6bc2c65483 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1120,6 +1120,20 @@ CXL_EXPORT struct cxl_decoder *cxl_decoder_get_next(struct cxl_decoder *decoder)
 	return list_next(&port->decoders, decoder, list);
 }
 
+CXL_EXPORT struct cxl_decoder *cxl_decoder_get_last(struct cxl_port *port)
+{
+	cxl_decoders_init(port);
+
+	return list_tail(&port->decoders, struct cxl_decoder, list);
+}
+
+CXL_EXPORT struct cxl_decoder *cxl_decoder_get_prev(struct cxl_decoder *decoder)
+{
+	struct cxl_port *port = decoder->port;
+
+	return list_prev(&port->decoders, decoder, list);
+}
+
 CXL_EXPORT struct cxl_ctx *cxl_decoder_get_ctx(struct cxl_decoder *decoder)
 {
 	return decoder->ctx;
@@ -1175,6 +1189,78 @@ cxl_decoder_get_dpa_size(struct cxl_decoder *decoder)
 	return decoder->dpa_size;
 }
 
+CXL_EXPORT int cxl_decoder_set_dpa_size(struct cxl_decoder *decoder,
+					unsigned long long size)
+{
+	struct cxl_port *port = cxl_decoder_get_port(decoder);
+	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+	char *path = decoder->dev_buf;
+	int len = decoder->buf_len, rc;
+	char buf[SYSFS_ATTR_SIZE];
+
+	if (!cxl_port_is_endpoint(port)) {
+		err(ctx, "%s: not an endpoint decoder\n",
+		    cxl_decoder_get_devname(decoder));
+		return -EINVAL;
+	}
+
+	if (snprintf(path, len, "%s/dpa_size", decoder->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+		    cxl_decoder_get_devname(decoder));
+		return -ENOMEM;
+	}
+
+	sprintf(buf, "%#llx\n", size);
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc < 0)
+		return rc;
+
+	decoder->dpa_size = size;
+	return 0;
+}
+
+CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
+				    enum cxl_decoder_mode mode)
+{
+	struct cxl_port *port = cxl_decoder_get_port(decoder);
+	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+	char *path = decoder->dev_buf;
+	int len = decoder->buf_len, rc;
+	char buf[SYSFS_ATTR_SIZE];
+
+	if (!cxl_port_is_endpoint(port)) {
+		err(ctx, "%s: not an endpoint decoder\n",
+		    cxl_decoder_get_devname(decoder));
+		return -EINVAL;
+	}
+
+	switch (mode) {
+	case CXL_DECODER_MODE_PMEM:
+		sprintf(buf, "pmem");
+		break;
+	case CXL_DECODER_MODE_RAM:
+		sprintf(buf, "ram");
+		break;
+	default:
+		err(ctx, "%s: unsupported mode: %d\n",
+		    cxl_decoder_get_devname(decoder), mode);
+		return -EINVAL;
+	}
+
+	if (snprintf(path, len, "%s/mode", decoder->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+		    cxl_decoder_get_devname(decoder));
+		return -ENOMEM;
+	}
+
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc < 0)
+		return rc;
+
+	decoder->mode = mode;
+	return 0;
+}
+
 CXL_EXPORT enum cxl_decoder_mode
 cxl_decoder_get_mode(struct cxl_decoder *decoder)
 {
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 88c5a7edd33e..7712de0c5010 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -173,4 +173,8 @@ global:
 	cxl_decoder_get_dpa_resource;
 	cxl_decoder_get_dpa_size;
 	cxl_decoder_get_mode;
+	cxl_decoder_get_last;
+	cxl_decoder_get_prev;
+	cxl_decoder_set_dpa_size;
+	cxl_decoder_set_mode;
 } LIBCXL_2;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 1436dc4601cc..33a216ee3a4c 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -139,6 +139,7 @@ enum cxl_decoder_mode {
 	CXL_DECODER_MODE_PMEM,
 	CXL_DECODER_MODE_RAM,
 };
+
 static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 {
 	static const char *names[] = {
@@ -154,6 +155,10 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 }
 
 enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
+int cxl_decoder_set_mode(struct cxl_decoder *decoder,
+			 enum cxl_decoder_mode mode);
+int cxl_decoder_set_dpa_size(struct cxl_decoder *decoder,
+			     unsigned long long size);
 const char *cxl_decoder_get_devname(struct cxl_decoder *decoder);
 struct cxl_target *cxl_decoder_get_target_by_memdev(struct cxl_decoder *decoder,
 						    struct cxl_memdev *memdev);
@@ -182,6 +187,10 @@ bool cxl_decoder_is_locked(struct cxl_decoder *decoder);
 	for (decoder = cxl_decoder_get_first(port); decoder != NULL;           \
 	     decoder = cxl_decoder_get_next(decoder))
 
+#define cxl_decoder_foreach_reverse(port, decoder)                             \
+	for (decoder = cxl_decoder_get_last(port); decoder != NULL;           \
+	     decoder = cxl_decoder_get_prev(decoder))
+
 struct cxl_target;
 struct cxl_target *cxl_target_get_first(struct cxl_decoder *decoder);
 struct cxl_target *cxl_target_get_next(struct cxl_target *target);
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 1cecad2dba4b..e42f554326ec 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -33,6 +33,7 @@ static struct parameters {
 	bool align;
 	const char *type;
 	const char *size;
+	const char *decoder_filter;
 } param;
 
 static struct log_ctx ml;
@@ -71,6 +72,19 @@ OPT_STRING('s', "size",  &param.size, "size",			\
 OPT_BOOLEAN('a', "align",  &param.align,			\
 	"auto-align --size per device's requirement")
 
+#define RESERVE_DPA_OPTIONS()                                          \
+OPT_STRING('s', "size", &param.size, "size",                           \
+	   "size in bytes (Default: all available capacity)")
+
+#define DPA_OPTIONS()                                          \
+OPT_STRING('d', "decoder", &param.decoder_filter,              \
+   "decoder instance id",                                      \
+   "override the automatic decoder selection"),                \
+OPT_STRING('t', "type", &param.type, "type",                   \
+	   "'pmem' or 'ram' (volatile) (Default: 'pmem')"),    \
+OPT_BOOLEAN('f', "force", &param.force,                        \
+	    "Attempt 'expected to fail' operations")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	LABEL_OPTIONS(),
@@ -108,6 +122,242 @@ static const struct option set_partition_options[] = {
 	OPT_END(),
 };
 
+static const struct option reserve_dpa_options[] = {
+	BASE_OPTIONS(),
+	RESERVE_DPA_OPTIONS(),
+	DPA_OPTIONS(),
+	OPT_END(),
+};
+
+static const struct option free_dpa_options[] = {
+	BASE_OPTIONS(),
+	DPA_OPTIONS(),
+	OPT_END(),
+};
+
+enum reserve_dpa_mode {
+	DPA_ALLOC,
+	DPA_FREE,
+};
+
+static int __reserve_dpa(struct cxl_memdev *memdev,
+			 enum reserve_dpa_mode alloc_mode,
+			 struct action_context *actx)
+{
+	struct cxl_decoder *decoder, *auto_target = NULL, *target = NULL;
+	struct cxl_endpoint *endpoint = cxl_memdev_get_endpoint(memdev);
+	const char *devname = cxl_memdev_get_devname(memdev);
+	unsigned long long avail_dpa, size;
+	enum cxl_decoder_mode mode;
+	struct cxl_port *port;
+	char buf[256];
+	int rc;
+
+	if (param.type) {
+		if (strcmp(param.type, "ram") == 0)
+			mode = CXL_DECODER_MODE_RAM;
+		else if (strcmp(param.type, "volatile") == 0)
+			mode = CXL_DECODER_MODE_RAM;
+		else if (strcmp(param.type, "ram") == 0)
+			mode = CXL_DECODER_MODE_RAM;
+		else if (strcmp(param.type, "pmem") == 0)
+			mode = CXL_DECODER_MODE_PMEM;
+		else {
+			log_err(&ml, "%s: unsupported type: %s\n", devname,
+				param.type);
+			return -EINVAL;
+		}
+	} else
+		mode = CXL_DECODER_MODE_RAM;
+
+	if (!endpoint) {
+		log_err(&ml, "%s: CXL operation disabled\n", devname);
+		return -ENXIO;
+	}
+
+	port = cxl_endpoint_get_port(endpoint);
+
+	if (mode == CXL_DECODER_MODE_RAM)
+		avail_dpa = cxl_memdev_get_ram_size(memdev);
+	else
+		avail_dpa = cxl_memdev_get_pmem_size(memdev);
+
+	cxl_decoder_foreach(port, decoder) {
+		size = cxl_decoder_get_dpa_size(decoder);
+		if (size == ULLONG_MAX)
+			continue;
+		if (cxl_decoder_get_mode(decoder) != mode)
+			continue;
+
+		if (size > avail_dpa) {
+			log_err(&ml, "%s: capacity accounting error\n",
+				devname);
+			return -ENXIO;
+		}
+		avail_dpa -= size;
+	}
+
+	if (!param.size)
+		if (alloc_mode == DPA_ALLOC) {
+			size = avail_dpa;
+			if (!avail_dpa) {
+				log_err(&ml, "%s: no available capacity\n",
+					devname);
+				return -ENOSPC;
+			}
+		} else
+			size = 0;
+	else {
+		size = parse_size64(param.size);
+		if (size == ULLONG_MAX) {
+			log_err(&ml, "%s: failed to parse size option '%s'\n",
+				devname, param.size);
+			return -EINVAL;
+		}
+		if (size > avail_dpa) {
+			log_err(&ml, "%s: '%s' exceeds available capacity\n",
+				devname, param.size);
+			if (!param.force)
+				return -ENOSPC;
+		}
+	}
+
+	/*
+	 * Find next free decoder, assumes cxl_decoder_foreach() is in
+	 * hardware instance-id order
+	 */
+	if (alloc_mode == DPA_ALLOC)
+		cxl_decoder_foreach(port, decoder) {
+			/* first 0-dpa_size is our target */
+			if (cxl_decoder_get_dpa_size(decoder) == 0) {
+				auto_target = decoder;
+				break;
+			}
+		}
+	else
+		cxl_decoder_foreach_reverse(port, decoder) {
+			/* nothing to free? */
+			if (!cxl_decoder_get_dpa_size(decoder))
+				continue;
+			/*
+			 * Active decoders can't be freed, and by definition all
+			 * previous decoders must also be active
+			 */
+			if (cxl_decoder_get_size(decoder))
+				break;
+			/* first dpa_size > 0 + disabled decoder is our target */
+			if (cxl_decoder_get_dpa_size(decoder) < ULLONG_MAX) {
+				auto_target = decoder;
+				break;
+			}
+		}
+
+	if (param.decoder_filter) {
+		unsigned long id;
+		char *end;
+
+		id = strtoul(param.decoder_filter, &end, 0);
+		/* allow for standalone ordinal decoder ids */
+		if (*end == '\0')
+			rc = snprintf(buf, sizeof(buf), "decoder%d.%ld",
+				      cxl_port_get_id(port), id);
+		else
+			rc = snprintf(buf, sizeof(buf), "%s",
+				      param.decoder_filter);
+
+		if (rc >= (int)sizeof(buf)) {
+			log_err(&ml, "%s: decoder filter '%s' too long\n",
+				devname, param.decoder_filter);
+			return -EINVAL;
+		}
+
+		if (alloc_mode == DPA_ALLOC)
+			cxl_decoder_foreach(port, decoder) {
+				target = util_cxl_decoder_filter(decoder, buf);
+				if (target)
+					break;
+			}
+		else
+			cxl_decoder_foreach_reverse(port, decoder) {
+				target = util_cxl_decoder_filter(decoder, buf);
+				if (target)
+					break;
+			}
+
+		if (!target) {
+			log_err(&ml, "%s: no match for decoder: '%s'\n",
+				devname, param.decoder_filter);
+			return -ENXIO;
+		}
+
+		if (target != auto_target) {
+			log_err(&ml, "%s: %s is out of sequence\n", devname,
+				cxl_decoder_get_devname(target));
+			if (!param.force)
+				return -EINVAL;
+		}
+	}
+
+	if (!target)
+		target = auto_target;
+
+	if (!target) {
+		log_err(&ml, "%s: no suitable decoder found\n", devname);
+		return -ENXIO;
+	}
+
+	if (cxl_decoder_get_mode(target) != mode) {
+		rc = cxl_decoder_set_dpa_size(target, 0);
+		if (rc) {
+			log_err(&ml,
+				"%s: %s: failed to clear allocation to set mode\n",
+				devname, cxl_decoder_get_devname(target));
+			return rc;
+		}
+		rc = cxl_decoder_set_mode(target, mode);
+		if (rc) {
+			log_err(&ml, "%s: %s: failed to set %s mode\n", devname,
+				cxl_decoder_get_devname(target),
+				mode == CXL_DECODER_MODE_PMEM ? "pmem" : "ram");
+			return rc;
+		}
+	}
+
+	rc = cxl_decoder_set_dpa_size(target, size);
+	if (rc)
+		log_err(&ml, "%s: %s: failed to set dpa allocation\n", devname,
+			cxl_decoder_get_devname(target));
+	else {
+		struct json_object *jdev, *jdecoder;
+		unsigned long flags = 0;
+
+		if (actx->f_out == stdout && isatty(1))
+			flags |= UTIL_JSON_HUMAN;
+		jdev = util_cxl_memdev_to_json(memdev, flags);
+		jdecoder = util_cxl_decoder_to_json(target, flags);
+		if (!jdev || !jdecoder) {
+			json_object_put(jdev);
+			json_object_put(jdecoder);
+		} else {
+			json_object_object_add(jdev, "decoder", jdecoder);
+			json_object_array_add(actx->jdevs, jdev);
+		}
+	}
+	return rc;
+}
+
+static int action_reserve_dpa(struct cxl_memdev *memdev,
+			      struct action_context *actx)
+{
+	return __reserve_dpa(memdev, DPA_ALLOC, actx);
+}
+
+static int action_free_dpa(struct cxl_memdev *memdev,
+			   struct action_context *actx)
+{
+	return __reserve_dpa(memdev, DPA_FREE, actx);
+}
+
 static int action_disable(struct cxl_memdev *memdev, struct action_context *actx)
 {
 	if (!cxl_memdev_is_enabled(memdev))
@@ -452,7 +702,8 @@ static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 		err++;
 	}
 
-	if (action == action_setpartition)
+	if (action == action_setpartition || action == action_reserve_dpa ||
+	    action == action_free_dpa)
 		actx.jdevs = json_object_new_array();
 
 	if (err == argc) {
@@ -495,6 +746,8 @@ static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 	count = 0;
 
 	for (i = 0; i < argc; i++) {
+		bool found = false;
+
 		cxl_memdev_foreach(ctx, memdev) {
 			const char *memdev_filter = NULL;
 			const char *serial_filter = NULL;
@@ -507,6 +760,7 @@ static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 			if (!util_cxl_memdev_filter(memdev, memdev_filter,
 						    serial_filter))
 				continue;
+			found = true;
 
 			if (action == action_write) {
 				single = memdev;
@@ -519,6 +773,8 @@ static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 			else if (rc && !err)
 				err = rc;
 		}
+		if (!found)
+			log_info(&ml, "no memdev matches %s\n", argv[i]);
 	}
 	rc = err;
 
@@ -622,3 +878,25 @@ int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx)
 
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_reserve_dpa(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int count = memdev_action(
+		argc, argv, ctx, action_reserve_dpa, reserve_dpa_options,
+		"cxl reserve-dpa <mem0> [<mem1>..<memn>] [<options>]");
+	log_info(&ml, "reservation completed on %d mem device%s\n",
+		 count >= 0 ? count : 0, count > 1 ? "s" : "");
+
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
+
+int cmd_free_dpa(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int count = memdev_action(
+		argc, argv, ctx, action_free_dpa, free_dpa_options,
+		"cxl free-dpa <mem0> [<mem1>..<memn>] [<options>]");
+	log_info(&ml, "reservation release completed on %d mem device%s\n",
+		 count >= 0 ? count : 0, count > 1 ? "s" : "");
+
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}

