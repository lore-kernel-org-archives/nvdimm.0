Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 35D462034BBC0
 for <linux-nvdimm@lists.01.org>; Wed, 15 Nov 2017 18:21:45 -0800 (PST)
Subject: [ndctl PATCH 3/4] ndctl,
 create-namespace: introduce "fsdax" and "devdax" modes
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 15 Nov 2017 18:17:39 -0800
Message-ID: <151079865915.25456.12040009254708608223.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151079864874.25456.11655607153151633382.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151079864874.25456.11655607153151633382.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Kelly Couch <kelly.j.couch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

In hindsight "memory" was terrible name for the mode that supports a
'struct page' allocation/reservation to support filesystem-dax
operation. Now that the kernel is moving to disable "page-less" dax we
can just name this mode "fsdax" directly. The "dax" mode name is also
ambiguous so we rename it to "devdax".

The old names are still accepted as options and "ndctl listr" will only use
the new names when the --human option is specified so that scripts that
have learned the original names do not break.

The man page is refreshed to address user questions around what the
modes imply for system operation.

Reported-by: Kelly Couch <kelly.j.couch@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl/ndctl-create-namespace.txt |   98 ++++++++++++++----------
 contrib/ndctl                                  |    2 
 ndctl/libndctl.h.in                            |    2 
 ndctl/namespace.c                              |    8 +-
 util/json.c                                    |   10 ++
 5 files changed, 75 insertions(+), 45 deletions(-)

diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index 4f1f9849207f..0910edd753ab 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -15,7 +15,8 @@ include::namespace-description.txt[]
 EXAMPLES
 --------
 
-Create a maximally sized pmem namespace in 'memory' mode
+Create a maximally sized pmem namespace in 'fsdax' mode (the
+default)
 [verse]
 ndctl create-namespace
 
@@ -28,24 +29,26 @@ OPTIONS
 -t::
 --type=::
 	Create a 'pmem' or 'blk' namespace (subject to available
-	capacity).  A pmem namespace supports the DAX (direct access)
+	capacity).  A pmem namespace supports the dax (direct access)
 	capability to linkndctl:mmap[2] persistent memory directly into
 	a process address space.  A blk namespace access persistent
 	memory through a block-window-aperture.  Compared to pmem it
 	supports a traditional storage error model (EIO on error rather
 	than a cpu exception on a bad memory access), but it does not
-	support DAX.
+	support dax.
 
 -m::
 --mode=::
-	- "raw": expose the namespace capacity directly with some
-	  limitations.  Neither a raw pmem namepace nor raw blk namespace
-	  support sector atomicity by default (see "sector" mode below).  A
-	  raw pmem namespace may have limited support for passing a DAX
-	  mapping to other syscalls.  I.e. direct-I/O to/from a DAX buffer
-	  may fail for a pmem namespace in raw mode.
-
-	- "sector" or "safe": persistent memory, given that it is byte
+	- "raw": expose the namespace capacity directly with
+	  limitations.  Neither a raw pmem namepace nor raw blk
+	  namespace support sector atomicity by default (see "sector"
+	  mode below).  A raw pmem namespace may have limited to no dax
+	  support depending the kernel. In other words operations like
+	  direct-I/O targeting a dax buffer may fail for a pmem
+	  namespace in raw mode or indirect through a page-cache buffer.
+	  See "fsdax" and "devdax" mode for dax operation.
+
+	- "sector": persistent memory, given that it is byte
 	  addressable, does not support sector atomicity.  The
 	  problematic aspect of sector tearing is that most applications
 	  do not know they have a atomic sector update dependency.  At
@@ -54,27 +57,34 @@ OPTIONS
 	  Persistent memory devices will always tear and always
 	  silently.  Until an application is audited to be robust in the
 	  presence of sector-tearing "safe" mode is recommended.  This
