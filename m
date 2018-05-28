Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 947AC202E61AA
 for <linux-nvdimm@lists.01.org>; Mon, 28 May 2018 06:53:04 -0700 (PDT)
Date: Mon, 28 May 2018 09:52:59 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
In-Reply-To: <CAPcyv4hWswV=VCfB7KatoW_zc-kUUju2jD45N-Gsg4sW-XFe-A@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1805280943460.16538@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180519052503.325953342@debian.vm>
 <20180519052635.567438191@debian.vm> <20180522063946.GB8054@infradead.org>
 <20180522184103.GA25826@redhat.com>
 <CAPcyv4g395RccdEPF=sCu5RdCH9zwD+GvOfSp7-F0Oh64CeDgA@mail.gmail.com>
 <20180522191942.GB25904@redhat.com>
 <CAPcyv4hWswV=VCfB7KatoW_zc-kUUju2jD45N-Gsg4sW-XFe-A@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On Tue, 22 May 2018, Dan Williams wrote:

> >> Except I'm being responsive.
> >
> > Except you're looking to immediately punt to linux-arm-kernel ;)
> 
> Well, I'm not, not really. I'm saying drop ARM support, it's not ready.

This is the worst thing to do - because once late cache flushing is 
dropped from the dm-writecache target, it could hardly be reintroduced 
again.

> >> I agree with Christoph that we should
> >> build pmem helpers at an architecture level and not per-driver. Let's
> >> make this driver depend on ARCH_HAS_PMEM_API and require ARM to catch
> >> up to x86 in this space. We already have PowerPC enabling PMEM API, so
> >> I don't see an unreasonable barrier to ask the same of ARM. This patch
> >> is not even cc'd to linux-arm-kernel. Has the subject been broached
> >> with them?
> >
> > No idea.  Not by me.
> >
> > The thing is, I'm no expert in pmem.  You are.  Coordinating the change
> > with ARM et al feels unnecessarily limiting and quicky moves outside my
> > control.
> >
> > Serious question: Why can't this code land in this dm-writecache target
> > and then be lifted (or obsoleted)?
> 
> Because we already have an API, and we don't want to promote local
> solutions to global problems, or carry  unnecessary technical debt.
> 
> >
> > But if you think it worthwhile to force ARM to step up then fine.  That
> > does limit the availability of using writecache on ARM while they get
> > the PMEM API together.
> >
> > I'll do whatever you want.. just put the smack down and tell me how it
> > is ;)
> 
> I'd say just control the variables you can control. Drop the ARM
> support if you want to move forward and propose extensions / updates

What do we gain by dropping it?

> to the pmem api for x86 and I'll help push those since I was involved
> in pushing the x86 pmem api in the first instance. That way you don't
> need to touch this driver as new archs add their pmem api enabling.

The pmem API is x86-centric - that the problem.

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
