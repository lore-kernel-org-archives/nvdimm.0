Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <553ABA06.90305@hp.com>
Date: Fri, 24 Apr 2015 17:47:50 -0400
From: Linda Knippers <linda.knippers@hp.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [PATCH 05/21] nfit-test: manufactured NFITs for
 interface development
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com> <20150418013541.25237.36797.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20150418013541.25237.36797.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 4/17/2015 9:35 PM, Dan Williams wrote:
:
> diff --git a/drivers/block/nd/Kconfig b/drivers/block/nd/Kconfig
> index 5fa74f124b3e..0106b3807202 100644
> --- a/drivers/block/nd/Kconfig
> +++ b/drivers/block/nd/Kconfig
> @@ -41,4 +41,24 @@ config NFIT_ACPI
>  	  register the platform-global NFIT blob with the core.  Also
>  	  enables the core to craft ACPI._DSM messages for platform/dimm
>  	  configuration.
> +
> +config NFIT_TEST
> +	tristate "NFIT TEST: Manufactured NFIT for interface testing"
> +	depends on DMA_CMA
> +	depends on ND_CORE=m
> +	depends on m
> +	help
> +	  For development purposes register a manufactured
> +	  NFIT table to verify the resulting device model topology.
> +	  Note, this module arranges for ioremap_cache() to be
> +	  overridden locally to allow simulation of system-memory as an
> +	  io-memory-resource.
> +
> +	  Note, this test expects to be able to find at least
> +	  256MB of CMA space (CONFIG_CMA_SIZE_MBYTES) or it will fail to

It seems to actually be wanting >= 584MB.

-- ljk

> +	  load.  Kconfig does not allow for numerical value
> +	  dependencies, so we can only warn at runtime.
> +
> +	  Say N unless you are doing development of the 'nd' subsystem.
> +
>  endif
