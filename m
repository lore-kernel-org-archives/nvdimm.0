Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BEF2D3EC3
	for <nvdimm@lists.linux.dev>; Wed, 13 Aug 2025 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755091436; cv=none; b=W+AejFL/TgWj3iCrfY0KLdrTEXvZzECrwHda+Kyf008Uws//l7dBsmi3tC4OrzK9U3G/tnsPMa+MwuxMqn4QIubKqvGU4fTTxDMR5AgQrYJTKsfQGBRlmekyVUIfIAdVUF9+BiUXxyxa1JMdIElKSCy2FonBEpcLmVR70WX4zYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755091436; c=relaxed/simple;
	bh=bsPwH+lfd/qXUUhvahSgwJz62Ihew8kA9wWinqW5WJk=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NhyHWVNuxn9wxB3vvsraLnRxuez9WvU1gNwjbHGI6V8+XAtmPDpwzTQSMR+PxMTvfKjPol6tnIdhMGwqQ6tywRInuzMXRbeRscaixtk04i4jyFmPjeFqN72KPb6WvBEFzBeCNqWuJF8+1yMxWu9Q0NprHanKGC6OTo8JVD5tUDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c28D1352cz6GFl5;
	Wed, 13 Aug 2025 21:21:53 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 344711400D7;
	Wed, 13 Aug 2025 21:23:51 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 13 Aug
 2025 15:23:50 +0200
Date: Wed, 13 Aug 2025 14:23:49 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <gost.dev@samsung.com>,
	<a.manzanares@samsung.com>, <vishak.g@samsung.com>, <neeraj.kernel@gmail.com>
Subject: Re: [PATCH V2 02/20] nvdimm/label: Prep patch to accommodate cxl
 lsa 2.1 support
Message-ID: <20250813142349.000032a4@huawei.com>
In-Reply-To: <20250730121209.303202-3-s.neeraj@samsung.com>
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e@epcas5p3.samsung.com>
	<20250730121209.303202-3-s.neeraj@samsung.com>
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

On Wed, 30 Jul 2025 17:41:51 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

> LSA 2.1 format introduces region label, which can also reside
> into LSA along with only namespace label as per v1.1 and v1.2
> 
> As both namespace and region labels are of same size of 256 bytes.
> Thus renamed "struct nd_namespace_label" to "struct nd_lsa_label",
> where both namespace label and region label can stay as union.

Maybe add something on why it makes sense to use a union rather than
new handling.

> 
> No functional change introduced.
> 
> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
> ---
A few minor comments inline.


> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 55cfbf1e0a95..bdf1ed6f23d8 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1615,17 +1619,21 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
>  		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>  		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +		struct nd_lsa_label *lsa_label = NULL;
Why not pull this into the scope below.

>  		struct nd_namespace_label *nd_label = NULL;
>  		u64 hw_start, hw_end, pmem_start, pmem_end;
>  		struct nd_label_ent *label_ent;
>  
>  		lockdep_assert_held(&nd_mapping->lock);
>  		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
e.g.
			struct nd_lsa_label *lsa_label = label_ent->label;

then no need to set it to NULL later.

> -			nd_label = label_ent->label;
> -			if (!nd_label)
> +			lsa_label = label_ent->label;
> +			if (!lsa_label)
>  				continue;
> +
> +			nd_label = &lsa_label->ns_label;
>  			if (nsl_uuid_equal(ndd, nd_label, pmem_id))
>  				break;
> +			lsa_label = NULL;
>  			nd_label = NULL;
>  		}
>  
> @@ -1746,19 +1754,21 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  
>  	/* Calculate total size and populate namespace properties from label0 */
>  	for (i = 0; i < nd_region->ndr_mappings; i++) {
> +		struct nd_lsa_label *lsa_label;
>  		struct nd_namespace_label *label0;
>  		struct nvdimm_drvdata *ndd;
>  
>  		nd_mapping = &nd_region->mapping[i];
>  		label_ent = list_first_entry_or_null(&nd_mapping->labels,
>  				typeof(*label_ent), list);
> -		label0 = label_ent ? label_ent->label : NULL;
> +		lsa_label = label_ent ? label_ent->label : NULL;
>  
> -		if (!label0) {
> +		if (!lsa_label) {
>  			WARN_ON(1);
>  			continue;
>  		}
>  
> +		label0 = &lsa_label->ns_label;
>  		ndd = to_ndd(nd_mapping);
>  		size += nsl_get_rawsize(ndd, label0);
>  		if (nsl_get_position(ndd, label0) != 0)
>

