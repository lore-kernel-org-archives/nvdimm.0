Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5B44210D8528
 for <linux-nvdimm@lists.01.org>; Fri,  3 Aug 2018 10:11:48 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ACPI: nfit: return -ENODEV if fail to find NFIT at startup
Date: Fri, 3 Aug 2018 17:11:41 +0000
Message-ID: <1533316299.8557.71.camel@intel.com>
References: <1533289198-11400-1-git-send-email-oceanhehy@gmail.com>
In-Reply-To: <1533289198-11400-1-git-send-email-oceanhehy@gmail.com>
Content-Language: en-US
Content-ID: <CE939AF9BD0A30438FEC5A12E3B27967@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "oceanhehy@gmail.com" <oceanhehy@gmail.com>, "Jiang, Dave" <dave.jiang@intel.com>, "lenb@kernel.org" <lenb@kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "hehy1@lenovo.com" <hehy1@lenovo.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-08-03 at 05:39 -0400, Ocean He wrote:
> From: Ocean He <hehy1@lenovo.com>
> 
> In the beginning of acpi_nfit_add, if fail to find NFIT table then
> should
> return -ENODEV, instead of 0.
> 
> Signed-off-by: Ocean He <hehy1@lenovo.com>
> ---
>  drivers/acpi/nfit/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 7c47900..1790d7c 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3355,7 +3355,7 @@ static int acpi_nfit_add(struct acpi_device
> *adev)
>  	if (ACPI_FAILURE(status)) {
>  		/* This is ok, we could have an nvdimm hotplugged
> later */
>  		dev_dbg(dev, "failed to find NFIT at startup\n");
> -		return 0;
> +		return -ENODEV;

Hm, the comment directly above this says this is ok..
Has this caused any problems in practice?

>  	}
>  
>  	rc = devm_add_action_or_reset(dev, acpi_nfit_put_table,
> tbl);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
