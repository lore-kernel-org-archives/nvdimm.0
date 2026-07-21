Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2643655D0;
	Tue, 21 Jul 2026 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784640386; cv=none; b=SKPo9fbczu1CkrFtsXA4RFOH0R7TfdEt9HkGb+/AloBzi84WzVvxRpLZrg8IY9peLZuMnR8u37+4akHeqb0ahFRmQS+DepVd1uFOhHbssG8hYH15OA3hn3TQkKvykxyQInK+/7YZY1zoJsfT/U4wxXs/2brGNmnFpjIsoY/yZlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784640386; c=relaxed/simple;
	bh=Hc9kzoQ9rFyyW8XHyUKHR1d2Dsj44oWw597yXAQp+uc=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=GEdDjd+l4Gj33ZCwWwrJxIBzZMFI9e4j/ITV72Yg0PdryKBOEpAw0kzHvyU9ULEnsQngigOH4JsMaBOetENIGbOCBx6pZgnTLXBilTze45H6GqyqfZb0TPzW1reanA58CF1ZJR1Kzb565cLmo+EBqCsi9y6kOERkDaqFQ9IiOc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Uj1oBLm2; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Uj1oBLm2"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9hgq2bOlQdWO8j42MpZzQv278XodO4khDw3hgg8g+EE=;
	b=Uj1oBLm2piRS2jcNrVUUdAj64NR7QB2AifXV29XsiXtXTCt8/PmMpEq+nwr+s8iX+TO4SVXy8
	IusYOu5A+t3ilK/5m8l2t6qY1s1aIGuzFz4Xh3ZFK7Gj4qZgTf2WIrFuLXxQw3LkIeDfDM4c4Ja
	qOFsHfRNHFyUbXAQwQgO+MU=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4h4HwR2B42zLlX5;
	Tue, 21 Jul 2026 21:16:55 +0800 (CST)
Received: from whupemo200006.china.huawei.com (unknown [7.152.185.252])
	by mail.maildlp.com (Postfix) with ESMTPS id 668704056C;
	Tue, 21 Jul 2026 21:26:17 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 whupemo200006.china.huawei.com (7.152.185.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Jul 2026 21:26:10 +0800
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>
CC: <linux-mm@kvack.org>, <Zhigang.Luo@amd.com>, <arun.george@samsung.com>,
	<balbirs@nvidia.com>, <brendan.jackman@linux.dev>, <apopple@nvidia.com>,
	<alucerop@amd.com>, <matthew.brost@intel.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <corbet@lwn.net>, <skhan@linuxfoundation.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <dakr@kernel.org>,
	<djbw@kernel.org>, <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
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
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <a9c52bb6-5e04-1d41-913a-685a7be3fad4@huawei.com>
Date: Tue, 21 Jul 2026 21:26:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemo200006.china.huawei.com (7.152.185.252)

On 2026/7/21 3:33, Gregory Price wrote:
>   KVM: guest_memfd: bind backing memory to a NUMA node at creation
>   KVM: selftests: add a guest_memfd FLAG_BIND_NODE test

I can't find the last patch in my inbox or on the lore. Not sure what went
wrong.

Thanks,
Zenghui
