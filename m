Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 78D3621962301
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 15:40:47 -0700 (PDT)
From: Keith Busch <keith.busch@intel.com>
Subject: [ndctl PATCH] ndctl: Add reconfigure-namespace command
Date: Wed,  8 Aug 2018 16:40:45 -0600
Message-Id: <20180808224045.16667-1-keith.busch@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Namespace reconfiguration was the only utility 'verb' in ndctl that
did not have its own command. This patch provides a new command,
"reconfigure-namespace <namespace>".

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 Documentation/ndctl/Makefile.am                    |   1 +
 Documentation/ndctl/ndctl-create-namespace.txt     |   1 +
 .../ndctl/ndctl-reconfigure-namespace.txt          | 199 +++++++++++++++++++++
 builtin.h                                          |   1 +
 ndctl/action.h                                     |   1 +
 ndctl/namespace.c                                  |  44 +++++
 ndctl/ndctl.c                                      |   1 +
 7 files changed, 248 insertions(+)
 create mode 100644 Documentation/ndctl/ndctl-reconfigure-namespace.txt

diff --git a/Documentation/ndctl/Makefile.am b/Documentation/ndctl/Makefile.am
index a30b139..d1ec67c 100644
--- a/Documentation/ndctl/Makefile.am
+++ b/Documentation/ndctl/Makefile.am
@@ -41,6 +41,7 @@ man1_MANS = \
 	ndctl-enable-namespace.1 \
 	ndctl-disable-namespace.1 \
 	ndctl-create-namespace.1 \
+	ndctl-reconfigure-namespace.1 \
 	ndctl-destroy-namespace.1 \
 	ndctl-check-namespace.1 \
 	ndctl-inject-error.1 \
diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index 343733d..9250a76 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -219,5 +219,6 @@ linkndctl:ndctl-zero-labels[1],
 linkndctl:ndctl-init-labels[1],
 linkndctl:ndctl-disable-namespace[1],
 linkndctl:ndctl-enable-namespace[1],
+linkndctl:ndctl-reconfigure-namespace[1],
 http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]
 https://nvdimm.wiki.kernel.org[Linux Persistent Memory Wiki]
