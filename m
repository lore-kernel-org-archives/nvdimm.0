Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 569272119175E
 for <linux-nvdimm@lists.01.org>; Mon,  3 Dec 2018 12:12:26 -0800 (PST)
Subject: Re: [PATCH] acpi/nfit: Fix user-initiated ARS to be "ARS-long" rather
 than "ARS-short"
References: <154386182529.24428.16722249724563229676.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <6345bd3b-b5c0-eb51-bd81-878cd764e66d@intel.com>
Date: Mon, 3 Dec 2018 13:12:24 -0700
MIME-Version: 1.0
In-Reply-To: <154386182529.24428.16722249724563229676.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jacek Zloch <jacek.zloch@intel.com>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


On 12/3/2018 11:30 AM, Dan Williams wrote:
> A "short" ARS (address range scrub) instructs the platform firmware to
> return known errors. In contrast, a "long" ARS instructs platform
> firmware to arrange every data address on the DIMM to be read / checked
> for poisoned data.
>
> The conversion of the flags in commit d3abaf43bab8 "acpi, nfit: Fix
> Address Range Scrub completion tracking", changed the meaning of passing
> '0' to acpi_nfit_ars_rescan(). Previously '0' meant "not short", now '0'
> is ARS_REQ_SHORT. Pass ARS_REQ_LONG to restore the expected scrub-type
> behavior of user-initiated ARS sessions.
>
> Fixes: d3abaf43bab8 ("acpi, nfit: Fix Address Range Scrub completion tracking")
> Reported-by: Jacek Zloch <jacek.zloch@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   drivers/acpi/nfit/core.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 14d9f5bea015..5912d30020c7 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1308,7 +1308,7 @@ static ssize_t scrub_store(struct device *dev,
>   	if (nd_desc) {
>   		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
>   
> -		rc = acpi_nfit_ars_rescan(acpi_desc, 0);
> +		rc = acpi_nfit_ars_rescan(acpi_desc, ARS_REQ_LONG);
>   	}
>   	device_unlock(dev);
>   	if (rc)
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
