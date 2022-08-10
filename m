Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935684A28
	for <nvdimm@lists.linux.dev>; Wed, 10 Aug 2022 23:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660172978; x=1691708978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ll4sf0upnKEMkgqJbhm+w9VOWthNvFQnSAhuMYPnYTg=;
  b=JhV+zbAUivdpjcQNyoKlpRdaImhBlkqEIqIjtX1GikBJTnmhEhnx5fcQ
   rwnLKD/21sieOc/NFAQRpDuEwTXsVNndW0bo+leBTcbwnbvkQeIdxTo7V
   6b+bLeEnGLYKy6wi17bw0bWc9NiyRimPVq4Vhg+nQfud10VnNHZ8Q9sDV
   8qCk9QUuz4tqPTTXdl3IzEMW4rGl9Ibse1DxthcOHEf0SZ5bhe1VczZgB
   XK9AtOzACiqbX2w0Dzd1pmfQtQR0eATOESupQfnTLFetTovUyabndS4dG
   r150YLot6RlHIVhxUZ97PN5Ap0CSbFccNIx3iNQcGGQBY/gv0HcYFQolQ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="292471275"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="292471275"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 16:09:33 -0700
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="581429438"
Received: from maughenb-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.209.94.5])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 16:09:32 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 05/10] libcxl: add low level APIs for region creation
Date: Wed, 10 Aug 2022 17:09:09 -0600
Message-Id: <20220810230914.549611-6-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810230914.549611-1-vishal.l.verma@intel.com>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=20891; h=from:subject; bh=ll4sf0upnKEMkgqJbhm+w9VOWthNvFQnSAhuMYPnYTg=; b=owGbwMvMwCXGf25diOft7jLG02pJDElfrGamyclmPpxqY3pm4v2FNVVb33YpBgpd4BUNPKuQZnDZ 5sK8jlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEzEk5WR4Rzb21sWP/bsdpvYF5T0c9 bn0nkurCm7fL8J8WcbHag7toaRoX+HaVym6duq4+9maXX8+XytOXzrYjOtLtf2Z0c2PczbxwMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add libcxl APIs to create a region under a given root decoder, and to
set different attributes for the new region. These allow setting the
size, interleave_ways, interleave_granularity, uuid, and the target
devices for the newly minted cxl_region object.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |  69 ++++++
 cxl/lib/private.h                |   2 +
 cxl/lib/libcxl.c                 | 377 ++++++++++++++++++++++++++++++-
 cxl/libcxl.h                     |  23 +-
 cxl/lib/libcxl.sym               |  16 ++
 5 files changed, 484 insertions(+), 3 deletions(-)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 7a38ce4..c3a8f36 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -508,6 +508,75 @@ device to represent the root of a PCI device hierarchy. The
 cxl_target_get_physical_node() helper returns the device name of that
 companion object in the PCI hierarchy.
 
