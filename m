Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk0-x234.google.com (mail-vk0-x234.google.com
 [IPv6:2607:f8b0:400c:c05::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6160D21D2DD18
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 11:22:38 -0700 (PDT)
Received: by mail-vk0-x234.google.com with SMTP id x10so8945926vkd.0
 for <linux-nvdimm@lists.01.org>; Fri, 04 Aug 2017 11:24:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170804182109.GA16128@linux.intel.com>
References: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
 <20170728173143.GE15980@bombadil.infradead.org>
 <20170802221359.GA20666@linux.intel.com>
 <20170803001315.GF32020@bbox> <20170803211335.GA1260@linux.intel.com>
 <20170804035441.GA305@bbox> <20170804081740.GA2083@bbox>
 <CAPcyv4hhO6RFUB9VKMvc2gVSG0AdeMaB8mE7-MCcSU7377Kyag@mail.gmail.com>
 <20170804182109.GA16128@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 4 Aug 2017 11:24:49 -0700
Message-ID: <CAPcyv4hsicQybj1091n1n9aKDtQ1JB2fEhjK+_21mi4ta5S46Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] remove rw_page() from brd, pmem and btt
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
Cc: Jens Axboe <axboe@kernel.dk>, Jerome Marchand <jmarchan@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@kernel.org>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "karam . lee" <karam.lee@lge.com>, seungho1.park@lge.com, Nitin Gupta <ngupta@vflare.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 4, 2017 at 11:21 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, Aug 04, 2017 at 11:01:08AM -0700, Dan Williams wrote:
>> [ adding Dave who is working on a blk-mq + dma offload version of the
>> pmem driver ]
>>
>> On Fri, Aug 4, 2017 at 1:17 AM, Minchan Kim <minchan@kernel.org> wrote:
>> > On Fri, Aug 04, 2017 at 12:54:41PM +0900, Minchan Kim wrote:
>> [..]
>> >> Thanks for the testing. Your testing number is within noise level?
>> >>
>> >> I cannot understand why PMEM doesn't have enough gain while BTT is significant
>> >> win(8%). I guess no rw_page with BTT testing had more chances to wait bio dynamic
>> >> allocation and mine and rw_page testing reduced it significantly. However,
>> >> in no rw_page with pmem, there wasn't many cases to wait bio allocations due
>> >> to the device is so fast so the number comes from purely the number of
>> >> instructions has done. At a quick glance of bio init/submit, it's not trivial
>> >> so indeed, i understand where the 12% enhancement comes from but I'm not sure
>> >> it's really big difference in real practice at the cost of maintaince burden.
>> >
>> > I tested pmbench 10 times in my local machine(4 core) with zram-swap.
>> > In my machine, even, on-stack bio is faster than rw_page. Unbelievable.
>> >
>> > I guess it's really hard to get stable result in severe memory pressure.
>> > It would be a result within noise level(see below stddev).
>> > So, I think it's hard to conclude rw_page is far faster than onstack-bio.
>> >
>> > rw_page
>> > avg     5.54us
>> > stddev  8.89%
>> > max     6.02us
>> > min     4.20us
>> >
>> > onstack bio
>> > avg     5.27us
>> > stddev  13.03%
>> > max     5.96us
>> > min     3.55us
>>
>> The maintenance burden of having alternative submission paths is
>> significant especially as we consider the pmem driver ising more
>> services of the core block layer. Ideally, I'd want to complete the
>> rw_page removal work before we look at the blk-mq + dma offload
>> reworks.
>>
>> The change to introduce BDI_CAP_SYNC is interesting because we might
>> have use for switching between dma offload and cpu copy based on
>> whether the I/O is synchronous or otherwise hinted to be a low latency
>> request. Right now the dma offload patches are using "bio_segments() >
>> 1" as the gate for selecting offload vs cpu copy which seem
>> inadequate.
>
> Okay, so based on the feedback above and from Jens[1], it sounds like we want
> to go forward with removing the rw_page() interface, and instead optimize the
> regular I/O path via on-stack BIOS and dma offload, correct?
>
> If so, I'll prepare patches that fully remove the rw_page() code, and let
> Minchan and Dave work on their optimizations.

I think the conversion to on-stack-bio should be done in the same
patchset that removes rw_page. We don't want to leave a known
performance regression while the on-stack-bio work is in-flight.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
