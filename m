Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 4FFFF1A1EC8
 for <linux-nvdimm@lists.01.org>; Sun,  8 May 2016 15:40:44 -0700 (PDT)
Subject: [ndctl PATCH 2/2] ndctl: utility support for dax devices
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 08 May 2016 15:39:56 -0700
Message-ID: <146274719671.12219.14728869739783138076.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146274718628.12219.9049769475511391374.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146274718628.12219.9049769475511391374.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Teach destroy-namespace, create-namespace, and other utility routines
considerations for dax devices.  A dax device is just another mode of a
pfn device, so adopt workalike code in routines that consider pfn
devices.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-create-namespace.txt |   12 +++++++++++
 builtin-xaction-namespace.c              |   33 +++++++++++++++++++++++++++---
 util/json.c                              |   17 +++++++++++++++
 3 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/Documentation/ndctl-create-namespace.txt b/Documentation/ndctl-create-namespace.txt
index 8d919255e04f..a2f5e5b8b9ac 100644
--- a/Documentation/ndctl-create-namespace.txt
+++ b/Documentation/ndctl-create-namespace.txt
@@ -64,6 +64,18 @@ OPTIONS
 	  "System RAM" or from a reserved portion of pmem (see the --map=
 	  option).
 
+	- "dax": Device DAX is the device-centric analogue of Filesystem
+	  DAX (CONFIG_FS_DAX).  It allows memory ranges to be allocated
+	  and mapped without need of an intervening file system.  Device
+	  DAX is strict, precise and predictable.  Specifically this
+	  interface:
+
+	  * Guarantees fault granularity with respect to a given page
+	    size (pte, pmd, or pud) set at configuration time.
+
+	  * Enforces deterministic behavior by being strict about what
+	    fault scenarios are supported.
+
 -s::
 --size=::
 	For NVDIMM devices that support namespace labels, set the
diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index d20e9167dc81..286628b16532 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -145,6 +145,8 @@ static int set_defaults(enum namespace_action mode)
 		      /* pass */;
 		else if (strcmp(param.mode, "raw") == 0)
 		      /* pass */;
+		else if (strcmp(param.mode, "dax") == 0)
+		      /* pass */;
 		else {
 			error("invalid mode '%s'\n", param.mode);
 			rc = -EINVAL;
@@ -303,6 +305,14 @@ static int setup_namespace(struct ndctl_region *region,
 		try(ndctl_pfn, set_align, pfn, SZ_2M);
 		try(ndctl_pfn, set_namespace, pfn, ndns);
 		rc = ndctl_pfn_enable(pfn);
+	} else if (p->mode == NDCTL_NS_MODE_DAX) {
+		struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
+
+		try(ndctl_dax, set_uuid, dax, uuid);
+		try(ndctl_dax, set_location, dax, p->loc);
+		try(ndctl_dax, set_align, dax, SZ_2M);
+		try(ndctl_dax, set_namespace, dax, ndns);
+		rc = ndctl_dax_enable(dax);
 	} else if (p->mode == NDCTL_NS_MODE_SAFE) {
 		struct ndctl_btt *btt = ndctl_region_get_btt_seed(region);
 
@@ -330,6 +340,7 @@ static int is_namespace_active(struct ndctl_namespace *ndns)
 {
 	return ndns && (ndctl_namespace_is_enabled(ndns)
 		|| ndctl_namespace_get_pfn(ndns)
+		|| ndctl_namespace_get_dax(ndns)
 		|| ndctl_namespace_get_btt(ndns));
 }
 
@@ -385,6 +396,8 @@ static int validate_namespace_options(struct ndctl_region *region,
 			p->mode = NDCTL_NS_MODE_SAFE;
 		else if (strcmp(param.mode, "safe") == 0)
 			p->mode = NDCTL_NS_MODE_SAFE;
+		else if (strcmp(param.mode, "dax") == 0)
+			p->mode = NDCTL_NS_MODE_DAX;
 		else
 			p->mode = NDCTL_NS_MODE_RAW;
 
@@ -431,7 +444,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 				ndctl_namespace_get_devname(ndns));
 			return -EINVAL;
 		}
-	} else if (p->mode == NDCTL_NS_MODE_MEMORY)
+	} else if (p->mode == NDCTL_NS_MODE_MEMORY || NDCTL_NS_MODE_DAX)
 		p->loc = NDCTL_PFN_LOC_PMEM;
 
 	/* check if we need, and whether the kernel supports, pfn devices */