+==== REGIONS
+A CXL region is composed of one or more slices of CXL memdevs, with configurable
+interleave settings - both the number of interleave ways, and the interleave
+granularity. In terms of hierarchy, it is the child of a CXL root decoder. A root
+decoder (recall that this corresponds to an ACPI CEDT.CFMWS 'window'), may have
+multiple chile regions, but a region is strictly tied to one root decoder.
+
+A region also defines a set of mappings which are slices of capacity on a memdev,
+each represented by an endpoint decoder.
+
+===== REGION: Enumeration
+----
+struct cxl_region *cxl_region_get_first(struct cxl_decoder *decoder);
+struct cxl_region *cxl_region_get_next(struct cxl_region *region);
+
+#define cxl_region_foreach(decoder, region)                                    \
+	for (region = cxl_region_get_first(decoder); region != NULL;           \
+	     region = cxl_region_get_next(region))
+
+#define cxl_region_foreach_safe(decoder, region, _region)                      \
+	for (region = cxl_region_get_first(decoder),                           \
+	     _region = region ? cxl_region_get_next(region) : NULL;            \
+	     region != NULL;                                                   \
+	     region = _region,                                                 \
+	     _region = _region ? cxl_region_get_next(_region) : NULL)
+----
+
+===== REGION: Attributes
+----
+int cxl_region_get_id(struct cxl_region *region);
+const char *cxl_region_get_devname(struct cxl_region *region);
+void cxl_region_get_uuid(struct cxl_region *region, uuid_t uu);
+unsigned long long cxl_region_get_size(struct cxl_region *region);
+unsigned long long cxl_region_get_resource(struct cxl_region *region);
+unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
+unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
+struct cxl_decoder *cxl_region_get_target_decoder(struct cxl_region *region,
+						  int position);
+int cxl_region_set_size(struct cxl_region *region, unsigned long long size);
+int cxl_region_set_uuid(struct cxl_region *region, uuid_t uu);
+int cxl_region_set_interleave_ways(struct cxl_region *region,
+				   unsigned int ways);
+int cxl_region_set_interleave_granularity(struct cxl_region *region,
+					  unsigned int granularity);
+int cxl_region_set_target(struct cxl_region *region, int position,
+			  struct cxl_decoder *decoder);
+int cxl_region_clear_target(struct cxl_region *region, int position);
+int cxl_region_clear_all_targets(struct cxl_region *region);
+int cxl_region_decode_commit(struct cxl_region *region);
+int cxl_region_decode_reset(struct cxl_region *region);
+----
+
+A region's resource attribute is the Host Physical Address at which the region's
+address space starts. The region's address space is a subset of the parent root
+decoder's address space.
+
+The interleave ways is the number of component memdevs participating in the
+region.
+
+The interleave granularity depends on the root decoder's granularity, and must
+follow the interleave math rules defined in the CXL spec.
+
+Regions have a list of targets 0..N, which are programmed with the name of an
+endpoint decoder under each participating memdev.
+
+The 'decode_commit' and 'decode_reset' attributes reserve and free DPA space
+on a given memdev by allocating an endpoint decoder, and programming it based
+on the region's interleave geometry.
+
 include::../../copyright.txt[]
 
 SEE ALSO
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index da49a6c..8619bb1 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -110,6 +110,8 @@ struct cxl_decoder {
 	int nr_targets;
 	int id;
 	enum cxl_decoder_mode mode;
+	unsigned int interleave_ways;
+	unsigned int interleave_granularity;
 	bool pmem_capable;
 	bool volatile_capable;
 	bool mem_capable;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 8dd804c..b4d7890 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -17,6 +17,7 @@
 #include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
 #include <ccan/short_types/short_types.h>
+#include <ccan/container_of/container_of.h>
 
 #include <util/log.h>
 #include <util/list.h>
@@ -412,6 +413,39 @@ CXL_EXPORT int cxl_region_enable(struct cxl_region *region)
 	return 0;
 }
 
+static int cxl_region_delete_name(struct cxl_decoder *decoder,
+				  const char *devname)
+{
+	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+	char *path = decoder->dev_buf;
+	int rc;
+
+	sprintf(path, "%s/delete_region", decoder->dev_path);
+	rc = sysfs_write_attr(ctx, path, devname);
+	if (rc != 0) {
+		err(ctx, "error deleting region: %s\n", strerror(-rc));
+		return rc;
+	}
+	return 0;
+}
+
+CXL_EXPORT int cxl_region_delete(struct cxl_region *region)
+{
+	struct cxl_decoder *decoder = cxl_region_get_decoder(region);
+	const char *devname = cxl_region_get_devname(region);
+	int rc;
+
+	if (cxl_region_is_enabled(region))
+		return -EBUSY;
+
+	rc = cxl_region_delete_name(decoder, devname);
+	if (rc != 0)
+		return rc;
+
+	free_region(region);
+	return 0;
+}
+
 static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 {
 	const char *devname = devpath_to_devname(cxlregion_base);
@@ -589,6 +623,258 @@ cxl_region_get_interleave_granularity(struct cxl_region *region)
 	return region->interleave_granularity;
 }
 
