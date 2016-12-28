Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F017817BB
 for <linux-nvdimm@lists.01.org>; Wed, 28 Dec 2016 15:43:29 -0800 (PST)
Date: Wed, 28 Dec 2016 23:43:22 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v2 1/3] introduce memcpy_nocache()
Message-ID: <20161228234321.GA27417@ZenIV.linux.org.uk>
References: <20161026155021.20892-1-brian.boylston@hpe.com>
 <20161026155021.20892-2-brian.boylston@hpe.com>
 <58110959.90901@plexistor.com>
 <CS1PR84MB011975E5DCF3B091E53A3FB38EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <5818A5C8.6040300@plexistor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5818A5C8.6040300@plexistor.com>
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
To: Boaz Harrosh <boaz@plexistor.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Moreno," Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org, " <x86@kernel.org>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "boylston@burromesa.net" <boylston@burromesa.net>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 01, 2016 at 04:25:12PM +0200, Boaz Harrosh wrote:

> >> What about memcpy_to_pmem() in linux/pmem.h it already has all the arch switches.
> >>
> >> Feels bad to add yet just another arch switch over __copy_user_nocache
> >>
> >> Just feels like too many things that do the same thing. Sigh
> > 
> > I agree that this looks like a nicer path.
> > 
> > I had considered adjusting copy_from_iter_nocache() to use memcpy_to_pmem(),
> > but lib/iov_iter.c doesn't currently #include linux/pmem.h.  Would it be
> > acceptable to add it?  Also, I wasn't sure if memcpy_to_pmem() would always
> > mean exactly "memcpy nocache".
> > 
> 
> I think this is the way to go. In my opinion there is no reason why not to include
> pmem.h into lib/iov_iter.c.
> 
> And I think memcpy_to_pmem() would always be the fastest arch way to bypass cache
> so it should be safe to use this for all cases. It is so in the arches that support
> this now, and I cannot imagine a theoretical arch that would differ. But let the
> specific arch people holler if this steps on their tows, later when they care about
> this at all.
 
First of all, if it's the fastest arch way to bypass cache, why the hell
is it sitting in pmem-related areas?

More to the point, x86 implementation of that thing is tied to uaccess API
for no damn reason whatsoever.  Let's add a real memcpy_nocache() and
be done with that.  I mean, this
        if (WARN(rem, "%s: fault copying %p <- %p unwritten: %d\n",
                                __func__, dst, src, rem))
                BUG();
is *screaming* "API misused here".  And let's stay away from the STAC et.al. -
it's pointless for kernel-to-kernel copies.

BTW, your "it's iovec, only non-temporal stores there" logics in
arch_copy_from_iter_pmem() is simply wrong - for one thing, unaligned
copies will have parts done via normal stores, for another 32bit will
_not_ go for non-caching codepath for short copies.  What semantics do
we really need there?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