@@ -447,6 +460,16 @@ static int validate_namespace_options(struct ndctl_region *region,
 		}
 	}
 
+	/* check if we need, and whether the kernel supports, dax devices */
+	if (p->mode == NDCTL_NS_MODE_DAX) {
+		struct ndctl_dax *dax = ndctl_region_get_dax_seed(region);
+
+		if (!dax) {
+			error("operation failed, dax mode not available\n");
+			return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
@@ -533,8 +556,10 @@ static int namespace_destroy(struct ndctl_region *region,
 {
 	const char *devname = ndctl_namespace_get_devname(ndns);
 	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
 	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
 	const char *bdev = NULL;
+	bool dax_active = false;
 	char path[50];
 	int fd, rc;
 
@@ -546,12 +571,14 @@ static int namespace_destroy(struct ndctl_region *region,
 
 	if (pfn && ndctl_pfn_is_enabled(pfn))
 		bdev = ndctl_pfn_get_block_device(pfn);
+	else if (dax && ndctl_dax_is_enabled(dax))
+		dax_active = true;
 	else if (btt && ndctl_btt_is_enabled(btt))
 		bdev = ndctl_btt_get_block_device(btt);
 	else if (ndctl_namespace_is_enabled(ndns))
 		bdev = ndctl_namespace_get_block_device(ndns);
 
-	if (bdev && !force) {
+	if ((bdev || dax_active) && !force) {
 		error("%s is active, specify --force for re-configuration\n",
 				devname);
 		return -EBUSY;
@@ -578,7 +605,7 @@ static int namespace_destroy(struct ndctl_region *region,
 		}
 	}
 
-	if (pfn || btt) {
+	if (pfn || btt || dax) {
 		rc = zero_info_block(ndns);
 		if (rc)
 			return rc;
diff --git a/util/json.c b/util/json.c
index 1d914da318fa..d144039bb559 100644
--- a/util/json.c
+++ b/util/json.c
@@ -88,10 +88,12 @@ bool util_namespace_active(struct ndctl_namespace *ndns)
 {
 	struct ndctl_btt *btt = ndctl_namespace_get_btt(ndns);
 	struct ndctl_pfn *pfn = ndctl_namespace_get_pfn(ndns);
+	struct ndctl_dax *dax = ndctl_namespace_get_dax(ndns);
 
 	if ((btt && ndctl_btt_is_enabled(btt))
 			|| (pfn && ndctl_pfn_is_enabled(pfn))
-			|| (!btt && !pfn
+			|| (dax && ndctl_dax_is_enabled(dax))
+			|| (!btt && !pfn && !dax
 				&& ndctl_namespace_is_enabled(ndns)))
 		return true;
 	return false;
@@ -106,6 +108,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
 	const char *bdev = NULL;
 	struct ndctl_btt *btt;
 	struct ndctl_pfn *pfn;
+	struct ndctl_dax *dax;
 	char buf[40];
 	uuid_t uuid;
 
@@ -118,6 +121,7 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
 	json_object_object_add(jndns, "dev", jobj);
 
 	btt = ndctl_namespace_get_btt(ndns);
+	dax = ndctl_namespace_get_dax(ndns);
 	pfn = ndctl_namespace_get_pfn(ndns);
 	mode = ndctl_namespace_get_mode(ndns);
 	switch (mode) {
@@ -128,6 +132,10 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
 			size = ndctl_namespace_get_size(ndns);
 		jobj = json_object_new_string("memory");
 		break;
+	case NDCTL_NS_MODE_DAX:
+		size = ndctl_dax_get_size(dax);
+		jobj = json_object_new_string("dax");
+		break;
 	case NDCTL_NS_MODE_SAFE:
 		jobj = json_object_new_string("sector");
 		break;
@@ -169,6 +177,13 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns)
 			goto err;
 		json_object_object_add(jndns, "uuid", jobj);
 		bdev = ndctl_pfn_get_block_device(pfn);
+	} else if (dax) {
+		ndctl_dax_get_uuid(dax, uuid);
+		uuid_unparse(uuid, buf);
+		jobj = json_object_new_string(buf);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jndns, "uuid", jobj);
 	} else if (ndctl_namespace_get_type(ndns) != ND_DEVICE_NAMESPACE_IO) {
 		const char *name;
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
