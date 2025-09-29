Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB6C246BD2
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726510; cv=none; b=Fme/aHNxqiiksHDOSZhnORBpjdwaRHX+6XxnWyi5HCu0OduA+qlnnd8TchY2uuyWnxAPbJmDzi+ZPGPcSJDmuTbiOW9N//LzXSfYHgJC3zv2Fl5gFc1OhEkTbp6BY1OQ+4Lccl3qPOu9fZVXYV6az8ROQ9vF5a1R8+ojyZYcPSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726510; c=relaxed/simple;
	bh=59NiRBpV+xpAIzQh2Ndy4MnoltJdoNHSSIbWGPXzIa0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=heSJgwVmG939t8HuHJix/XkQmCQvWDr5x836Q2vVsC/Tws93cT04JS3PPAsq/fWBr22cBI1s76CaTiar+Zr08mU+eFK6Mxw/MonaHFgDRHk2MBIHH1YPIj+1jhKPF1lGOTWpIYotPVKLJU2CxEe99FpRaXTavi4WLmXfkNeKFho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WGpr1B3q; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WGpr1B3q"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251006045505epoutp03d234c35e89a1847bdc04626c3d5a053e~rze7QuAid1934019340epoutp03e
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251006045505epoutp03d234c35e89a1847bdc04626c3d5a053e~rze7QuAid1934019340epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726505;
	bh=y6FJyrcXjgckQdV3QCYfUXSLOftY8ZH6P9MXHgu/6EY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WGpr1B3q+sazbejkR/txWGXJ/D1IGmA2SOBOEFmBPAjijv4JNBKs109L2zLNDRpXY
	 c7WPlxD1pYLmpzq2WXD0X14QsJF0rSqfxnjhWJQ7KAR/Usr+Z+t/kAN0t2/lkSs4dZ
	 /XXKEJpoPqqurExs3AyVCWaCgKKxZm778l0D5tu4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251006045504epcas5p32e075bc2d63a1f63cd9ebe6a23e44bf7~rze69yGu42860328603epcas5p3E;
	Mon,  6 Oct 2025 04:55:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cg6QJ4gcWz6B9m6; Mon,  6 Oct
	2025 04:55:04 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250929140231epcas5p44c37719e556027dacacc0a6d30a083f6~pxb54tjHD1687316873epcas5p4e;
	Mon, 29 Sep 2025 14:02:31 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250929140229epsmtip2e7d848d595a6c6f7be80cdd949505956~pxb4l636B1114111141epsmtip2c;
	Mon, 29 Sep 2025 14:02:29 +0000 (GMT)
Date: Mon, 29 Sep 2025 19:32:25 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 20/20] cxl/pmem: Add CXL LSA 2.1 support in cxl pmem
Message-ID: <1256440269.161759726504643.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <28d78d2b-c17d-4910-9f28-67af1fbb10ee@intel.com>
X-CMS-MailID: 20250929140231epcas5p44c37719e556027dacacc0a6d30a083f6
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----mxO_4HALYOJvr1vdRg0el_y50LUdjfkHM5FQPcyM.heriKG9=_74d4_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134213epcas5p139ba10deb2f4361f9bbab8e8490c4720
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134213epcas5p139ba10deb2f4361f9bbab8e8490c4720@epcas5p1.samsung.com>
	<20250917134116.1623730-21-s.neeraj@samsung.com>
	<28d78d2b-c17d-4910-9f28-67af1fbb10ee@intel.com>

------mxO_4HALYOJvr1vdRg0el_y50LUdjfkHM5FQPcyM.heriKG9=_74d4_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 24/09/25 01:47PM, Dave Jiang wrote:
>
>> +++ b/drivers/cxl/core/pmem_region.c
>> @@ -290,3 +290,56 @@ int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
>>  	return rc;
>>  }
>>  EXPORT_SYMBOL_NS_GPL(devm_cxl_add_pmem_region, "CXL");
>> +
>> +static int match_free_ep_decoder(struct device *dev, const void *data)
>> +{
>> +	struct cxl_decoder *cxld = to_cxl_decoder(dev);
>
>I think this is needed if the function is match_free_ep_decoder().
>
>if (!is_endpoint_decoder(dev))
>	return 0;
>

Yes this check is required, I will add this.

>> +
>> +	return !cxld->region;
>> +}
>
>May want to borrow some code from match_free_decoder() in core/region.c. I think the decoder commit order matters?
>

Yes Dave, Looking at [1], seems commit order matters. Sure I will look
at match_free_decoder() in core/region.c
[1] https://lore.kernel.org/all/172964783668.81806.14962699553881333486.stgit@dwillia2-xfh.jf.intel.com/


>> +
>> +static struct cxl_decoder *cxl_find_free_ep_decoder(struct cxl_port *port)
>> +{
>> +	struct device *dev;
>> +
>> +	dev = device_find_child(&port->dev, NULL, match_free_ep_decoder);
>> +	if (!dev)
>> +		return NULL;
>> +
>> +	/* Release device ref taken via device_find_child() */
>> +	put_device(dev);
>
>Should have the caller put the device.

Its like taking device ref temporarly and releasing it then and there
after finding proper root decoder. I believe, releasing device ref
from caller would make it look little out of context.


Regards,
Neeraj

------mxO_4HALYOJvr1vdRg0el_y50LUdjfkHM5FQPcyM.heriKG9=_74d4_
Content-Type: text/plain; charset="utf-8"


------mxO_4HALYOJvr1vdRg0el_y50LUdjfkHM5FQPcyM.heriKG9=_74d4_--

