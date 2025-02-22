Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFA915853B
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 01:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740186780; cv=none; b=XsFeaHHahmCgBJ/ztBkI1kD2MnFcmOR8bS9H5TETesgDxd9hY167BnQebZ8I1CZ0D/weQTZjm4sKo1BdbciXuNf+D1woYkxgtE8CL6bjtXA7zz+HDjTVUpCBj8uVmtM6ueBjep0yxlbl9OPBuw3CKGpzw3BGltSTxJKJGnAf18E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740186780; c=relaxed/simple;
	bh=O6DZi57Va/gDUy3dLLvOK2ckmPoBCLLeuimpP9n8whU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=D8cQ4h+/ei59gNDYJBCQseBtB54on3dSV3B+yq7JlnaiSadQolClS6HWa9qjgool+p4u+VMnTVzBjR8aFmp6k/+z+CC1fcBk3TfAfTMWf3oNdOhyPkosnppeXJKb3OQVz9F5VpHr68iHRahK8cyPDqQWP8/2s1YCrkPjy5e2U/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z089y4vqFz4f3jt4
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:12:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 12D331A1676
	for <nvdimm@lists.linux.dev>; Sat, 22 Feb 2025 09:12:55 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB321+VJLlnFggiEg--.19789S3;
	Sat, 22 Feb 2025 09:12:54 +0800 (CST)
Subject: Re: [PATCH 05/12] badblocks: return error if any badblock set fails
To: Coly Li <i@coly.li>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, colyli@kernel.org, dan.j.williams@intel.com,
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a3c74c7c-44b6-c4c0-872d-0de7e29214c0@huaweicloud.com>
Date: Sat, 22 Feb 2025 09:12:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <70D2392E-4F75-43C6-8C34-498AACC78E0C@coly.li>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB321+VJLlnFggiEg--.19789S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYK7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
	1l4c8EcI0Ec7CjxVAaw2AFwI0_GFv_Wryl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6r
	W5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU
	FfHUDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/02/21 18:12, Coly Li 写道:
> So we don’t need to add a negative return value for partial success/failure?
> 
> Coly Li.

Yes, I think so. No one really use this value, and patch 10 clean this
up by changing return type to bool.

Thanks,
Kuai

