Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4876F1FB2
	for <nvdimm@lists.linux.dev>; Sat,  3 Dec 2022 06:16:20 +0000 (UTC)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NPKGF038ZzqSkS;
	Sat,  3 Dec 2022 14:12:05 +0800 (CST)
Received: from [10.174.178.41] (10.174.178.41) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 3 Dec 2022 14:16:10 +0800
Message-ID: <51674c87-d9a9-ff26-8150-181119d8420b@huawei.com>
Date: Sat, 3 Dec 2022 14:16:09 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] ndtest: Add checks for devm_kcalloc
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, <dan.j.williams@intel.com>,
	<vishal.l.verma@intel.com>, <dave.jiang@intel.com>, <ira.weiny@intel.com>,
	<jane.chu@oracle.com>, <dave.hansen@linux.intel.com>, <santosh@fossix.org>,
	<nvdimm@lists.linux.dev>
References: <20221125020825.37125-1-yuancan@huawei.com>
 <e74d9636-5886-07d6-e333-f447b3587a86@linux.ibm.com>
From: Yuan Can <yuancan@huawei.com>
In-Reply-To: <e74d9636-5886-07d6-e333-f447b3587a86@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.41]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected


在 2022/12/2 19:29, Shivaprasad G Bhat 写道:
> On 11/25/22 07:38, Yuan Can wrote:
>> As the devm_kcalloc may return NULL, the return value needs to be 
>> checked
>> to avoid NULL poineter dereference.
>
> s/poineter/pointer
>
> Patch looks good to me otherwise.
Thanks for the review!

-- 
Best regards,
Yuan Can

