Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802201D0E0D
	for <nvdimm@lists.linux.dev>; Wed, 30 Oct 2024 21:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730325317; cv=none; b=qTQKHjVjcStIB+Yi7BY/AG+NpiiQi+138aDJ3zQDUP4YytYfBACbPs7FpsdawpGbmeaTHEVxOt51e085AB3/4sx1QATzJ1UPy3ppThQycaYz9Znvj5QXUomameq8AkKT5ygu0rURcfTf+GYgYwAA+dQFoieGzyoPJ5eOPvOmdOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730325317; c=relaxed/simple;
	bh=9a1sAnRX7zf6QJZHCa5uRKk1d/kP28qRgid/slWPCtw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=T5z0jQDyGt1OtMDFdjEfnqMR+q80eyCFRJb9yBleCCUyfuFtZOZT3dBa/wjrConSejTUhutcy+zfXYroD1c8JFhCspwDnGkmiVkAmilmz6zBUgel5Ee+GSUze/QoX843IhU/D7fbChkN99L586wp81phVFJafXEDm0npqktJnv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jyzGauJx; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jyzGauJx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730325314; x=1761861314;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=9a1sAnRX7zf6QJZHCa5uRKk1d/kP28qRgid/slWPCtw=;
  b=jyzGauJxS2/IoeFX3IN0xZLm5P/zjWPqlMVLpbWaAu5Y2OnFKoPI9C39
   AFo8sCKnUto0CG6LMiSQ8ZhTdLmy6y9tzcuUoEippXw+d1yJq0kCOSXR2
   0o8Ki3wBlFVqPueUXGJSumTS6Tz4CqnaCyMObcoZq5bSHQJpzd+3JcR2m
   r4uw9VwSJ+F5hvYO8zE+n/wjEINKFVBoHfyuIng+o4qlVT1sIuWfyha65
   3+kNqejTBSgzsGVS8tZwrLvnq5G5FWaTtkX/fo1r64LbSoC1IDI/3M23k
   g1khUbtz8BVLUEf32dw/q4/XZt0uQ4SijqCiIbLpBmPg3Q4SrWuqwNnvD
   w==;
X-CSE-ConnectionGUID: +bXnFXSSRaKc3XF4Lu1FIA==
X-CSE-MsgGUID: 2QFrB/D2TAW5b1d7JtH5Lw==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="40620539"
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="40620539"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 14:55:13 -0700
X-CSE-ConnectionGUID: H7UK86xTScW7QbWVr3GA9A==
X-CSE-MsgGUID: hPwBkY75SoCi0y6WiO9xEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="119899977"
Received: from msatwood-mobl.amr.corp.intel.com (HELO localhost) ([10.125.108.161])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 14:55:12 -0700
From: ira.weiny@intel.com
Date: Wed, 30 Oct 2024 16:54:47 -0500
Subject: [ndctl PATCH 4/6] cxl/region: Add creation of Dynamic capacity
 regions
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241030-dcd-region2-v1-4-04600ba2b48e@intel.com>
References: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
In-Reply-To: <20241030-dcd-region2-v1-0-04600ba2b48e@intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, 
 Jonathan Cameron <jonathan.cameron@Huawei.com>, Fan Ni <fan.ni@samsung.com>, 
 Navneet Singh <navneet.singh@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>, Sushant1 Kumar <sushant1.kumar@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730325302; l=21119;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=FVsSpGStbX5yclkjrSSbkTX6IUp5xgqEI5oxJhk5glM=;
 b=qx2V9YpQzdPFDdBjgFCRSysfE9UdyJAg3gFZafIZL7gENY1qDzNhRZU8witSkScr3XEUFnpoi
 0KHm2eTcNs9DC4pmpr4WIZfZ9wenby0P1SPJOsqb1LdlOd+VaDzkM2t
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
spare and defined as dynamic capacity (dc).