diff --git a/Documentation/ndctl/ndctl-reconfigure-namespace.txt b/Documentation/ndctl/ndctl-reconfigure-namespace.txt
new file mode 100644
index 0000000..dcd9fa8
--- /dev/null
+++ b/Documentation/ndctl/ndctl-reconfigure-namespace.txt
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0
+
+ndctl-reconfigure-namespace(1)
+==============================
+
+NAME
+----
+ndctl-reconfigure-namespace - reconfigure a namespace
+
+SYNOPSIS
+--------
+[verse]
+'ndctl reconfigure-namespace' namespace [<options>]
+
+include::namespace-description.txt[]
+
+EXAMPLES
+--------
+
+Convert namespace0.0 to mapping to 'mem'
+[verse]
+ndctl reconfigure-namespace namespace0.0 -f --map=mem
+
+Convert namespace0.0 size to 10G
+[verse]
+ndctl reconfigure-namespace namespace0.0 -f --size=10G
+
+OPTIONS
+-------
+-m::
+--mode=::
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
+	  addressable, does not support sector atomicity.  The
+	  problematic aspect of sector tearing is that most applications
+	  do not know they have a atomic sector update dependency.  At
+	  least a disk rarely ever tears sectors and if it does it
+	  almost certainly returns a checksum error on access.
+	  Persistent memory devices will always tear and always
+	  silently.  Until an application is audited to be robust in the
+	  presence of sector-tearing "safe" mode is recommended.  This
+	  imposes some performance overhead and disables the dax
+	  capability. (also known as "safe" or "btt" mode)
+
+	- "fsdax": A pmem namespace in this mode supports dax
+	  operation with a block-device based filesystem (in previous
+	  ndctl releases this mode was named "memory" mode). This mode
+	  comes at the cost of allocating per-page metadata. The
+	  capacity can be allocated from "System RAM", or from a
+	  reserved portion of "Persistent Memory" (see the --map=
+	  option).  NOTE: A filesystem that supports DAX is required
+	  for dax operation. If the raw block device (/dev/pmemX) is
+	  used directly without a filesystem, it will use the page
+	  cache. See "devdax" mode for raw device access that supports
+	  dax.
+
+	- "devdax": The device-dax character device interface is a
+	  statically allocated / raw access analogue of filesystem-dax
+	  (in previous ndctl releases this mode was named "dax" mode).
+	  It allows memory ranges to be mapped without need of an
+	  intervening filesystem.  The device-dax is interface strict,
+	  precise and predictable. Specifically the interface:
+
+	  * Guarantees fault granularity with respect to a given page
+	    size (4K, 2M, or 1G on x86) set at configuration time.
+
+	  * Enforces deterministic behavior by being strict about what
+	    fault scenarios are supported. I.e. if a device is
+	    configured with a 2M alignment an attempt to fault a 4K
+	    aligned offset will result in SIGBUS.
+
+-s::
+--size=::
+	For NVDIMM devices that support namespace labels, set the
+	namespace size in bytes.  Otherwise it defaults to the maximum
+	size specified by platform firmware.  This option supports the
+	suffixes "k" or "K" for KiB, "m" or "M" for MiB, "g" or "G" for
+	GiB and "t" or "T" for TiB.
+
+	For pmem namepsaces the size must be a multiple of the
+	interleave-width and the namespace alignment (see
+	below).
+
+-a::
+--align::
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
+
+-u::
+--uuid=::
+	This option is not recommended as a new uuid should be generated
+	every time a namespace is (re-)created.  For recovery scenarios
+	however the uuid may be specified.
+
+-n::
+--name=::
+	For NVDIMM devices that support namespace labels,
+	specify a human friendly name for a namespace.  This name is
+	available as a device attribute for use in udev rules.
+
+-l::
+--sector-size::
+	Specify the logical sector size (LBA size) of the
+	Linux block device associated with an namespace.
+
+-M::
+--map=::
+	A pmem namespace in "fsdax" or "devdax" mode requires allocation of
+	per-page metadata.  The allocation can be drawn from either:
+	- "mem": typical system memory
+	- "dev": persistent memory reserved from the namespace
+
+	Given relative capacities of "Persistent Memory" to "System
+	RAM" the allocation defaults to reserving space out of the
+	namespace directly ("--map=dev"). The overhead is 64-bytes per
+	4K (16GB per 1TB) on x86.
+
+-f::
+--force::
+	Unless this option is specified the 'reconfigure namespace'
+	operation will fail if the namespace is presently active.
+	Specifying --force causes the namespace to be disabled before
+	the operation is attempted. However, if the namespace is
+	mounted then the 'disable namespace' and 'reconfigure
+	namespace' operations will be aborted.  The namespace must be
+	unmounted before being reconfigured.
+
+-L::
+--autolabel::
+--no-autolabel::
+	Legacy NVDIMM devices do not support namespace labels. In that
+	case the kernel creates region-sized namespaces that can not
+	be deleted.  Their mode can be changed, but they can not be
+	resized smaller than their parent region. This is termed a
+	"label-less namespace". In contrast, NVDIMMs and hypervisors
+	that support the ACPI 6.2 label area definition (ACPI 6.2
+	Section 6.5.10 NVDIMM Label Methods) support "labelled
+	namespace" operation.
+
+	- There are two cases where the kernel will default to
+	  label-less operation:
+
+	  * NVDIMM does not support labels
+
+	  * The NVDIMM supports labels, but the Label Index Block (see
+	    UEFI 2.7) is not present and there is no capacity aliasing
+	    between 'blk' and 'pmem' regions.
+
+	- In the latter case the configuration can be upgraded to
+	  labelled operation by writing an index block on all DIMMs in a
+	  region and re-enabling that region. The 'autolabel' capability
+	  of 'ndctl reconfigure-namespace' tries to do this by
+	  default if it can determine that all DIMM capacity is
+	  referenced by the namespace being reconfigured. It will
+	  otherwise fail to autolabel and remain in label-less mode if
+	  it finds a DIMM contributes capacity to more than one region.
+	  This check prevents inadvertent data loss of that other region
+	  is in active use. The --autolabel option is implied by
+	  default, the --no-autolabel option can be used to disable this
+	  behavior. When automatic labeling fails and labelled operation
+	  is still desired the safety policy can be bypassed by the
+	  following commands, note that all data on all regions is
+	  forfeited by running these commands:
+
+	ndctl disable-region all
+	ndctl init-labels all
+	ndctl enable-region all
+
+-v::
+--verbose::
+	Emit debug messages for the namespace creation process
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkndctl:ndctl-zero-labels[1],
+linkndctl:ndctl-init-labels[1],
+linkndctl:ndctl-disable-namespace[1],
+linkndctl:ndctl-enable-namespace[1],
+linkndctl:ndctl-create-namespace[1],
+http://www.uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf[UEFI NVDIMM Label Protocol]
+https://nvdimm.wiki.kernel.org[Linux Persistent Memory Wiki]
diff --git a/builtin.h b/builtin.h
index 675a6ce..0cfd96f 100644
--- a/builtin.h
+++ b/builtin.h
@@ -23,6 +23,7 @@ struct cmd_struct {
 int cmd_create_nfit(int argc, const char **argv, void *ctx);
 int cmd_enable_namespace(int argc, const char **argv, void *ctx);
 int cmd_create_namespace(int argc, const char **argv, void *ctx);
+int cmd_reconfigure_namespace(int argc, const char **argv, void *ctx);
 int cmd_destroy_namespace(int argc, const char **argv, void *ctx);
 int cmd_disable_namespace(int argc, const char **argv, void *ctx);
 int cmd_check_namespace(int argc, const char **argv, void *ctx);
diff --git a/ndctl/action.h b/ndctl/action.h
index 1ecad49..44e141e 100644
--- a/ndctl/action.h
+++ b/ndctl/action.h
@@ -9,6 +9,7 @@ enum device_action {
 	ACTION_ENABLE,
 	ACTION_DISABLE,
 	ACTION_CREATE,
+	ACTION_RECONFIGURE,
 	ACTION_DESTROY,
 	ACTION_CHECK,
 	ACTION_WAIT,
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 510553c..cd01a1f 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -115,6 +115,23 @@ OPT_STRING('a', "align", &param.align, "align", \
 OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active"), \
 OPT_BOOLEAN('L', "autolabel", &param.autolabel, "automatically initialize labels")
 
+#define RECONFIGURE_OPTIONS() \
+OPT_STRING('u', "uuid", &param.uuid, "uuid", \
+	"specify the uuid for the namespace (default: autogenerate)"), \
+OPT_STRING('n', "name", &param.name, "name", \
+	"specify an optional free form name for the namespace"), \
+OPT_STRING('s', "size", &param.size, "size", \
+	"specify the namespace size in bytes (default: available capacity)"), \
+OPT_STRING('m', "mode", &param.mode, "operation-mode", \
+	"specify a mode for the namespace, 'sector', 'fsdax', 'devdax' or 'raw'"), \
+OPT_STRING('M', "map", &param.map, "memmap-location", \
+	"specify 'mem' or 'dev' for the location of the memmap"), \
+OPT_STRING('a', "align", &param.align, "align", \
+	"specify the namespace alignment in bytes (default: 2M)"), \
+OPT_BOOLEAN('f', "force", &force, "reconfigure namespace even if currently active"), \
+OPT_BOOLEAN('L', "autolabel", &param.autolabel, "automatically initialize labels")
+
+
 #define CHECK_OPTIONS() \
 OPT_BOOLEAN('R', "repair", &repair, "perform metadata repairs"), \
 OPT_BOOLEAN('L', "rewrite-log", &logfix, "regenerate the log"), \
@@ -138,6 +155,12 @@ static const struct option create_options[] = {
 	OPT_END(),
 };
 
+static const struct option reconfigure_options[] = {
+	BASE_OPTIONS(),
+	RECONFIGURE_OPTIONS(),
+	OPT_END(),
+};
+
 static const struct option check_options[] = {
 	BASE_OPTIONS(),
 	CHECK_OPTIONS(),
@@ -270,6 +293,9 @@ static const char *parse_namespace_options(int argc, const char **argv,
 	param.do_scan = argc == 1;
         argc = parse_options(argc, argv, options, u, 0);
 
+	if (mode == ACTION_RECONFIGURE)
+		param.reconfig = argv[0];
+
 	rc = set_defaults(mode);
 
 	if (argc == 0 && mode != ACTION_CREATE) {
@@ -288,6 +314,9 @@ static const char *parse_namespace_options(int argc, const char **argv,
 			case ACTION_CHECK:
 				action_string = "check";
 				break;
+			case ACTION_RECONFIGURE:
+				action_string = "reconfigure";
+				break;
 			default:
 				action_string = "<>";
 				break;
@@ -1053,6 +1082,7 @@ static int do_xaction_namespace(const char *namespace,
 						return rc;
 					break;
 				case ACTION_CREATE:
+				case ACTION_RECONFIGURE:
 					rc = namespace_reconfig(region, ndns);
 					if (rc < 0)
 						return rc;
@@ -1114,6 +1144,20 @@ int cmd_enable_namespace(int argc, const char **argv, void *ctx)
 	}
 }
 
+int cmd_reconfigure_namespace(int argc, const char **argv, void *ctx)
+{
+	char *xable_usage = "ndctl reconfigure-namespace <namespace> [<options>]";
+	char *namespace = parse_namespace_options(argc, argv,
+			ACTION_RECONFIGURE, reconfigure_options, xable_usage);
+	int reconfigured = do_xaction_namespace(namespace, ACTION_RECONFIGURE,
+						ctx);
+
+	if (reconfigured < 1)
+		fprintf(stderr, "failed to reconfigure namespace:%s %s\n",
+			namespace, strerror(-reconfigured));
+	return reconfigured;
+}
+
 int cmd_create_namespace(int argc, const char **argv, void *ctx)
 {
 	char *xable_usage = "ndctl create-namespace [<options>]";
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 73dabfa..b4d252c 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -72,6 +72,7 @@ static struct cmd_struct commands[] = {
 	{ "enable-namespace", cmd_enable_namespace },
 	{ "disable-namespace", cmd_disable_namespace },
 	{ "create-namespace", cmd_create_namespace },
+	{ "reconfigure-namespace", cmd_reconfigure_namespace },
 	{ "destroy-namespace", cmd_destroy_namespace },
 	{ "check-namespace", cmd_check_namespace },
 	{ "enable-region", cmd_enable_region },
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
