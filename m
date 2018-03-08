Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2DAB4209574F3
 for <linux-nvdimm@lists.01.org>; Thu,  8 Mar 2018 09:02:17 -0800 (PST)
Received: by mail-ot0-x243.google.com with SMTP id f11so6058454otj.12
 for <linux-nvdimm@lists.01.org>; Thu, 08 Mar 2018 09:08:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180308145153.GB23262@infradead.org>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
 <20180308145153.GB23262@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Mar 2018 09:08:32 -0800
Message-ID: <CAPcyv4gBUt5NYK2Lx0dMZAnENeSgKm3KaUvY9kkqB+PNPyQu4w@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH] dm-writecache
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Snitzer <msnitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 8, 2018 at 6:51 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> --- /dev/null 1970-01-01 00:00:00.000000000 +0000
>> +++ linux-2.6/drivers/md/dm-writecache.c      2018-03-08 14:23:31.059999000 +0100
>> @@ -0,0 +1,2417 @@
>> +#include <linux/device-mapper.h>
>
> missing copyright statement, or for those new-fashioned SPDX statement.
>
>> +#define WRITEBACK_FUA                        true
>
> no business having this around.
>
>> +#ifndef bio_set_dev
>> +#define      bio_set_dev(bio, dev)   ((bio)->bi_bdev = (dev))
>> +#endif
>> +#ifndef timer_setup
>> +#define timer_setup(t, c, f) setup_timer(t, c, (unsigned long)(t))
>> +#endif
>
> no business in mainline.
>
>> +/*
>> + * On X86, non-temporal stores are more efficient than cache flushing.
>> + * On ARM64, cache flushing is more efficient.
>> + */
>> +#if defined(CONFIG_X86_64)
>> +#define NT_STORE(dest, src)                          \
>> +do {                                                 \
>> +     typeof(src) val = (src);                        \
>> +     memcpy_flushcache(&(dest), &val, sizeof(src));  \
>> +} while (0)
>> +#define COMMIT_FLUSHED()     wmb()
>> +#else
>> +#define NT_STORE(dest, src)  WRITE_ONCE(dest, src)
>> +#define FLUSH_RANGE          dax_flush
>> +#define COMMIT_FLUSHED()     do { } while (0)
>> +#endif
>
> Please use proper APIs for this, this has no business in a driver.

I had the same feedback, and Mikulas sent this useful enhancement to
the memcpy_flushcache API:

    https://patchwork.kernel.org/patch/10217655/

...it's in my queue to either push through -tip or add it to the next
libnvdimm pull request for 4.17-rc1.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