Add support for DCD devices.  Query for DCD capabilities.  Add the
ability to add DC partitions to a CXL DC region.

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Co-authored-by: Sushant1 Kumar <sushant1.kumar@intel.com>
Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
Co-authored-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: adjust to new sysfs interface.]
[iweiny: Rebase to latest pending]
[iweiny: Adjust DCD region code to new upstream sysfs entries]
[iweiny: Ensure backwards compatibility for non-DC kernels]
[iweiny: fixup help message to show DC type]
[iweiny: don't double declare decoder mode is dc]
[iweiny: simplify __reserve_dpa() with decoder mode to index]
[iweiny: Adjust to the new region mode]
---
 cxl/json.c         | 26 +++++++++++++++
 cxl/lib/libcxl.c   | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 cxl/lib/libcxl.sym |  3 ++
 cxl/lib/private.h  |  6 +++-
 cxl/libcxl.h       | 55 +++++++++++++++++++++++++++++--
 cxl/memdev.c       |  7 +++-
 cxl/region.c       | 49 ++++++++++++++++++++++++++--
 7 files changed, 234 insertions(+), 7 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index dcd3cc28393faf7e8adf299a857531ecdeaac50a..4276b9678d7e03eaf2aec581a08450f2a0b857f2 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -754,10 +754,12 @@ err_free:
 	return jpoison;
 }
 
+#define DC_SIZE_NAME_LEN 64
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
 	const char *devname = cxl_memdev_get_devname(memdev);
+	char size_name[DC_SIZE_NAME_LEN];
 	struct json_object *jdev, *jobj;
 	unsigned long long serial, size;
 	const char *fw_version;
@@ -800,6 +802,17 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		}
 	}
 
+	for (int index; index < MAX_NUM_DC_REGIONS; index++) {
+		size = cxl_memdev_get_dc_size(memdev, index);
+		if (size) {
+			jobj = util_json_object_size(size, flags);
+			if (jobj) {
+				sprintf(size_name, "dc%d_size", index);
+				json_object_object_add(jdev,
+						       size_name, jobj);
+			}
+		}
+	}
 	if (flags & UTIL_JSON_HEALTH) {
 		jobj = util_cxl_memdev_health_to_json(memdev, flags);
 		if (jobj)
@@ -948,11 +961,13 @@ struct json_object *util_cxl_bus_to_json(struct cxl_bus *bus,
 	return jbus;
 }
 
+#define DC_CAPABILITY_NAME_LEN 16
 struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 					     unsigned long flags)
 {
 	const char *devname = cxl_decoder_get_devname(decoder);
 	struct cxl_port *port = cxl_decoder_get_port(decoder);
+	char dc_capable_name[DC_CAPABILITY_NAME_LEN];
 	struct json_object *jdecoder, *jobj;
 	struct cxl_region *region;
 	u64 val, size;
@@ -1059,6 +1074,17 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 				json_object_object_add(
 					jdecoder, "volatile_capable", jobj);
 		}
