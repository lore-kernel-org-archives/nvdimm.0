Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9231F207E5408
 for <linux-nvdimm@lists.01.org>; Thu, 17 May 2018 13:03:49 -0700 (PDT)
Received: by mail-ot0-x244.google.com with SMTP id t1-v6so6475944oth.8
 for <linux-nvdimm@lists.01.org>; Thu, 17 May 2018 13:03:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180517195656.GH26718@bombadil.infradead.org>
References: <20180517183711.GE26718@bombadil.infradead.org>
 <CAPcyv4jXaEMW-41yU8eu11-g53apPUX3hg70aQCuwot6kyApUw@mail.gmail.com>
 <20180517195656.GH26718@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 17 May 2018 13:03:48 -0700
Message-ID: <CAPcyv4jkXiNMSqxhAshhS-+cXFnVJFkVAixrjc4Hjn7xOhgMyw@mail.gmail.com>
Subject: Re: [PATCH] dax: Fix use of zero page
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
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 17, 2018 at 12:56 PM, Matthew Wilcox <willy@infradead.org> wrote:
> On Thu, May 17, 2018 at 12:32:07PM -0700, Dan Williams wrote:
>> On Thu, May 17, 2018 at 11:37 AM, Matthew Wilcox <willy@infradead.org> wrote:
>> >
>> > I plucked this patch from my XArray work.  It seems self-contained enough
>> > that it could go into the DAX tree for merging this cycle.
>> >
>> > From 8cb56f4ba36af38814ca7b8ba030a66384e59a21 Mon Sep 17 00:00:00 2001
>> > From: Matthew Wilcox <mawilcox@microsoft.com>
>> > Date: Thu, 29 Mar 2018 22:41:18 -0400
>> > Subject: [PATCH] dax: Fix use of zero page
>> >
>> > Use my_zero_pfn instead of ZERO_PAGE, and pass the vaddr to it so it
>> > works on MIPS and s390.
>> >
>> > Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
>>
>> I'm being thick and / or lazy, what's the user visible effect of this fix?
>
> For s390 it appears to be a performance issue:
>
> Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Date:   Mon Oct 25 16:10:07 2010 +0200
>
>     [S390] zero page cache synonyms
>
>     If the zero page is mapped to virtual user space addresses that differ
>     only in bit 2^12 or 2^13 we get L1 cache synonyms which can affect
>     performance. Follow the mips model and use multiple zero pages to avoid
>     the synonyms.
>
> MIPS' use of multiple ZERO_PAGEs predates git history.  Given the
> history of MIPS' caches behaving in incredibly weird ways, I'd assume
> that getting this wrong results in miniature black holes forming and/or
> the CPU calculating the largest prime number.

Unless I am missing something I think this sounds like 4.18-rc1
material with a cc: stable. Last I heard no one is really using
dccssblk + dax, and MIPS has no way to describe pmem outside of
memmap= which is only a development tool.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
