Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D97C245032
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759726508; cv=none; b=SYlx4d6uA9TuBjvAM9bIAuR1IRB343kQ4YQKkoqr/GKxrGQFFdYqalD0L4e9lk2VjCQ0nZAeLZg0B7dLY0MDGC+UWLWJWPRqZZm/HbQi+JQyY3ahRqQG/wymwjZsrdLR75so7SVZhrFtJeqdAyM5Ew+1qBGURSkbbOerBc9L0K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759726508; c=relaxed/simple;
	bh=u4Rkk/XPq4sm1ecP5jFSaYINMSC9Q3ZShnVbxXlHPag=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=fJeee5GJIuRugV/UXCIlTRyxpQZFHB7/WNR6gP/ZD3hkViAl8jP1510qX5TMLDUbljtZ8tNcHOdFMiL3GoeG1ubE6Eb5me5GcMlP7UwPR8OJnG2vDSBcldzdeYzti9V+lAj/wGgwhI+RReWFoPcve/Ny/NjfT2K1+ifD+D/8k28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=sAftzDRD; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="sAftzDRD"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251006045504epoutp03225dfd729794adb037836fb8adf866b8~rze62JMGy1644716447epoutp03g
	for <nvdimm@lists.linux.dev>; Mon,  6 Oct 2025 04:55:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251006045504epoutp03225dfd729794adb037836fb8adf866b8~rze62JMGy1644716447epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759726504;
	bh=u4Rkk/XPq4sm1ecP5jFSaYINMSC9Q3ZShnVbxXlHPag=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sAftzDRDEgAd9o82lEuWD4qn7f8jnOcFX9AXNNue1Z/pOFyO/EKVPtD9pNL6ZYJgG
	 vVcTe9giFU9+OBzAkUGRcv9Y8ZYWXAydlSQ/ZkASJ6ILcywsj2vFQ00WVCXXQO+xns
	 EU3sg7qulrvROtkVBYcC6Za4Z2XpNDel40irA1K8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20251006045504epcas5p4a0c3caf21317c3ac1e6000b8750b68cb~rze6iIuQr2196921969epcas5p4n;
	Mon,  6 Oct 2025 04:55:04 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cg6QJ1N1lz3hhT7; Mon,  6 Oct
	2025 04:55:04 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250929135210epcas5p38239fc5a1426ee49707e1fc2e11e81fe~pxS4ES8Ib1329113291epcas5p3l;
	Mon, 29 Sep 2025 13:52:10 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250929135209epsmtip1893dc67ae02275be0dacfb510be74402~pxS21k5db1115311153epsmtip1P;
	Mon, 29 Sep 2025 13:52:09 +0000 (GMT)
Date: Mon, 29 Sep 2025 19:22:06 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 16/20] cxl/mem: Preserve cxl root decoder during mem
 probe
Message-ID: <439928219.101759726504189.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <0bcc237d-08ba-4909-8ad2-748570cbc1db@intel.com>
X-CMS-MailID: 20250929135210epcas5p38239fc5a1426ee49707e1fc2e11e81fe
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7480_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134203epcas5p3819aee1deecdeaed95bd92d19d3b1910
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134203epcas5p3819aee1deecdeaed95bd92d19d3b1910@epcas5p3.samsung.com>
	<20250917134116.1623730-17-s.neeraj@samsung.com>
	<0bcc237d-08ba-4909-8ad2-748570cbc1db@intel.com>

------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7480_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 24/09/25 11:23AM, Dave Jiang wrote:
>
>
>On 9/17/25 6:41 AM, Neeraj Kumar wrote:
>> Saved root decoder info is required for cxl region persistency
>
>Should squash this patch into the previous patch. It's small enough that the usage and the implementation can be in the same patch.
>

Yes its small change. I will squash this in previous patch.

Regards,
Neeraj

------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7480_
Content-Type: text/plain; charset="utf-8"


------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_7480_--

