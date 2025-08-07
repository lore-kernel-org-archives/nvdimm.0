Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905BF252286
	for <nvdimm@lists.linux.dev>; Sun, 10 Aug 2025 12:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754829014; cv=none; b=K3+KZ4HhypTf2OJUOZPJS0SxcZUiSw463Z/b+iSzcn9ZHwiwftLz7dEMFaBijQkB3Mg9WW/j52Dp0VeHbChjZJfCRzj/dYA8lm7zXZ/Ye3G5VmIjDrqXqfmgs0Q3CLyABWezHdkDvrxM2BCNrGozKUjUxymMICYGZdgpxCnLlUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754829014; c=relaxed/simple;
	bh=sEDCDrE6UaiWIhMD6cJ0TnbRfom7RnarYsp+lhz57OY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=k/S1NUW7DG/BNWVSsfw5GiOixfnLjHHpAeGUWYrBopO5uKKQmCsT7mRwg1ToJh8z2sVsyJ7KJ0m115duCW5fGXW7SboUMMAtcNTYVedvHJ3m70g942Jk6I3Ij47NdJGs9cVLXjNOaipvN7TyrmlvRRkNUGHpxaLKZ23t8xj45fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IQ5gOUvy; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IQ5gOUvy"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250810123003epoutp02320593981f6e8f6ca2c27562f1f57156~aZ65hZMqe0551505515epoutp02A
	for <nvdimm@lists.linux.dev>; Sun, 10 Aug 2025 12:30:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250810123003epoutp02320593981f6e8f6ca2c27562f1f57156~aZ65hZMqe0551505515epoutp02A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754829003;
	bh=sEDCDrE6UaiWIhMD6cJ0TnbRfom7RnarYsp+lhz57OY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IQ5gOUvyFcZGwtSgMbiGJAoyFQo4ikbl2C/3Zdgt3kA1tkgR2apmqhdKWiz8jtkVO
	 s4RNC0VM/Zy0VFoQRRMZjyKrDCHzx+Nts5DftITYTgAIgmd/f2MR64E8wDCiu4c8xW
	 inl1fVkfDsa1rY5cqrhQn1PN6NKXoVZ99UdGL5qc=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250810123002epcas5p148fc2b449517f564baddc20b05aa29b4~aZ64j-aql1995119951epcas5p1K;
	Sun, 10 Aug 2025 12:30:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4c0HCZ2tRZz2SSKX; Sun, 10 Aug
	2025 12:30:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250807090254epcas5p22d81d318908416ca3d5401b53bb7d2c0~ZcKLNR8ps0698406984epcas5p2K;
	Thu,  7 Aug 2025 09:02:54 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807090252epsmtip1db8a8d52c1ea56c6cc1cc33ef1833a91~ZcKJXFbU30745807458epsmtip1p;
	Thu,  7 Aug 2025 09:02:52 +0000 (GMT)
Date: Thu, 7 Aug 2025 14:32:39 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>, Davidlohr Bueso
	<dave@stgolabs.net>, Jonathan Cameron <jonathan.cameron@huawei.com>, Dave
	Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Alison
	Schofield <alison.schofield@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 00/20] Add CXL LSA 2.1 format support in nvdimm and
 cxl pmem
Message-ID: <1983025922.01754829002385.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
X-CMS-MailID: 20250807090254epcas5p22d81d318908416ca3d5401b53bb7d2c0
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_76dae_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121221epcas5p3ffb9e643af6b8ae07cfccf0bdee90e37
References: <CGME20250730121221epcas5p3ffb9e643af6b8ae07cfccf0bdee90e37@epcas5p3.samsung.com>
	<20250730121209.303202-1-s.neeraj@samsung.com>

------CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_76dae_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 30/07/25 05:41PM, Neeraj Kumar wrote:
>Introduction:
>=============
>CXL Persistent Memory (Pmem) devices region, namespace and content must be
>persistent across system reboot. In order to achieve this persistency, it
>uses Label Storage Area (LSA) to store respective metadata. During system
>reboot, stored metadata in LSA is used to bring back the region, namespace
>and content of CXL device in its previous state.
>CXL specification provides Get_LSA (4102h) and Set_LSA (4103h) mailbox
>commands to access the LSA area. nvdimm driver is using same commands to
>get/set LSA data.
>

Hi Jonathan, Dave and Ira

I have addressed the review comments of V1 patch-set and sent out this
V2 Patch-set.
0-Day Kernel Test bot has reported couple of minor issues which I will
address in next series.

Can you please have a look at this V2 series and let me know your
feedback.


Regards,
Neeraj

------CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_76dae_
Content-Type: text/plain; charset="utf-8"


------CDBSwZz52MZUMeM1Rx6lI.cEW_5b_YZAAzr3v09AM7rvldzc=_76dae_--