+		for (int index = 0; index < MAX_NUM_DC_REGIONS; index++) {
+			if (cxl_decoder_is_dc_capable(decoder, index)) {
+				jobj = json_object_new_boolean(true);
+				if (jobj) {
+					sprintf(dc_capable_name, "dc%d_capable", index);
+					json_object_object_add(jdecoder,
+							       dc_capable_name,
+							       jobj);
+				}
+			}
+		}
 	}
 
 	if (cxl_port_is_root(port) &&
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 5cbfb3e7d466b491ef87ea285f7e50d3bac230db..4caa2d02313bf71960971c4eaa67fa42cea08d55 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1267,7 +1267,6 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	char buf[SYSFS_ATTR_SIZE];
 	struct stat st;
 	char *host;
-
 	if (!path)
 		return NULL;
 	dbg(ctx, "%s: base: \'%s\'\n", devname, cxlmem_base);
@@ -1304,6 +1303,19 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	else
 		memdev->ram_qos_class = atoi(buf);
 
+	memdev->dc_partition_count = 0;
+	for (int partition = 0; partition < MAX_NUM_DC_REGIONS; partition++) {
+		sprintf(path, "%s/dc%d/size", cxlmem_base, partition);
+		if (sysfs_read_attr(ctx, path, buf) < 0)
+			continue;
+		memdev->dc_size[partition] = strtoull(buf, NULL, 0);
+		memdev->dc_partition_count++;
+		sprintf(path, "%s/dc%d/qos_class", cxlmem_base, partition);
+		if (sysfs_read_attr(ctx, path, buf) < 0)
+			continue;
+		memdev->dc_qos_class[partition] = strtoull(buf, NULL, 0);
+	}
+
 	sprintf(path, "%s/payload_max", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0) {
 		memdev->payload_max = strtoull(buf, NULL, 0);
@@ -1540,6 +1552,14 @@ CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
 	return memdev->ram_qos_class;
 }
 
+CXL_EXPORT unsigned long long cxl_memdev_get_dc_size(struct cxl_memdev *memdev, int index)
+{
+	if (index >= 0 && index < MAX_NUM_DC_REGIONS)
+		return memdev->dc_size[index];
+
+	return 0;
+}
+
 CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev)
 {
 	return memdev->firmware_version;
@@ -2275,6 +2295,22 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			decoder->mode = CXL_DECODER_MODE_RAM;
 		else if (strcmp(buf, "pmem") == 0)
 			decoder->mode = CXL_DECODER_MODE_PMEM;
+		else if (strcmp(buf, "dc0") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC0;
+		else if (strcmp(buf, "dc1") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC1;
+		else if (strcmp(buf, "dc2") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC2;
+		else if (strcmp(buf, "dc3") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC3;
+		else if (strcmp(buf, "dc4") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC4;
+		else if (strcmp(buf, "dc5") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC5;
+		else if (strcmp(buf, "dc6") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC6;
+		else if (strcmp(buf, "dc7") == 0)
+			decoder->mode = CXL_DECODER_MODE_DC7;
 		else if (strcmp(buf, "mixed") == 0)
 			decoder->mode = CXL_DECODER_MODE_MIXED;
 		else if (strcmp(buf, "none") == 0)
@@ -2318,6 +2354,14 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	case CXL_PORT_SWITCH:
 		decoder->pmem_capable = true;
 		decoder->volatile_capable = true;
+		decoder->dc_capable[0] = true;
+		decoder->dc_capable[1] = true;
+		decoder->dc_capable[2] = true;
+		decoder->dc_capable[3] = true;
+		decoder->dc_capable[4] = true;
+		decoder->dc_capable[5] = true;
+		decoder->dc_capable[6] = true;
+		decoder->dc_capable[7] = true;
 		decoder->mem_capable = true;
 		decoder->accelmem_capable = true;
 		sprintf(path, "%s/locked", cxldecoder_base);
@@ -2341,6 +2385,14 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			{ "cap_type2", &decoder->accelmem_capable },
 			{ "cap_type3", &decoder->mem_capable },
 			{ "cap_ram", &decoder->volatile_capable },
+			{ "cap_ram", &decoder->dc_capable[0] },
+			{ "cap_ram", &decoder->dc_capable[1] },
+			{ "cap_ram", &decoder->dc_capable[2] },
+			{ "cap_ram", &decoder->dc_capable[3] },
+			{ "cap_ram", &decoder->dc_capable[4] },
+			{ "cap_ram", &decoder->dc_capable[5] },
+			{ "cap_ram", &decoder->dc_capable[6] },
+			{ "cap_ram", &decoder->dc_capable[7] },
 			{ "cap_pmem", &decoder->pmem_capable },
 			{ "locked", &decoder->locked },
 		};
@@ -2592,6 +2644,30 @@ CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
 	case CXL_DECODER_MODE_RAM:
 		sprintf(buf, "ram");
 		break;
+	case CXL_DECODER_MODE_DC0:
+		sprintf(buf, "dc0");
+		break;
+	case CXL_DECODER_MODE_DC1:
+		sprintf(buf, "dc1");
+		break;
+	case CXL_DECODER_MODE_DC2:
+		sprintf(buf, "dc2");
+		break;
+	case CXL_DECODER_MODE_DC3:
+		sprintf(buf, "dc3");
+		break;
+	case CXL_DECODER_MODE_DC4:
+		sprintf(buf, "dc4");
+		break;
+	case CXL_DECODER_MODE_DC5:
+		sprintf(buf, "dc5");
+		break;
+	case CXL_DECODER_MODE_DC6:
+		sprintf(buf, "dc6");
+		break;
+	case CXL_DECODER_MODE_DC7:
+		sprintf(buf, "dc7");
+		break;
 	default:
 		err(ctx, "%s: unsupported mode: %d\n",
 		    cxl_decoder_get_devname(decoder), mode);
@@ -2648,6 +2724,14 @@ CXL_EXPORT bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder)
 	return decoder->mem_capable;
 }
 
+CXL_EXPORT bool cxl_decoder_is_dc_capable(struct cxl_decoder *decoder, int index)
+{
+	if (index >= 0 && index < MAX_NUM_DC_REGIONS)
+		return decoder->dc_capable[index];
+
+	return 0;
+}
+
 CXL_EXPORT bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder)
 {
 	return decoder->accelmem_capable;
@@ -2717,6 +2801,8 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
 		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
 	else if (mode == CXL_DECODER_MODE_RAM)
 		sprintf(path, "%s/create_ram_region", decoder->dev_path);
+	else if (cxl_decoder_mode_is_dc(mode))
+		sprintf(path, "%s/create_dc_region", decoder->dev_path);
 
 	rc = sysfs_read_attr(ctx, path, buf);
 	if (rc < 0) {
@@ -2768,6 +2854,13 @@ cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
 	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
 }
 
+CXL_EXPORT struct cxl_region *
+cxl_decoder_create_dc_region(struct cxl_decoder *decoder,
+			     enum cxl_decoder_mode mode)
+{
+	return cxl_decoder_create_region(decoder, mode);
+}
+
 CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
 {
 	return decoder->nr_targets;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index b5d9bdcc38e09812f26afc1cb0e804f86784b8e6..351da7512e05080d847fd87740488d613462dbc9 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -19,6 +19,7 @@ global:
 	cxl_memdev_get_ctx;
 	cxl_memdev_get_pmem_size;
 	cxl_memdev_get_ram_size;
+	cxl_memdev_get_dc_size;
 	cxl_memdev_get_firmware_verison;
 	cxl_cmd_get_devname;
 	cxl_cmd_new_raw;
@@ -247,6 +248,8 @@ LIBCXL_5 {
 global:
 	cxl_region_get_mode;
 	cxl_decoder_create_ram_region;
+	cxl_decoder_is_dc_capable;
+	cxl_decoder_create_dc_region;
 	cxl_region_get_daxctl_region;
 	cxl_port_get_parent_dport;
 } LIBCXL_4;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 0f45be89b6a00477d13fb6d7f1906213a3073c48..10abfa63dfc759b1589f9f039da1b920f8eb605e 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -12,7 +12,6 @@
 #include <util/bitmap.h>
 
 #define CXL_EXPORT __attribute__ ((visibility("default")))
-
 struct cxl_pmem {
 	int id;
 	void *dev_buf;
@@ -47,6 +46,9 @@ struct cxl_memdev {
 	struct list_node list;
 	unsigned long long pmem_size;
 	unsigned long long ram_size;
+	unsigned long long dc_size[MAX_NUM_DC_REGIONS];
+	unsigned long long dc_qos_class[MAX_NUM_DC_REGIONS];
+	int dc_partition_count;
 	int ram_qos_class;
 	int pmem_qos_class;
 	int payload_max;
@@ -111,6 +113,7 @@ struct cxl_endpoint {
 	struct cxl_memdev *memdev;
 };
 
+
 struct cxl_target {
 	struct list_node list;
 	struct cxl_decoder *decoder;
@@ -140,6 +143,7 @@ struct cxl_decoder {
 	bool pmem_capable;
 	bool volatile_capable;
 	bool mem_capable;
+	bool dc_capable[MAX_NUM_DC_REGIONS];
 	bool accelmem_capable;
 	bool locked;
 	enum cxl_decoder_target_type target_type;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 06b87a0924faafec6c80eca83ea7551d4e117256..17ed682548b970d57f016942badc76dce61bdeaf 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -72,6 +72,7 @@ int cxl_memdev_get_minor(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+unsigned long long cxl_memdev_get_dc_size(struct cxl_memdev *memdev, int index);
 int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
 int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
@@ -191,11 +192,20 @@ unsigned long long
 cxl_decoder_get_max_available_extent(struct cxl_decoder *decoder);
 int cxl_root_decoder_get_qos_class(struct cxl_decoder *decoder);
 
+#define MAX_NUM_DC_REGIONS 8
 enum cxl_decoder_mode {
 	CXL_DECODER_MODE_NONE,
 	CXL_DECODER_MODE_MIXED,
 	CXL_DECODER_MODE_PMEM,
 	CXL_DECODER_MODE_RAM,
+	CXL_DECODER_MODE_DC0,
+	CXL_DECODER_MODE_DC1,
+	CXL_DECODER_MODE_DC2,
+	CXL_DECODER_MODE_DC3,
+	CXL_DECODER_MODE_DC4,
+	CXL_DECODER_MODE_DC5,
+	CXL_DECODER_MODE_DC6,
+	CXL_DECODER_MODE_DC7,
 };
 
 static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
@@ -205,9 +215,17 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 		[CXL_DECODER_MODE_MIXED] = "mixed",
 		[CXL_DECODER_MODE_PMEM] = "pmem",
 		[CXL_DECODER_MODE_RAM] = "ram",
+		[CXL_DECODER_MODE_DC0] = "dc0",
+		[CXL_DECODER_MODE_DC1] = "dc1",
+		[CXL_DECODER_MODE_DC2] = "dc2",
+		[CXL_DECODER_MODE_DC3] = "dc3",
+		[CXL_DECODER_MODE_DC4] = "dc4",
+		[CXL_DECODER_MODE_DC5] = "dc5",
+		[CXL_DECODER_MODE_DC6] = "dc6",
+		[CXL_DECODER_MODE_DC7] = "dc7",
 	};
 
-	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_RAM)
+	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_DC7)
 		mode = CXL_DECODER_MODE_NONE;
 	return names[mode];
 }
@@ -221,9 +239,35 @@ cxl_decoder_mode_from_ident(const char *ident)
 		return CXL_DECODER_MODE_RAM;
 	else if (strcmp(ident, "pmem") == 0)
 		return CXL_DECODER_MODE_PMEM;
+	else if (strcmp(ident, "dc0") == 0)
+		return CXL_DECODER_MODE_DC0;
+	else if (strcmp(ident, "dc1") == 0)
+		return CXL_DECODER_MODE_DC1;
+	else if (strcmp(ident, "dc2") == 0)
+		return CXL_DECODER_MODE_DC2;
+	else if (strcmp(ident, "dc3") == 0)
+		return CXL_DECODER_MODE_DC3;
+	else if (strcmp(ident, "dc4") == 0)
+		return CXL_DECODER_MODE_DC4;
+	else if (strcmp(ident, "dc5") == 0)
+		return CXL_DECODER_MODE_DC5;
+	else if (strcmp(ident, "dc6") == 0)
+		return CXL_DECODER_MODE_DC6;
+	else if (strcmp(ident, "dc7") == 0)
+		return CXL_DECODER_MODE_DC7;
 	return CXL_DECODER_MODE_NONE;
 }
 
+static inline bool cxl_decoder_mode_is_dc(enum cxl_decoder_mode mode)
+{
+	return (mode >= CXL_DECODER_MODE_DC0 && mode <= CXL_DECODER_MODE_DC7);
+}
+
+static inline int cxl_decoder_dc_mode_to_index(enum cxl_decoder_mode mode)
+{
+	return mode - CXL_DECODER_MODE_DC0;
+}
+
 enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
 int cxl_decoder_set_mode(struct cxl_decoder *decoder,
 			 enum cxl_decoder_mode mode);
@@ -248,6 +292,7 @@ enum cxl_decoder_target_type {
 enum cxl_decoder_target_type
 cxl_decoder_get_target_type(struct cxl_decoder *decoder);
 bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
+bool cxl_decoder_is_dc_capable(struct cxl_decoder *decoder, int index);
 bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
@@ -258,6 +303,8 @@ unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *decoder);
+struct cxl_region *cxl_decoder_create_dc_region(struct cxl_decoder *decoder,
+						enum cxl_decoder_mode mode);
 struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
 					    const char *ident);
 struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);
@@ -308,6 +355,7 @@ enum cxl_region_mode {
 	CXL_REGION_MODE_MIXED = CXL_DECODER_MODE_MIXED,
 	CXL_REGION_MODE_PMEM = CXL_DECODER_MODE_PMEM,
 	CXL_REGION_MODE_RAM = CXL_DECODER_MODE_RAM,
+	CXL_REGION_MODE_DC,
 };
 
 static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
@@ -317,9 +365,10 @@ static inline const char *cxl_region_mode_name(enum cxl_region_mode mode)
 		[CXL_REGION_MODE_MIXED] = "mixed",
 		[CXL_REGION_MODE_PMEM] = "pmem",
 		[CXL_REGION_MODE_RAM] = "ram",
+		[CXL_REGION_MODE_DC] = "dc",
 	};
 
-	if (mode < CXL_REGION_MODE_NONE || mode > CXL_REGION_MODE_RAM)
+	if (mode < CXL_REGION_MODE_NONE || mode > CXL_REGION_MODE_DC)
 		mode = CXL_REGION_MODE_NONE;
 	return names[mode];
 }
@@ -333,6 +382,8 @@ cxl_region_mode_from_ident(const char *ident)
 		return CXL_REGION_MODE_RAM;
 	else if (strcmp(ident, "pmem") == 0)
 		return CXL_REGION_MODE_PMEM;
+	else if (strcmp(ident, "dc") == 0)
+		return CXL_REGION_MODE_DC;
 	return CXL_REGION_MODE_NONE;
 }
 
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 6e44d1578d03b6af998502e54714635b8f31b556..0a7d350efe9e612cd67d32328cca286dcdcb2991 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -269,8 +269,13 @@ static int __reserve_dpa(struct cxl_memdev *memdev,
 
 	if (mode == CXL_DECODER_MODE_RAM)
 		avail_dpa = cxl_memdev_get_ram_size(memdev);
-	else
+	else if (mode == CXL_DECODER_MODE_PMEM)
 		avail_dpa = cxl_memdev_get_pmem_size(memdev);
+	else if (cxl_decoder_mode_is_dc(mode)) {
+		int i = cxl_decoder_dc_mode_to_index(mode);
+
+		avail_dpa = cxl_memdev_get_dc_size(memdev, i);
+	}
 
 	cxl_decoder_foreach(port, decoder) {
 		size = cxl_decoder_get_dpa_size(decoder);
diff --git a/cxl/region.c b/cxl/region.c
index 207cf2d003148992255c715f286bc0f38de2ca84..310694ae07fae25f13d032a30c130bf7d3394388 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -78,7 +78,7 @@ OPT_INTEGER('w', "ways", &param.ways, \
 OPT_INTEGER('g', "granularity", &param.granularity,  \
 	    "granularity of the interleave set"), \
 OPT_STRING('t', "type", &param.type, \
-	   "region type", "region type - 'pmem' or 'ram'"), \
+	   "region type", "region type - 'pmem', 'ram', 'dcX'"), \
 OPT_STRING('U', "uuid", &param.uuid, \
 	   "region uuid", "uuid for the new region (default: autogenerate)"), \
 OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
@@ -400,9 +400,22 @@ static int parse_region_options(int argc, const char **argv,
 	}
 }
 
+static int dc_mode_to_region_index(enum cxl_decoder_mode mode)
+{
+	int index = 0;
+
+	for (unsigned int i = CXL_DECODER_MODE_DC0; i <= CXL_DECODER_MODE_DC7; i++) {
+		if (mode == i)
+			return index;
+		index++;
+	}
+
+	return -EINVAL;
+}
+
 static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
 {
-	int i;
+	int i, index;
 
 	for (i = 0; i < p->ways; i++) {
 		struct json_object *jobj =
@@ -417,6 +430,10 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
 		case CXL_DECODER_MODE_PMEM:
 			size = cxl_memdev_get_pmem_size(memdev);
 			break;
+		case CXL_DECODER_MODE_DC0 ... CXL_DECODER_MODE_DC7:
+			index =  dc_mode_to_region_index(p->mode);
+			size = cxl_memdev_get_dc_size(memdev, index);
+			break;
 		default:
 			/* Shouldn't ever get here */ ;
 		}
@@ -473,6 +490,7 @@ static int validate_decoder(struct cxl_decoder *decoder,
 			    struct parsed_params *p)
 {
 	const char *devname = cxl_decoder_get_devname(decoder);
+	int index;
 	int rc;
 
 	switch(p->mode) {
@@ -488,6 +506,13 @@ static int validate_decoder(struct cxl_decoder *decoder,
 			return -EINVAL;
 		}
 		break;
+	case CXL_DECODER_MODE_DC0 ... CXL_DECODER_MODE_DC7:
+		index =  dc_mode_to_region_index(p->mode);
+		if (!cxl_decoder_is_dc_capable(decoder, index)) {
+			log_err(&rl, "%s is not dc%d capable\n", devname, index);
+			return -EINVAL;
+		}
+		break;
 	default:
 		log_err(&rl, "unknown type: %s\n", param.type);
 		return -EINVAL;
@@ -502,12 +527,25 @@ static int validate_decoder(struct cxl_decoder *decoder,
 	return 0;
 }
 
+static enum cxl_decoder_mode dc_region_index_to_mode(int index)
+{
+	return (CXL_DECODER_MODE_DC0 + index);
+}
+
 static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
 {
 	/* if param.type was explicitly specified, nothing to do here */
 	if (param.type)
 		return;
 
+	/* Only chose DC if it is the only type available */
+	for (int index = 0; index < MAX_NUM_DC_REGIONS; index++) {
+		if (cxl_decoder_is_dc_capable(p->root_decoder, index)) {
+			p->mode = dc_region_index_to_mode(index);
+			break;
+		}
+	}
+
 	/*
 	 * default to pmem if both types are set, otherwise the single
 	 * capability dominates.
@@ -699,6 +737,13 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 				param.root_decoder);
 			return -ENXIO;
 		}
+	} else if (cxl_decoder_mode_is_dc(p->mode)) {
+		region = cxl_decoder_create_dc_region(p->root_decoder, p->mode);
+		if (!region) {
+			log_err(&rl, "failed to create region under %s\n",
+				param.root_decoder);
+			return -ENXIO;
+		}
 	} else {
 		log_err(&rl, "region type '%s' is not supported\n",
 			param.type);

-- 
2.47.0

