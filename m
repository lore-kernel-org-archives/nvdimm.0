Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4801205AD5
	for <nvdimm@lists.linux.dev>; Tue, 25 Feb 2025 09:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740474814; cv=none; b=LX4pZLyBgoJlZ6XP71FtSm/RgB+ukEI56bGUuVpSNaQO28/c9OT8e/ZDocbxPKQk2AczHesRMH/L0kRrxWogVvgR/dfv2mHu2pYgUT8zUythiSBkZXADUiYcFuof5BJehRIRZAnno1mYTZawBM/tNTFgOWR7D3eLehYE5iMfKhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740474814; c=relaxed/simple;
	bh=GEN46+vS928u7YiMujMeznp6z00+C6lrAtllorFuIX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V2kl/NQdpNNJqy3Yr6f19Ob2OlkEIVx8t4o6unNpXiOmD1eWAuxgrVGo68bMCk6ws7k9XAqTV2uBdHdKj+KoXsqyhZDdpv1puI1moSw47ES/fs0y7v2NXRnqG3jScAofqtVkEBSqZv+kNHfAW3V3igT60EZJMBvtJruuPy80oH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z2Bj341rNz4f3jt8
	for <nvdimm@lists.linux.dev>; Tue, 25 Feb 2025 17:13:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 09F231A1517
	for <nvdimm@lists.linux.dev>; Tue, 25 Feb 2025 17:13:28 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP3 (Coremail) with SMTP id _Ch0CgA3icO2ib1nAkMhEw--.60201S3;
	Tue, 25 Feb 2025 17:13:27 +0800 (CST)
Message-ID: <366d8fee-e39e-bb01-db91-ecf359591ea5@huaweicloud.com>
Date: Tue, 25 Feb 2025 17:13:26 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 04/12] badblocks: return error directly when setting
 badblocks exceeds 512
To: Yu Kuai <yukuai1@huaweicloud.com>,
 Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk,
 song@kernel.org, colyli@kernel.org, dan.j.williams@intel.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
 dlemoal@kernel.org, yanjun.zhu@linux.dev, kch@nvidia.com, hare@suse.de,
 zhengqixing@huawei.com, john.g.garry@oracle.com, geliang@kernel.org,
 xni@redhat.com, colyli@suse.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-5-zhengqixing@huaweicloud.com>
 <bec8776a-f0d4-2ec3-4455-9976ad87775e@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <bec8776a-f0d4-2ec3-4455-9976ad87775e@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgA3icO2ib1nAkMhEw--.60201S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUOr7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvE
	ncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I
	8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0E
	jII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbI
	xvr21l42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_GFv_Wryl4I8I3I0E4IkC
	6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWw
	C2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_
	JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr
	0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
	cSsGvfC2KfnxnUUI43ZEXa7VU1YiiDUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/2/21 17:55, Yu Kuai 写道:
> Hi,
> 
> +CC Linan
> 
> 在 2025/02/21 16:11, Zheng Qixing 写道:
>> From: Li Nan <linan122@huawei.com>
>>
>> In the current handling of badblocks settings, a lot of processing has
>> been done for scenarios where the number of badblocks exceeds 512.
>> This makes the code look quite complex and also introduces some issues,
> 
> It's better to add explanations about these issues here.
>>

Thank you for your review. I will add more details in the next version.

-- 
Thanks,
Nan