+CXL_EXPORT struct cxl_decoder *
+cxl_region_get_target_decoder(struct cxl_region *region, int position)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	int len = region->buf_len, rc;
+	char *path = region->dev_buf;
+	struct cxl_decoder *decoder;
+	char buf[SYSFS_ATTR_SIZE];
+
+	if (snprintf(path, len, "%s/target%d", region->dev_path, position) >=
+	    len) {
+		err(ctx, "%s: buffer too small!\n", devname);
+		return NULL;
+	}
+
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc < 0) {
+		err(ctx, "%s: error reading target%d: %s\n", devname,
+		    position, strerror(-rc));
+		return NULL;
+	}
+
+	decoder = cxl_decoder_get_by_name(ctx, buf);
+	if (!decoder) {
+		err(ctx, "%s: error locating decoder for target%d\n", devname,
+		    position);
+		return NULL;
+	}
+	return decoder;
+}
+
+CXL_EXPORT int cxl_region_set_size(struct cxl_region *region,
+				   unsigned long long size)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	int len = region->buf_len, rc;
+	char *path = region->dev_buf;
+	char buf[SYSFS_ATTR_SIZE];
+
+	if (size == 0) {
+		dbg(ctx, "%s: cannot use %s to delete a region\n", __func__,
+		    devname);
+		return -EINVAL;
+	}
+
+	if (snprintf(path, len, "%s/size", region->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n", devname);
+		return -ENXIO;
+	}
+
+	sprintf(buf, "%#llx\n", size);
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc < 0)
+		return rc;
+
+	region->size = size;
+
+	return 0;
+}
+
+CXL_EXPORT int cxl_region_set_uuid(struct cxl_region *region, uuid_t uu)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	int len = region->buf_len, rc;
+	char *path = region->dev_buf;
+	char uuid[SYSFS_ATTR_SIZE];
+
+	if (snprintf(path, len, "%s/uuid", region->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n", devname);
+		return -ENXIO;
+	}
+
+	uuid_unparse(uu, uuid);
+	rc = sysfs_write_attr(ctx, path, uuid);
+	if (rc != 0)
+		return rc;
+	memcpy(region->uuid, uu, sizeof(uuid_t));
+	return 0;
+}
+
+CXL_EXPORT int cxl_region_set_interleave_ways(struct cxl_region *region,
+					      unsigned int ways)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	int len = region->buf_len, rc;
+	char *path = region->dev_buf;
+	char buf[SYSFS_ATTR_SIZE];
+
+	if (snprintf(path, len, "%s/interleave_ways",
+		     region->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n", devname);
+		return -ENXIO;
+	}
+
+	sprintf(buf, "%u\n", ways);
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc < 0)
+		return rc;
+
+	region->interleave_ways = ways;
+
+	return 0;
+}
+
+CXL_EXPORT int cxl_region_set_interleave_granularity(struct cxl_region *region,
+						     unsigned int granularity)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	int len = region->buf_len, rc;
+	char *path = region->dev_buf;
+	char buf[SYSFS_ATTR_SIZE];
+
+	if (snprintf(path, len, "%s/interleave_granularity",
+		     region->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n", devname);
+		return -ENXIO;
+	}
+
+	sprintf(buf, "%u\n", granularity);
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc < 0)
+		return rc;
+
+	region->interleave_granularity = granularity;
+
+	return 0;
+}
+
+static int region_write_target(struct cxl_region *region, int position,
+			       struct cxl_decoder *decoder)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	int len = region->buf_len, rc;
+	char *path = region->dev_buf;
+	const char *dec_name = "";
+
+	if (decoder)
+		dec_name = cxl_decoder_get_devname(decoder);
+
+	if (snprintf(path, len, "%s/target%d", region->dev_path, position) >=
+	    len) {
+		err(ctx, "%s: buffer too small!\n", devname);
+		return -ENXIO;
+	}
+
+	rc = sysfs_write_attr(ctx, path, dec_name);
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
+CXL_EXPORT int cxl_region_set_target(struct cxl_region *region, int position,
+				     struct cxl_decoder *decoder)
+{
+	if (!decoder)
+		return -ENXIO;
+
+	return region_write_target(region, position, decoder);
+}
+
+CXL_EXPORT int cxl_region_clear_target(struct cxl_region *region, int position)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	int rc;
+
+	if (cxl_region_is_enabled(region)) {
+		err(ctx, "%s: can't clear targets on an active region\n",
+		    devname);
+		return -EBUSY;
+	}
+
+	rc = region_write_target(region, position, NULL);
+	if (rc) {
+		err(ctx, "%s: error clearing target%d: %s\n",
+		    devname, position, strerror(-rc));
+		return rc;
+	}
+
+	return 0;
+}
+
+CXL_EXPORT int cxl_region_clear_all_targets(struct cxl_region *region)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	unsigned int ways, i;
+	int rc;
+
+	if (cxl_region_is_enabled(region)) {
+		err(ctx, "%s: can't clear targets on an active region\n",
+		    devname);
+		return -EBUSY;
+	}
+
+	ways = cxl_region_get_interleave_ways(region);
+	if (ways == 0 || ways == UINT_MAX)
+		return -ENXIO;
+
+	for (i = 0; i < ways; i++) {
+		rc = region_write_target(region, i, NULL);
+		if (rc) {
+			err(ctx, "%s: error clearing target%d: %s\n",
+			    devname, i, strerror(-rc));
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+static int set_region_decode(struct cxl_region *region,
+			     enum cxl_decode_state decode_state)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
+	int len = region->buf_len, rc;
+	char *path = region->dev_buf;
+	char buf[SYSFS_ATTR_SIZE];
+
+	if (snprintf(path, len, "%s/commit", region->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n", devname);
+		return -ENXIO;
+	}
+
+	sprintf(buf, "%d\n", decode_state);
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc < 0)
+		return rc;
+
+	region->decode_state = decode_state;
+
+	return 0;
+}
+
+CXL_EXPORT int cxl_region_decode_commit(struct cxl_region *region)
+{
+	return set_region_decode(region, CXL_DECODE_COMMIT);
+}
+
+CXL_EXPORT int cxl_region_decode_reset(struct cxl_region *region)
+{
+	return set_region_decode(region, CXL_DECODE_RESET);
+}
+
 static struct cxl_decoder *__cxl_port_match_decoder(struct cxl_port *port,
 						    const char *ident)
 {
@@ -623,8 +909,8 @@ static struct cxl_decoder *cxl_port_find_decoder(struct cxl_port *port,
 	return NULL;
 }
 
-static struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
-						   const char *ident)
+CXL_EXPORT struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
+						       const char *ident)
 {
 	struct cxl_bus *bus;
 
@@ -1387,6 +1673,18 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	} else
 		decoder->mode = CXL_DECODER_MODE_NONE;
 
