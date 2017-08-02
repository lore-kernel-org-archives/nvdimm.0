Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB69E21DF37D2
 for <linux-nvdimm@lists.01.org>; Wed,  2 Aug 2017 03:52:16 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id s21so5245118oie.5
 for <linux-nvdimm@lists.01.org>; Wed, 02 Aug 2017 03:54:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170801222347.GF20061@linux.intel.com>
References: <20170801114926.1171418-1-arnd@arndb.de>
 <20170801144534.2a1e1def29e68eb6c83e203c@linux-foundation.org>
 <20170801222347.GF20061@linux.intel.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 2 Aug 2017 12:54:25 +0200
Message-ID: <CAK8P3a0rq27jEt-XU1o7O=jNdiR7N+-i91JEsWacomDJhXZDEQ@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: avoid bogus -Wmaybe-uninitialized warning
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
Cc: linux-nvdimm@lists.01.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 2, 2017 at 12:23 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Tue, Aug 01, 2017 at 02:45:34PM -0700, Andrew Morton wrote:
>> On Tue,  1 Aug 2017 13:48:48 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>> > --- a/drivers/nvdimm/nd.h
>> > +++ b/drivers/nvdimm/nd.h
>> > @@ -392,8 +392,10 @@ static inline bool nd_iostat_start(struct bio *bio, unsigned long *start)
>> >  {
>> >     struct gendisk *disk = bio->bi_bdev->bd_disk;
>> >
>> > -   if (!blk_queue_io_stat(disk->queue))
>> > +   if (!blk_queue_io_stat(disk->queue)) {
>> > +           *start = 0;
>> >             return false;
>> > +   }
>> >
>> >     *start = jiffies;
>> >     generic_start_io_acct(bio_data_dir(bio),
>>
>> Well that's sad.
>>
>> The future of btt-remove-btt_rw_page.patch and friends is shrouded in
>> mystery, but if we proceed that way then yes, I guess we'll need to
>> work around such gcc glitches.
>>
>> But let's not leave apparently-unneeded code in place without telling
>> people why it is in fact needed?
>
> Maybe it's just cleaner to initialize 'start' in all the callers, so we don't
> have a mysterious line and have to remember why it's there / comment it?

I considered that but decided that would be worse, since it shuts up more
potential warnings about actual uninitialized use of the variable, and is
slightly harder for the compiler to optimize away. You also end up having
to add a comment in multiple places. Note that Andrew already added
a comment when he applied my patch to his mmotm tree.

     Arnd
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
