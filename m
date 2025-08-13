Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486AA13D521
	for <nvdimm@lists.linux.dev>; Wed, 13 Aug 2025 15:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755097770; cv=none; b=Y68vO4XW8vP/ngSz362GLr5baFe3ktths58+uYisAYu1HRViJYZiWwFIwOevpyBDIEqvIMrLDID6M7RnYF39gC4f2VxJv+9RN4E2eouvUerbd//o5I7x7riYlAmUn24l7zapatXlMoj9F52zng7dw3Sn/4cPZVyTRHLEj84Xei0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755097770; c=relaxed/simple;
	bh=K5dXaEoNmMWgRK1fo+BPg/hTdrwFez38GOBfbSR/ayU=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PFbVW0otI5J0BxjeaR7jX1Mxpx4rXb95jmcgSpVjtJYfBGKfr/zCT8IcVhV7kFTHsReXzBc4a9xhVNujO1yjtwRYgPsUOpo01L1zL1Rl8YeA6VL7Elqq7cdsJeMratifYCQiI6g3X9B5f4ytqFq86Hu1sPZkfPazX8gJXH7trMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c2BYs3CZqz6GFlQ;
	Wed, 13 Aug 2025 23:07:29 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 5433C1400D4;
	Wed, 13 Aug 2025 23:09:27 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 13 Aug
 2025 17:09:26 +0200
Date: Wed, 13 Aug 2025 16:09:25 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V2 09/20] nvdimm/namespace_label: Skip region label
 during ns label DPA reservation
Message-ID: <20250813160925.000015c8@huawei.com>
In-Reply-To: <20250730121209.303202-10-s.neeraj@samsung.com>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121234epcas5p2605fbec7bc95f6096550792844b8f8ee@epcas5p2.samsung.com>
	<20250730121209.303202-10-s.neeraj@samsung.com>
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

On Wed, 30 Jul 2025 17:41:58 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> If Namespace label is present in LSA during nvdimm_probe then DPA
> reservation is required. But this reservation is not required by region
> label. Therefore if LSA scanning finds any region label, skip it.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index c4748e30f2b6..064a945dcdd1 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -452,6 +452,10 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  		lsa_label = to_label(ndd, slot);
>  		nd_label = &lsa_label->ns_label;
>  
> +		/* skip region label, dpa reservation for ns label only */
Confusing comment and not clear if skip applies just to region label or
to dpa reservation as well.

		/* Skip region label.  DPA reservation is for NS label only. */

or something along those lines (assuming I have understood this right!)
> +		if (is_region_label(ndd, lsa_label))
> +			continue;
> +
>  		if (!slot_valid(ndd, lsa_label, slot))
>  			continue;
>  

