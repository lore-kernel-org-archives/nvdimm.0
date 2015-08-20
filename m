Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1440092994.30197.5.camel@linux.intel.com>
Subject: Re: [PATCH] nvdimm: change to use generic kvfree()
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Thu, 20 Aug 2015 11:49:54 -0600
In-Reply-To: <1440064809-26036-1-git-send-email-yalin.wang2010@gmail.com>
References: <1440064809-26036-1-git-send-email-yalin.wang2010@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: yalin wang <yalin.wang2010@gmail.com>
Cc: dan.j.williams@intel.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2015-08-20 at 18:00 +0800, yalin wang wrote:
> Signed-off-by: yalin wang <yalin.wang2010@gmail.com>
> ---
>  drivers/nvdimm/dimm_devs.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index c05eb80..651b8d1 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -241,10 +241,7 @@ void nvdimm_drvdata_release(struct kref *kref)
>  		nvdimm_free_dpa(ndd, res);
>  	nvdimm_bus_unlock(dev);
>  
> -	if (ndd->data && is_vmalloc_addr(ndd->data))
> -		vfree(ndd->data);
> -	else
> -		kfree(ndd->data);
> +	kvfree(ndd->data);
>  	kfree(ndd);
>  	put_device(dev);
>  }

This seems fine.  You're skipping the existing check to see if ndd->data is
NULL, but I think that is handled implicitly by is_vmalloc_addr() since NULL
won't be in the vmalloc address range.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>


