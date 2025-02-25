Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12961267AE8
	for <nvdimm@lists.linux.dev>; Tue, 25 Feb 2025 09:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740474740; cv=none; b=KiYoyiDHpWY0DNphq9631V7md6orsGcKo5QwLUTY8YPs74FoD58TQs7e9kdVfkS1U0Aqcev5kpUZGZueciBazJUARLTxPdca/MaY1n7Fy1UNldYVLlCbwTewRMwO/r+oyp5LaA/07srbJuxaZSWmJcgJF4v4XZTv5zooLqIR8j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740474740; c=relaxed/simple;
	bh=jSfr0DnZJRt/ciNTHE0XDHV5JQ8wzrnyJ3cQBG5h2r0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AsPDeh+Dzia7NK8uLuJOsiBK7qaT1MQhIxI2i1edEduvL6hXOj6RakvP3hJ3BG5DGOzVPetw9EsRl00jvFR1xMIfBnnxwu+8Am0J3LYs0W9EJIaM/uDS4fxzGXTAoLNAM0u6W+43JDlpdlf2FEy4Ftb2upfakhkCqhsGuQl5eOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Z2BgX3gLcz4f3jrs
	for <nvdimm@lists.linux.dev>; Tue, 25 Feb 2025 17:11:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 4B69D1A13EC
	for <nvdimm@lists.linux.dev>; Tue, 25 Feb 2025 17:12:14 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP3 (Coremail) with SMTP id _Ch0CgAne8Vrib1nMy0hEw--.30895S3;
	Tue, 25 Feb 2025 17:12:14 +0800 (CST)
Message-ID: <b9fee454-54e0-d07f-44eb-74bfc588abeb@huaweicloud.com>
Date: Tue, 25 Feb 2025 17:12:11 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 05/12] badblocks: return error if any badblock set fails
To: Coly Li <colyli@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Coly Li <i@coly.li>, Zheng Qixing <zhengqixing@huaweicloud.com>,
 axboe@kernel.dk, song@kernel.org, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
 dlemoal@kernel.org, yanjun.zhu@linux.dev, kch@nvidia.com,
 Hannes Reinecke <hare@suse.de>, zhengqixing@huawei.com,
 john.g.garry@oracle.com, geliang@kernel.org, xni@redhat.com, colyli@suse.de,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-6-zhengqixing@huaweicloud.com>
 <4qo5qliidycbjmauq22tqgv6nbw2dus2xlhg2qvfss7nawdr27@arztxmrwdhzb>
 <272e37ea-886c-8a44-fd6b-96940a268906@huaweicloud.com>
 <70D2392E-4F75-43C6-8C34-498AACC78E0C@coly.li>
 <a3c74c7c-44b6-c4c0-872d-0de7e29214c0@huaweicloud.com>
 <vdd6yaz3opuhufbfhbkhwtfj4a3oiskem7o23n3axtzy5e74xp@fibgbwxospom>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <vdd6yaz3opuhufbfhbkhwtfj4a3oiskem7o23n3axtzy5e74xp@fibgbwxospom>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAne8Vrib1nMy0hEw--.30895S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUOo7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvE
	ncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I
	8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0E
	jII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbI
	xvr21l42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_GFv_Wryl4I8I3I0E4IkC
	6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWw
	C2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_
	JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJV
	WUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIY
	CTnIWIevJa73UjIFyTuYvjfUOyCJUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/2/22 14:16, Coly Li 写道:
> On Sat, Feb 22, 2025 at 09:12:53AM +0800, Yu Kuai wrote:
>> Hi,
>>
>> 在 2025/02/21 18:12, Coly Li 写道:
>>> So we don’t need to add a negative return value for partial success/failure?
>>>
>>> Coly Li.
>>
>> Yes, I think so. No one really use this value, and patch 10 clean this
>> up by changing return type to bool.
> 
> OK, then it is fine to me.
> 
> It will be good to add a code comment that parital setting will be treated as failure.
> 
> Thanks.
> 
> 

Thank you for your review. I will add comment in the next version.

-- 
Thanks,
Nan

