Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06763A3F17
	for <nvdimm@lists.linux.dev>; Wed, 17 Dec 2025 14:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765981995; cv=none; b=AKGCeDk1TaZGNOdF5mVF39S4FMwbxgmqS4UzkFDg/yRUnR3ND8P2puDA5RI5clWiTMJ/NhpliPvg8lQgZpdpYx4x58iH+sY7SQG4iiT+BAjChZaJQ6v7atNkNmpAZN/aJ0stVm5m9+/lbPgV7ldrVi7Zz6zFoFIZsGq3ND3wx0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765981995; c=relaxed/simple;
	bh=DizvcCyR0GRLOOMYbE/xjVJP7CsJk6HQkyY9KVbzTR4=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fgVWLwZU1QPEivOHv0a3741cxHX2Z70ya7PH/PJRsEBf4t8p1+GiqI8ajuJPB6HGwIDuP3mlLMYUx4sAKN5+bcFQI31cffMG3Xh9pK3XEGOZbvxHXNi3OznKtx90Z6jNvkGatqeQdyCzSrKk6TkpvTomgRzxqyUrbSp+nTgHg7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dWbqc5qbWzHnGjS;
	Wed, 17 Dec 2025 22:32:44 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 2ABCA40539;
	Wed, 17 Dec 2025 22:33:10 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 17 Dec
 2025 14:33:09 +0000
Date: Wed, 17 Dec 2025 14:33:08 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V4 05/17] nvdimm/label: Skip region label during ns
 label DPA reservation
Message-ID: <20251217143308.00006144@huawei.com>
In-Reply-To: <20251119075255.2637388-6-s.neeraj@samsung.com>
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075315epcas5p2be6f51993152492f0dd64366863d70e2@epcas5p2.samsung.com>
	<20251119075255.2637388-6-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100009.china.huawei.com (7.191.174.83) To
 dubpeml100005.china.huawei.com (7.214.146.113)

On Wed, 19 Nov 2025 13:22:43 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> If Namespace label is present in LSA during nvdimm_probe() then DPA
> reservation is required. But this reservation is not required by region
> label. Therefore if LSA scanning finds any region label, skip it.

It would be good to have a little more explanation of why these two
types of label put different requirements here.

I'd rather not go spec diving to find out!

Otherwise LGTM.

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 6ccc51552822..e90e48672da3 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -469,6 +469,10 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  		lsa_label = to_lsa_label(ndd, slot);
>  		nd_label = &lsa_label->ns_label;
>  
> +		/* Skip region label. DPA reservation is for NS label only */
> +		if (is_region_label(ndd, lsa_label))
> +			continue;
> +
>  		if (!slot_valid(ndd, lsa_label, slot))
>  			continue;
>  