+	sprintf(path, "%s/interleave_granularity", cxldecoder_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		decoder->interleave_granularity = UINT_MAX;
+	else
+		decoder->interleave_granularity = strtoul(buf, NULL, 0);
+
+	sprintf(path, "%s/interleave_ways", cxldecoder_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		decoder->interleave_ways = UINT_MAX;
+	else
+		decoder->interleave_ways = strtoul(buf, NULL, 0);
+
 	switch (port->type) {
 	case CXL_PORT_ENDPOINT:
 		sprintf(path, "%s/dpa_resource", cxldecoder_base);
@@ -1719,6 +2017,63 @@ CXL_EXPORT bool cxl_decoder_is_locked(struct cxl_decoder *decoder)
 	return decoder->locked;
 }
 
+CXL_EXPORT unsigned int
+cxl_decoder_get_interleave_granularity(struct cxl_decoder *decoder)
+{
+	return decoder->interleave_granularity;
+}
+
+CXL_EXPORT unsigned int
+cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder)
+{
+	return decoder->interleave_ways;
+}
+
+CXL_EXPORT struct cxl_region *
+cxl_decoder_create_pmem_region(struct cxl_decoder *decoder)
+{
+	struct cxl_ctx *ctx = cxl_decoder_get_ctx(decoder);
+	char *path = decoder->dev_buf;
+	char buf[SYSFS_ATTR_SIZE];
+	struct cxl_region *region;
+	int rc;
+
+	sprintf(path, "%s/create_pmem_region", decoder->dev_path);
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc < 0) {
+		err(ctx, "failed to read new region name: %s\n",
+		    strerror(-rc));
+		return NULL;
+	}
+
+	rc = sysfs_write_attr(ctx, path, buf);
+	if (rc < 0) {
+		err(ctx, "failed to write new region name: %s\n",
+		    strerror(-rc));
+		return NULL;
+	}
+
+	/* create_region was successful, walk to the new region */
+	cxl_region_foreach(decoder, region) {
+		const char *devname = cxl_region_get_devname(region);
+
+		if (strcmp(devname, buf) == 0)
+			goto found;
+	}
+
+	/*
+	 * If walking to the region we just created failed, something has gone
+	 * very wrong. Attempt to delete it to avoid leaving a dangling region
+	 * id behind.
+	 */
+	err(ctx, "failed to add new region to libcxl\n");
+	cxl_region_delete_name(decoder, buf);
+	return NULL;
+
+ found:
+	return region;
+}
+
 CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
 {
 	return decoder->nr_targets;
@@ -1729,6 +2084,24 @@ CXL_EXPORT const char *cxl_decoder_get_devname(struct cxl_decoder *decoder)
 	return devpath_to_devname(decoder->dev_path);
 }
 
