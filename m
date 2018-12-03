Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 204CE21A07A80
 for <linux-nvdimm@lists.01.org>; Mon,  3 Dec 2018 13:19:18 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] acpi/nfit: Fix user-initiated ARS to be "ARS-long"
 rather than "ARS-short"
Date: Mon, 3 Dec 2018 21:19:17 +0000
Message-ID: <f62c2c146b846286a19bf708aa7204d5341b1fe4.camel@intel.com>
References: <154386182529.24428.16722249724563229676.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154386182529.24428.16722249724563229676.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <A828882E70DA6D41BFD2CD7592019C98@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "Zloch, Jacek" <jacek.zloch@intel.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>


On Mon, 2018-12-03 at 10:30 -0800, Dan Williams wrote:
> A "short" ARS (address range scrub) instructs the platform firmware
> to
> return known errors. In contrast, a "long" ARS instructs platform
> firmware to arrange every data address on the DIMM to be read /
> checked
> for poisoned data.
> 
> The conversion of the flags in commit d3abaf43bab8 "acpi, nfit: Fix
> Address Range Scrub completion tracking", changed the meaning of
> passing
> '0' to acpi_nfit_ars_rescan(). Previously '0' meant "not short", now
> '0'
> is ARS_REQ_SHORT. Pass ARS_REQ_LONG to restore the expected scrub-
> type
> behavior of user-initiated ARS sessions.
> 
> Fixes: d3abaf43bab8 ("acpi, nfit: Fix Address Range Scrub completion
> tracking")
> Reported-by: Jacek Zloch <jacek.zloch@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks good,
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 14d9f5bea015..5912d30020c7 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1308,7 +1308,7 @@ static ssize_t scrub_store(struct device *dev,
>  	if (nd_desc) {
>  		struct acpi_nfit_desc *acpi_desc =
> to_acpi_desc(nd_desc);
>  
> -		rc = acpi_nfit_ars_rescan(acpi_desc, 0);
> +		rc = acpi_nfit_ars_rescan(acpi_desc, ARS_REQ_LONG);
>  	}
>  	device_unlock(dev);
>  	if (rc)
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
