Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA902C235A
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758120425; cv=none; b=Lm8Q2H9vWSktLOsChweE9Rc3AHFqRYTpTcU3sFm7c0+1P/bhT/M2Q89eSoYdTa6Jrby7EspZ6E1EomO9pwvfmN/1j7j/qNhASnFlaXkVzKmb/t3enYGpCmWyqfIp8M3EE63hrHzv6zG3I3M8fML3j6zI1w8DnC//1MiY1z4KX+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758120425; c=relaxed/simple;
	bh=rQmRuK5KU7Z/3bIU2Azpwz/1kuf16Qoy7+ym9YjEuoY=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TwtDFmwW+wn/itkWV9/C8gNIjBsvqg7LpeCsvf1iSaktKC/yNvZufvccy454L+8cYTleoM0Lq1jGWtK4ovGPot4IkgfNN5jleWldOXedrc2arjCDnozT9e3PqzofF+PMnjnU8ZuEqGBPZv/hHqhj8hWcIANN6n9Lj+n8mzAI0uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cRhNp0YNhz6M5G5;
	Wed, 17 Sep 2025 22:44:10 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id C7C3A1400D4;
	Wed, 17 Sep 2025 22:46:58 +0800 (CST)
Received: from localhost (10.203.177.15) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 17 Sep
 2025 16:46:58 +0200
Date: Wed, 17 Sep 2025 15:46:56 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V3 04/20] nvdimm/label: Update mutex_lock() with
 guard(mutex)()
Message-ID: <20250917154656.00001c2f@huawei.com>
In-Reply-To: <20250917132940.1566437-5-s.neeraj@samsung.com>
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133034epcas5p2c9485e40fce4c3a5a826cc94d515b25d@epcas5p2.samsung.com>
	<20250917132940.1566437-5-s.neeraj@samsung.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed, 17 Sep 2025 18:59:24 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> Updated mutex_lock() with guard(mutex)()

Say why.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/label.c | 36 +++++++++++++++++-------------------
>  1 file changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 668e1e146229..3235562d0e1c 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -948,7 +948,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  		return rc;
>  
>  	/* Garbage collect the previous label */
> -	mutex_lock(&nd_mapping->lock);
> +	guard(mutex)(&nd_mapping->lock);
>  	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>  		if (!label_ent->label)
>  			continue;
> @@ -960,20 +960,20 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	/* update index */
>  	rc = nd_label_write_index(ndd, ndd->ns_next,
>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
> -	if (rc == 0) {
> -		list_for_each_entry(label_ent, &nd_mapping->labels, list)
> -			if (!label_ent->label) {
> -				label_ent->label = nd_label;
> -				nd_label = NULL;
> -				break;
> -			}
> -		dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
> -				"failed to track label: %d\n",
> -				to_slot(ndd, nd_label));
> -		if (nd_label)
> -			rc = -ENXIO;
> -	}
> -	mutex_unlock(&nd_mapping->lock);
> +	if (rc)
> +		return rc;
> +
> +	list_for_each_entry(label_ent, &nd_mapping->labels, list)
> +		if (!label_ent->label) {
> +			label_ent->label = nd_label;
> +			nd_label = NULL;
> +			break;

Perhaps it will change in later patches, but you could have done
		if (!label_ent->label) {
			label_ent->label = nd_label;
			return;
		}
as nothing else happens if we find a match.

> +		}
> +	dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
> +			"failed to track label: %d\n",
> +			to_slot(ndd, nd_label));
> +	if (nd_label)
> +		rc = -ENXIO;
>  
>  	return rc;
>  }
> @@ -998,9 +998,8 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>  		label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
>  		if (!label_ent)
>  			return -ENOMEM;
> -		mutex_lock(&nd_mapping->lock);
> +		guard(mutex)(&nd_mapping->lock);
>  		list_add_tail(&label_ent->list, &nd_mapping->labels);
> -		mutex_unlock(&nd_mapping->lock);

Not sure I'd bother with cases like this but harmless.

>  	}
>  
>  	if (ndd->ns_current == -1 || ndd->ns_next == -1)
> @@ -1039,7 +1038,7 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  	if (!preamble_next(ndd, &nsindex, &free, &nslot))
>  		return 0;
>  
> -	mutex_lock(&nd_mapping->lock);
> +	guard(mutex)(&nd_mapping->lock);
>  	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
>  		struct nd_namespace_label *nd_label = label_ent->label;
>  
> @@ -1061,7 +1060,6 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
>  		nd_mapping_free_labels(nd_mapping);
>  		dev_dbg(ndd->dev, "no more active labels\n");
>  	}
> -	mutex_unlock(&nd_mapping->lock);
This is a potential functional change as the lock is held for longer than before.
nd_label_write_index is not trivial so reviewing if that is safe is not trivial.

The benefit is small so far (maybe that changes in later patches) so I would not
make the change.



>  
>  	return nd_label_write_index(ndd, ndd->ns_next,
>  			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);

