Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035F31FC0E3
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 09:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670267; cv=none; b=TehgrWhqQh6UtcZgTR5xLXidOZcR7Z6ZAC4fDTJ7LTntUeEw5EhUpHVV+9jStrLTFEaP5o6fiBYt9fnydx1aNwOYn9UYafOUrSEKN6GRE4GjQnyG/erCIUtXb89nUGy8CIu50cEsrJgP5900sKJx0fRFuYd1l7gsAEBr10pT1cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670267; c=relaxed/simple;
	bh=Lz+4noPkADPzOVza6QdPRsZLH7WjZAqND7jwzSRYIug=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qkedgW+vnxcKqZao8hjTFYPu6saNEu0kN6cQUYZWtUdTHCPTH14+B9MSv9BLdH4B0FikUSjgdk6KEFLWKv94reu5vGuOrYe6Qdx86k+PC23qxZKx1CH1CAtkkoSF5EJ4Ze7VA8QwN2WXTuvAOthG2bCuR3u5WaI/OYUhvgzSCoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bQj90252dz6HJqs;
	Mon, 23 Jun 2025 17:15:16 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id E5FD81402EF;
	Mon, 23 Jun 2025 17:17:42 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Jun
 2025 11:17:42 +0200
Date: Mon, 23 Jun 2025 10:17:40 +0100
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
Subject: Re: [RFC PATCH 12/20] nvdimm/namespace_label: Skip region label
 during namespace creation
Message-ID: <20250623101740.00004840@huawei.com>
In-Reply-To: <2024918163.301750165206130.JavaMail.epsvc@epcpadp1new>
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124040epcas5p3be044cbdc5b33b0b8465d84870a5b280@epcas5p3.samsung.com>
	<2024918163.301750165206130.JavaMail.epsvc@epcpadp1new>
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

On Tue, 17 Jun 2025 18:09:36 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> During namespace creation skip presence of region label if present.
> Also preserve region label into labels list if present.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
>  drivers/nvdimm/namespace_devs.c | 48 +++++++++++++++++++++++++++++----
>  1 file changed, 43 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index b081661b7aaa..ca8f8546170c 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1976,6 +1976,10 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  		if (!nd_label)
>  			continue;
>  
> +		/* skip region labels if present */
> +		if (is_region_label(ndd, nd_label))
> +			continue;
> +
>  		/* skip labels that describe extents outside of the region */
>  		if (nsl_get_dpa(ndd, &nd_label->ns_label) < nd_mapping->start ||
>  		    nsl_get_dpa(ndd, &nd_label->ns_label) > map_end)
> @@ -2014,9 +2018,29 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  
>  	if (count == 0) {
>  		struct nd_namespace_pmem *nspm;
> +		for (i = 0; i < nd_region->ndr_mappings; i++) {
> +			struct nd_label_ent *le, *e;
> +			LIST_HEAD(list);
>  
> -		/* Publish a zero-sized namespace for userspace to configure. */
> -		nd_mapping_free_labels(nd_mapping);
> +			nd_mapping = &nd_region->mapping[i];
> +			if (list_empty(&nd_mapping->labels))
> +				continue;
> +
> +			list_for_each_entry_safe(le, e, &nd_mapping->labels,
> +						 list) {
> +				struct nd_lsa_label *nd_label = le->label;
> +
> +				/* preserve region labels if present */
> +				if (is_region_label(ndd, nd_label))
> +					list_move_tail(&le->list, &list);
> +			}
> +
> +			/* Publish a zero-sized namespace for userspace

Comment syntax as before looks to be inconsistent with file.

> +			 * to configure.
> +			 */
> +			nd_mapping_free_labels(nd_mapping);
> +			list_splice_init(&list, &nd_mapping->labels);
> +		}
>  		nspm = kzalloc(sizeof(*nspm), GFP_KERNEL);
>  		if (!nspm)
>  			goto err;
> @@ -2028,7 +2052,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  	} else if (is_memory(&nd_region->dev)) {
>  		/* clean unselected labels */
>  		for (i = 0; i < nd_region->ndr_mappings; i++) {
> -			struct list_head *l, *e;
> +			struct nd_label_ent *le, *e;
>  			LIST_HEAD(list);
>  			int j;
>  
> @@ -2039,10 +2063,24 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  			}
>  
>  			j = count;
> -			list_for_each_safe(l, e, &nd_mapping->labels) {
> +			list_for_each_entry_safe(le, e, &nd_mapping->labels,
> +						 list) {
> +				struct nd_lsa_label *nd_label = le->label;
> +
> +				/* preserve region labels */
> +				if (is_region_label(ndd, nd_label)) {
> +					list_move_tail(&le->list, &list);
> +					continue;
> +				}
> +
> +				/* Once preserving selected ns label done
Comment syntax.
> +				 * break out of loop
> +				 */
>  				if (!j--)
>  					break;
> -				list_move_tail(l, &list);
> +
> +				/* preserve selected ns label */
> +				list_move_tail(&le->list, &list);
>  			}
>  			nd_mapping_free_labels(nd_mapping);
>  			list_splice_init(&list, &nd_mapping->labels);

