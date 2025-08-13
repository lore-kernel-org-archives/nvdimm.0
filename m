Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC7C2FF16C
	for <nvdimm@lists.linux.dev>; Wed, 13 Aug 2025 14:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755097087; cv=none; b=gq/cl0sXESdyuc38Qgs1gx2IOGR2wsD3kLXhWBgKA5jvRdxn3F2jLxavpSUInLqr/9PXRs4okgvVqiClRJxBWQFlgWoSEKP58WLDeMpB6a0nrZhp5y+dGbFNhyRFoxKVSb47AJJulKj1UtUrZ2zEbXjLOv5mbpUOsgqpOFi73vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755097087; c=relaxed/simple;
	bh=m1J3TF1MO84jIxVJ7FCYASTbO1gmPS/TD7OlvLJ5QQs=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f+913Lk03WjPPpjfK3TIta9ee9nN7sg0CVc+wJHNHZ1uAgypPZDWxMFjfIAjx7REHX3Ix96cj5EXjXyC7SPcEVJsIC9FWYvvnEJBXNLLCjBISIGNWrFyJxozx1Ea59IrN2zhsKsghRqEVXa9LBzyB+3iwJQR72dWFAVZ06ANLa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c2BHt69W4z6G9kQ;
	Wed, 13 Aug 2025 22:55:22 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id E82F01404C4;
	Wed, 13 Aug 2025 22:58:03 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 13 Aug
 2025 16:58:03 +0200
Date: Wed, 13 Aug 2025 15:58:02 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V2 07/20] nvdimm/namespace_label: Update namespace
 init_labels and its region_uuid
Message-ID: <20250813155802.00003f3d@huawei.com>
In-Reply-To: <20250730121209.303202-8-s.neeraj@samsung.com>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121231epcas5p2c12cb2b4914279d1f1c93e56a32c3908@epcas5p2.samsung.com>
	<20250730121209.303202-8-s.neeraj@samsung.com>
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

On Wed, 30 Jul 2025 17:41:56 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> nd_mapping->labels maintains the list of labels present into LSA.
> init_labels() prepares this list while adding new label into LSA
> and updates nd_mapping->labels accordingly. During cxl region
> creation nd_mapping->labels list and LSA was updated with one
> region label. Therefore during new namespace label creation
> pre-include the previously created region label, so increase
> num_labels count by 1.
> 
> Also updated nsl_set_region_uuid with region uuid with which
> namespace is associated with.

Any reason these are in the same patch?  I'd like to have
seen a bit more on why this 'Also' change is here and a separate
patch might make that easier to see.

> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index be18278d6cea..fd02b557612e 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -957,7 +957,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	nsl_set_slot(ndd, nd_label, slot);
>  	nsl_set_alignment(ndd, nd_label, 0);
>  	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
> -	nsl_set_region_uuid(ndd, nd_label, NULL);
> +	nsl_set_region_uuid(ndd, nd_label, &nd_set->uuid);
>  	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
>  	nsl_calculate_checksum(ndd, nd_label);
>  	nd_dbg_dpa(nd_region, ndd, res, "\n");
> @@ -1129,7 +1129,8 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
>  				count++;
>  		WARN_ON_ONCE(!count);
>  
> -		rc = init_labels(nd_mapping, count);
> +		/* Adding 1 to pre include the already added region label */
> +		rc = init_labels(nd_mapping, count + 1);
>  		if (rc < 0)
>  			return rc;
>  

