Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 314CA1A1E2B
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 12:59:59 -0800 (PST)
Received: by mail-oi0-x236.google.com with SMTP id m82so20288759oif.1
 for <linux-nvdimm@lists.01.org>; Tue, 08 Mar 2016 12:59:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFy=V-esUXZa2AogS685k+r9PyyNStkZrrUUkWSKvLFUGQ@mail.gmail.com>
References: <1457460530-17959-1-git-send-email-toshi.kani@hpe.com>
 <CA+55aFy=V-esUXZa2AogS685k+r9PyyNStkZrrUUkWSKvLFUGQ@mail.gmail.com>
Date: Tue, 8 Mar 2016 12:59:44 -0800
Message-ID: <CAPcyv4gT1RvnEquYXVo7sZscdUrkiWpG-Yvr_EX4=L25397X0g@mail.gmail.com>
Subject: Re: [PATCH v2-UPDATE2 3/4] resource: Add device-managed
 insert/remove_resource()
From: Dan Williams <dan.j.williams@intel.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 8, 2016 at 12:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Mar 8, 2016 at 10:08 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
>>
>> Add device-managed implementaions of insert_resource() and
>> remove_resouce() functions.
>
> Can we get an example of the users and show how much this would actually help?
>
> insert_resource() is fairly unusual to begin with, and it should
> basically *never* be used by a driver at all (it's more of a bus
> thing).
>
> The patch doesn't look _wrong_, but it does look potentially largely
> pointless. Adding new interfaces to do things that aren't common
> enough to worry about is counter-productive, imho.

Here's the usage patch from Toshi [1] (copied below).  It is indeed a
resource injected by nfit / nvdimm bus implementation.  We just happen
to support nfit and libnvdimm as modules.

The goal of these patches is to use the ACPI NFIT data to create a
"Persistent Memory" rather than "reserved" resource.  This is for
platform-firmware implementations that use E820-Type2 rather than
E820-Type7 to describe pmem.

[1]: https://patchwork.kernel.org/patch/8485691/

8<--
From: Toshi Kani <toshi.kani@hpe.com>

ACPI 6.0 defines persistent memory (PMEM) ranges in multiple
firmware interfaces, e820, EFI, and ACPI NFIT table.  This EFI
change, however, leads to hit a bug in the grub bootloader, which
treats EFI_PERSISTENT_MEMORY type as regular memory and corrupts
stored user data [1].

Therefore, BIOS may set generic reserved type in e820 and EFI
to cover PMEM ranges.  The kernel can initialize PMEM ranges
from ACPI NFIT table alone.

This scheme causes a problem in the iomem table, though.  On x86,
for instance, e820_reserve_resources() initializes top-level entries
(iomem_resource.child) from the e820 table at early boot-time.
This creates "reserved" entry for a PMEM range, which does not allow
region_intersects() to check with PMEM type.

Change acpi_nfit_register_region() to call acpi_nfit_insert_resource(),
which calls devm_insert_resource() to insert a PMEM entry from NFIT
when the iomem table does not have a PMEM entry already.  That is,
when a PMEM range is marked as reserved type in e820, it inserts
"Persistent Memory" entry, which results as follows.

 + "Persistent Memory"
    + "reserved"

This allows the EINJ driver, which calls region_intersects() to
check PMEM ranges, to work continuously even if BIOS sets reserved
type (or sets nothing) to PMEM ranges in e820 and EFI.

[1]: https://lists.gnu.org/archive/html/grub-devel/2015-11/msg00209.html
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/acpi/nfit.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
index fb53db1..d97b53f 100644
--- a/drivers/acpi/nfit.c
+++ b/drivers/acpi/nfit.c
@@ -1571,6 +1571,30 @@ static int ars_status_process_records(struct
nvdimm_bus *nvdimm_bus,
        return 0;
 }

+static int acpi_nfit_insert_resource(struct acpi_nfit_desc *acpi_desc,
+               struct nd_region_desc *ndr_desc)
+{
+       struct resource *res, *nd_res = ndr_desc->res;
+       size_t size = nd_res->end - nd_res->start + 1;
+
+       /* No operation if the region is already registered as PMEM */
+       if (region_intersects(nd_res->start, size, IORESOURCE_MEM,
+                       IORES_DESC_PERSISTENT_MEMORY) == REGION_INTERSECTS)
+               return 0;
+
+       res = devm_kzalloc(acpi_desc->dev, sizeof(*res), GFP_KERNEL);
+       if (!res)
+               return -ENOMEM;
+
+       res->name = "Persistent Memory";
+       res->start = nd_res->start;
+       res->end = nd_res->end;
+       res->flags = IORESOURCE_MEM;
+       res->desc = IORES_DESC_PERSISTENT_MEMORY;
+
+       return devm_insert_resource(acpi_desc->dev, &iomem_resource, res);
+}
+
 static int acpi_nfit_find_poison(struct acpi_nfit_desc *acpi_desc,
                struct nd_region_desc *ndr_desc)
 {
@@ -1781,6 +1805,12 @@ static int acpi_nfit_register_region(struct
acpi_nfit_desc *acpi_desc,

        nvdimm_bus = acpi_desc->nvdimm_bus;
        if (nfit_spa_type(spa) == NFIT_SPA_PM) {
+               rc = acpi_nfit_insert_resource(acpi_desc, ndr_desc);
+               if (rc)
+                       dev_warn(acpi_desc->dev,
+                               "failed to insert pmem resource to iomem: %d\n",
+                               rc);
+
                rc = acpi_nfit_find_poison(acpi_desc, ndr_desc);
                if (rc) {
                        dev_err(acpi_desc->dev,
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
