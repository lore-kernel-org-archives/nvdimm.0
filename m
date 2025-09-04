Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5B52045B7
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757055787; cv=none; b=EA0V6nOTXvApg1ix/ELYAfSOJ8Eqn0v/DobuEnbGFwpJBpf8NrVO0UfAJ+PgrNu+WUO5kDLZvw6bCsGgpYH/njUmwiuLyHLZ5x7uuZy1OICVrYWXPQauK8EFAkgQQM0RMpAt2NTStFGSvmHSGXmXQZBzjXf4kppWndisb/29LSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757055787; c=relaxed/simple;
	bh=GFB77Kia7nFWeUn6EKHzA83dbk9PLHtJAef6GyQAXJw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=PloAO3/VBZ8ZTJvLVKp84aaOfbo8WUF1tzbT18qVw60IUBZQo0fmKoyRh34vk6C5+XI5tqsHj4iqt+bDIBf6saOil5MIeGe1rPswuQkKtOsOwbm/DMjxmnNQ//iP5hs1oubIdYIyFLA7Ikrmv8JVrv1Bbcpt8ceK0glodmSO5EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Xw7j69eR; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Xw7j69eR"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250905070303epoutp0434491cb1f2f820f470297759d0e7b1f6~iUOz8s2nH2397223972epoutp04K
	for <nvdimm@lists.linux.dev>; Fri,  5 Sep 2025 07:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250905070303epoutp0434491cb1f2f820f470297759d0e7b1f6~iUOz8s2nH2397223972epoutp04K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757055783;
	bh=GFB77Kia7nFWeUn6EKHzA83dbk9PLHtJAef6GyQAXJw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Xw7j69eRswsCDUefMTsmiYSXV3SD3GkiDZYv8rDh+m7epK7xT0XSMsD/9xu/l1AUR
	 7SWoRIP8Oeo+HJ9fba2wZ8342Hv9bC2PqlL5QbjxQ2wCMX+fR4q9iNP71VzvHmYNcO
	 UWJrGyRP3HBk2KlkHBfbQoN3MyQEyajM8NYxLdlo=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250905070303epcas5p3ae383c5ed342aa2b5a50aaf9a95e88a4~iUOzpy3un1446414464epcas5p3p;
	Fri,  5 Sep 2025 07:03:03 +0000 (GMT)
Received: from epcpadp2new (unknown [182.195.40.142]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cJ6kH0QkRz2SSKn; Fri,  5 Sep
	2025 07:03:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250904140222epcas5p2cf05c11cfab462d6b7ea44a696615674~iGTopfau41527115271epcas5p24;
	Thu,  4 Sep 2025 14:02:22 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250904140220epsmtip2833e27c5fb9767d885da67727bf44810~iGTnUDHOk2403024030epsmtip2S;
	Thu,  4 Sep 2025 14:02:20 +0000 (GMT)
Date: Thu, 4 Sep 2025 19:32:15 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V2 04/20] nvdimm/label: CXL labels skip the need for
 'interleave-set cookie'
Message-ID: <1931444790.41757055783048.JavaMail.epsvc@epcpadp2new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <68a4a09b147ef_27db95294a8@iweiny-mobl.notmuch>
X-CMS-MailID: 20250904140222epcas5p2cf05c11cfab462d6b7ea44a696615674
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_eac9d_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121227epcas5p4675fdb3130de49cd99351c5efd09e29e@epcas5p4.samsung.com>
	<20250730121209.303202-5-s.neeraj@samsung.com>
	<68a4a09b147ef_27db95294a8@iweiny-mobl.notmuch>

------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_eac9d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 19/08/25 11:04AM, Ira Weiny wrote:
>Neeraj Kumar wrote:
>> CXL LSA v2.1 utilizes the region labels stored in the LSA for interleave
>> set configuration instead of interleave-set cookie used in previous LSA
>> versions. As interleave-set cookie is not required for CXL LSA v2.1 format
>> so skip its usage for CXL LSA 2.1 format
>>
>> Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
>
>Seems ok:
>
>Acked-by: Ira Weiny <ira.weiny@intel.com>

Thanks Ira for review and AB tag.


Regards,
Neeraj

------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_eac9d_
Content-Type: text/plain; charset="utf-8"


------AO5Z5CA5q82FpJQJAbIGDvoW6m12ppu.cCYhbwpEEtg295OJ=_eac9d_--