-	  imposes some performance overhead and disables the DAX
-	  capability.
-
-	- "memory": A pmem namespace in this mode supports direct I/O
-	  to/from DAX mappings.  Depending on the kernel this mode may
-	  come at the cost of allocating per-pmem-page metadata.  If that
-	  allocation is required the capacity can be allocated from
-	  "System RAM" or from a reserved portion of pmem (see the --map=
-	  option).
-
-	- "dax": Device DAX is the device-centric analogue of Filesystem
-	  DAX (CONFIG_FS_DAX).  It allows memory ranges to be allocated
-	  and mapped without need of an intervening file system.  Device
-	  DAX is strict, precise and predictable.  Specifically this
-	  interface:
+	  imposes some performance overhead and disables the dax
+	  capability. (also known as "safe" or "btt" mode)
+
+	- "fsdax": A pmem namespace in this mode supports dax
+	  operation with a block-device based filesystem (in previous
+	  ndctl releases this mode was named "memory" mode). This mode
+	  comes at the cost of allocating per-page metadata. The
+	  capacity can be allocated from "System RAM", or from a
+	  reserved portion of "Persistent Memory" (see the --map=
+	  option).  Note that a filesystem is required for dax
+	  operation, the resulting raw block device (/dev/pmemX) will
+	  use the page cache. See "devdax" mode for raw device access
+	  that supports dax.
+
+	- "devdax": The device-dax character device interface is a
+	  statically allocated / raw access analogue of filesystem-dax
+	  (in previous ndctl releases this mode was named "dax" mode).
+	  It allows memory ranges to be mapped without need of an
+	  intervening filesystem.  The device-dax is interface strict,
+	  precise and predictable. Specifically the interface:
 
 	  * Guarantees fault granularity with respect to a given page
-	    size (pte, pmd, or pud) set at configuration time.
+	    size (4K, 2M, or 1G on x86) set at configuration time.
 
 	  * Enforces deterministic behavior by being strict about what
-	    fault scenarios are supported.
+	    fault scenarios are supported. I.e. if a device is
+	    configured with a 2M alignment an attempt to fault a 4K
+	    aligned offset will result in SIGBUS.
 
 -s::
 --size=::
@@ -90,12 +100,16 @@ OPTIONS
 
 -a::
 --align::
-	Applications that want to establish DAX memory mappings
-	with page table entries greater than 4K in size need a
-	persistent memory namespace that is sufficiently aligned. For
-	"memory" and "dax" mode this defaults to 2M. Note that "dax"
-	mode enforces all mappings to be aligned to this value,
-	i.e. fails unaligned mapping attempts.
+	Applications that want to establish dax memory mappings with
+	page table entries greater than system base page size (4K on
+	x86) need a persistent memory namespace that is sufficiently
+	aligned. For "fsdax" and "devdax" mode this defaults to 2M.
+	Note that "devdax" mode enforces all mappings to be aligned to
+	this value, i.e. it fails unaligned mapping attempts. The
+	"fsdax" alignment setting determines the starting alignment of
+	filesystem extents and may limit the possible granularities,
+	if a large mapping is not possible it will silently fall back
+	to a smaller page size.
 
 -e::
 --reconfig=::
@@ -116,21 +130,25 @@ OPTIONS
 --name=::
 	For NVDIMM devices that support namespace labels,
 	specify a human friendly name for a namespace.  This name is
-	available as device attribute for use in udev rules or
-	elsewhere.
+	available as a device attribute for use in udev rules.
 
 -l::
 --sector-size::
-	Specify the logical sector size (LBA size) of the block storage
-	device associated with a namespace.
+	Specify the logical sector size (LBA size) of the
+	Linux block device associated with an namespace.
 
 -M::
 --map=::
-	A pmem namespace in "memory" mode may require allocation
-	of per-page metadata.  The allocation can be drawn from either:
+	A pmem namespace in "fsdax" or "devdax" mode requires allocation of
+	per-page metadata.  The allocation can be drawn from either:
 	- "mem": typical system memory
 	- "dev": persistent memory reserved from the namespace
 
+	Given relative capacities of "Persistent Memory" to "System
+	RAM" the allocation defaults to reserving space out of the
+	namespace directly ("--map=dev"). The overhead is 64-bytes per
+	4K (16GB per 1TB) on x86.
+
 -f::
 --force::
 	Unless this option is specified the 'reconfigure namespace'
