Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 26 Aug 2015 21:07:40 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/2]: nfit: Clarify memory device state flags strings
Message-ID: <20150827030740.GB4438@linux.intel.com>
References: <1440606024-29873-1-git-send-email-toshi.kani@hp.com>
 <1440606024-29873-2-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1440606024-29873-2-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: dan.j.williams@intel.com, rafael.j.wysocki@intel.com, linux-nvdimm@lists.01.org, robert.moore@intel.com, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 26, 2015 at 10:20:23AM -0600, Toshi Kani wrote:
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index c3fe206..6993ff2 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -701,12 +701,13 @@ static ssize_t flags_show(struct device *dev,
>  {
>  	u16 flags = to_nfit_memdev(dev)->flags;
>  
> -	return sprintf(buf, "%s%s%s%s%s\n",
> -			flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save " : "",
> -			flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore " : "",
> -			flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush " : "",
> -			flags & ACPI_NFIT_MEM_ARMED ? "arm " : "",
> -			flags & ACPI_NFIT_MEM_HEALTH_OBSERVED ? "smart " : "");
> +	return sprintf(buf, "%s%s%s%s%s%s\n",
> +		flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save_fail " : "",
> +		flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore_fail " : "",
> +		flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush_fail " : "",
> +		flags & ACPI_NFIT_MEM_ARMED ? "not_arm " : "",

Assuming we do want to update these strings to be more friendly, "not_armed"
probably makes more sense than "not_arm".  Also applies to the 2nd hunk below.

> +		flags & ACPI_NFIT_MEM_HEALTH_OBSERVED ? "smart_event " : "",
> +		flags & ACPI_NFIT_MEM_HEALTH_ENABLED ? "notify_enabled " : "");
>  }
>  static DEVICE_ATTR_RO(flags);
>  
> @@ -834,11 +835,11 @@ static int acpi_nfit_register_dimms(struct acpi_nfit_desc *acpi_desc)
>  			continue;
>  
>  		dev_info(acpi_desc->dev, "%s: failed: %s%s%s%s\n",
> -				nvdimm_name(nvdimm),
> -			mem_flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save " : "",
> -			mem_flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore " : "",
> -			mem_flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush " : "",
> -			mem_flags & ACPI_NFIT_MEM_ARMED ? "arm " : "");
> +		  nvdimm_name(nvdimm),
> +		  mem_flags & ACPI_NFIT_MEM_SAVE_FAILED ? "save_fail " : "",
> +		  mem_flags & ACPI_NFIT_MEM_RESTORE_FAILED ? "restore_fail ":"",
> +		  mem_flags & ACPI_NFIT_MEM_FLUSH_FAILED ? "flush_fail " : "",
> +		  mem_flags & ACPI_NFIT_MEM_ARMED ? "not_arm " : "");

While you're in here, is there a reason not to include the last two flags
(smart_event and notify_enabled) in this dev_info() output?
