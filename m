Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F0C92097174A
 for <linux-nvdimm@lists.01.org>; Mon, 28 May 2018 10:41:52 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id d5-v6so7899148oib.5
 for <linux-nvdimm@lists.01.org>; Mon, 28 May 2018 10:41:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1805280943460.16538@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180519052503.325953342@debian.vm>
 <20180519052635.567438191@debian.vm>
 <20180522063946.GB8054@infradead.org> <20180522184103.GA25826@redhat.com>
 <CAPcyv4g395RccdEPF=sCu5RdCH9zwD+GvOfSp7-F0Oh64CeDgA@mail.gmail.com>
 <20180522191942.GB25904@redhat.com>
 <CAPcyv4hWswV=VCfB7KatoW_zc-kUUju2jD45N-Gsg4sW-XFe-A@mail.gmail.com>
 <alpine.LRH.2.02.1805280943460.16538@file01.intranet.prod.int.rdu2.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 28 May 2018 10:41:51 -0700
Message-ID: <CAPcyv4gxCNqqG2G3R6f=kH3zNbByhgE2R-trJWurH49-p+51Gg@mail.gmail.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 28, 2018 at 6:52 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Tue, 22 May 2018, Dan Williams wrote:
>
>> >> Except I'm being responsive.
>> >
>> > Except you're looking to immediately punt to linux-arm-kernel ;)
>>
>> Well, I'm not, not really. I'm saying drop ARM support, it's not ready.
>
> This is the worst thing to do - because once late cache flushing is
> dropped from the dm-writecache target, it could hardly be reintroduced
> again.
>
>> >> I agree with Christoph that we should
>> >> build pmem helpers at an architecture level and not per-driver. Let's
>> >> make this driver depend on ARCH_HAS_PMEM_API and require ARM to catch
>> >> up to x86 in this space. We already have PowerPC enabling PMEM API, so
>> >> I don't see an unreasonable barrier to ask the same of ARM. This patch
>> >> is not even cc'd to linux-arm-kernel. Has the subject been broached
>> >> with them?
>> >
>> > No idea.  Not by me.
>> >
>> > The thing is, I'm no expert in pmem.  You are.  Coordinating the change
>> > with ARM et al feels unnecessarily limiting and quicky moves outside my
>> > control.
>> >
>> > Serious question: Why can't this code land in this dm-writecache target
>> > and then be lifted (or obsoleted)?
>>
>> Because we already have an API, and we don't want to promote local
>> solutions to global problems, or carry  unnecessary technical debt.
>>
>> >
>> > But if you think it worthwhile to force ARM to step up then fine.  That
>> > does limit the availability of using writecache on ARM while they get
>> > the PMEM API together.
>> >
>> > I'll do whatever you want.. just put the smack down and tell me how it
>> > is ;)
>>
>> I'd say just control the variables you can control. Drop the ARM
>> support if you want to move forward and propose extensions / updates
>
> What do we gain by dropping it?
>
>> to the pmem api for x86 and I'll help push those since I was involved
>> in pushing the x86 pmem api in the first instance. That way you don't
>> need to touch this driver as new archs add their pmem api enabling.
>
> The pmem API is x86-centric - that the problem.

When I read your patch I came away with the impression that ARM had
not added memcpy_flushcache() yet and you were working around that
fact. Now that I look, ARM *does* define memcpy_flushcache() and
you're avoiding it. You use memcpy+arch_wb_pmem where arch_wb_pmem on
ARM64 is defined as __clean_dcache_area_pop(dst, cnt). The ARM
memcpy_flushcache() implementation is:

    memcpy(dst, src, cnt);
    __clean_dcache_area_pop(dst, cnt);

So, I do not see how what you're doing is any less work unless you are
flushing less than you copy?

If memcpy_flushcache() is slower than memcpy + arch_wb_pmem then the
ARM implementation is broken and that needs to be addressed not worked
around in a driver.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
