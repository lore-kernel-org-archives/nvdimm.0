Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x243.google.com (mail-pf0-x243.google.com
 [IPv6:2607:f8b0:400e:c00::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B7DE1A1DF3
 for <linux-nvdimm@lists.01.org>; Fri, 24 Jun 2016 00:55:25 -0700 (PDT)
Received: by mail-pf0-x243.google.com with SMTP id 66so8623498pfy.1
 for <linux-nvdimm@lists.01.org>; Fri, 24 Jun 2016 00:54:53 -0700 (PDT)
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2] libnvdimm, nfit: treat volatile virtual CD region as pmem
Date: Fri, 24 Jun 2016 15:51:50 +0800
Message-Id: <1466754710-5948-1-git-send-email-jlee@suse.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linda Knippers <linda.knippers@hpe.com>
Cc: "Lee, Chun-Yi" <jlee@suse.com>, linux-acpi@vger.kernel.org, Gary Lin <GLin@suse.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch adds logic to treat volatile virtual CD region as pmem
region, then /dev/pmem* device can be mounted with iso9660.

It's useful to work with the httpboot in EFI firmware to pull a remote
ISO file to the local memory region for booting and installation.

Wiki page of UEFI HTTPBoot with OVMF:
	https://en.opensuse.org/UEFI_HTTPBoot_with_OVMF

The ramdisk function in EDK2/OVMF generates a ACPI0012 root device that
it contains empty _STA but without _DSM:

DefinitionBlock ("ssdt2.aml", "SSDT", 2, "INTEL ", "RamDisk ", 0x00001000)
{
    Scope (\_SB)
    {
        Device (NVDR)
        {
            Name (_HID, "ACPI0012")  // _HID: Hardware ID
            Name (_STR, Unicode ("NVDIMM Root Device"))  // _STR: Description String
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                Return (0x0F)
            }
        }
    }
}

In section 5.2.25.2 of ACPI 6.1 spec, it mentions that the "SPA Range
Structure Index" of VCD SPA shall be set to zero. That means VCD SPA
will not be associated by any NVDIMM region mapping.

The VCD's SPA Range Structure in NFIT is similar to virtual disk region
as following:

[028h 0040   2]                Subtable Type : 0000 [System Physical Address Range]
[02Ah 0042   2]                       Length : 0038

[02Ch 0044   2]                  Range Index : 0000
[02Eh 0046   2]        Flags (decoded below) : 0000
                   Add/Online Operation Only : 0
                      Proximity Domain Valid : 0
[030h 0048   4]                     Reserved : 00000000
[034h 0052   4]             Proximity Domain : 00000000
[038h 0056  16]           Address Range GUID : 77AB535A-45FC-624B-5560-F7B281D1F96E
[048h 0072   8]           Address Range Base : 00000000B6ABD018
[050h 0080   8]         Address Range Length : 0000000005500000
[058h 0088   8]         Memory Map Attribute : 0000000000000000

The range index set to zero that means the VCD region not associated by
any NVDIMM region mapping, and it will not assoicate to "flush hint",
"interleave" or "control region".

After testing on OVMF, pmem driver can support the region that it doesn't
assoicate to any NVDIMM mapping. So, treat VCD as pmem is a idea to get
a pmem block device that it containts iso. 
 
v2
Removed the code for setting VCD to a read-only region.

Cc: Gary Lin <GLin@suse.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/acpi/nfit.c          |  8 +++++++-
 drivers/nvdimm/region_devs.c | 26 +++++++++++++++++++++++++-
 include/linux/libnvdimm.h    |  2 ++
 3 files changed, 34 insertions(+), 2 deletions(-)

Index: linux/drivers/acpi/nfit.c
===================================================================
--- linux.orig/drivers/acpi/nfit.c
+++ linux/drivers/acpi/nfit.c
@@ -1995,7 +1995,7 @@ static int acpi_nfit_register_region(str
 	if (nfit_spa->nd_region)
 		return 0;
 
-	if (spa->range_index == 0) {
+	if (spa->range_index == 0 && nfit_spa_type(spa) != NFIT_SPA_VCD) {
 		dev_dbg(acpi_desc->dev, "%s: detected invalid spa index\n",
 				__func__);
 		return 0;
@@ -2059,6 +2059,11 @@ static int acpi_nfit_register_region(str
 				ndr_desc);
 		if (!nfit_spa->nd_region)
 			rc = -ENOMEM;
+	} else if (nfit_spa_type(spa) == NFIT_SPA_VCD) {
+		nfit_spa->nd_region = nvdimm_vcd_region_create(nvdimm_bus,
+				ndr_desc);
+		if (!nfit_spa->nd_region)
+			rc = -ENOMEM;
 	}
 
  out:
Index: linux/drivers/nvdimm/region_devs.c
===================================================================
--- linux.orig/drivers/nvdimm/region_devs.c
+++ linux/drivers/nvdimm/region_devs.c
@@ -56,9 +56,19 @@ static struct device_type nd_volatile_de
 	.release = nd_region_release,
 };
 
+static struct device_type nd_vcd_device_type = {
+	.name = "nd_vcd",
+	.release = nd_region_release,
+};
+
+bool is_nd_vcd(struct device *dev)
+{
+	return dev ? dev->type == &nd_vcd_device_type : false;
+}
+
 bool is_nd_pmem(struct device *dev)
 {
-	return dev ? dev->type == &nd_pmem_device_type : false;
+	return dev ? dev->type == &nd_pmem_device_type || is_nd_vcd(dev) : false;
 }
 
 bool is_nd_blk(struct device *dev)
@@ -774,6 +784,14 @@ struct nd_region *nvdimm_pmem_region_cre
 }
 EXPORT_SYMBOL_GPL(nvdimm_pmem_region_create);
 
+struct nd_region *nvdimm_vcd_region_create(struct nvdimm_bus *nvdimm_bus,
+		struct nd_region_desc *ndr_desc)
+{
+	return nd_region_create(nvdimm_bus, ndr_desc, &nd_vcd_device_type,
+			__func__);
+}
+EXPORT_SYMBOL_GPL(nvdimm_vcd_region_create);
+
 struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc)
 {
Index: linux/include/linux/libnvdimm.h
===================================================================
--- linux.orig/include/linux/libnvdimm.h
+++ linux/include/linux/libnvdimm.h
@@ -145,6 +145,8 @@ u32 nd_cmd_out_size(struct nvdimm *nvdim
 int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count);
 struct nd_region *nvdimm_pmem_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc);
+struct nd_region *nvdimm_vcd_region_create(struct nvdimm_bus *nvdimm_bus,
+		struct nd_region_desc *ndr_desc);
 struct nd_region *nvdimm_blk_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_region_desc *ndr_desc);
 struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
