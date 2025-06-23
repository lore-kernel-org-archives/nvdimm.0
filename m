Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AB322F77F
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 09:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670455; cv=none; b=iE16pQfjksMelCFHhXL+JAr6/eYSIbcug2vevtEcSeNcUzUi5ihB8GWQS/Qp0kUcCj/JwUG1Tk+Jf2gG2iTMnww080RhS8F0RgBBKe5eJdC9gn0kWMhb8D4Od3GfdODtLwKGXusmEYOPOyozs8Zqj9ihqhtxp4NLGcBHegzkK0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670455; c=relaxed/simple;
	bh=yPNVRmb7MDtEqXGhH5b4pWnQ1vD1JGAVWJ7awgEhwaA=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pEhfjMC1OIAGZW0bIqLCi3BdKtwSuZ+bCixCUsvy4C3Y/i5YvCgocly1tBrdE41yTX1IDSYnWb0EggoJgNviX47pc3MNc8boZ3ukIwZkg8GcyT22Tkcu6t2yZZi+uF1TTFH5xcmByDxG2x6oiT/JVYhHPgEwEt12JF560F1um50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQjGZ5D7Fz6M539;
	Mon, 23 Jun 2025 17:20:06 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 3519F1402E9;
	Mon, 23 Jun 2025 17:20:49 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 11:20:48 +0200
Date: Mon, 23 Jun 2025 10:20:47 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <dan.j.williams@intel.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <a.manzanares@samsung.com>, <nifan.cxl@gmail.com>,
	<anisa.su@samsung.com>, <vishak.g@samsung.com>, <krish.reddy@samsung.com>,
	<arun.george@samsung.com>, <alok.rathore@samsung.com>,
	<neeraj.kernel@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<gost.dev@samsung.com>, <cpgs@samsung.com>
Subject: Re: [RFC PATCH 13/20] cxl/mem: Refactor cxl pmem region
 auto-assembling
Message-ID: <20250623102047.000020fc@huawei.com>
In-Reply-To: <1213349904.281750165205974.JavaMail.epsvc@epcpadp1new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124043epcas5p21e5b77aa3a6acfa7e01847ffd58350ed@epcas5p2.samsung.com>
	<1213349904.281750165205974.JavaMail.epsvc@epcpadp1new>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500011.china.huawei.com (7.191.174.215) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 17 Jun 2025 18:09:37 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> In 84ec985944ef3, For cxl pmem region auto-assembly after endpoint port
> probing, cxl_nvd presence was required. And for cxl region persistency,
> region creation happens during nvdimm_probe which need the completion
> of endpoint probe.
> 
> It is therefore refactored cxl pmem region auto-assembly after endpoint
> probing to cxl mem probing
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
For ordering requirements this needs more eyes.  I've never cared that
much about he persistency and auto assembly code so not something I have
a good mental model of!


> ---
>  drivers/cxl/core/port.c | 38 ++++++++++++++++++++++++++++++++++++++
>  drivers/cxl/cxl.h       |  1 +
>  drivers/cxl/mem.c       | 27 ++++++++++++++++++---------
>  drivers/cxl/port.c      | 38 --------------------------------------
>  4 files changed, 57 insertions(+), 47 deletions(-)

> diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
> index 2f03a4d5606e..aaea4eb178ef 100644
> --- a/drivers/cxl/mem.c
> +++ b/drivers/cxl/mem.c

> @@ -180,6 +171,24 @@ static int cxl_mem_probe(struct device *dev)
>  			return rc;
>  	}
>  
> +	if (resource_size(&cxlds->pmem_res) && IS_ENABLED(CONFIG_CXL_PMEM)) {
> +		rc = devm_cxl_add_nvdimm(parent_port, cxlmd);
> +		if (rc) {
> +			if (rc == -ENODEV)
> +				dev_info(dev, "PMEM disabled by platform\n");
> +			return rc;
> +		}
> +	}
> +
> +	/*
> +	 * Now that all endpoint decoders are successfully enumerated, try to
> +	 * assemble region autodiscovery from committed decoders.
> +	 * Earlier it was part of cxl_endpoint_port_probe, So moved it here

I would drop this history statement. Good to have in the patch description
but no point in keeping it in the code. Just state what the requirements
are now.

> +	 * as cxl_nvd of the memdev needs to be available during the pmem
> +	 * region auto-assembling
> +	 */
> +	cxl_region_discovery(cxlmd->endpoint);
> +
>  	/*
>  	 * The kernel may be operating out of CXL memory on this device,



