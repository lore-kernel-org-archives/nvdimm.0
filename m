From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2] nvdimm: btt_devs: fix a NULL pointer dereference
Date: Mon, 25 Mar 2019 09:56:36 +0100
Message-ID: <08d11679-8efd-3710-b7b5-a25714c37920@suse.de>
References: <20190323214125.10233-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190323214125.10233-1-pakki001@umn.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: linux-nvdimm@lists.01.org, kjlu@umn.edu, linux-kernel@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

On 23/03/2019 22:41, Aditya Pakki wrote:
> In case kmemdup fails, the fix releases resources and returns to
> avoid the NULL pointer dereference.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> 
> ---
> v1: Free nd_btt->id in case of failure and avoid double free, suggested
> by Dan Williams
> ---
>  drivers/nvdimm/btt_devs.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index b72a303176c7..119a4ead2e46 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c
> @@ -204,8 +204,14 @@ static struct device *__nd_btt_create(struct nd_region *nd_region,
>  	}
>  
>  	nd_btt->lbasize = lbasize;
> -	if (uuid)
> +	if (uuid) {
>  		uuid = kmemdup(uuid, 16, GFP_KERNEL);
> +		if (!uuid) {
> +			kfree(nd_btt->id);
> +			kfree(nd_btt);
> +			return NULL;
> +		}
> +	}

nd_btt->id is an ida and thus must be freed using:
ida_simple_remove(&nd_region->btt_ida, nd_btt->id);

that being I'd prefer a 'out_put_id' label at the end of the function
and to the cleanups there.

Something like this:

	if (uuid) {
		uuid = kmemdup(uuid, 16, GFP_KERNEL);
		if (!uuid)
			goto out_put_id;

	[...]

	return dev;

out_put_id:
	ida_simple_remove(&nd_region->btt_ida, nd_btt->id);
	kfree(nd_btt);
	return NULL;
}


-- 
Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