+CXL_EXPORT struct cxl_memdev *
+cxl_ep_decoder_get_memdev(struct cxl_decoder *decoder)
+{
+	struct cxl_port *port = cxl_decoder_get_port(decoder);
+	struct cxl_endpoint *ep;
+
+	if (!port)
+		return NULL;
+	if (!cxl_port_is_endpoint(port))
+		return NULL;
+
+	ep = container_of(port, struct cxl_endpoint, port);
+	if (!ep)
+		return NULL;
+
+	return cxl_endpoint_get_memdev(ep);
+}
+
 CXL_EXPORT struct cxl_target *cxl_target_get_first(struct cxl_decoder *decoder)
 {
 	return list_top(&decoder->targets, struct cxl_target, list);
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index c77a7b9..0b84977 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -182,7 +182,13 @@ bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_locked(struct cxl_decoder *decoder);
-
+unsigned int
+cxl_decoder_get_interleave_granularity(struct cxl_decoder *decoder);
+unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
+struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
+struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
+					    const char *ident);
+struct cxl_memdev *cxl_ep_decoder_get_memdev(struct cxl_decoder *decoder);
 #define cxl_decoder_foreach(port, decoder)                                     \
 	for (decoder = cxl_decoder_get_first(port); decoder != NULL;           \
 	     decoder = cxl_decoder_get_next(decoder))
@@ -231,6 +237,7 @@ int cxl_region_decode_is_committed(struct cxl_region *region);
 int cxl_region_is_enabled(struct cxl_region *region);
 int cxl_region_disable(struct cxl_region *region);
 int cxl_region_enable(struct cxl_region *region);
+int cxl_region_delete(struct cxl_region *region);
 struct cxl_ctx *cxl_region_get_ctx(struct cxl_region *region);
 struct cxl_decoder *cxl_region_get_decoder(struct cxl_region *region);
 int cxl_region_get_id(struct cxl_region *region);
@@ -240,6 +247,20 @@ unsigned long long cxl_region_get_size(struct cxl_region *region);
 unsigned long long cxl_region_get_resource(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_ways(struct cxl_region *region);
 unsigned int cxl_region_get_interleave_granularity(struct cxl_region *region);
+struct cxl_decoder *cxl_region_get_target_decoder(struct cxl_region *region,
+						  int position);
+int cxl_region_set_size(struct cxl_region *region, unsigned long long size);
+int cxl_region_set_uuid(struct cxl_region *region, uuid_t uu);
+int cxl_region_set_interleave_ways(struct cxl_region *region,
+				   unsigned int ways);
+int cxl_region_set_interleave_granularity(struct cxl_region *region,
+					  unsigned int granularity);
+int cxl_region_set_target(struct cxl_region *region, int position,
+			  struct cxl_decoder *decoder);
+int cxl_region_clear_target(struct cxl_region *region, int position);
+int cxl_region_clear_all_targets(struct cxl_region *region);
+int cxl_region_decode_commit(struct cxl_region *region);
+int cxl_region_decode_reset(struct cxl_region *region);
 
 #define cxl_region_foreach(decoder, region)                                    \
 	for (region = cxl_region_get_first(decoder); region != NULL;           \
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index e410298..6bf3e91 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -140,6 +140,7 @@ global:
 	cxl_decoder_is_mem_capable;
 	cxl_decoder_is_accelmem_capable;
 	cxl_decoder_is_locked;
+	cxl_decoder_create_pmem_region;
 	cxl_target_get_first;
 	cxl_target_get_next;
 	cxl_target_get_decoder;
@@ -183,6 +184,7 @@ global:
 	cxl_region_is_enabled;
 	cxl_region_disable;
 	cxl_region_enable;
+	cxl_region_delete;
 	cxl_region_get_ctx;
 	cxl_region_get_decoder;
 	cxl_region_get_id;
@@ -192,9 +194,23 @@ global:
 	cxl_region_get_resource;
 	cxl_region_get_interleave_ways;
 	cxl_region_get_interleave_granularity;
+	cxl_region_get_target_decoder;
+	cxl_region_set_size;
+	cxl_region_set_uuid;
+	cxl_region_set_interleave_ways;
+	cxl_region_set_interleave_granularity;
+	cxl_region_set_target;
+	cxl_region_clear_target;
+	cxl_region_clear_all_targets;
+	cxl_region_decode_commit;
+	cxl_region_decode_reset;
 	cxl_mapping_get_first;
 	cxl_mapping_get_next;
 	cxl_mapping_get_decoder;
 	cxl_mapping_get_region;
 	cxl_mapping_get_position;
+	cxl_decoder_get_by_name;
+	cxl_ep_decoder_get_memdev;
+	cxl_decoder_get_interleave_granularity;
+	cxl_decoder_get_interleave_ways;
 } LIBCXL_2;
-- 
2.37.1

