Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778EA3D6698
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 17:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499804; cv=none; b=t4yIEdllWW/qM1gDxkOkUmu0vXJEcz75Z7Gb8MR4RMoaCEYGF7MVkFrSIxb2vC8vuUuCrT5i3Iox2c1/rHr8UjhA7CIicnhVgwzM35TRS9a0HJUbSK6xve1gr9V0WAnRw4E1yCX53vvu4c7pElwJRJH74eRj4cIwDFlxg+gLJRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499804; c=relaxed/simple;
	bh=P9PdSDJDsbkhhfORPEiZ++mZV3ZgsLE+sDZ+KbutvSI=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bZ/ql6bvhJ/mqJLFyrGIIv0g10oUORj7AtxFYM6W6/4nkx8jiAXPc1/vXiXlsZ8x+ObPptbMeKJRthsFXBilfHaV17V9FTVUWotIuo3fsem2wR+8bxsQQFqeSEivSqjeeybG8ndWr14nI1HKenY2aiF8HuG4Ebqa1lttNaQCtoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dsVzD46sqzJ467g;
	Fri, 16 Jan 2026 01:56:24 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 3706440571;
	Fri, 16 Jan 2026 01:56:41 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Thu, 15 Jan
 2026 17:56:40 +0000
Date: Thu, 15 Jan 2026 17:56:39 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V5 05/17] nvdimm/label: Skip region label during ns
 label DPA reservation
Message-ID: <20260115175639.00004f3a@huawei.com>
In-Reply-To: <20260109124437.4025893-6-s.neeraj@samsung.com>
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124517epcas5p3d11e7d0941bcf34c74a789917c8aa0d0@epcas5p3.samsung.com>
	<20260109124437.4025893-6-s.neeraj@samsung.com>
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

On Fri,  9 Jan 2026 18:14:25 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> CXL 3.2 Spec mentions CXL LSA 2.1 Namespace Labels at section
> 9.13.2.5. If Namespace label is present in LSA during
> nvdimm_probe() then dimm-physical-address(DPA) reservation is
> required. But this reservation is not required by cxl region
> label. Therefore if LSA scanning finds any region label, skip it.
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  drivers/nvdimm/label.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 9854cb45fb62..169692dfa12c 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -469,6 +469,14 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  		lsa_label = to_lsa_label(ndd, slot);
>  		nd_label = &lsa_label->ns_label;
>  
> +		/*
> +		 * Skip region label. If LSA label is region label
> +		 * then it don't require dimm-physical-address(DPA)
> +		 * reservation. Whereas its required for namespace label
> +		 */
> +		if (is_region_label(ndd, lsa_label))
> +			continue;
> +
>  		if (!slot_valid(ndd, lsa_label, slot))
>  			continue;
>  

