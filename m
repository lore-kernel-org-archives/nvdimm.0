Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3002234C155
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 15:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768145298; cv=none; b=T+4glh3IHpMZE1vrpRkYPIhBlXXGHMbbtzn5LWS00k5RGbZ/OuQ4gBtelT9K2x5WLC0kZuIir2eYfj42YOUNnufxHKVlTBlOOZbb+kUG7oe6vpXBvZpwDWnHxtEbH6hcaa5e+PQ7RF1Q/SGAn/jEzG03PtTEz+wicYtp0ZE/I/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768145298; c=relaxed/simple;
	bh=WnrqtBtYnkGtzkuQTjvkFq/gdHW+fRRLySaWvXNugsA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=HEgS3xyHFw3ELoo3mPcfMta6vBGqS3zaS8emqHrYmVtFZLSdEuKVQ/gvwb6K98yjQN5nGnDNz9k2KZCWBNi5LazRqcpED7b3dwwHndVFPDkdd/IE8YtTqppz016DMXEWw9LLBJhP3QInBoCTtfI3pM/Wyx1VmI7J24oTtpIxNz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pF/4Kc0/; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pF/4Kc0/"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260111152804epoutp01d9431212177371cb2f45601184a8fc01~JtsSfbf9I0553105531epoutp01Q
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 15:28:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260111152804epoutp01d9431212177371cb2f45601184a8fc01~JtsSfbf9I0553105531epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768145284;
	bh=vfQjmGXD9Gk2pii3GBrMd/hZGqYhy8zh/drwh9K9kYw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pF/4Kc0//rVH576b/zSriDDwFY4H9khxXDDG97ECtcQo4cUbBu3PSwD68k/sR5ZMd
	 tj0jol2HphXUhgUMfU1o8nk1jJx+iN9WxAn6PH5iROYx5H+O7dOXHIHLz7ehblnr06
	 PwMz0FPQI2rGnhAkIVib3HgrPpVbNYPFHL1AI/1w=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260111152803epcas5p3c51191cd69f853f46e323a5a5fc50b9f~JtsR3ii6f2540325403epcas5p3z;
	Sun, 11 Jan 2026 15:28:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dpzsv4Qtvz3hhT3; Sun, 11 Jan
	2026 15:28:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260109123728epcas5p27dc15044f14f2f7767eaa34f6ec74c4b~JEEwwHnaX2779527795epcas5p2C;
	Fri,  9 Jan 2026 12:37:28 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260109123725epsmtip10fe8d5faa403181de62e34739cb9fe6d~JEEuU4hxc0458704587epsmtip1U;
	Fri,  9 Jan 2026 12:37:25 +0000 (GMT)
Date: Fri, 9 Jan 2026 18:07:18 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V4 16/17] cxl/pmem_region: Create pmem region using
 information parsed from LSA
Message-ID: <700072760.81768145283611.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <13001a14-4b13-4405-afe1-c0e68dc57406@intel.com>
X-CMS-MailID: 20260109123728epcas5p27dc15044f14f2f7767eaa34f6ec74c4b
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_e630b_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20251119075339epcas5p3160bfa74362cc974e917fcc9b83ee112
References: <20251119075255.2637388-1-s.neeraj@samsung.com>
	<CGME20251119075339epcas5p3160bfa74362cc974e917fcc9b83ee112@epcas5p3.samsung.com>
	<20251119075255.2637388-17-s.neeraj@samsung.com>
	<13001a14-4b13-4405-afe1-c0e68dc57406@intel.com>

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_e630b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/11/25 04:37PM, Dave Jiang wrote:
>
>
>On 11/19/25 12:52 AM, Neeraj Kumar wrote:
>> create_pmem_region() creates cxl region based on region information
>> parsed from LSA. This routine required cxl root decoder and endpoint
>> decoder. Therefore added cxl_find_root_decoder_by_port() and
>> cxl_find_free_ep_decoder(). These routines find cxl root decoder and
>> free endpoint decoder on cxl bus using cxl port
>
>Please consider:
>create_pmem_region() creates CXL region based on region information
>parsed from the Label Storage Area (LSA). This routine requires cxl root
>decoder and endpoint decoder. Add cxl_find_root_decoder_by_port()
>and cxl_find_free_ep_decoder() to find the root decoder and a free
>endpoint decoder respectively.
>

Fixed it accordingly in V5

>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/cxl/core/core.h        |  4 ++
>>  drivers/cxl/core/pmem_region.c | 97 ++++++++++++++++++++++++++++++++++
>>  drivers/cxl/core/region.c      | 13 +++--
>>  drivers/cxl/cxl.h              |  5 ++
>>  4 files changed, 115 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
>> index beeb9b7527b8..dd2efd3deb5e 100644
>> --- a/drivers/cxl/core/core.h
>> +++ b/drivers/cxl/core/core.h
>> @@ -35,6 +35,7 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
>>  #define CXL_REGION_TYPE(x) (&cxl_region_type)
>>  #define SET_CXL_REGION_ATTR(x) (&dev_attr_##x.attr),
>>  #define CXL_DAX_REGION_TYPE(x) (&cxl_dax_region_type)
>> +int verify_free_decoder(struct device *dev);
>>  int cxl_region_init(void);
>>  void cxl_region_exit(void);
>>  int cxl_get_poison_by_endpoint(struct cxl_port *port);
>> @@ -88,6 +89,9 @@ static inline struct cxl_region *to_cxl_region(struct device *dev)
>>  {
>>  	return NULL;
>>  }
>> +static inline int verify_free_decoder(struct device *dev)
>> +{
>
>this function needs to return something

Thanks for catching this. Fixed it in V5

>
>> +}
>>  #define CXL_REGION_ATTR(x) NULL
>>  #define CXL_REGION_TYPE(x) NULL
>>  #define SET_CXL_REGION_ATTR(x)
>> diff --git a/drivers/cxl/core/pmem_region.c b/drivers/cxl/core/pmem_region.c
>> index be4feb73aafc..06665937c180 100644
>> --- a/drivers/cxl/core/pmem_region.c
>> +++ b/drivers/cxl/core/pmem_region.c
>> @@ -291,3 +291,100 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>>  	cxlr->cxl_nvb = NULL;
>>  	return rc;
>>  }
>> +
>> +static int match_root_decoder(struct device *dev, const void *data)
>> +{
>> +	return is_root_decoder(dev);
>
>Is it suppose to just grab the first root decoder? If so the function should be match_first_root_decoder(). However, should the root decoder cover the region it's trying to match to? Should there be some checks to see if the region fits under the root decoder range? Also, should it not check the root decoder flags to see if it has CXL_DECODER_F_PMEM set so the CFMWS can cover PMEM?
>

Yes Dave, Here we should check as you suggested. Also currently its only
considering only first decoder but it should return the root decoder
associated with particular endpoint decoder. I have fixed this in V5.



Regards,
Neeraj

------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_e630b_
Content-Type: text/plain; charset="utf-8"


------HKC0oM6l2X7jDELFNxUL3gr1rNZobpnU9ZVzK0VPY15yFScq=_e630b_--

