Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D96212110C817
 for <linux-nvdimm@lists.01.org>; Sun,  3 Jun 2018 13:05:31 -0700 (PDT)
Subject: [PATCH] acpi, nfit: Remove ecc_unit_size
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 03 Jun 2018 12:55:34 -0700
Message-ID: <152805573421.36904.10280982218277525255.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The "Clear Error Unit" may be smaller than the ECC unit size on some
devices. For example, poison may be tracked at 64-byte alignment even
though the ECC unit is larger. Unless / until the ACPI specification
provides a non-ambiguous way to communicate this property do not expose
this to userspace.

Software that had been using this property must already be prepared for
the case where the property is not provided on older kernels, so it is
safe to remove this attribute.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/removed/sysfs-bus-nfit |   17 +++++++++++++++++
 Documentation/ABI/testing/sysfs-bus-nfit |   19 -------------------
 drivers/acpi/nfit/core.c                 |   11 -----------
 3 files changed, 17 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/ABI/removed/sysfs-bus-nfit

diff --git a/Documentation/ABI/removed/sysfs-bus-nfit b/Documentation/ABI/removed/sysfs-bus-nfit
new file mode 100644
index 000000000000..ae8c1ca53828
--- /dev/null
+++ b/Documentation/ABI/removed/sysfs-bus-nfit
@@ -0,0 +1,17 @@
+What:		/sys/bus/nd/devices/regionX/nfit/ecc_unit_size
+Date:		Aug, 2017
+KernelVersion:	v4.14 (Removed v4.18)
+Contact:	linux-nvdimm@lists.01.org
+Description:
+		(RO) Size of a write request to a DIMM that will not incur a
+		read-modify-write cycle at the memory controller.
+
+		When the nfit driver initializes it runs an ARS (Address Range
+		Scrub) operation across every pmem range. Part of that process
+		involves determining the ARS capabilities of a given address
+		range. One of the capabilities that is reported is the 'Clear
+		Uncorrectable Error Range Length Unit Size' (see: ACPI 6.2
+		section 9.20.7.4 Function Index 1 - Query ARS Capabilities).
+		This property indicates the boundary at which the NVDIMM may
+		need to perform read-modify-write cycles to maintain ECC (Error
+		Correcting Code) blocks.
diff --git a/Documentation/ABI/testing/sysfs-bus-nfit b/Documentation/ABI/testing/sysfs-bus-nfit
index 619eb8ca0f99..a1cb44dcb908 100644
--- a/Documentation/ABI/testing/sysfs-bus-nfit
+++ b/Documentation/ABI/testing/sysfs-bus-nfit
@@ -212,22 +212,3 @@ Description:
 		range. Used by NVDIMM Region Mapping Structure to uniquely refer
 		to this structure. Value of 0 is reserved and not used as an
 		index.
-
-
-What:		/sys/bus/nd/devices/regionX/nfit/ecc_unit_size
-Date:		Aug, 2017
-KernelVersion:	v4.14
-Contact:	linux-nvdimm@lists.01.org
-Description:
-		(RO) Size of a write request to a DIMM that will not incur a
-		read-modify-write cycle at the memory controller.
-
-		When the nfit driver initializes it runs an ARS (Address Range
-		Scrub) operation across every pmem range. Part of that process
-		involves determining the ARS capabilities of a given address
-		range. One of the capabilities that is reported is the 'Clear
-		Uncorrectable Error Range Length Unit Size' (see: ACPI 6.2
-		section 9.20.7.4 Function Index 1 - Query ARS Capabilities).
-		This property indicates the boundary at which the NVDIMM may
-		need to perform read-modify-write cycles to maintain ECC (Error
-		Correcting Code) blocks.
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e2235ed3e4be..b87252bf4571 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1978,19 +1978,8 @@ static ssize_t range_index_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(range_index);
 
-static ssize_t ecc_unit_size_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct nd_region *nd_region = to_nd_region(dev);
-	struct nfit_spa *nfit_spa = nd_region_provider_data(nd_region);
-
-	return sprintf(buf, "%d\n", nfit_spa->clear_err_unit);
-}
-static DEVICE_ATTR_RO(ecc_unit_size);
-
 static struct attribute *acpi_nfit_region_attributes[] = {
 	&dev_attr_range_index.attr,
-	&dev_attr_ecc_unit_size.attr,
 	NULL,
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
