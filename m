Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1AC6721106FA6
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 15:44:27 -0700 (PDT)
Subject: Re: [PATCH] libnvdimm, dimm: Maximize label transfer size
References: <153816098159.2233877.8382846671636531035.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Message-ID: <3cf89dd3-a024-dbab-36ed-923f9466669c@linux.intel.com>
Date: Fri, 28 Sep 2018 15:44:27 -0700
MIME-Version: 1.0
In-Reply-To: <153816098159.2233877.8382846671636531035.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 9/28/2018 11:56 AM, Dan Williams wrote:
> Use kvzalloc() to bypass the arbitrary PAGE_SIZE limit of label transfer
> operations. Given the expense of calling into firmware, maximize the
> amount of label data we transfer per call to be up to the total label
> space if allowed by the firmware.
> 
> Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

This looks mostly fine to me.

The only thing I am not certain about is if we want to use the raw 
max_cmd_size value or not since there is no guarantee it is aligned to 
any sort of boundary. It might be beneficial to either cache line align 
it or align it to 256B if it is larger than that since that way we at 
least would be getting full labels instead of partial ones.

> ---
>   drivers/nvdimm/dimm_devs.c |   12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 863cabc35215..82ab96a9f560 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -111,8 +111,8 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
>   	if (!ndd->data)
>   		return -ENOMEM;
>   
> -	max_cmd_size = min_t(u32, PAGE_SIZE, ndd->nsarea.max_xfer);
> -	cmd = kzalloc(max_cmd_size + sizeof(*cmd), GFP_KERNEL);
> +	max_cmd_size = min_t(u32, ndd->nsarea.config_size, ndd->nsarea.max_xfer);
> +	cmd = kvzalloc(max_cmd_size + sizeof(*cmd), GFP_KERNEL);
>   	if (!cmd)
>   		return -ENOMEM;
>   
> @@ -134,7 +134,7 @@ int nvdimm_init_config_data(struct nvdimm_drvdata *ndd)
>   		memcpy(ndd->data + offset, cmd->out_buf, cmd->in_length);
>   	}
>   	dev_dbg(ndd->dev, "len: %zu rc: %d\n", offset, rc);
> -	kfree(cmd);
> +	kvfree(cmd);
>   
>   	return rc;
>   }
> @@ -157,9 +157,9 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
>   	if (offset + len > ndd->nsarea.config_size)
>   		return -ENXIO;
>   
> -	max_cmd_size = min_t(u32, PAGE_SIZE, len);
> +	max_cmd_size = min_t(u32, ndd->nsarea.config_size, len);
>   	max_cmd_size = min_t(u32, max_cmd_size, ndd->nsarea.max_xfer);
> -	cmd = kzalloc(max_cmd_size + sizeof(*cmd) + sizeof(u32), GFP_KERNEL);
> +	cmd = kvzalloc(max_cmd_size + sizeof(*cmd) + sizeof(u32), GFP_KERNEL);
>   	if (!cmd)
>   		return -ENOMEM;
>   
> @@ -183,7 +183,7 @@ int nvdimm_set_config_data(struct nvdimm_drvdata *ndd, size_t offset,
>   			break;
>   		}
>   	}
> -	kfree(cmd);
> +	kvfree(cmd);
>   
>   	return rc;
>   }
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
