Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20F5334688
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167721; cv=none; b=Q+ZYd1FLg81JWE6lQmnxgbc2azLNdNDcHBg7HQXuSiQtkkQqOHa/tCpk1YUqNLqumf7m7nzo2NTkzjHGUrXYuWGSnZpy8i/xC7wn0N2YXpGTHv1QZ7S8RZ8JkbyyUtCheCmEzGc9TuT/yfhMjHBlsLbrQZLHRYu+1wTd2j0rzS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167721; c=relaxed/simple;
	bh=xSZUTEEHwqs61CXx/upuGJKxukXWwnXzrDdbEO5EF7k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=mD6SDU29FtLe57kbhkh+6gP71iWrEL54BTJ0VLVUPUaRSmZZeQ1kvjwTcZgqrT4BGyaiqm0i7xq5mHEpqip4mhFKhZfefOvozmn7ixiD9sLxt9hmBGFfaTckU2OOGO5SPP9NwDre0Ibmg1I+WhKZ2QAv3e/ENDOB0XF/0EHEX44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oWGpY8b/; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oWGpY8b/"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123112837epoutp02d1b0f6b0193cba23100edb2e841a0dfa~NWKpR-jef2784027840epoutp023
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:28:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123112837epoutp02d1b0f6b0193cba23100edb2e841a0dfa~NWKpR-jef2784027840epoutp023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167717;
	bh=XcSdF1hkfyYL5h8G/+OZwAlMareBvKot+H6MucPIojQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oWGpY8b/u7e4PgPHxi08uRrVAwWX+fagwv93P1JcFyqpnpjk/q3yLi6oPuHDmUQ14
	 qPbO312xeF/nv/rcR8cWZdh+JMN8TLN165/Lyxy9Z1tWWqPQCfLerxwZych4to5fXK
	 ifQ6k9tOhaJHV8N9+P+6TNVyy1FvgjWCWMQDHhIs=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260123112836epcas5p3f9c3a779755cbf873b03b65d871e284a~NWKoz7Stl1452214522epcas5p3-;
	Fri, 23 Jan 2026 11:28:36 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.93]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dyG036lCWz6B9m4; Fri, 23 Jan
	2026 11:28:35 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260123112835epcas5p23b33c26eba8d9e06a4a7e81d5a8a24c9~NWKnsR3671326613266epcas5p2Z;
	Fri, 23 Jan 2026 11:28:35 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123112834epsmtip28bc038bbec5aa741e8194a1808b5ecbd~NWKmf_EPV2355023550epsmtip2b;
	Fri, 23 Jan 2026 11:28:34 +0000 (GMT)
Date: Fri, 23 Jan 2026 16:58:29 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V5 16/17] cxl/pmem_region: Create pmem region using
 information parsed from LSA
Message-ID: <20260123112829.hjyysaptr3lml6le@test-PowerEdge-R740xd>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260115182831.0000722b@huawei.com>
X-CMS-MailID: 20260123112835epcas5p23b33c26eba8d9e06a4a7e81d5a8a24c9
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f8f6_"
CMS-TYPE: 105P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260109124532epcas5p403ad41a20c916855bf3fea644ee6e5ec
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124532epcas5p403ad41a20c916855bf3fea644ee6e5ec@epcas5p4.samsung.com>
	<20260109124437.4025893-17-s.neeraj@samsung.com>
	<20260115182831.0000722b@huawei.com>

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f8f6_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 15/01/26 06:28PM, Jonathan Cameron wrote:
>On Fri,  9 Jan 2026 18:14:36 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> create_pmem_region() creates CXL region based on region information
>> parsed from the Label Storage Area (LSA). This routine requires cxl
>> endpoint decoder and root decoder. Add cxl_find_root_decoder_by_port()
>> and cxl_find_free_ep_decoder() to find the root decoder and a free
>> endpoint decoder respectively.
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>Hi Neeraj,
>
>Just a few minor things.
>
>Jonathan
>
>> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
>> index 53d3d81e9676..4a8cf8322cf0 100644
>> --- a/drivers/cxl/core/pmem_region.c
>> +++ b/drivers/cxl/core/pmem_region.c
>> @@ -287,3 +287,139 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>>  	cxlr->cxl_nvb = NULL;
>>  	return rc;
>>  }
>> +
>> +static int match_root_decoder_by_dport(struct device *dev, const void *data)
>> +{
>> +	const struct cxl_port *ep_port = data;
>> +	struct cxl_root_decoder *cxlrd;
>> +	struct cxl_port *root_port;
>> +	struct cxl_decoder *cxld;
>> +	struct cxl_dport *dport;
>> +	bool dport_matched = false;
>> +
>> +	if (!is_root_decoder(dev))
>> +		return 0;
>> +
>> +	cxld = to_cxl_decoder(dev);
>> +	if (!(cxld->flags & CXL_DECODER_F_PMEM))
>> +		return 0;
>> +
>> +	cxlrd = to_cxl_root_decoder(dev);
>> +
>> +	root_port = cxlrd_to_port(cxlrd);
>> +	dport = cxl_find_dport_by_dev(root_port, ep_port->host_bridge);
>> +	if (!dport)
>> +		return 0;
>> +
>There is a fairly standard way to check if a loop matched without
>needing a boolean. Just check if the exit condition was reached.
>
>drop declaration of i out of here.
>> +	for (int i = 0; i < cxlrd->cxlsd.nr_targets; i++) {
>> +		if (dport == cxlrd->cxlsd.target[i]) {
>> +			dport_matched = true;
>No need for this.
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (!dport_matched)
>	if (i == cxlrd->cxlsd.nr_targets)
>		return 0;

Thanks for your suggestion. I have fixed it accordingly in V6.

>
>> +		return 0;
>> +
>> +	return is_root_decoder(dev);
>> +}
>> +
>> +/**
>> + * cxl_find_root_decoder_by_port() - find a cxl root decoder on cxl bus
>> + * @port: any descendant port in CXL port topology
>> + * @cxled: endpoint decoder
>> + *
>> + * Caller of this function must call put_device() when done as a device ref
>> + * is taken via device_find_child()
>> + */
>> +static struct cxl_root_decoder *
>> +cxl_find_root_decoder_by_port(struct cxl_port *port,
>> +			      struct cxl_endpoint_decoder *cxled)
>> +{
>> +	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
>> +	struct cxl_port *ep_port = cxled_to_port(cxled);
>> +	struct device *dev;
>> +
>> +	if (!cxl_root)
>> +		return NULL;
>> +
>> +	dev = device_find_child(&cxl_root->port.dev, ep_port,
>> +				match_root_decoder_by_dport);
>> +	if (!dev)
>> +		return NULL;
>> +
>> +	return to_cxl_root_decoder(dev);
>> +}
>
>> +void create_pmem_region(struct nvdimm *nvdimm)
>> +{
>> +	struct cxl_region *cxlr;
>> +	struct cxl_memdev *cxlmd;
>> +	struct cxl_nvdimm *cxl_nvd;
>> +	struct cxl_endpoint_decoder *cxled;
>> +	struct cxl_pmem_region_params *params;
>
>CXL tends to be reverse xmas tree and good to stick to local style.

Changed them in reverse xmas tree style.


Regards,
Neeraj

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f8f6_
Content-Type: text/plain; charset="utf-8"


------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_11f8f6_--
