Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sat, 18 Apr 2015 10:06:35 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 07/21] nd: dimm devices (nfit "memory-devices")
Message-ID: <20150418080635.GA28706@kroah.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150418013551.25237.76215.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150418013551.25237.76215.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 17, 2015 at 09:35:52PM -0400, Dan Williams wrote:
> Register the dimms described in the nfit as devices on a nd_bus, named
> "dimmN" where N is a global ida index.  The dimm numbering per-bus may
> appear contiguous, since we only allow a single nd_bus to be registered
> at at a time.  However, eventually, dimm-hotplug invalidates this
> property and dimms should be addressed via NFIT-handle.
> 
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Neil Brown <neilb@suse.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/block/nd/Makefile     |    1 
>  drivers/block/nd/bus.c        |   62 +++++++++-
>  drivers/block/nd/core.c       |   55 +++++++++
>  drivers/block/nd/dimm_devs.c  |  243 +++++++++++++++++++++++++++++++++++++++++
>  drivers/block/nd/nd-private.h |   19 +++
>  5 files changed, 373 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/block/nd/dimm_devs.c
> 
> diff --git a/drivers/block/nd/Makefile b/drivers/block/nd/Makefile
> index 7772fb599809..6b34dd4d4df8 100644
> --- a/drivers/block/nd/Makefile
> +++ b/drivers/block/nd/Makefile
> @@ -21,3 +21,4 @@ nd_acpi-y := acpi.o
>  
>  nd-y := core.o
>  nd-y += bus.o
> +nd-y += dimm_devs.o
> diff --git a/drivers/block/nd/bus.c b/drivers/block/nd/bus.c
> index c27db50511f2..e24db67001d0 100644
> --- a/drivers/block/nd/bus.c
> +++ b/drivers/block/nd/bus.c
> @@ -13,18 +13,59 @@
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  #include <linux/uaccess.h>
>  #include <linux/fcntl.h>
> +#include <linux/async.h>
>  #include <linux/slab.h>
>  #include <linux/fs.h>
>  #include <linux/io.h>
>  #include "nd-private.h"
>  #include "nfit.h"
>  
> -static int nd_major;
> +static int nd_bus_major;

Call it nd_bus_major in the previous patch, and avoid the unneeded churn
in this patch.

thanks,

greg k-h
