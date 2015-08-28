Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Moore, Robert" <robert.moore@intel.com>
Subject: RE: [PATCH]: acpica/nfit: Rename not-armed bit definition
Date: Fri, 28 Aug 2015 15:44:17 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E37D3420EF@ORSMSX112.amr.corp.intel.com>
References: <1440772817-13562-1-git-send-email-toshi.kani@hp.com>
In-Reply-To: <1440772817-13562-1-git-send-email-toshi.kani@hp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Cc: "devel@acpica.org" <devel@acpica.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

+#define ACPI_NFIT_MEM_NOT_ARMED         (1<<3)	/* 03: Memory Device observed to be not armed */

I'll add this to ACPICA immediately, for the next release in mid-september.


> -----Original Message-----
> From: Toshi Kani [mailto:toshi.kani@hp.com]
> Sent: Friday, August 28, 2015 7:40 AM
> To: Williams, Dan J; Wysocki, Rafael J; Moore, Robert
> Cc: devel@acpica.org; linux-nvdimm@lists.01.org; linux-
> acpi@vger.kernel.org; linux-kernel@vger.kernel.org; Toshi Kani
> Subject: [PATCH]: acpica/nfit: Rename not-armed bit definition
> 
> ACPI 6.0 NFIT Memory Device State Flags in Table 5-129 defines bit 3 as
> follows.
> 
>   Bit [3] set to 1 to indicate that the Memory Device is observed
>   to be not armed prior to OSPM hand off. A Memory Device is
>   considered armed if it is able to accept persistent writes.
> 
> This bit is currently defined as ACPI_NFIT_MEM_ARMED, which can be
> confusing as if the Memory Device is armed when this bit is set.
> 
> Change the name to ACPI_NFIT_MEM_NOT_ARMED per the spec.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Cc: Bob Moore <robert.moore@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> This patch is based on the linus's tree.
> ---
>  drivers/acpi/nfit.c              |    6 +++---
>  drivers/acpi/nfit.h              |    2 +-
>  include/acpi/actbl1.h            |    2 +-
>  tools/testing/nvdimm/test/nfit.c |    2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c index
> cf0fd96..4596e0a 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -705,7 +705,7 @@ static ssize_t flags_show(struct device *dev,
>  		flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save_fail " : "",
>  		flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore_fail " : "",
>  		flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush_fail " : "",
> -		flags & ACPI_NFIT_MEM_ARMED ? "not_armed " : "",
> +		flags & ACPI_NFIT_MEM_NOT_ARMED ? "not_armed " : "",
>  		flags & ACPI_NFIT_MEM_HEALTH_OBSERVED ? "smart_event " : "");
> }  static DEVICE_ATTR_RO(flags); @@ -830,7 +830,7 @@ static int
> acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>  			flags |= NDD_ALIASING;
> 
>  		mem_flags = __to_nfit_memdev(nfit_mem)->flags;
> -		if (mem_flags & ACPI_NFIT_MEM_ARMED)
> +		if (mem_flags & ACPI_NFIT_MEM_NOT_ARMED)
>  			flags |= NDD_UNARMED;
> 
>  		rc = acpi_nfit_add_dimm(acpi_desc, nfit_mem, device_handle);
> @@ -854,7 +854,7 @@ static int acpi_nfit_register_dimms(struct
> acpi_nfit_desc *acpi_desc)
>  		  mem_flags & ACPI_NFIT_MEM_SAVE_FAILED ? " save_fail" : "",
>  		  mem_flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "
> restore_fail":"",
>  		  mem_flags & ACPI_NFIT_MEM_FLUSH_FAILED ? " flush_fail" : "",
> -		  mem_flags & ACPI_NFIT_MEM_ARMED ? " not_armed" : "");
> +		  mem_flags & ACPI_NFIT_MEM_NOT_ARMED ? " not_armed" : "");
> 
>  	}
> 
> diff --git a/drivers/acpi/nfit.h b/drivers/acpi/nfit.h index
> 79b6d83..90505e3 100644
> --- a/drivers/acpi/nfit.h
> +++ b/drivers/acpi/nfit.h
> @@ -24,7 +24,7 @@
>  #define UUID_NFIT_DIMM "4309ac30-0d11-11e4-9191-0800200c9a66"
>  #define ACPI_NFIT_MEM_FAILED_MASK (ACPI_NFIT_MEM_SAVE_FAILED \
>  		| ACPI_NFIT_MEM_RESTORE_FAILED | ACPI_NFIT_MEM_FLUSH_FAILED \
> -		| ACPI_NFIT_MEM_ARMED)
> +		| ACPI_NFIT_MEM_NOT_ARMED)
> 
>  enum nfit_uuids {
>  	NFIT_SPA_VOLATILE,
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h index
> fcd5709..238754e 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h
> @@ -1012,7 +1012,7 @@ struct acpi_nfit_memory_map {
>  #define ACPI_NFIT_MEM_SAVE_FAILED       (1)	/* 00: Last SAVE to Memory
> Device failed */
>  #define ACPI_NFIT_MEM_RESTORE_FAILED    (1<<1)	/* 01: Last RESTORE from
> Memory Device failed */
>  #define ACPI_NFIT_MEM_FLUSH_FAILED      (1<<2)	/* 02: Platform flush
> failed */
> -#define ACPI_NFIT_MEM_ARMED             (1<<3)	/* 03: Memory Device
> observed to be not armed */
> +#define ACPI_NFIT_MEM_NOT_ARMED         (1<<3)	/* 03: Memory Device
> observed to be not armed */
>  #define ACPI_NFIT_MEM_HEALTH_OBSERVED   (1<<4)	/* 04: Memory Device
> observed SMART/health events */
>  #define ACPI_NFIT_MEM_HEALTH_ENABLED    (1<<5)	/* 05: SMART/health events
> enabled */
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c
> b/tools/testing/nvdimm/test/nfit.c
> index d0bdae4..ed271ba 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -917,7 +917,7 @@ static void nfit_test1_setup(struct nfit_test *t)
>  	memdev->interleave_ways = 1;
>  	memdev->flags = ACPI_NFIT_MEM_SAVE_FAILED |
> ACPI_NFIT_MEM_RESTORE_FAILED
>  		| ACPI_NFIT_MEM_FLUSH_FAILED | ACPI_NFIT_MEM_HEALTH_OBSERVED
> -		| ACPI_NFIT_MEM_ARMED;
> +		| ACPI_NFIT_MEM_NOT_ARMED;
> 
>  	offset += sizeof(*memdev);
>  	/* dcr-descriptor0 */
