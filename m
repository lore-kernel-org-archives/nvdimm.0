Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A91168
	for <nvdimm@lists.linux.dev>; Wed, 30 Jun 2021 03:14:45 +0000 (UTC)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GF5RZ0g4ZzXmbK
	for <nvdimm@lists.linux.dev>; Wed, 30 Jun 2021 10:50:02 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 30 Jun 2021 10:55:21 +0800
Received: from [127.0.0.1] (10.174.177.249) by dggema765-chm.china.huawei.com
 (10.1.198.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 30
 Jun 2021 10:55:21 +0800
Subject: Re: [ndctl PATCH 0/2] fix two issues reported by Coverity
To: <vishal.l.verma@intel.com>
CC: <nvdimm@lists.linux.dev>, <linfeilong@huawei.com>, lixiaokeng
	<lixiaokeng@huawei.com>, <liuzhiqiang26@huawei.com>
References: <d9881921-aef7-5410-1536-71df81227f4b@huawei.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <92a991be-36e8-77b7-fcac-b2687a015567@huawei.com>
Date: Wed, 30 Jun 2021 10:55:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <d9881921-aef7-5410-1536-71df81227f4b@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.249]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected

friendly ping..

On 2021/6/15 20:37, Zhiqiang Liu wrote:
> Recently, we use Coverity to analysis the ndctl package, again.
> Two issues should be resolved to make Coverity happy.
>
> Zhiqiang Liu (2):
>   libndctl: check return value of ndctl_pfn_get_namespace
>   namespace: fix potentail fd leak problem in do_xaction_namespace()
>
>  ndctl/namespace.c | 35 +++++++++++++++++++++++------------
>  test/libndctl.c   |  4 ++--
>  util/json.c       |  2 ++
>  3 files changed, 27 insertions(+), 14 deletions(-)
>

