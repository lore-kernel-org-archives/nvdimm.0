Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FF87203564DC
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jan 2018 15:34:17 -0800 (PST)
Subject: Re: [ndctl PATCH 2/2] ndctl: add sector_size to 'ndctl list' output
References: <20180125232638.6585-1-ross.zwisler@linux.intel.com>
 <20180125232638.6585-2-ross.zwisler@linux.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <8bcc1523-7a9b-6532-699d-fa8eff587ee6@intel.com>
Date: Thu, 25 Jan 2018 16:39:46 -0700
MIME-Version: 1.0
In-Reply-To: <20180125232638.6585-2-ross.zwisler@linux.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 01/25/2018 04:26 PM, Ross Zwisler wrote:
> It used to be that the only PMEM namespaces with a variable sector size
> were ones with a BTT, but that has changed.  sector_size still doesn't make
> sense for device DAX since we don't have a block I/O path, and we also skip
> it if we don't have a specified sector size, as happens with namespaces of
> devtype nd_namespace_io.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>   util/json.c | 22 +++++++++++++++++-----
>   1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/util/json.c b/util/json.c
> index 95beaa2..89306f0 100644
> --- a/util/json.c
> +++ b/util/json.c
> @@ -718,11 +718,6 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>   			goto err;
>   		json_object_object_add(jndns, "uuid", jobj);
>   
> -		jobj = json_object_new_int(ndctl_btt_get_sector_size(btt));
> -		if (!jobj)
> -			goto err;
> -		json_object_object_add(jndns, "sector_size", jobj);
> -
>   		bdev = ndctl_btt_get_block_device(btt);
>   	} else if (pfn) {
>   		ndctl_pfn_get_uuid(pfn, uuid);
> @@ -774,6 +769,23 @@ struct json_object *util_namespace_to_json(struct ndctl_namespace *ndns,
>   	} else
>   		bdev = ndctl_namespace_get_block_device(ndns);
>   
> +	jobj = NULL;
> +	if (btt) {
> +		jobj = json_object_new_int(ndctl_btt_get_sector_size(btt));
> +		if (!jobj)
> +			goto err;
> +	} else if (!dax) {
> +		unsigned int sector_size = ndctl_namespace_get_sector_size(ndns);
> +
> +		if (sector_size) {
> +			jobj = json_object_new_int(sector_size);
> +			if (!jobj)
> +				goto err;
> +		}
> +	}
> +	if (jobj)
> +		json_object_object_add(jndns, "sector_size", jobj);
> +
>   	if (bdev && bdev[0]) {
>   		jobj = json_object_new_string(bdev);
>   		if (!jobj)
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
