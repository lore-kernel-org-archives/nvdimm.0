Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3C22E717D
	for <nvdimm@lists.linux.dev>; Wed, 13 Aug 2025 13:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755090746; cv=none; b=LWWkKoLGVbOfCIDpzolmKRLA4YUwqYK3P6R85l6pR0Nnmxzslo2G8olAwGyS8len+oypxUgb9rBCCUmTUGYp7JYDyrE5L7wRqElx174xuWfGszpZoP7R+s/7Q/CJgsAf5mScU9z55Ow26LgKxkjilEzgjIwh34Hk2Gzp5z0ng7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755090746; c=relaxed/simple;
	bh=YNsjdNBFLKWTh/v73VJcx2a44VB2p4Q1HkHsczmvRtg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V+yUt0NnZBL7pQxZZcC8aqbaESFd+mkTowNo9xuq4/Bfxb8vXn54csqXL/ZPpKtqVmhIEnaOK/R+yLKTiZW/LEVUUstAJuMShpW7KBfOMvTojs7GPQw0reqGlZwEvprRtMPDkslr4QNnkAZJgHbumOqrbSzxuFMV+6pu/9fGjAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c27vM3yMhz6L4yD;
	Wed, 13 Aug 2025 21:07:27 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 2E9AF140121;
	Wed, 13 Aug 2025 21:12:20 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 13 Aug
 2025 15:12:19 +0200
Date: Wed, 13 Aug 2025 14:12:18 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V2 01/20] nvdimm/label: Introduce NDD_CXL_LABEL flag to
 set cxl label format
Message-ID: <20250813141218.0000091f@huawei.com>
In-Reply-To: <20250730121209.303202-2-s.neeraj@samsung.com>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121223epcas5p1386bdf99a0af820dd4411fbdbd413cd5@epcas5p1.samsung.com>
	<20250730121209.303202-2-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed, 30 Jul 2025 17:41:50 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Prior to LSA 2.1 version, LSA contain only namespace labels. LSA 2.1
> introduced in CXL 2.0 Spec, which contain region label along with
> namespace label.
> 
> NDD_LABELING flag is used for namespace. Introduced NDD_CXL_LABEL
> flag for region label. Based on these flags nvdimm driver performs
> operation on namespace label or region label.
> 
> NDD_CXL_LABEL will be utilized by cxl driver to enable LSA2.1 region
> label support
> 
> Accordingly updated label index version
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Hi Neeraj,

A few comments inline.

> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 04f4a049599a..7a011ee02d79 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -688,11 +688,25 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
>  		- (unsigned long) to_namespace_index(ndd, 0);
>  	nsindex->labeloff = __cpu_to_le64(offset);
>  	nsindex->nslot = __cpu_to_le32(nslot);
> -	nsindex->major = __cpu_to_le16(1);
> -	if (sizeof_namespace_label(ndd) < 256)
> +
> +	/* Set LSA Label Index Version */
> +	if (ndd->cxl) {
> +		/* CXL r3.2 Spec: Table 9-9 Label Index Block Layout */
> +		nsindex->major = __cpu_to_le16(2);
>  		nsindex->minor = __cpu_to_le16(1);
> -	else
> -		nsindex->minor = __cpu_to_le16(2);
> +	} else {
> +		nsindex->major = __cpu_to_le16(1);
> +		/*
> +		 * NVDIMM Namespace Specification
> +		 * Table 2: Namespace Label Index Block Fields
> +		 */
> +		if (sizeof_namespace_label(ndd) < 256)
> +			nsindex->minor = __cpu_to_le16(1);
> +		else
> +		 /* UEFI Specification 2.7: Label Index Block Definitions */

Odd comment alignment. Either put it on the else so
		else /* UEFI 2.7: Label Index Block Defintions */

or indent it an extra tab

		else
			/* UEFI 2.7: Label Index Block Definitions */
			
> +			nsindex->minor = __cpu_to_le16(2);
> +	}
> +
>  	nsindex->checksum = __cpu_to_le64(0);
>  	if (flags & ND_NSINDEX_INIT) {
>  		unsigned long *free = (unsigned long *) nsindex->free;

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

This enum is 'curious'.  It combined flags from a bunch of different
flags fields and some stuff that are nothing to do with flags.

Anyhow, putting that aside I'd either rename it to something like
NDD_REGION_LABELING (similar to NDD_LABELING that is there for namespace labels
or just have it a meaning it is LSA Format 2.1 and drop the fact htat
also means region labels are supported.

Combination of a comment that talks about one thing and a definition name
that doesn't associate with it seems confusing to me.

Jonathan


> +
>  	/* need to set a limit somewhere, but yes, this is likely overkill */
>  	ND_IOCTL_MAX_BUFLEN = SZ_4M,
>  	ND_CMD_MAX_ELEM = 5,

