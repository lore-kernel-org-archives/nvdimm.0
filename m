Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553E41115
	for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 06:55:39 +0000 (UTC)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KcK2m4hqvzdZjT;
	Mon, 11 Apr 2022 14:39:28 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2375.24; Mon, 11 Apr 2022 14:40:01 +0800
Message-ID: <ad34d938-6131-d48f-b14b-6c1e3280b3f7@huawei.com>
Date: Mon, 11 Apr 2022 14:40:00 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v12 5/7] mm: Introduce mf_dax_kill_procs() for fsdax case
Content-Language: en-US
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, <linux-kernel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <david@fromorbit.com>,
	<hch@infradead.org>, <jane.chu@oracle.com>, Christoph Hellwig <hch@lst.de>
References: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com>
 <20220410160904.3758789-6-ruansy.fnst@fujitsu.com>
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
In-Reply-To: <20220410160904.3758789-6-ruansy.fnst@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.234.194]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected

 >> This new function is a variant of mf_generic_kill_procs that accepts a
 >> file, offset pair instead o a struct to support multiple files sharing a
typo, instead of
