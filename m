Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 72444209603E1
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 12:00:20 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id a6-v6so17200791oia.2
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 12:00:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180522184103.GA25826@redhat.com>
References: <20180519052503.325953342@debian.vm>
 <20180519052635.567438191@debian.vm>
 <20180522063946.GB8054@infradead.org> <20180522184103.GA25826@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 May 2018 12:00:18 -0700
Message-ID: <CAPcyv4g395RccdEPF=sCu5RdCH9zwD+GvOfSp7-F0Oh64CeDgA@mail.gmail.com>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 22, 2018 at 11:41 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Tue, May 22 2018 at  2:39am -0400,
> Christoph Hellwig <hch@infradead.org> wrote:
>
>> On Sat, May 19, 2018 at 07:25:07AM +0200, Mikulas Patocka wrote:
>> > Use new API for flushing persistent memory.
>>
>> The sentence doesnt make much sense.  'A new API', 'A better
>> abstraction' maybe?
>>
>> >
>> > The problem is this:
>> > * on X86-64, non-temporal stores have the best performance
>> > * ARM64 doesn't have non-temporal stores, so we must flush cache. We
>> >   should flush cache as late as possible, because it performs better this
>> >   way.
>> >
>> > We introduce functions pmem_memcpy, pmem_flush and pmem_commit. To commit
>> > data persistently, all three functions must be called.
>> >
>> > The macro pmem_assign may be used instead of pmem_memcpy. pmem_assign
>> > (unlike pmem_memcpy) guarantees that 8-byte values are written atomically.
>> >
>> > On X86, pmem_memcpy is memcpy_flushcache, pmem_flush is empty and
>> > pmem_commit is wmb.
>> >
>> > On ARM64, pmem_memcpy is memcpy, pmem_flush is arch_wb_cache_pmem and
>> > pmem_commit is empty.
>>
>> All these should be provided by the pmem layer, and be properly
>> documented.  And be sorted before adding your new target that uses
>> them.
>
> I don't see that as a hard requirement.  Mikulas did the work to figure
> out what is more optimal on x86_64 vs amd64.  It makes a difference for
> his target and that is sufficient to carry it locally until/when it is
> either elevated to pmem.
>
> We cannot even get x86 and swait maintainers to reply to repeat requests
> for review.  Stacking up further deps on pmem isn't high on my list.
>

Except I'm being responsive. I agree with Christoph that we should
build pmem helpers at an architecture level and not per-driver. Let's
make this driver depend on ARCH_HAS_PMEM_API and require ARM to catch
up to x86 in this space. We already have PowerPC enabling PMEM API, so
I don't see an unreasonable barrier to ask the same of ARM. This patch
is not even cc'd to linux-arm-kernel. Has the subject been broached
with them?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
