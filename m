Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DF12EB0F;
	Fri,  4 Sep 2026 01:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788483957; cv=none; b=D3EMHdCn/q9CLxQQyxSZDYgj36zy0Dtk52BkMX1IYBs1be2pU49ODMhvp7RfDPZTaWjvYvLshrsFo+TPKyKmeMstI6fhN9D8h9b/Vxmv5mpYO3qTVHII/syYOS5L6A6evoLlYnsKK3AaY2LSenCtDZk+zvg6uciU4SnA2GkdkBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788483957; c=relaxed/simple;
	bh=pXJxK3+dwpX0ZuLCucXJEaT/CLa6AThnH/lmQa4I3lI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=qOpY5UD2RRNkE8dMob4MfMxHW0wfFWXa5TcCNmU0klMjm2uJk0OeIgjPpygnhWyIVEOXaWzmVKofonpt0wbbnrXAlIgHDqMOw/WjTqYMIMJlm6t2Rut3HJd6CSPowhjCPrOjDFAO46dusbvfcbGyZwSJmOuQ2ZkJYq7TEF4rb78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=c1r7eiZl; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="c1r7eiZl"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=R44xkW68vjRLhEKdA9HxJ22eV9oyvArt4A8C0/wQSo8=;
	b=c1r7eiZldp5+In5FW8BEUxdtlU5u/WVo+hSCJWw91lCBymS2tcgwWI/JzJA041tHKqqz4v/Nl
	hXo7ErQV6AgoBMx7gU1AaEoW5lxF3r8HvNXZJwWBGTpxd9MgOyQkHUYa6XLn1XNdCt00vy8B1Ug
	A1o7hU9teks1R0J1f8bUgiU=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hbdJz6RXHz12LHt;
	Fri,  4 Sep 2026 08:54:27 +0800 (CST)
Received: from kwepemo500018.china.huawei.com (unknown [7.202.195.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A59E40579;
	Fri,  4 Sep 2026 09:05:43 +0800 (CST)
Received: from [10.174.176.101] (10.174.176.101) by
 kwepemo500018.china.huawei.com (7.202.195.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 4 Sep 2026 09:05:39 +0800
Message-ID: <0334fe7d-d949-45f7-8914-3012cb11b740@huawei.com>
Date: Fri, 4 Sep 2026 09:05:39 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Qiqi Li <liqiqi23@huawei.com>
Subject: Re: [PATCH v5 25/36] mm/memory_hotplug: support N_MEMORY_PRIVATE node
 hotplug
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <Zhigang.Luo@amd.com>, <arun.george@samsung.com>,
	<balbirs@nvidia.com>, <brendan.jackman@linux.dev>, <yuzenghui@huawei.com>,
	<apopple@nvidia.com>, <alucerop@amd.com>, <matthew.brost@intel.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <gregkh@linuxfoundation.org>,
	<rafael@kernel.org>, <dakr@kernel.org>, <djbw@kernel.org>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <osandov@osandov.com>, <jannh@google.com>,
	<pfalcato@suse.de>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <pbonzini@redhat.com>, <osalvador@suse.de>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<ying.huang@linux.alibaba.com>, <kasong@tencent.com>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <baohua@kernel.org>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <weixugc@google.com>, <yury.norov@gmail.com>,
	<linux@rasmusvillemoes.dk>, <longman@redhat.com>, <ridong.chen@linux.dev>,
	<tj@kernel.org>, <mkoutny@suse.com>, <sj@kernel.org>, <jgg@ziepe.ca>,
	<jhubbard@nvidia.com>, <peterx@redhat.com>, <baolin.wang@linux.alibaba.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<lance.yang@linux.dev>, <usama.arif@linux.dev>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <roman.gushchin@linux.dev>,
	<muchun.song@linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <driver-core@lists.linux.dev>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<linux-debuggers@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <cgroups@vger.kernel.org>, <damon@lists.linux.dev>,
	<linux-kselftest@vger.kernel.org>, <kernel-team@meta.com>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-26-gourry@gourry.net>
 <6840c720-8cb7-46bb-a652-040c130a4427@huawei.com>
 <aoJaaYp30LnKLj1w@gourry-fedora-PF4VCD3F>
In-Reply-To: <aoJaaYp30LnKLj1w@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo500018.china.huawei.com (7.202.195.199)

On 8/17/2026 8:49 AM, Gregory Price wrote:
> It would need to be reserved, and you could use numa emulation but
> that's clunky.  I have an RFC for exactly this issue - though i haven't
> pushed it further yet.
> 
> https://lore.kernel.org/all/20260610014517.253609-1-gourry@gourry.net/

Hi Gregory,

Sorry for the late reply.

I took a look at the exclusive-node RFC. The approach looks useful for
device-backed private memory without a firmware-described NUMA node.
Thanks for the pointer.

We are currently looking into the private-node and CRAM design as a
whole. I noticed that CRAM was not included with the v5 series, and saw
that others were also interested in a v5 version.

If you already have a CRAM branch or patches based on v5, even if they
are still work in progress, would you mind sharing them? It would be
very helpful for us to continue testing the overall design.

Thanks,
Qiqi
