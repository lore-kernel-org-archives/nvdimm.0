Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 241A421E1DAC5
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 12:00:54 -0700 (PDT)
Date: Tue, 1 Aug 2017 15:02:57 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: enable opt-out of device-mapper dax support
Message-ID: <20170801190257.GA10033@redhat.com>
References: <150161113411.34055.9762658795237184307.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150161113411.34055.9762658795237184307.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 01 2017 at  2:12pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> Now that dax is no longer a default property of a block-device, i.e.
> ->direct_access() is not a block-device operation, we optionally enable
> device-mapper dax support with a new CONFIG_DM_DAX option.
> 
> All the dax operations helpers are moved to a new file,
> drivers/md/dm-dax.c, that is optionally compiled when CONFIG_DM_DAX=y.
> Otherwise, we stub out all the operations with NULL function pointers
> and nop wrappers for the core dax routines.
> 
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Reported-by: Bart Van Assche <Bart.VanAssche@wdc.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/md/Kconfig     |   14 +++
>  drivers/md/Makefile    |    1 
>  drivers/md/dm-dax.c    |  227 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm-dax.h    |   73 +++++++++++++++
>  drivers/md/dm-linear.c |   56 ------------
>  drivers/md/dm-snap.c   |    9 --
>  drivers/md/dm-stripe.c |   89 -------------------
>  drivers/md/dm-target.c |    7 -
>  drivers/md/dm.c        |  105 ++--------------------
>  drivers/md/dm.h        |   34 +++++++
>  10 files changed, 363 insertions(+), 252 deletions(-)
>  create mode 100644 drivers/md/dm-dax.c
>  create mode 100644 drivers/md/dm-dax.h
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 4a249ee86364..bf27b435f7cd 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -200,7 +200,6 @@ config BLK_DEV_DM_BUILTIN
>  config BLK_DEV_DM
>  	tristate "Device mapper support"
>  	select BLK_DEV_DM_BUILTIN
> -	select DAX
>  	---help---
>  	  Device-mapper is a low level volume manager.  It works by allowing
>  	  people to specify mappings for ranges of logical sectors.  Various
> @@ -214,6 +213,19 @@ config BLK_DEV_DM
>  
>  	  If unsure, say N.
>  
> +config DM_DAX
> +	bool "Direct access (DAX) support"
> +	depends on BLK_DEV_DM
> +	default BLK_DEV_PMEM
> +	select DAX
> +	---help---
> +	  Enable DAX support for the device-mapper linear and stripe
> +	  targets for use with DAX capable block devices like /dev/pmemN.
> +	  If you have a DAX capable block device and have enabled
> +	  filesystem DAX support (CONFIG_FS_DAX), then say Y.
> +
> +	  If unsure, say N.
> +

I'm questioning the need to have yet another Kbuild CONFIG option.  If
the user has enabled CONFIG_BLK_DEV_PMEM and CONFIG_FS_DAX (DAX already
gets selected by CONFIG_FS_DAX) then shouldn't the DM capabilities just
be enabled?

Guess I'm just skeptical of: why do we want to move to a model where
users need to opt-in to DM support for DAX?

I also _really_ don't like each target's DAX support being colocated in
drivers/md/dm-dax.c

This all looks and feels like a serious step backwards.

Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
