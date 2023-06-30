Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B601136D
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 02:40:50 +0000 (UTC)
Received: from mail02.huawei.com (unknown [172.30.67.143])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QsfL41XL4z4f3v78
	for <nvdimm@lists.linux.dev>; Fri, 30 Jun 2023 10:25:16 +0800 (CST)
Received: from [10.174.176.117] (unknown [10.174.176.117])
	by APP1 (Coremail) with SMTP id cCh0CgDHLCcJPZ5k4ZicMA--.28386S2;
	Fri, 30 Jun 2023 10:25:17 +0800 (CST)
Subject: Re: [PATCH v2] virtio_pmem: add the missing REQ_OP_WRITE for flush
 bio
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
 nvdimm@lists.linux.dev, virtualization@lists.linux-foundation.org,
 houtao1@huawei.com
References: <ZJLpYMC8FgtZ0k2k@infradead.org>
 <20230621134340.878461-1-houtao@huaweicloud.com>
 <CAM9Jb+j8-DWdRMsXJNiHm_UK5Nx6L2=a2PnRL=m3sMyQz4cXLw@mail.gmail.com>
From: Hou Tao <houtao@huaweicloud.com>
Message-ID: <d484a89f-8aaf-c0ae-5c12-f9a87b62384c@huaweicloud.com>
Date: Fri, 30 Jun 2023 10:25:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAM9Jb+j8-DWdRMsXJNiHm_UK5Nx6L2=a2PnRL=m3sMyQz4cXLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID:cCh0CgDHLCcJPZ5k4ZicMA--.28386S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WrW7KryUJw4rGrW8Aw43KFg_yoW8WF1rpr
	sxtayayrZrJFZ8u3WxXa18GryFgwn7WrZ7GrWrX3y8Kry2yF1DGrn5WFy0q397Ary8GFW2
	qFW0qw1YvrWDZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected

Hi Pankaj,

On 6/22/2023 4:35 PM, Pankaj Gupta wrote:
>> The following warning was reported when doing fsync on a pmem device:
>>
>>  ------------[ cut here ]------------
>>  WARNING: CPU: 2 PID: 384 at block/blk-core.c:751 submit_bio_noacct+0x340/0x520
SNIP
>> Hi Jens & Dan,
>>
>> I found Pankaj was working on the fix and optimization of virtio-pmem
>> flush bio [0], but considering the last status update was 1/12/2022, so
>> could you please pick the patch up for v6.4 and we can do the flush fix
>> and optimization later ?
>>
>> [0]: https://lore.kernel.org/lkml/20220111161937.56272-1-pankaj.gupta.linux@gmail.com/T/
>>
>>  drivers/nvdimm/nd_virtio.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
>> index c6a648fd8744..97098099f8a3 100644
>> --- a/drivers/nvdimm/nd_virtio.c
>> +++ b/drivers/nvdimm/nd_virtio.c
>> @@ -105,7 +105,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
>>          * parent bio. Otherwise directly call nd_region flush.
>>          */
>>         if (bio && bio->bi_iter.bi_sector != -1) {
>> -               struct bio *child = bio_alloc(bio->bi_bdev, 0, REQ_PREFLUSH,
>> +               struct bio *child = bio_alloc(bio->bi_bdev, 0, REQ_OP_WRITE | REQ_PREFLUSH,
>>                                               GFP_ATOMIC);
>>
>>                 if (!child)
> Fix looks good to me. Will give a run soon.
>
> Yes, [0] needs to be completed. Curious to know if you guys using
> virtio-pmem device?
Sorry about missing the question. We are plan to use DAX to do page
cache offload and now we are just do experiment with virtio-pmem and
nd-pmem.

> Thanks,
> Pankaj

