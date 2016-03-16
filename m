Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
 [67.231.153.30])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 82D071A1E05
 for <linux-nvdimm@lists.01.org>; Tue, 15 Mar 2016 17:20:42 -0700 (PDT)
Subject: Re: [PATCH 0/4] Remove un-needed 'major' registration when
 alloc_disk(0) is used.
References: <20160309215702.20904.61407.stgit@noble>
 <20160314225017.GC19926@linux.intel.com>
 <878u1jgzgi.fsf@notabene.neil.brown.name>
From: Jens Axboe <axboe@fb.com>
Message-ID: <56E8A6BF.7060304@fb.com>
Date: Tue, 15 Mar 2016 17:20:15 -0700
MIME-Version: 1.0
In-Reply-To: <878u1jgzgi.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: NeilBrown <neilb@suse.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 03/15/2016 03:15 PM, NeilBrown wrote:
> On Tue, Mar 15 2016, Ross Zwisler wrote:
>
>> On Thu, Mar 10, 2016 at 08:59:28AM +1100, NeilBrown wrote:
>>> When alloc_disk(0) is used, the ->major number is ignored and
>>> irrelevant.  Yet several drivers register a major number anyway.
>>>
>>> This series of patches removes the pointless registrations.  The pmem
>>> driver also does this, but a patch has already been sent for that
>>> driver.
>>>
>>> Note that I am not in a position to test these beyond simple compile
>>> testing.
>>>
>>> Thanks,
>>> NeilBrown
>>>
>>>
>>> ---
>>>
>>> NeilBrown (4):
>>>        nvdimm/blk: don't allocate unused major device number
>>>        nvdimm/btt: don't allocate unused major device number
>>>        memstick: don't allocate unused major for ms_block
>>>        NVMe: don't allocate unused nvme_major
>>>
>>>
>>>   drivers/memstick/core/ms_block.c |   17 ++---------------
>>>   drivers/nvdimm/blk.c             |   18 +-----------------
>>>   drivers/nvdimm/btt.c             |   19 ++-----------------
>>>   drivers/nvme/host/core.c         |   16 +---------------
>>>   4 files changed, 6 insertions(+), 64 deletions(-)
>>
>> There are several other drivers that allocate a major, but then use it for
>> some small number of minors (1 for null_blk.c and 16 for virtio_blk.c).  They
>> both have GENHD_FL_EXT_DEVT set, so I think what happens is that after we
>> exhaust the allocated minors they hop over to having BLOCK_EXT_MAJOR as a
>> major and a dynamically assigned minor.
>
> null_blk looks like it would be safe to convert - it is just used for
> testing.  Jens Axboe would probably know for sure.
>
> virtio_blk is a much older and there may will be code which has some
> sort of expectations about minor numbers.  I think it would not be worth
> the risks to change it.

Agree on both - null_blk can be trivially converted, and I too would be 
worried about virt_blkio changes breaking existing assumptions.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
