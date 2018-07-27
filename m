Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29B23210C2D6E
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 11:42:21 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] acpi/nfit: queue issuing of ars when an uc error
 notification comes in
Date: Fri, 27 Jul 2018 18:41:56 +0000
Message-ID: <1532716914.8557.39.camel@intel.com>
References: <153270745762.70694.3487924980141893382.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153270745762.70694.3487924980141893382.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <AF4F10BE095FF84B8517F9D5CDF7C040@intel.com>
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
To: "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-07-27 at 09:04 -0700, Dave Jiang wrote:
> When the ACPI UC error notifier gets called and ARS_REQ bit is set
> with the passed in flag, we can receive -EBUSY if ARS_REQ bit is already
> set for the nfit_spa->ars_state. When that happens, the ARS request is
> dropped. That can potentially cause us to miss the unreported errors that
> the on going ARS request does not receive. Add an ARS_REQ_REDO state that
> will request short ARS upon ARS completion to grab any errors we missed.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/acpi/nfit/core.c |   12 +++++++++---
>  drivers/acpi/nfit/nfit.h |    1 +
>  2 files changed, 10 insertions(+), 3 deletions(-)

Looks good to me, you can add:
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 274f636cd3d2..def64259f9a7 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -2567,7 +2567,12 @@ static void ars_complete(struct acpi_nfit_desc *acpi_desc,
>  			test_bit(ARS_SHORT, &nfit_spa->ars_state)
>  			? "short" : "long");
>  	clear_bit(ARS_SHORT, &nfit_spa->ars_state);
> -	set_bit(ARS_DONE, &nfit_spa->ars_state);
> +	if (test_and_clear_bit(ARS_REQ_REDO, &nfit_spa->ars_state)) {
> +		set_bit(ARS_SHORT, &nfit_spa->ars_state);
> +		set_bit(ARS_REQ, &nfit_spa->ars_state);
> +		dev_dbg(dev, "ARS: processing scrub request received while in progress\n");
> +	} else
> +		set_bit(ARS_DONE, &nfit_spa->ars_state);
>  }
>  
>  static int ars_status_process_records(struct acpi_nfit_desc *acpi_desc)
> @@ -3264,9 +3269,10 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, unsigned long flags)
>  		if (test_bit(ARS_FAILED, &nfit_spa->ars_state))
>  			continue;
>  
> -		if (test_and_set_bit(ARS_REQ, &nfit_spa->ars_state))
> +		if (test_and_set_bit(ARS_REQ, &nfit_spa->ars_state)) {
>  			busy++;
> -		else {
> +			set_bit(ARS_REQ_REDO, &nfit_spa->ars_state);
> +		} else {
>  			if (test_bit(ARS_SHORT, &flags))
>  				set_bit(ARS_SHORT, &nfit_spa->ars_state);
>  			scheduled++;
> diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
> index a97ff42fe311..d1274ea2d251 100644
> --- a/drivers/acpi/nfit/nfit.h
> +++ b/drivers/acpi/nfit/nfit.h
> @@ -119,6 +119,7 @@ enum nfit_dimm_notifiers {
>  
>  enum nfit_ars_state {
>  	ARS_REQ,
> +	ARS_REQ_REDO,
>  	ARS_DONE,
>  	ARS_SHORT,
>  	ARS_FAILED,
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
