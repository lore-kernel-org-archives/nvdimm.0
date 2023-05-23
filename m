Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3405383
	for <nvdimm@lists.linux.dev>; Tue, 23 May 2023 02:55:44 +0000 (UTC)
Received: from mail02.huawei.com (unknown [172.30.67.153])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QQJR56nXZz4f3khx
	for <nvdimm@lists.linux.dev>; Tue, 23 May 2023 10:38:41 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgAHvbAyJ2xk9nwPKA--.33442S3;
	Tue, 23 May 2023 10:38:43 +0800 (CST)
Message-ID: <daca108d-4dd3-ecbf-c630-69d4bc2b96c0@huaweicloud.com>
Date: Tue, 23 May 2023 10:38:41 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 0/7] badblocks improvement for multiple bad block
 ranges
To: Coly Li <colyli@suse.de>, linux-block@vger.kernel.org
Cc: nvdimm@lists.linux.dev, linux-raid@vger.kernel.org,
 Dan Williams <dan.j.williams@intel.com>, Geliang Tang
 <geliang.tang@suse.com>, Hannes Reinecke <hare@suse.de>,
 Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
 Richard Fan <richard.fan@suse.com>, Vishal L Verma
 <vishal.l.verma@intel.com>, Wols Lists <antlists@youngman.org.uk>,
 Xiao Ni <xni@redhat.com>
References: <20220721121152.4180-1-colyli@suse.de>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20220721121152.4180-1-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAHvbAyJ2xk9nwPKA--.33442S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYB7kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY
	6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr
	0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxG
	rwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFfHjUUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/
X-CFilter-Loop: Reflected

Hi Coly Li,

Recently, I have been trying to fix the bug of backblocks settings, and 
I found that your patch series has already fixed the bug. This patch 
series has not been applied to mainline at present, may I ask if you 
still plan to continue working on it?

-- 
Thanks,
Nan

