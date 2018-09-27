Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14A2921159C83
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 08:47:10 -0700 (PDT)
Subject: Re: [PATCH] libnvdimm, security: Comment fixes
References: <153801494828.825550.15533638717371880458.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <22557718-daeb-0573-afde-a23c3d5944ae@intel.com>
Date: Thu, 27 Sep 2018 08:47:09 -0700
MIME-Version: 1.0
In-Reply-To: <153801494828.825550.15533638717371880458.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 09/26/2018 07:22 PM, Dan Williams wrote:
> Correct some spelling and stray comments.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/nvdimm/dimm_devs.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 06d0395c1f43..8740c6c61912 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -237,8 +237,8 @@ static int nvdimm_security_erase(struct device *dev, unsigned int keyid)
>  	rc = nvdimm->security_ops->erase(nvdimm,
>  			(struct nvdimm_key_data *) payload->data);
>  	up_read(&key->sem);
> -	/* remove key since secure erase kills the passphrase */
>  
> +	/* remove key since secure erase kills the passphrase */
>  	if (!is_userkey) {
>  		key_unlink(nvdimm_keyring, key);
>  		key_invalidate(key);
> @@ -423,14 +423,12 @@ static int nvdimm_security_change_key(struct device *dev,
>  		goto out;
>  	}
>  
> -	/* we need to check description as well */
> -
>  	if (!update)
>  		key = nvdimm_replace_key(key);
>  
>  	/*
> -	 * We don't need to release key->sem here because nvdimm_repalce_key
> -	 * will.
> +	 * We don't need to release key->sem here because
> +	 * nvdimm_replace_key will.
>  	 */
>  	if (!key)
>  		goto out;
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
