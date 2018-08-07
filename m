Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 86AE9210DA7A9
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 12:25:18 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ACPI: nfit: adjust annotation for why return 0 if fail
 to find NFIT at startup
Date: Tue, 7 Aug 2018 19:25:15 +0000
Message-ID: <1533669914.18175.28.camel@intel.com>
References: <1533622531-3617-1-git-send-email-oceanhehy@gmail.com>
In-Reply-To: <1533622531-3617-1-git-send-email-oceanhehy@gmail.com>
Content-Language: en-US
Content-ID: <387B8D4E660F724E90D074645DD74C78@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "oceanhehy@gmail.com" <oceanhehy@gmail.com>, "lenb@kernel.org" <lenb@kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "hehy1@lenovo.com" <hehy1@lenovo.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2018-08-07 at 02:15 -0400, Ocean He wrote:
> From: Ocean He <hehy1@lenovo.com>

Just some minor nits in commit message wording:

> 
> Add detail explanation why it's ok to return 0 if fail to find NFIT at
      detailed          ^for                       ^we          ^an
> startup, refer to chapter 9.20.2 NVDIMM Root Device in ACPI 6.2 spec.
         . Refer

Perhaps Dave can fixup while applying..
> 
> Signed-off-by: Ocean He <hehy1@lenovo.com>
> ---
> v1: https://lists.01.org/pipermail/linux-nvdimm/2018-August/017311.html 
> v2: Per Vishal's comments of v1, it turns out that it's right to keep 
> "return 0" if NFIT not found at boot time. This v2 adjust annotation
> to avoid misunderstanding of "return 0".

Looks good, thanks for the update. Feel free to add:
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
>  drivers/acpi/nfit/core.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 7c47900..1b982fe 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3353,7 +3353,13 @@ static int acpi_nfit_add(struct acpi_device *adev)
>  
>  	status = acpi_get_table(ACPI_SIG_NFIT, 0, &tbl);
>  	if (ACPI_FAILURE(status)) {
> -		/* This is ok, we could have an nvdimm hotplugged later */
> +		/* The NVDIMM root device allows OS to trigger enumeration of
> +		 * NVDIMMs through NFIT at boot time and re-enumeration at
> +		 * root level via the _FIT method during runtime.
> +		 * This is ok to return 0 here, we could have an nvdimm
> +		 * hotplugged later and evaluate _FIT method which returns
> +		 * data in the format of a series of NFIT Structures.
> +		 */
>  		dev_dbg(dev, "failed to find NFIT at startup\n");
>  		return 0;
>  	}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
