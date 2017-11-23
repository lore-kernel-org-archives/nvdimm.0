Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22a.google.com (mail-it0-x22a.google.com
 [IPv6:2607:f8b0:4001:c0b::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 76782220C1C36
 for <linux-nvdimm@lists.01.org>; Thu, 23 Nov 2017 08:25:11 -0800 (PST)
Received: by mail-it0-x22a.google.com with SMTP id x28so10656111ita.0
 for <linux-nvdimm@lists.01.org>; Thu, 23 Nov 2017 08:29:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171123082946.GB17859@infradead.org>
References: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
 <20171123082946.GB17859@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 23 Nov 2017 08:29:27 -0800
Message-ID: <CAA9_cmcBk8AMU=dc3A2fv2oS7Drk_a1iBQAxJRDrqLV0k=rLWg@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH 2/2] dm-writecache
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
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 23, 2017 at 12:29 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> +/*
>> + * The clflushopt instruction is very slow on Broadwell, so we use non-temporal
>> + * stores instead.
>> + */
>> +#ifdef CONFIG_X86_64
>> +#define NT_STORE(dest, src)  asm ("movnti %1, %0" : "=m"(dest) : "r"(src))
>> +#define FLUSH_RANGE(dax, ptr, size)  do { } while (0)
>> +#define COMMIT_FLUSHED()     wmb()
>> +#else
>> +#define NT_STORE(dest, src)  ACCESS_ONCE(dest) = (src)
>> +#define FLUSH_RANGE          dax_flush
>> +#define COMMIT_FLUSHED()     do { } while (0)
>> +#endif
>
> Please go through the proper pmem APIs.

Yes, see _copy_from_iter_flushcache() and all its related apis.
Drivers shouldn't be doing anything different than what fs/dax.c is
using.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
