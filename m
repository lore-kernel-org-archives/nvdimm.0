Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2FE3FC3
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 20:33:53 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso8398027pjh.5
        for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 13:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=12EcOqClZL2NdniFoQSXbl5bCHq8Vg4z9WdZdd/j3Qg=;
        b=0FywxIR9DYqL7k4JNQpCurJRYRx2yHzRZqPBOgXf8ZibsDbQg2ICQ0SO/K06EgI4Dn
         O/hHgjlgD1bQucA3a5pxSquuBiabnRqamWSbUnFbeNHpX7wPeRXxVTEYYOR2NcMOG3H0
         c3Fjbtd4s5aoQOC2l+pswHHaMKYPc9+fT7TsIl93sjAXKfRl8wuUIbx2zICUxyAfn/zp
         ZEjfXIwi+LEVyQls8cMn20hnDBbtgdxnf8CZMTUnPXR0mgRsJHAff4e7FVKfZ6O+UHjc
         2cy+8ab2+x/8KEqUaH6lFAgMDSGHhxJgehsN5SaTCSptnl7/+J+5ldGP4fZN9bSSw4Lc
         md+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=12EcOqClZL2NdniFoQSXbl5bCHq8Vg4z9WdZdd/j3Qg=;
        b=hRGbuE21hQDrsNJMLmg2RZn4MViN+zx1Fbk04JegrwiMaQfpl9nnCouQG+0SBewNUs
         AFE5Jm+xlFAL0qz4ns7J//r9tBF3ajrLrtyxRg6lKKs513f6gvNaiqdtUuLGPE+q5MRI
         SykjkvrsuP94cHTJbbdwzg93ODpZMpF4oUMnZDlY5pRJPY+a/GPE4XQPfd6in9u/QDrw
         lo97RBuDmX/Are/wqWQItfKS35fyMLKH5c/oS+OzanZeVcXsJjrgDJwFx025LCgVzIzK
         ptalCErnBByG/FVmaDHBUGl+2XOMDoXaqkMhiHFzlIoIWrftKdOMdDn/Tx4Z6om9kX+D
         R4kQ==
X-Gm-Message-State: AOAM533cctSXLt4Dpt1e/ywFRJXbm7c3cSHhtl9vcytYsNlfNQ0zxMfh
	p/NAAe8lQtHnyl3+w63MEGzuXxdxcQfQqrIN69bccjJCPmg8MQ==
X-Google-Smtp-Source: ABdhPJzum3H3rbyk5groX6o2LukdMv4I8lqkz1dsWquOOS/ZLeVFE7p+EfnrS43E1sV6OYeguDOo9k9ClyUrTkpXkh8=
X-Received: by 2002:a17:902:cec8:b0:13b:9ce1:b3ef with SMTP id
 d8-20020a170902cec800b0013b9ce1b3efmr6426487plg.4.1631824433090; Thu, 16 Sep
 2021 13:33:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic> <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic>
In-Reply-To: <YUHN1DqsgApckZ/R@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Sep 2021 13:33:42 -0700
Message-ID: <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Borislav Petkov <bp@alien8.de>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Jane Chu <jane.chu@oracle.com>, 
	Luis Chamberlain <mcgrof@suse.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 15, 2021 at 3:41 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Sep 14, 2021 at 11:08:00AM -0700, Dan Williams wrote:
> > Sure, I should probably include this following note in all patches
> > touching the DAX-memory_failure() path, because it is a frequently
> > asked question. The tl;dr is:
> >
> > Typical memory_failure() does not assume the physical page can be
> > recovered and put back into circulation, PMEM memory_failure() allows
> > for recovery of the page.
>
> Hmm, I think by "PMEM memory_failure()" you mean what pmem_do_write()
> does with that poison clearing or?

I am specifically talking about the memory_failure_dev_pagemap() path
taken from memory_failure().

> But then I have no clue what the "DAX-memory_failure()" path is.

