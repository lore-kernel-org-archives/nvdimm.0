Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A093C05;
	Tue, 28 Jun 2022 15:25:54 +0000 (UTC)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXSzV0H6Vz688Bk;
	Tue, 28 Jun 2022 23:23:34 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 17:25:51 +0200
Received: from localhost (10.202.226.42) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 28 Jun
 2022 16:25:50 +0100
Date: Tue, 28 Jun 2022 16:25:49 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <hch@infradead.org>,
	<alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 06/46] cxl/core: Drop is_cxl_decoder()
Message-ID: <20220628162549.00001d15@Huawei.com>
In-Reply-To: <165603874340.551046.15491766127759244728.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<165603874340.551046.15491766127759244728.stgit@dwillia2-xfh>
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

On Thu, 23 Jun 2022 19:45:43 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> This helper was only used to identify the object type for lockdep
> purposes. Now that lockdep support is done with explicit lock classes,
> this helper can be dropped.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
FWIW..

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  drivers/cxl/core/port.c |    6 ------
>  drivers/cxl/cxl.h       |    1 -
>  2 files changed, 7 deletions(-)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index b51eb41aa839..13c321afe076 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -271,12 +271,6 @@ bool is_root_decoder(struct device *dev)
>  }
>  EXPORT_SYMBOL_NS_GPL(is_root_decoder, CXL);
>  
> -bool is_cxl_decoder(struct device *dev)
> -{
> -	return dev->type && dev->type->release == cxl_decoder_release;
> -}
> -EXPORT_SYMBOL_NS_GPL(is_cxl_decoder, CXL);
> -
>  struct cxl_decoder *to_cxl_decoder(struct device *dev)
>  {
>  	if (dev_WARN_ONCE(dev, dev->type->release != cxl_decoder_release,
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 35ce17872fc1..6e08fe8cc0fe 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -337,7 +337,6 @@ struct cxl_dport *cxl_find_dport_by_dev(struct cxl_port *port,
>  struct cxl_decoder *to_cxl_decoder(struct device *dev);
>  bool is_root_decoder(struct device *dev);
>  bool is_endpoint_decoder(struct device *dev);
> -bool is_cxl_decoder(struct device *dev);
>  struct cxl_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
>  					   unsigned int nr_targets);
>  struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
> 

