Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B1532F763
	for <nvdimm@lists.linux.dev>; Thu, 13 Nov 2025 07:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763020210; cv=none; b=YwWjwMru0wZEmgHepkm7WzEQju2kLr+qUwnAzTBk3amPrDTfYa0lDtGRVKxh3nj7ULrOZ/pm9Vh6sn0VNCMJagE7hVcaSc4aMJkq9hPzARg8p7naBLcAI6Kp2/9KeUCrQCDW3lvHUsLCmUz+wFDHE27VeBxPyftkrnZcyIHPxwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763020210; c=relaxed/simple;
	bh=rPpv0YpI1s5IrHKxhIrzkZ9tfhot0vKl5EEgO7jMoXw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=K4GeU6kKYsxUrCCTIWbbq+RZI7f1NQ5AIab/i5ZKZ6ErHmnDQ2/DZE8CTrGQir676uFveNei2L3x1ZEXMzSIRL52zH0jU70djelG3Fybgimj6uLeMD+1tIG86iGWSLwxnUVjL7BbRuVCEaESQxCpDp4CLsOzj02a0noAuNbvADI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=A9l14zFZ; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="A9l14zFZ"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251113075002epoutp03ed3f9f753f1d130adfec881624a36c6f~3gYiBfUbt1120511205epoutp03D
	for <nvdimm@lists.linux.dev>; Thu, 13 Nov 2025 07:50:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251113075002epoutp03ed3f9f753f1d130adfec881624a36c6f~3gYiBfUbt1120511205epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763020202;
	bh=rPpv0YpI1s5IrHKxhIrzkZ9tfhot0vKl5EEgO7jMoXw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A9l14zFZuSkh+OidejInaqgr+qLiNd+IwX/OebIx1AoomckDymuGsivNFVyzMEwEE
	 JSpmaW/oWo78pYwbzW5R0ws3qAspDdoj3sXsTWRSHOx+ipaBSxoHOIkeVTrc3C01kf
	 ItnqK9I6WqBjgC2a/DoCJ+mazpcyG9U01k/sEP2M=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251113075002epcas5p2223c3bb7ed92c0b3dd1494dc7113ef43~3gYhvQe4-2564525645epcas5p2O;
	Thu, 13 Nov 2025 07:50:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4d6XVf0cddz6B9m6; Thu, 13 Nov
	2025 07:50:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251113072717epcas5p22ac6aa251df5c33fadfe2c100ab833b1~3gEqdwnW62353123531epcas5p2U;
	Thu, 13 Nov 2025 07:27:17 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251113072715epsmtip1f93902a24349817692a96ba43c340c6c~3gEpFe0zQ2815128151epsmtip1S;
	Thu, 13 Nov 2025 07:27:15 +0000 (GMT)
Date: Thu, 13 Nov 2025 12:57:09 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 13/20] cxl/mem: Refactor cxl pmem region
 auto-assembling
Message-ID: <1983025922.01763020202072.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <a204bc0e-1111-4ff9-a8d2-eeb8b7b9fe8d@intel.com>
X-CMS-MailID: 20251113072717epcas5p22ac6aa251df5c33fadfe2c100ab833b1
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_bc0e0_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134157epcas5p1b30306bc8596b7b50548ddf3683c3b97
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134157epcas5p1b30306bc8596b7b50548ddf3683c3b97@epcas5p1.samsung.com>
	<20250917134116.1623730-14-s.neeraj@samsung.com>
	<c7b41eb6-b946-4ac0-9ddd-e75ba4ceb636@intel.com>
	<1296674576.21759726502325.JavaMail.epsvc@epcpadp1new>
	<361d0e84-9362-4389-a909-37878910b90f@intel.com>
	<1983025922.01762749301758.JavaMail.epsvc@epcpadp1new>
	<a204bc0e-1111-4ff9-a8d2-eeb8b7b9fe8d@intel.com>

------DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_bc0e0_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On 12/11/25 08:55AM, Dave Jiang wrote:
>
>

<snip>

>> During cxl_pci_probe() we call devm_cxl_add_memdev(struct cxl_memdev_ops *ops)
>> where function pointer as ops gets registered which gets called in cxl_mem_probe()
>> using cxlmd->ops->probe()
>>
>> The probe callback runs after the port topology is successfully attached for
>> the given memdev.
>>
>> So to use this infra we have to pass cxl_region_discovery() as ops parameter
>> of devm_cxl_add_memdev() getting called from cxl_pci_probe().
>>  
>> In this patch-set cxl_region_discovery() signature is different from cxlmd->ops->probe()
>>
>>    {{{
>>     void cxl_region_discovery(struct cxl_port *port)
>>     {
>>             device_for_each_child(&port->dev, NULL, discover_region);
>>     }
>>
>>     struct cxl_memdev_ops {
>>             int (*probe)(struct cxl_memdev *cxlmd);
>>     };
>>    }}}
>>
>> Even after changing the signature of cxl_region_discovery() as per cxlmd->ops->probe()
>> may create problem as when the ops->probe() fails, then it will halts the probe sequence
>> of cxl_pci_probe()
>>
>> It is because discover_region() may fail if two memdevs are participating into one region
>
>While discover_region() may fail, the return value is ignored. The current code disregards failures from device_for_each_child(). And also above, cxl_region_discovery() returns void. So I don't follow how ops->probe() would fail if we ignore errors from discover_region().
>
>DJ

Hi Dave,

Yes, you are correct. We can just change signature of cxl_region_discovery() as per
cxlmd->ops->probe(), anyway we are ignoring errors from discover_region().
With this change we can directly register cxl_region_discovery() with
devm_cxl_add_memdev(struct cxl_memdev_ops *ops) during pci_probe() using Dan's Infra.

I will use this new infra for region auto-assembling and share the v4 series shortly.


Regards,
Neeraj

------DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_bc0e0_
Content-Type: text/plain; charset="utf-8"


------DpLuDkH5jVwtRmV_no6S5rPRFid5ecuUEflgz2nUXUkLddKC=_bc0e0_--

