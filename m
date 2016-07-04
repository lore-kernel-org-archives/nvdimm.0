Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.nue.novell.com (smtp.nue.novell.com [195.135.221.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5FD61A1E03
 for <linux-nvdimm@lists.01.org>; Mon,  4 Jul 2016 00:55:06 -0700 (PDT)
Date: Mon, 4 Jul 2016 15:54:04 +0800
From: joeyli <jlee@suse.com>
Subject: Re: [PATCH] nfit: use devm_add_action_or_reset()
Message-ID: <20160704075404.GB10278@linux-rxt1.site>
References: <1467606771-21704-1-git-send-email-vikas.cha.sajjan@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1467606771-21704-1-git-send-email-vikas.cha.sajjan@hpe.com>
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
To: Vikas C Sajjan <vikas.cha.sajjan@hpe.com>
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 04, 2016 at 10:02:51AM +0530, Vikas C Sajjan wrote:
> If devm_add_action() fails, we are explicitly calling the cleanup to free
> the resources allocated. Lets use the helper devm_add_action_or_reset()
> and return directly in case of error, since the cleanup function
> has been already called by the helper if there was any error.
> 
> Signed-off-by: Vikas C Sajjan <vikas.cha.sajjan@hpe.com>
> ---
>  drivers/acpi/nfit.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index c2ad967..44ebe1e 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -1920,11 +1920,11 @@ static int acpi_nfit_insert_resource(struct acpi_nfit_desc *acpi_desc,
>  	if (ret)
>  		return ret;
>  
> -	ret = devm_add_action(acpi_desc->dev, acpi_nfit_remove_resource, res);
> -	if (ret) {
> -		remove_resource(res);
> +	ret = devm_add_action_or_reset(acpi_desc->dev,
> +					acpi_nfit_remove_resource,
> +					res);
> +	if (ret)
>  		return ret;
> -	}
>  
>  	return 0;
>  }
> -- 
> 1.9.1
>

Reviewed-by: Lee, Chun-Yi <jlee@suse.com>

Joey Lee 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
