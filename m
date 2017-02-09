Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from tama500.ecl.ntt.co.jp (tama500.ecl.ntt.co.jp [129.60.39.148])
 by ml01.01.org (Postfix) with ESMTP id E81108208A
 for <linux-nvdimm@lists.01.org>; Wed,  8 Feb 2017 18:45:56 -0800 (PST)
From: Yoshimi Ichiyanagi <ichiyanagi.yoshimi@lab.ntt.co.jp>
Subject: dax: enable DAX PMD suport for NVDIMM device
Date: Thu, 09 Feb 2017 11:45:29 +0900
MIME-Version: 1.0
Message-Id: <A42D2827E934C5DAD59E3A1@lab.ntt.co.jp>
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
To: linux-nvdimm@lists.01.org, dan.j.williams@intel.com
List-ID: <linux-nvdimm@lists.01.org>

Hello.

I use the HPE 8G NVDIMM modules on a HPE DL360G9 server. Currently DAX PMD
(2iMB pages) support is disabled for NVDIMM modules in kernel 4.10.0-rc5. 

PMD DAX would be enabled, if "PFN_DEV and PFN_MAP" of pmem device flags was
set at dax_pmd_insert_mapping().

But "PFN_DEV and PFN_MAP" was not set at pmem_attach_disk() with HPE NVDIMM
modules. Because the pmem_should_map_pages() did not return true at
pmem_attach_disk(). 

pmem_should_map_pages() would return true and DAX PMD would be enabled, 
if ND_REGION_PAGEMAP flag of nd_region flags was set.

In this case, the nd_region was initialized with
acpi_nfit_register_region(), and ND_REGION_PAGEMAP of the nd_region flags
was not set in acpi_nfit_register_region(). So DAX PMD was disabled.

Is it ok to set ND_REGION_PAGEMAP of the PM and VOLATILE type nd_region
flags?

Here is the fio-2.16 script(mmap.fio file) I used for my testing:

[global]
bs=4k
size=2G
directory=/mnt/pmem1
ioengine=mmap
rw=write

I did the following:
# mkfs.ext4 /dev/pmem1
# mount -t ext4 -o dax /dev/pmem1 /mnt/pmem1
# fio mmap.fio

Here are the performance results(ND_REGION_PAGEMAP flag was off):
Run status group 0 (all jobs):
  WRITE: bw=1228MiB/s (1287MB/s), 1228MiB/s-1228MiB/s (1287MB/s-1287MB/s), 
io=2048MiB (2147MB), run=1668-1668msec


Here are the performance results(ND_REGION_PAGEMAP flag was on with 
following patch):
Run status group 0 (all jobs):
  WRITE: bw=3459MiB/s (3628MB/s), 3459MiB/s-3459MiB/s (3628MB/s-3628MB/s), 
io=2048MiB (2147MB), run=592-592msec



diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 7361d00..1d3bd5a 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2096,7 +2096,7 @@ static int acpi_nfit_init_mapping(struct 
acpi_nfit_desc *acpi_desc,
        struct acpi_nfit_system_address *spa = nfit_spa->spa;
        struct nd_blk_region_desc *ndbr_desc;
        struct nfit_mem *nfit_mem;
-       int blk_valid = 0;
+       int blk_valid = -1;

        if (!nvdimm) {
                dev_err(acpi_desc->dev, "spa%d dimm: %#x not found\n",
@@ -2116,6 +2116,7 @@ static int acpi_nfit_init_mapping(struct 
acpi_nfit_desc *acpi_desc,
                if (!nfit_mem || !nfit_mem->bdw) {
                        dev_dbg(acpi_desc->dev, "spa%d %s missing bdw\n",
                                        spa->range_index, nvdimm_name
(nvdimm));
+                       blk_valid = 0;
                } else {
                        mapping->size = nfit_mem->bdw->capacity;
                        mapping->start = nfit_mem->bdw->start_address;
@@ -2135,6 +2136,9 @@ static int acpi_nfit_init_mapping(struct 
acpi_nfit_desc *acpi_desc,
                break;
        }

+       if ( blk_valid < 0 )
+               set_bit(ND_REGION_PAGEMAP, &ndr_desc->flags);
+
        return 0;
 }




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
