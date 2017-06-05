Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DFA821945DC1
 for <linux-nvdimm@lists.01.org>; Sun,  4 Jun 2017 17:59:39 -0700 (PDT)
From: "Huang\, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH -mm 05/13] block,
 THP: Make block_device_operations.rw_page support THP
References: <20170525064635.2832-1-ying.huang@intel.com>
 <20170525064635.2832-6-ying.huang@intel.com>
 <20170602055759.GC5909@linux.intel.com>
Date: Mon, 05 Jun 2017 09:00:42 +0800
In-Reply-To: <20170602055759.GC5909@linux.intel.com> (Ross Zwisler's message
 of "Thu, 1 Jun 2017 23:57:59 -0600")
Message-ID: <87a85n1c5h.fsf@yhuang-dev.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Ross Zwisler <ross.zwisler@intel.com>, linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>, "Huang," Ying" <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>," linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Ross Zwisler <ross.zwisler@linux.intel.com> writes:

> On Thu, May 25, 2017 at 02:46:27PM +0800, Huang, Ying wrote:
>> From: Huang Ying <ying.huang@intel.com>
>> 
>> The .rw_page in struct block_device_operations is used by the swap
>> subsystem to read/write the page contents from/into the corresponding
>> swap slot in the swap device.  To support the THP (Transparent Huge
>> Page) swap optimization, the .rw_page is enhanced to support to
>> read/write THP if possible.
>> 
>> Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Ross Zwisler <ross.zwisler@intel.com>
>> Cc: Vishal L Verma <vishal.l.verma@intel.com>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: linux-nvdimm@lists.01.org
>> ---
>>  drivers/block/brd.c           |  6 +++++-
>>  drivers/block/zram/zram_drv.c |  2 ++
>>  drivers/nvdimm/btt.c          |  4 +++-
>>  drivers/nvdimm/pmem.c         | 42 +++++++++++++++++++++++++++++++-----------
>>  4 files changed, 41 insertions(+), 13 deletions(-)
>
> The changes in brd.c, zram_drv.c and pmem.c look good to me.  For those bits
> you can add: 
>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks!

> I think we still want Vishal to make sure that the BTT changes are okay.  I
> don't know that code well enough to know whether it's safe to throw 512 pages
> at btt_[read|write]_pg().
>
> Also, Ying, next time can you please CC me (and probably the linux-nvdimm
> list) on the whole series?  It would give us more context on what the larger
> change is, allow us to see the cover letter, allow us to test with all the
> patches in the series, etc.  It's pretty easy for reviewers to skip over the
> patches we don't care about or aren't in our area.

Sure.

Best Regards,
Huang, Ying

> Thanks,
> - Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
