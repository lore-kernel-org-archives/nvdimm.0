Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4BC621E082AE
 for <linux-nvdimm@lists.01.org>; Mon,  5 Mar 2018 19:48:21 -0800 (PST)
Date: Mon, 5 Mar 2018 20:54:34 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] libnvdimm: remove redundant __func__ in dev_dbg
Message-ID: <20180306035434.GC15227@linux.intel.com>
References: <152029856149.39547.12704338925946035297.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152029856149.39547.12704338925946035297.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 05, 2018 at 05:09:21PM -0800, Dan Williams wrote:
> Dynamic debug can be instructed to add the function name to the debug
> output using the +f switch, so there is no need for the libnvdimm
> modules to do it again. If a user decides to add the +f switch for
> libnvdimm's dynamic debug this results in double prints of the function
> name.
> 
> Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/badrange.c       |    3 +-
>  drivers/nvdimm/btt_devs.c       |   21 ++++++++--------
>  drivers/nvdimm/bus.c            |   13 +++++-----
>  drivers/nvdimm/claim.c          |    2 +-
>  drivers/nvdimm/core.c           |    4 ++-
>  drivers/nvdimm/dax_devs.c       |    5 ++--
>  drivers/nvdimm/dimm_devs.c      |    7 ++---
>  drivers/nvdimm/label.c          |   51 ++++++++++++++++++---------------------
>  drivers/nvdimm/namespace_devs.c |   38 ++++++++++++-----------------
>  drivers/nvdimm/pfn_devs.c       |   25 +++++++++----------
>  drivers/nvdimm/pmem.c           |    2 +-
>  11 files changed, 77 insertions(+), 94 deletions(-)
> 
> diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
> index e068d72b4357..df17f1cd696d 100644
> --- a/drivers/nvdimm/badrange.c
> +++ b/drivers/nvdimm/badrange.c
> @@ -176,8 +176,7 @@ static void set_badblock(struct badblocks *bb, sector_t s, int num)
>  			(u64) s * 512, (u64) num * 512);
>  	/* this isn't an error as the hardware will still throw an exception */
>  	if (badblocks_set(bb, s, num, 1))
> -		dev_info_once(bb->dev, "%s: failed for sector %llx\n",
> -				__func__, (u64) s);
> +		dev_info_once(bb->dev, "failed for sector %llx\n", (u64) s);

I don't think you should remove this one.  dev_info_once() is just a printk(),
and doesn't inherit the +f flag from the dynamic debugging code. The __func__
here does add value.

The rest of these look correct, though I think you missed one in each of
nvdimm_map_release() and validate_dimm().  (I made these changes as well, but
you sent out your patch first. :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
