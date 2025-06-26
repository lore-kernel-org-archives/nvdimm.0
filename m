Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7D82E5437
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750944188; cv=none; b=s95g2G7pq8Zycr/HBpXWpgiw0Njsm0XKXYKAds6vYr6Iyn8vJ2Aujhk1FCz4UhX9RM/5I7zr0+CyR30JhrHGicyk5oYJdRILH8iLId3laxbr3Jd2A78xczx/Ck2A6Fh6w5IDo2DvZYJSRKUCVD2Qnaa5oA5gAKZQVttpOgWXhjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750944188; c=relaxed/simple;
	bh=7Y2bj4ER9YXKacIAP2XBw30W5Pr9HbBWHNoc0Lir4VY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=mB3HMYvbSNHFN3xuiS5/94hlIEFdDX8JWW0zDlqnaJoPK0CPo40z2kUkE2tBYI6rd5N5IwuCcJqwbz5Z5D0Mb9dZcO+NLy9CDN4EYp0A+42U3kLDPPqA4lDgPVaAbGcbJNqHyNVzuMl88qEuB7ENxD9RrdjPRmy4BPhqv4n38Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=YDKaZGSH; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YDKaZGSH"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250626132304epoutp015a894d1372cfcec08086564f90be9da2~MmnVy7wPh2271422714epoutp01F
	for <nvdimm@lists.linux.dev>; Thu, 26 Jun 2025 13:23:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250626132304epoutp015a894d1372cfcec08086564f90be9da2~MmnVy7wPh2271422714epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750944184;
	bh=O4gzzQvCjicEghZFRZ7bl9raNTx0Ql0DKk+oqVx58Ts=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YDKaZGSHlNtrMnSP9l6io1ycsTNQISCbSCttQ0IU6WepMke6nzsbARC4P1o+pM4nY
	 imvSQALU8tRDTKDJoje3B5sOGtuID2McMVKZvJmMMZM38Oy8ox318zN2qxlERcb6DA
	 muhlg8nDzKnImvf1coe2DyuTUges3HmzJZB575wU=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250626132303epcas5p44e87f11248249ad42fb03faeb78eba28~MmnVU0zoa2645726457epcas5p4B;
	Thu, 26 Jun 2025 13:23:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bSfWW62zwz6B9m6; Thu, 26 Jun
	2025 13:23:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250626103847epcas5p4e08a66bb5823d3912da0a9477e0996df~MkX5wMw7-1565015650epcas5p4V;
	Thu, 26 Jun 2025 10:38:47 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250626103844epsmtip1c4ed2997b1c8a761900877f32f6f90e5~MkX3V-dE01095110951epsmtip1I;
	Thu, 26 Jun 2025 10:38:44 +0000 (GMT)
Date: Thu, 26 Jun 2025 16:08:38 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
	a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 15/20] cxl: Add a routine to find cxl root decoder
 on cxl bus
Message-ID: <439928219.101750944183843.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250623104449.000069b3@huawei.com>
X-CMS-MailID: 20250626103847epcas5p4e08a66bb5823d3912da0a9477e0996df
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cdd2f_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8@epcas5p1.samsung.com>
	<1295226194.21750165382072.JavaMail.epsvc@epcpadp2new>
	<20250623104449.000069b3@huawei.com>

------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cdd2f_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/25 10:44AM, Jonathan Cameron wrote:
>On Tue, 17 Jun 2025 18:09:39 +0530
>Neeraj Kumar <s.neeraj@samsung.com> wrote:
>
>> Add cxl_find_root_decoder to find root decoder on cxl bus. It is used to
>> find root decoder during region creation
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>> ---
>>  drivers/cxl/core/port.c | 26 ++++++++++++++++++++++++++
>>  drivers/cxl/cxl.h       |  1 +
>>  2 files changed, 27 insertions(+)
>>
>> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
>> index 2452f7c15b2d..94d9322b8e38 100644
>> --- a/drivers/cxl/core/port.c
>> +++ b/drivers/cxl/core/port.c
>> @@ -513,6 +513,32 @@ struct cxl_switch_decoder *to_cxl_switch_decoder(struct device *dev)
>>  }
>>  EXPORT_SYMBOL_NS_GPL(to_cxl_switch_decoder, "CXL");
>>
>> +static int match_root_decoder(struct device *dev, void *data)
>> +{
>> +	return is_root_decoder(dev);
>> +}
>> +
>> +/**
>> + * cxl_find_root_decoder() - find a cxl root decoder on cxl bus
>> + * @port: any descendant port in root-cxl-port topology
>> + */
>> +struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port)
>> +{
>> +	struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
>> +	struct device *dev;
>> +
>> +	if (!cxl_root)
>> +		return NULL;
>> +
>> +	dev = device_find_child(&cxl_root->port.dev, NULL, match_root_decoder);
>> +
>
>No blank line here.  Generally when we have a call then an error check
>it is easier to see how they are related if we keep them in one block.
>

Thanks, Will fix it in V1

>> +	if (!dev)
>> +		return NULL;
>> +
>> +	return to_cxl_root_decoder(dev);
>> +}
>> +EXPORT_SYMBOL_NS_GPL(cxl_find_root_decoder, "CXL");
>> +
>>  static void cxl_ep_release(struct cxl_ep *ep)
>>  {
>>  	put_device(ep->ep);
>> diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
>> index 30c80e04cb27..2c6a782d0941 100644
>> --- a/drivers/cxl/cxl.h
>> +++ b/drivers/cxl/cxl.h
>> @@ -871,6 +871,7 @@ bool is_cxl_nvdimm_bridge(struct device *dev);
>>  int devm_cxl_add_nvdimm(struct cxl_port *parent_port, struct cxl_memdev *cxlmd);
>>  struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_port *port);
>>  void cxl_region_discovery(struct cxl_port *port);
>> +struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port);
>>
>>  #ifdef CONFIG_CXL_REGION
>>  bool is_cxl_pmem_region(struct device *dev);
>

------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cdd2f_
Content-Type: text/plain; charset="utf-8"


------h0bZ1fOXZXBKxlzn_9r8J_wZFA-mIVa_VlXZDLVzFug9RPyR=_cdd2f_--

