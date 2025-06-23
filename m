Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D5822FF37
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 09:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750671895; cv=none; b=Sqlu/4NbXg5EXzCPd6HD7P24AycXhoXbdZmMQmJAoRcpvcoO05cfxczgbJv01jHIcUFq2H/g8LaK6T4vcyAIc30N1/sX/0t8YpMiKP+h8CxY+oZBKQoNWcVs20oc9MqsFzl5oCQDizKflMwZZV79JNn7PKMrRsrJmvgk2I/iytM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750671895; c=relaxed/simple;
	bh=tVBj86PgtKM5634jqszKnYiIMkwXNySjUTkVWBXtn0w=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UKNRaeKUDN1w43SGY9Dmdjr3yongZqsbi3IeHy9cnyLxuFLtz9/ZV6C94L1BSY97dUc9rJIWK4uRLqZQpaaq2K2R/pNpZ1Y25NRDKur06lPwLHF/bYSj7S4c8RssA/LOJmGmG3laZ/hS/twLUaYdR6+IuRA7AOHlieDj4PWOB9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQjpJ6gSWz6M51k;
	Mon, 23 Jun 2025 17:44:08 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 6D23B1402E9;
	Mon, 23 Jun 2025 17:44:51 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 11:44:50 +0200
Date: Mon, 23 Jun 2025 10:44:49 +0100
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
Subject: Re: [RFC PATCH 15/20] cxl: Add a routine to find cxl root decoder
 on cxl bus
Message-ID: <20250623104449.000069b3@huawei.com>
In-Reply-To: <1295226194.21750165382072.JavaMail.epsvc@epcpadp2new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8@epcas5p1.samsung.com>
	<1295226194.21750165382072.JavaMail.epsvc@epcpadp2new>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 17 Jun 2025 18:09:39 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Add cxl_find_root_decoder to find root decoder on cxl bus. It is used to
> find root decoder during region creation
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/cxl/core/port.c | 26 ++++++++++++++++++++++++++
>  drivers/cxl/cxl.h       |  1 +
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index 2452f7c15b2d..94d9322b8e38 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -513,6 +513,32 @@ struct cxl_switch_decoder *to_cxl_switch_decoder(struct device *dev)
>  }
>  EXPORT_SYMBOL_NS_GPL(to_cxl_switch_decoder, "CXL");
>  
> +static int match_root_decoder(struct device *dev, void *data)
> +{
> +	return is_root_decoder(dev);
> +}
> +
> +/**
> + * cxl_find_root_decoder() - find a cxl root decoder on cxl bus
> + * @port: any descendant port in root-cxl-port topology
> + */
> +struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port)
> +{
> +	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
> +	struct device *dev;
> +
> +	if (!cxl_root)
> +		return NULL;
> +
> +	dev = device_find_child(&cxl_root->port.dev, NULL, match_root_decoder);
> +

No blank line here.  Generally when we have a call then an error check
it is easier to see how they are related if we keep them in one block.

> +	if (!dev)
> +		return NULL;
> +
> +	return to_cxl_root_decoder(dev);
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_find_root_decoder, "CXL");
> +
>  static void cxl_ep_release(struct cxl_ep *ep)
>  {
>  	put_device(ep->ep);
> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
> index 30c80e04cb27..2c6a782d0941 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -871,6 +871,7 @@ bool is_cxl_nvdimm_bridge(struct device *dev);
>  int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
>  struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
>  void cxl_region_discovery(struct cxl_port *port);
> +struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port);
>  
>  #ifdef CONFIG_CXL_REGION
>  bool is_cxl_pmem_region(struct device *dev);

