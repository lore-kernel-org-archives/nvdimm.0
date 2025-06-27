Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27CA26C393
	for <nvdimm@lists.linux.dev>; Fri, 27 Jun 2025 09:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751016788; cv=none; b=aeIm+i0pj5wvGkApbfLmDBVjgpuESA/qksROofHdUpbkXWuXmlQci2jzbNzuuuH4tzHb8j/iHez2pmyuF59Q/NtMG6P477MuaXHO97Z8ZnHbqeSsLigT59ozDKlVIGLqZRvzjNdL0N4XdWkfgPDxtTwjy8c8+tA/fjXq8lOS4Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751016788; c=relaxed/simple;
	bh=VXByMGvrYIFk6J7l6d66GOgoXAABV8VqYthKY3nfMFk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=hPie4/SGa+wF1puemJFbjR3cXK8yoSS1OJNz8Gh2gu0NfAF2VYVIuco8ev4y1yFiCyR5dMfjZzeVhO5Nb0aZTr3LuEsdx73hPZDhgd08P4Y2cR0NFSaf9pMPFhKuL7BxIZKQNVcCvoplV5Q92EFBGopO+zP6nle5RvsOZQDZJ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=uCxYqSBQ; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="uCxYqSBQ"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250627093303epoutp021ef414c30afdd939915ebfbf9042a5df~M3HzAJfV22785127851epoutp02h
	for <nvdimm@lists.linux.dev>; Fri, 27 Jun 2025 09:33:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250627093303epoutp021ef414c30afdd939915ebfbf9042a5df~M3HzAJfV22785127851epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1751016783;
	bh=803Ryi9f+g9PHC85frY88NRvvDMi88cIW/isNgputhc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uCxYqSBQfBbQ/WsDJJvQGDLQWfB+oc0xyEx0JyHGXoigzZWjwjWW30vl9gpZzObtl
	 92pYaJB2/ulIL5hd/cIjhnK6JreXJA5Gsqik7Ceg3B/xYJmuSrd2JDR+z1mMfmO+vz
	 UC1VT/NYLRHjrfOJertXs8iQEtvx9j1nYfVRp4bA=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250627093302epcas5p1a6ad3f06f523f5bccd4d50d2dac71130~M3HyHJ4Ct3060930609epcas5p1X;
	Fri, 27 Jun 2025 09:33:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bT9Mf3Y5Qz2SSKj; Fri, 27 Jun
	2025 09:33:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250627090337epcas5p1c77ffd7260b375241786afa81a1712ce~M2uGkTsPF2989429894epcas5p15;
	Fri, 27 Jun 2025 09:03:37 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250627090335epsmtip10a1c0b878e5135109f36f5fe1b81d39d~M2uEJ_prp1804518045epsmtip1L;
	Fri, 27 Jun 2025 09:03:35 +0000 (GMT)
Date: Fri, 27 Jun 2025 14:33:29 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, a.manzanares@samsung.com, nifan.cxl@gmail.com,
	anisa.su@samsung.com, vishak.g@samsung.com, krish.reddy@samsung.com,
	arun.george@samsung.com, alok.rathore@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH 15/20] cxl: Add a routine to find cxl root decoder
 on cxl bus
Message-ID: <1983025922.01751016782483.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aF2dUqGKcu8-rwaV@aschofie-mobl2.lan>
X-CMS-MailID: 20250627090337epcas5p1c77ffd7260b375241786afa81a1712ce
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_d1ff6_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8
References: <20250617123944.78345-1-s.neeraj@samsung.com>
	<CGME20250617124049epcas5p1de7eeee3b5ddd12ea221ca3ebf22f6e8@epcas5p1.samsung.com>
	<1295226194.21750165382072.JavaMail.epsvc@epcpadp2new>
	<aF2dUqGKcu8-rwaV@aschofie-mobl2.lan>

------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_d1ff6_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 26/06/25 12:19PM, Alison Schofield wrote:
>On Tue, Jun 17, 2025 at 06:09:39PM +0530, Neeraj Kumar wrote:
>> Add cxl_find_root_decoder to find root decoder on cxl bus. It is used to
>> find root decoder during region creation
>
>Does the existing to_cxl_root_decoder() provide what you need here?
>

Hi Alison,

Actually, my need is to find decoder0.0 from port1, with which endpoint device is connected.
Here i am already using to_cxl_root_decoder() inside cxl_find_root_decoder().
In cxl_find_root_decoder(), First i am finding dev which is required by to_cxl_root_decoder()

	struct cxl_root_decoder *cxl_find_root_decoder(struct cxl_port *port)
	{
		struct cxl_root *cxl_root __free(put_cxl_root) = find_cxl_root(port);
		struct device *dev = device_find_child(&cxl_root->port.dev, NULL, match_root_decoder);
		return to_cxl_root_decoder(dev);
	}


Thanks,
Neeraj

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
>> --
>> 2.34.1
>>
>>

------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_d1ff6_
Content-Type: text/plain; charset="utf-8"


------K5ZVV-zrPS8y8iJelFUsagW7KEVVNg7wn3oh2ZJRPRpX678s=_d1ff6_--

