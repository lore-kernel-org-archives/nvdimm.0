Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91B65107
	for <nvdimm@lists.linux.dev>; Wed,  9 Mar 2022 18:33:31 +0000 (UTC)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.200])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KDLRJ1f2jz67drY;
	Thu, 10 Mar 2022 02:33:00 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 19:33:28 +0100
Received: from localhost (10.47.72.217) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 9 Mar
 2022 18:33:27 +0000
Date: Wed, 9 Mar 2022 18:33:23 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <gregkh@linuxfoundation.org>, <rafael.j.wysocki@intel.com>, "Alison
 Schofield" <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, Ben Widawsky
	<ben.widawsky@intel.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 05/11] cxl/core: Introduce cxl_set_lock_class()
Message-ID: <20220309183323.00000048@Huawei.com>
In-Reply-To: <164610295699.2682974.3646198829625502263.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164610292916.2682974.12924748003366352335.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164610295699.2682974.3646198829625502263.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.47.72.217]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Mon, 28 Feb 2022 18:49:17 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> Update CONFIG_PROVE_CXL_LOCKING to use the common device-core helpers
> for device_lock validation.
> 
> When CONFIG_PROVE_LOCKING is enabled and device_set_lock_class() is
> passed a non-zero lock class the core acquires the 'struct device'
> @lockdep_mutex everywhere it acquires the device_lock. Where
> lockdep_mutex does not skip lockdep validation like device_lock.
> 
> cxl_set_lock_class() wraps device_set_lock_class() as to not collide
> with other subsystems that may also support this lockdep validation
> scheme. See the 'choice' for the various CONFIG_PROVE_$SUBSYS_LOCKING
> options in lib/Kconfig.debug.
> 
> Cc: Alison Schofield <alison.schofield@intel.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

One query inline - otherwise looks good to me.

> ---

> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index b1a4ba622739..f0a821de94cf 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -476,6 +476,7 @@ int cxl_add_region(struct cxl_decoder *cxld, struct cxl_region *cxlr)
>  	if (rc)
>  		goto err;
>  
> +	cxl_set_lock_class(dev);

I didn't see a cxl_lock_class for regions. Or is this meant to use
the ANON_LOCK?


>  	rc = device_add(dev);
>  	if (rc)
>  		goto err;
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 1357a245037d..f94eff659cce 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -543,5 +543,14 @@ static inline int cxl_lock_class(struct device *dev)
>  	else
>  		return CXL_ANON_LOCK;
>  }
> +
> +static inline void cxl_set_lock_class(struct device *dev)
> +{
> +	device_set_lock_class(dev, cxl_lock_class(dev));
> +}
> +#else
> +static inline void cxl_set_lock_class(struct device *dev)
> +{
> +}
>  #endif
>  #endif /* __CXL_H__ */
> 

