Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E4B348C5D;
	Thu,  6 Aug 2026 03:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785987025; cv=none; b=FEfjEj4uTQuUl8J5fcvrGYWVo1n+ikv0jFbHld+3p3uX6agBMnb5U7ruJEweD5RniIiCuTKi7n9je1Qbqm6lHWdR0sPzX3tSkaI1uIhUrppL04j+AgSAK1klA8iY8JzLvkH/FVq4xJQS7z+PJ5QqCA5CGfoIK70juVW0W+5IjmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785987025; c=relaxed/simple;
	bh=5wus9n0+Mpv7rQWIuIFpoGHkgxM6w2e5wGqel/1cJaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CdmIURc4tObe5NwvFRqgPLE9f7kfldvCKq0nz7WcXeQmjP6cckhH0aPcCzbKLyjHXfs+Y3XYrZj1rRD1KbbYf3ZU/QIxL/Cyfal0jVR61T6PMdL3er4ykgbN7+cyBmuVACl/xlA5c1mN8L8D4Vy5A3Q60Q4+RRyFoW5Ff8gkI/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=xvnedJmH; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="xvnedJmH"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5wus9n0+Mpv7rQWIuIFpoGHkgxM6w2e5wGqel/1cJaU=;
	b=xvnedJmHWhePXoOFObXkvLZJh87bx4MqXErY79eOEcbrJjXMeD32rgcW+e1+Mzp80DMGfqr0p
	H5FXDNNf1FtCAkZtvN0zOyEW3ZqTIIFL63xHsatM7LYQOmJbAX0l/KDbPYMgxr2Fhy00WgHcfHo
	1HBeTwRYcVunCQ6fWo8o/vc=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hFsx50g2bzmV8f;
	Thu,  6 Aug 2026 11:20:41 +0800 (CST)
Received: from kwepemo500018.china.huawei.com (unknown [7.202.195.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 14F5F4058A;
	Thu,  6 Aug 2026 11:30:13 +0800 (CST)
Received: from [10.174.176.101] (10.174.176.101) by
 kwepemo500018.china.huawei.com (7.202.195.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 6 Aug 2026 11:30:09 +0800
Message-ID: <6840c720-8cb7-46bb-a652-040c130a4427@huawei.com>
Date: Thu, 6 Aug 2026 11:30:08 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 25/36] mm/memory_hotplug: support N_MEMORY_PRIVATE node
 hotplug
To: Gregory Price <gourry@gourry.net>, <linux-mm@kvack.org>
CC: <Zhigang.Luo@amd.com>, <arun.george@samsung.com>, <balbirs@nvidia.com>,
	<brendan.jackman@linux.dev>, <yuzenghui@huawei.com>, <apopple@nvidia.com>,
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
 <20260720193431.3841992-26-gourry@gourry.net>
From: Qiqi Li <liqiqi23@huawei.com>
In-Reply-To: <20260720193431.3841992-26-gourry@gourry.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemo500018.china.huawei.com (7.202.195.199)

Hi Gregory,

On 7/21/2026 3:34 AM, Gregory Price wrote:

> Add add_private_memory_driver_managed() to let modules hotplug
> memory onto an N_MEMORY_PRIVATE node they control.

I am trying to understand how the nid passed to
add_private_memory_driver_managed() is expected to be provisioned.

From what I can see, both node_private_register() and
__add_memory_resource() require the nid to already be present in
node_possible_map. My understanding is therefore that this patch
supports hotplugging private memory onto an existing possible node,
rather than creating a new possible node ID at runtime.

For example, in the use case I am looking at, the device's private
node is not described by firmware. Would its nid need to be reserved
during early NUMA initialization, or is there another mechanism that
I may have missed?

Also, could you please Cc me on future revisions of this series?
I would appreciate it and would be happy to follow the work:)

Thanks,
Qiqi
