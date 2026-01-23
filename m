Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3342F549D
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167086; cv=none; b=U4udluaGU5XqM9vNBEO7VopIY6TZqsu3sQcv1HWsKGkPu1JsycEaK+RocjOYs+iC7BU7uxLPiMIR2DzN7KUs9kDIijgEIiYNxvEXB7RCFOdmigv5d/WzN+0J3ckuvSHM1IIhxLajfdQisbWGlYumXJZQ8LH/xPyytEvvUAnJj94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167086; c=relaxed/simple;
	bh=my2Kydk5e8moUcWWKVcH2XEUmnpUd4Fy1R5kO/cZfOc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=WS9FLfYw/6mTnzbcnlxNdSmrKcchL2NR14NH/3/JwWRgl6V+xwEMfdJFQ59t78QkR+VpqoGlOkY/oiQNWw9vq+ysu0GBOP5hdvLSG0X04ZYbWdD1/zbYc0orLz1v/AeHgRDzQ1ldoQrzHIr2+ISm9mUKaD5BclGCv8fr6FajDXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ePX0kMVw; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ePX0kMVw"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260123111802epoutp04e6ed3167c2a9f2578d3420823b51469f~NWBanPIDU2011320113epoutp04k
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:18:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260123111802epoutp04e6ed3167c2a9f2578d3420823b51469f~NWBanPIDU2011320113epoutp04k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167082;
	bh=my2Kydk5e8moUcWWKVcH2XEUmnpUd4Fy1R5kO/cZfOc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ePX0kMVwmSi77lZ7FoTd6woMnapdIRGKtz9xELiq6+Mbh4WHR8kPSBGtu4Nc9mWAJ
	 6tU0Sycd4wCzIQK+q53EqTrGRNBf0oY++r1sVbFqI62K577PKFuh4Gk5BiAEVkwDNa
	 7Ib6Vu8brn97OZ5cNmmxVkvOWCUDDlcXZDwskj9k=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260123111802epcas5p4ee9feec2c3ff8091119f8e0ff4df31db~NWBaRbmVF0751707517epcas5p4y;
	Fri, 23 Jan 2026 11:18:02 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dyFlt3v52z3hhT3; Fri, 23 Jan
	2026 11:18:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260123111125epcas5p2dbf4093cf16136d39afb918ff78424c5~NV7oxkLiS1660116601epcas5p2Z;
	Fri, 23 Jan 2026 11:11:25 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260123111124epsmtip1e3bf25d269aac3b92cb3f5fa4c70479e~NV7ndx7jR0247502475epsmtip1p;
	Fri, 23 Jan 2026 11:11:24 +0000 (GMT)
Date: Fri, 23 Jan 2026 16:41:16 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V5 09/17] nvdimm/label: Export routine to fetch region
 information
Message-ID: <1931444790.41769167082546.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <697021e1bdbd5_1a50d4100d9@iweiny-mobl.notmuch>
X-CMS-MailID: 20260123111125epcas5p2dbf4093cf16136d39afb918ff78424c5
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11f0a5_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260109124522epcas5p2ecae638cbd3211d7bdbecacba4ff89f3
References: <20260109124437.4025893-1-s.neeraj@samsung.com>
	<CGME20260109124522epcas5p2ecae638cbd3211d7bdbecacba4ff89f3@epcas5p2.samsung.com>
	<20260109124437.4025893-10-s.neeraj@samsung.com>
	<697021e1bdbd5_1a50d4100d9@iweiny-mobl.notmuch>

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11f0a5_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 20/01/26 06:46PM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> CXL region information preserved from the LSA needs to be exported for
>> use by the CXL driver for CXL region re-creation.
>>
>
>Some of the CXL tree patches did not apply cleanly to cxl/next.
>
>Up to this point I ran the nvdimm tests which showed that none of this
>broken existing functionality.
>
>Will there be additional nvdimm tests for this?

No I have not added any additional test for this.
This is tested using qemu and mentioned its procedure in cover letter

>
>Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Thanks Ira for RB tag.


Regards,
Neeraj

------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11f0a5_
Content-Type: text/plain; charset="utf-8"


------bVwHse4Nykw-L2c5iRRXKf-G.8k0lxUwrpcTFjGaDb9lfltx=_11f0a5_--

