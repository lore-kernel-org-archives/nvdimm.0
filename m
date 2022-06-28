Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AF73D6F;
	Tue, 28 Jun 2022 17:04:15 +0000 (UTC)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXW6z1gZ7z67MLx;
	Wed, 29 Jun 2022 01:00:11 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 19:04:12 +0200
Received: from localhost (10.202.226.42) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 28 Jun
 2022 18:04:12 +0100
Date: Tue, 28 Jun 2022 18:04:10 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <bwidawsk@kernel.org>,
	<hch@infradead.org>, <alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 13/46] cxl/hdm: Require all decoders to be enumerated
Message-ID: <20220628180410.000042dd@Huawei.com>
In-Reply-To: <165603879664.551046.6863805202478861026.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<165603879664.551046.6863805202478861026.stgit@dwillia2-xfh>
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
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 19:46:36 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Ben Widawsky <bwidawsk@kernel.org>
> 
> In preparation for region provisioning all device decoders need to be
> enumerated since DPA allocations are calculated by summing the
> capacities of all decoders in a set. I.e. the programming for decoder[N]
> depends on the state of decoder[N-1], so skipping over decoders that
> fail to initialize prevents accurate DPA accounting.
> 
> Signed-off-by: Ben Widawsky <bwidawsk@kernel.org>
> [djbw: reword changelog]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Good to see this tidied up the handling always felt a bit odd..

> ---
>  drivers/cxl/core/hdm.c |   12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> index 2223d151b61b..c940a4911fee 100644
> --- a/drivers/cxl/core/hdm.c
> +++ b/drivers/cxl/core/hdm.c
> @@ -199,7 +199,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
>  {
>  	void __iomem *hdm = cxlhdm->regs.hdm_decoder;
>  	struct cxl_port *port = cxlhdm->port;
> -	int i, committed, failed;
> +	int i, committed;
>  	u32 ctrl;
>  
>  	/*
> @@ -219,7 +219,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
>  	if (committed != cxlhdm->decoder_count)
>  		msleep(20);
>  
> -	for (i = 0, failed = 0; i < cxlhdm->decoder_count; i++) {
> +	for (i = 0; i < cxlhdm->decoder_count; i++) {
>  		int target_map[CXL_DECODER_MAX_INTERLEAVE] = { 0 };
>  		int rc, target_count = cxlhdm->target_count;
>  		struct cxl_decoder *cxld;
> @@ -250,8 +250,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
>  		rc = init_hdm_decoder(port, cxld, target_map, hdm, i);
>  		if (rc) {
>  			put_device(&cxld->dev);
> -			failed++;
> -			continue;
> +			return rc;
>  		}
>  		rc = add_hdm_decoder(port, cxld, target_map);
>  		if (rc) {
> @@ -261,11 +260,6 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm)
>  		}
>  	}
>  
> -	if (failed == cxlhdm->decoder_count) {
> -		dev_err(&port->dev, "No valid decoders found\n");
> -		return -ENXIO;
> -	}
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL_NS_GPL(devm_cxl_enumerate_decoders, CXL);
> 

