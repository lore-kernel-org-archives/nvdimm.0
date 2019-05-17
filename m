Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com
 [IPv6:2607:f8b0:4864:20::434])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 755412126D82A
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 08:53:57 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id n19so3896719pfa.1
 for <linux-nvdimm@lists.01.org>; Fri, 17 May 2019 08:53:57 -0700 (PDT)
Date: Fri, 17 May 2019 08:53:54 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
Message-ID: <201905170845.1B4E2A03@keescook>
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
 <2d8b1ba7890940bf8a512d4eef0d99b3@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2d8b1ba7890940bf8a512d4eef0d99b3@AcuMS.aculab.com>
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
To: David Laight <David.Laight@ACULAB.COM>
Cc: Jeff Smits <jeff.smits@intel.com>, Matthew Wilcox <willy@infradead.org>, 'Jan Kara' <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 17, 2019 at 09:06:26AM +0000, David Laight wrote:
> From: Jan Kara
> > Sent: 17 May 2019 09:48
> ...
> > So this last paragraph is not obvious to me as check_copy_size() does a lot
> > of various checks in CONFIG_HARDENED_USERCOPY case. I agree that some of
> > those checks don't make sense for PMEM pages but I'd rather handle that by
> > refining check_copy_size() and check_object_size() functions to detect and
> > appropriately handle pmem pages rather that generally skip all the checks
> > in pmem_copy_from/to_iter(). And yes, every check in such hot path is going
> > to cost performance but that's what user asked for with
> > CONFIG_HARDENED_USERCOPY... Kees?
> 
> Except that all the distros enable it by default.
> So you get the performance cost whether you (as a user) want it or not.

Note that it can be disabled on the kernel command line, but that seems
like a last resort. :)

> 
> I've changed some of our code to use __get_user() to avoid
> these stupid overheads.

__get_user() skips even access_ok() checking too, so that doesn't seem
like a good idea. Did you run access_ok() checks separately? (This
generally isn't recommended.)

The usercopy hardening is intended to only kick in when the copy size
isn't a builtin constant -- it's attempting to do a bounds check on
the size, with the pointer used to figure out what bounds checking is
possible (basically "is this stack? check stack location/frame size"
or "is this kmem cache? check the allocation size") and then do bounds
checks from there. It tries to bail out early to avoid needless checking,
so if there is some additional logic to be added to check_object_size()
that is globally applicable, sure, let's do it.

I'm still not clear from this thread about the case that is getting
tripped/slowed? If you're already doing bounds checks somewhere else
and there isn't a chance for the pointer or size to change, then yeah,
it seems safe to skip the usercopy size checks. But what's the actual
code that is having a problem?

-- 
Kees Cook
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
