Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DA4253F16
	for <nvdimm@lists.linux.dev>; Fri, 20 Jun 2025 16:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750437611; cv=none; b=m1TSgJxcHdngSsd4rZEaGfXiQZmkwcAqy99/NnVulhIGxpWuRgFKeh0YWN8Zvw7wBx2sk1xohkyTWSrMGd4oK6761fGrJB296uhFh3NvdEzJAmWKx7lMaPmDwxlhBkbpox9EFZnodi8WgYR9J7hGNQMGCtdV/JW555bGx4G/zko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750437611; c=relaxed/simple;
	bh=6MOrDPSqajVX9dglL2iIpKlky0ZC16o6M1J4f7fNxNY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K0PXggmM8itYYwLSdOgJekXP++PjdKx3q2brdUI1nThWBzUYDuCzj7RrTCVDg5BL3JvqbIwnb2V1ezS0UbXKfNCxJjqIZ7WP1SzgiwJrmS7iGCzDRC+mq7u41zEDSXyl/UI/9ZAVw7ZPwXv09G/GvPFBQqGCRE4SxVZHrhJ58ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bP36y4ySyz6L5jx;
	Sat, 21 Jun 2025 00:37:46 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id BC89B1402F3;
	Sat, 21 Jun 2025 00:40:05 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 20 Jun
 2025 18:40:04 +0200
Date: Fri, 20 Jun 2025 17:40:01 +0100
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
Subject: Re: [RFC PATCH 01/20] nvdimm/label: Introduce NDD_CXL_LABEL flag to
 set cxl label format
Message-ID: <20250620174001.00003aa2@huawei.com>
In-Reply-To: <158453976.61750165203630.JavaMail.epsvc@epcpadp1new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124008epcas5p2e702f786645d44ceb1cdd980a914ce8e@epcas5p2.samsung.com>
	<158453976.61750165203630.JavaMail.epsvc@epcpadp1new>
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

On Tue, 17 Jun 2025 18:09:25 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> NDD_CXL_LABEL is introduced to set cxl LSA 2.1 label format
> Accordingly updated label index version
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
A few local comments.  I'll need to read on to figure out how this
fits in generally.

> ---
>  drivers/nvdimm/dimm.c      |  1 +
>  drivers/nvdimm/dimm_devs.c | 10 ++++++++++
>  drivers/nvdimm/label.c     | 16 ++++++++++++----
>  drivers/nvdimm/nd.h        |  1 +
>  include/linux/libnvdimm.h  |  3 +++
>  5 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 91d9163ee303..8753b5cd91cc 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -62,6 +62,7 @@ static int nvdimm_probe(struct device *dev)
>  	if (rc < 0)
>  		dev_dbg(dev, "failed to unlock dimm: %d\n", rc);
>  
> +	ndd->cxl = nvdimm_check_cxl_label_format(ndd->dev);
>  
>  	/*
>  	 * EACCES failures reading the namespace label-area-properties
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index 21498d461fde..e8f545f889fd 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -18,6 +18,16 @@
>  
>  static DEFINE_IDA(dimm_ida);
>  
> +bool nvdimm_check_cxl_label_format(struct device *dev)
> +{
> +	struct nvdimm *nvdimm = to_nvdimm(dev);
> +
> +	if (test_bit(NDD_CXL_LABEL, &nvdimm->flags))
> +		return true;
> +
> +	return false;

	return test_bit(NDD_CXL_LABEL, &nvdimm->flags);

Unless this is going to get more complex in later patches, in which case
may be fine to ignore this comment.

> +}
> +
>  /*
>   * Retrieve bus and dimm handle and return if this bus supports
>   * get_config_data commands
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 082253a3a956..48b5ba90216d 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -687,11 +687,19 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>  		- (unsigned long) to_namespace_index(ndd, 0);
>  	nsindex->labeloff = __cpu_to_le64(offset);
>  	nsindex->nslot = __cpu_to_le32(nslot);
> -	nsindex->major = __cpu_to_le16(1);
> -	if (sizeof_namespace_label(ndd) < 256)
> +
> +	/* Support CXL LSA 2.1 label format */

Might be good to sprinkle some extra details in the references.
E.g. CXL r3.2 Table 9-9 Label Index Block Layout

> +	if (ndd->cxl) {
> +		nsindex->major = __cpu_to_le16(2);
>  		nsindex->minor = __cpu_to_le16(1);
> -	else
> -		nsindex->minor = __cpu_to_le16(2);
> +	} else {
> +		nsindex->major = __cpu_to_le16(1);

Same for these.  Case of making reviewers jobs easier by
giving them breadcrumb trails to follow.

> +		if (sizeof_namespace_label(ndd) < 256)
> +			nsindex->minor = __cpu_to_le16(1);
> +		else
> +			nsindex->minor = __cpu_to_le16(2);
> +	}
> +
>  	nsindex->checksum = __cpu_to_le64(0);
>  	if (flags & ND_NSINDEX_INIT) {
>  		unsigned long *free = (unsigned long *) nsindex->free;
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 5ca06e9a2d29..304f0e9904f1 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -522,6 +522,7 @@ void nvdimm_set_labeling(struct device *dev);
>  void nvdimm_set_locked(struct device *dev);
>  void nvdimm_clear_locked(struct device *dev);
>  int nvdimm_security_setup_events(struct device *dev);
> +bool nvdimm_check_cxl_label_format(struct device *dev);
>  #if IS_ENABLED(CONFIG_NVDIMM_KEYS)
>  int nvdimm_security_unlock(struct device *dev);
>  #else
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index e772aae71843..0a55900842c8 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -44,6 +44,9 @@ enum {
>  	/* dimm provider wants synchronous registration by __nvdimm_create() */
>  	NDD_REGISTER_SYNC = 8,
>  
> +	/* dimm supports region labels (LSA Format 2.1) */
> +	NDD_CXL_LABEL = 9,
> +
>  	/* need to set a limit somewhere, but yes, this is likely overkill */
>  	ND_IOCTL_MAX_BUFLEN = SZ_4M,
>  	ND_CMD_MAX_ELEM = 5,

