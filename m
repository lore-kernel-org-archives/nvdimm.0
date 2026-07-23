Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D7240862C;
	Thu, 23 Jul 2026 08:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784796308; cv=none; b=YuARorRXbElwUawwNoGu7EPf8+9ooJoi4bXbrfmykoTxRwesvt9Yb1M5Ms1HcnbeBAWtNdbYeRftKlPKGnCwRKwZxsnmidGjerUAujom6QavC6QX88ynhoN3GpbEInsGJRbVIj0vtZ7RnQLtT2mQ3K3/jX15DAwaCkSK4x19ipc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784796308; c=relaxed/simple;
	bh=8GgPzaxuYc4s2cVuSgAcGd76ajTea0DUpWFyFtd2Oy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=dOALgCHeUlGxQTwpEoO6EoTmY0R2TrvCOH4o483ji6QdgPuxmBc47U5HoUFk09CiGF1oUqIw1gWkVAl/xpNdYKH2I1X8ZdyBoxKPx5Kit3WIrTZAFt5tM6Jrgwnc51hYmmj50Tk9+b52wA4JbC7WqPBjPkcCc7U1F4VSyX5ECfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=W5gXIxoD; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="W5gXIxoD"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260723084503epoutp04a324084313ef02b272e897115231c5b2~E3sg4KZO-3034630346epoutp04L;
	Thu, 23 Jul 2026 08:45:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260723084503epoutp04a324084313ef02b272e897115231c5b2~E3sg4KZO-3034630346epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784796303;
	bh=sQjXIg3wAcrT3mkYCsdbl0LWsoOlUsvvM9TLKCcGrBo=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=W5gXIxoDyG4Nfrz0+i0pklqM2q3/qpEunf4JU/SLOUtj2VknFkftcVuCb6c5nB9rv
	 0PfvO1yP0f71Cs1IOmIxhbGH98MahM0XyvQigBVdJ9zrXWw6I7OJvWLRpHZNA++6Az
	 8E6N/DHVyIA5A/LbAByxODYxcLsaYG1fyL2e0bnc=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260723084503epcas5p43df5d820cf5e5603cbe8d66b060992f0~E3sgfyfxj0540505405epcas5p4A;
	Thu, 23 Jul 2026 08:45:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h5Pnq2p8Nz6B9mQ; Thu, 23 Jul
	2026 08:45:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260723083847epcas5p21a735796de0bdb6459cd2c3b7b9b18de~E3nCLElTK0474604746epcas5p2T;
	Thu, 23 Jul 2026 08:38:47 +0000 (GMT)
Received: from [107.122.10.65] (unknown [107.122.10.65]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260723083835epsmtip11766a99123bc01993811bc8746be0d2d~E3m3Il4WE1438914389epsmtip1e;
	Thu, 23 Jul 2026 08:38:35 +0000 (GMT)
Message-ID: <963815509.21784796303385.JavaMail.epsvc@epcpadp1new>
Date: Thu, 23 Jul 2026 14:08:31 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com, balbirs@nvidia.com, brendan.jackman@linux.dev,
	yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com,
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com,
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev,
	tj@kernel.org, mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca,
	jhubbard@nvidia.com, peterx@redhat.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	lance.yang@linux.dev, usama.arif@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, cgroups@vger.kernel.org,
	damon@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, cpgs@samsung.com
Content-Language: en-US
From: Arun George/Arun George <arun.george@samsung.com>
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260723083847epcas5p21a735796de0bdb6459cd2c3b7b9b18de
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20260720193443epcas5p167fa7d8490edfb4d8c0aa6a259db058f
References: <CGME20260720193443epcas5p167fa7d8490edfb4d8c0aa6a259db058f@epcas5p1.samsung.com>
	<20260720193431.3841992-1-gourry@gourry.net>

On 21-07-2026 01:03 am, Gregory Price wrote:
> Changes Since V4
> ================
>   - dropped compressed ram example from series
>       - will submit separately if this moves forward

We intend to test this series on a compression capable CXL expander 
hardware. Since compressed ram example (cram) is not part of this 
series, how do you suggest to do that? Do you have a version of cram 
module compatible with this series?

~Arun

