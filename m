Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B353A2C9C
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 12:55:50 +0000 (UTC)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jp4ZW07YSz67b9w;
	Tue,  1 Feb 2022 20:52:03 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Feb 2022 13:55:48 +0100
Received: from localhost (10.202.226.41) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 1 Feb
 2022 12:55:47 +0000
Date: Tue, 1 Feb 2022 12:55:45 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <ben.widawsky@intel.com>
Subject: Re: [PATCH 1/2] cxl/core/port: Fix / relax decoder target
 enumeration
Message-ID: <20220201125545.00003d48@Huawei.com>
In-Reply-To: <164317464406.3438644.6609329492458460242.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164317463887.3438644.4087819721493502301.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164317464406.3438644.6609329492458460242.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.41]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Tue, 25 Jan 2022 21:24:04 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> If the decoder is not presently active the target_list may not be
> accurate. Perform a best effort mapping and assume that it will be fixed
> up when the decoder is enabled.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Make sense.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/cxl/acpi.c      |    2 +-
>  drivers/cxl/core/port.c |    5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
> index df6691d0a6d0..f64d98bfcb3b 100644
> --- a/drivers/cxl/acpi.c
> +++ b/drivers/cxl/acpi.c
> @@ -15,7 +15,7 @@
>  
>  static unsigned long cfmws_to_decoder_flags(int restrictions)
>  {
> -	unsigned long flags = 0;
> +	unsigned long flags = CXL_DECODER_F_ENABLE;
>  
>  	if (restrictions & ACPI_CEDT_CFMWS_RESTRICT_TYPE2)
>  		flags |= CXL_DECODER_F_TYPE2;
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 224a4853a33e..e75e0d4fb894 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -1263,8 +1263,11 @@ int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
>  	port = to_cxl_port(cxld->dev.parent);
>  	if (!is_endpoint_decoder(dev)) {
>  		rc = decoder_populate_targets(cxld, port, target_map);
> -		if (rc)
> +		if (rc && (cxld->flags & CXL_DECODER_F_ENABLE)) {
> +			dev_err(&port->dev,
> +				"Failed to populate active decoder targets\n");
>  			return rc;
> +		}
>  	}
>  
>  	rc = dev_set_name(dev, "decoder%d.%d", port->id, cxld->id);
> 