Sorry, I should not have lazily used {PMEM,DAX} memory_failure() to
refer to the exact routine in question: memory_failure_dev_pagemap().
That path is taken when memory_failure() sees that a pfn was mapped by
memremap_pages(). It determines that the pfn does not represent a
dynamic page allocator page and may refer to a static page of storage
from a device like /dev/pmem, or /dev/dax.

>
> > The longer description is:
> > Typical memory_failure() for anonymous, or page-cache pages, has the
> > flexibility to invalidate bad pages and trigger any users to request a
> > new page from the page allocator to replace the quarantined one. DAX
> > removes that flexibility. The page is a handle for a fixed storage
> > location, i.e. no mechanism to remap a physical page to a different
> > logical address. Software expects to be able to repair an error in
> > PMEM by reading around the poisoned cache lines and writing zeros,
> > fallocate(...FALLOC_FL_PUNCH_HOLE...), to overwrite poison. The page
> > needs to remain accessible to enable recovery.
>
> Aha, so memory failure there is not offlining he 4K page but simply
> zeroing the poison.

The zeroing of the poison comes optionally later if userspace
explicitly asks for it to be cleared.

> What happens if the same physical location triggers
> more read errors, i.e., the underlying hw is going bad? Don't you want
> to exclude that location from ever being written again?

Yes. The device driver avoids reconsumption of the same error by
recording the error in a "badblocks" structure (block/badblocks.c).
The driver consults its badblocks instance on every subsequent access
and preemptively returns EIO. The driver registers for machine-check
notifications and translates those events into badblocks entries. So,
repeat consumption is avoided unless/until the babblocks entry can be
cleared along with the poison itself.

I'll note that going forward the filesystem wants to be more involved
in tracking and managing these errors so the driver will grow the
ability to forward those notifications up the stack.

> Or maybe such recovery action doesn't make sense for pmem?

It does. In addition to machine-check synchronous notification of
poison, there are asynchronous scanning mechanisms that prepopulate
the badblocks entries to get ahead of consumption events.

> > Short answer, PMEM never goes "offline" because it was never "online"
> > in the first place. Where "online" in this context is specifically
> > referring to pfns that are under the watchful eye of the core-mm page
> > allocator.
>
> Ok, so pmem wants to be handled differently during memory failure.
> Looking at the patch again, you change the !unmap case to do
> _set_memory_uc().
>
> That bool unmap thing gets *not* set in whole_page():
>
>         return MCI_MISC_ADDR_LSB(m->misc) >= PAGE_SHIFT;
>
> so I'm guessing that "Recoverable Address LSB (bits 5:0): The lowest
> valid recoverable address bit." thing is < 12 for pmem.
>
> But are you really saying that the hardware would never report a lower
> than 12 value for normal memory?

Ugh, no, I failed to update my mental model of set_mce_nopsec() usage
after commit 17fae1294ad9 "x86/{mce,mm}: Unmap the entire page if the
whole page is affected and poisoned". I was just looking for "where
does set_mce_nospec() do the UC vs NP decision", and did not read the
new calling convention... more below.

> If it does, then that is wrong here.
>
> In any case, I'd prefer if the code would do an explicit check somewhere
> saying "is this pmem" in order to do that special action only for when
> it really is pmem and not rely on it implicitly.

After thinking this through a bit I don't think we want that, but I
did find a bug, and this patch needs a rewritten changelog to say why
pmem does not need to be explicitly called out in this path. The
reasoning is that set_mce_nospec() was introduced as a way to achieve
the goal of preventing speculative consumption of poison *and* allow
for reads around poisoned cachelines for PMEM recovery. UC achieves
that goal for both PMEM and DRAM, unlike what this changelog alluded
to which was NP for DRAM and UC for PMEM. The new consideration of
whole_page() errors means that the code in nfit_handle_mce() is wrong
to assume that the length of the error is just 1 cacheline. When that
bug is fixed the badblocks range will cover the entire page in
whole_page() notification cases. Because the entire page is dead there
is no need for UC because all the cachelines are gone, nothing to
read-around in this page. In short DRAM and PMEM want to share the
exact same policy here and use NP for whole_page() and UC for not.
Just the small matter of ignoring the memtype by using
_set_memory_uc().

Thanks for triggering that deeper look.