diff --git a/contrib/ndctl b/contrib/ndctl
index 86718eb4fa4a..d98386807769 100755
--- a/contrib/ndctl
+++ b/contrib/ndctl
@@ -188,7 +188,7 @@ __ndctl_comp_options()
 			fi
 			;;
 		--mode)
-			opts="raw sector memory dax"
+			opts="raw sector fsdax devdax memory dax"
 			if [[ "$type_filter" == "blk" ]]; then
 				opts="raw sector"
 			fi
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index a42a7a4105b9..fb77d243a893 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -511,9 +511,11 @@ const char *ndctl_namespace_get_type_name(struct ndctl_namespace *ndns);
 const char *ndctl_namespace_get_block_device(struct ndctl_namespace *ndns);
 enum ndctl_namespace_mode {
 	NDCTL_NS_MODE_MEMORY,
+	NDCTL_NS_MODE_FSDAX = NDCTL_NS_MODE_MEMORY,
 	NDCTL_NS_MODE_SAFE,
 	NDCTL_NS_MODE_RAW,
 	NDCTL_NS_MODE_DAX,
+	NDCTL_NS_MODE_DEVDAX = NDCTL_NS_MODE_DAX,
 	NDCTL_NS_MODE_UNKNOWN, /* must be last entry */
 };
 enum ndctl_namespace_mode ndctl_namespace_get_mode(
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 970515570ce9..d31244b71c37 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -171,10 +171,14 @@ static int set_defaults(enum device_action mode)
 		      param.mode = "safe"; /* pass */
 		else if (strcmp(param.mode, "memory") == 0)
 		      /* pass */;
+		else if (strcmp(param.mode, "fsdax") == 0)
+			param.mode = "memory"; /* pass */
 		else if (strcmp(param.mode, "raw") == 0)
 		      /* pass */;
 		else if (strcmp(param.mode, "dax") == 0)
 		      /* pass */;
+		else if (strcmp(param.mode, "devdax") == 0)
+			param.mode = "dax"; /* pass */
 		else {
 			error("invalid mode '%s'\n", param.mode);
 			rc = -EINVAL;
@@ -200,7 +204,7 @@ static int set_defaults(enum device_action mode)
 		if (!param.reconfig && param.mode
 				&& strcmp(param.mode, "memory") != 0
 				&& strcmp(param.mode, "dax") != 0) {
-			error("--map only valid for a memory mode pmem namespace\n");
+			error("--map only valid for an dax mode pmem namespace\n");
 			rc = -EINVAL;
 		}
 	} else if (!param.reconfig)
@@ -514,7 +518,7 @@ static int validate_namespace_options(struct ndctl_region *region,
 					|| p->mode == NDCTL_NS_MODE_DAX)) {
 			debug("blk %s does not support %s mode\n", region_name,
 					p->mode == NDCTL_NS_MODE_MEMORY
-					? "memory" : "dax");
+					? "fsdax" : "devdax");
 			return -EAGAIN;
 		}
 	} else if (ndns)
diff --git a/util/json.c b/util/json.c
index 02a4e93d48b4..f49921236823 100644
--- a/util/json.c
+++ b/util/json.c
@@ -679,13 +679,19 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
 			size = ndctl_pfn_get_size(pfn);
 		else /* native/static memory mode */
 			size = ndctl_namespace_get_size(ndns);
-		jobj = json_object_new_string("memory");
+		if (flags & UTIL_JSON_HUMAN)
+			jobj = json_object_new_string("fsdax");
+		else
+			jobj = json_object_new_string("memory");
 		break;
 	case NDCTL_NS_MODE_DAX:
 		if (!dax)
 			goto err;
 		size = ndctl_dax_get_size(dax);
-		jobj = json_object_new_string("dax");
+		if (flags & UTIL_JSON_HUMAN)
+			jobj = json_object_new_string("devdax");
+		else
+			jobj = json_object_new_string("dax");
 		break;
 	case NDCTL_NS_MODE_SAFE:
 		if (!btt)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
