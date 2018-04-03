Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 01AD2226C7C34
 for <linux-nvdimm@lists.01.org>; Tue,  3 Apr 2018 08:31:02 -0700 (PDT)
Subject: Re: [PATCH 2/6] nfit, address-range-scrub: fix scrub in-progress
 reporting
References: <152273076087.38372.4803377088477706610.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152273077198.38372.11857145045474104173.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <f4647d2b-dcc9-f54b-7674-2bc96aec10cf@intel.com>
Date: Tue, 3 Apr 2018 08:31:01 -0700
MIME-Version: 1.0
In-Reply-To: <152273077198.38372.11857145045474104173.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: stable@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


On 4/2/2018 9:46 PM, Dan Williams wrote:
> There is a small window whereby ARS scan requests can schedule work that
> userspace will miss when polling scrub_show. Hold the init_mutex lock
> over calls to report the status to close this potential escape. Also,
> make sure that requests to cancel the ARS workqueue are treated as an
> idle event.
>
> Cc: <stable@vger.kernel.org>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Fixes: 37b137ff8c83 ("nfit, libnvdimm: allow an ARS scrub...")
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>


> ---
>   drivers/acpi/nfit/core.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index ea9f3e727fef..2a1fc3817a81 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1249,8 +1249,11 @@ static ssize_t scrub_show(struct device *dev,
>   	if (nd_desc) {
>   		struct acpi_nfit_desc *acpi_desc = to_acpi_desc(nd_desc);
>   
> +		mutex_lock(&acpi_desc->init_mutex);
>   		rc = sprintf(buf, "%d%s", acpi_desc->scrub_count,
> -				(work_busy(&acpi_desc->work)) ? "+\n" : "\n");
> +				work_busy(&acpi_desc->work)
> +				&& !acpi_desc->cancel ? "+\n" : "\n");
> +		mutex_unlock(&acpi_desc->init_mutex);
>   	}
>   	device_unlock(dev);
>   	return rc;
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
