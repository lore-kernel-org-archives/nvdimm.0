Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E71C3FCB
	for <nvdimm@lists.linux.dev>; Tue, 21 Sep 2021 02:05:02 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id t1so19294557pgv.3
        for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 19:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FYrM/RzmYkooaIgiaBS+xzc+ouPWh3U85lPQJ64IViw=;
        b=K9vEjPqLTDcznukBNO9tBFRvGlY2hgu3nvAMKqu01b+khPED8fHMEGirh2wukqJsSk
         9MnKeL2LuGxmYiHKnX4QmN9H3zF5DMhQF1XY1A9t8J73A8JbXb4ioKxPS0+id29m3R1y
         KPtnwAW+UZ8wxbW33bWEC2WUB2qpGIM1ZrS72E/OjSH1uMmGcIYtb0C8ok0PjU8XP4bY
         SWcFYzitNcCoH2jQlDm9BU/EerH8JXEJZT3xI2cIGZaXKZVaO7OfssZvo+Oz3l94oyYe
         JSuLcb7OaDahXu1VSI0uwBP18EdcXOU7AiOf3CX3g4WOW2BdKkgQWz8Y6Qo0qwk6u8un
         M9/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FYrM/RzmYkooaIgiaBS+xzc+ouPWh3U85lPQJ64IViw=;
        b=IIeKsAXtuRcFRXW80bHAYJLypXe7FOAYLxcSnp0cCDvdscWSr9uyffTfHEfE88Kvj2
         JnEt3MSFtZyR6rK9T0gCbhrUvKmVaMZv08GrfO43oErNOHYOdWWTMSjFkufp33j5NYpO
         FQTvs10jlP4rjHwENaGf9A7nVk9/0ImMrTN9alNrM0GFXssa9VM79DRAwOf3UHQxy8BV
         hqGbLlYfDc1S5GtjfIpiGnqyMXh8y+HuI/sxOckKmY1ZqZQTblTH8FVYvtp8a7/4Wvfx
         L3Sk0WJ8NQdrq8Uecal3eT2x9XiRhuNhlIQS/HQW6J4hRcxk4byvFZ9m3eeWRf35VdvK
         tcXA==
X-Gm-Message-State: AOAM5316VUkkWFC6B8HxqnlOIGVIxq4gcinJCxJpT0XA72sbYt7EuNAu
	6czoYU26eLS6WW+ibjVLXrTZ7kWSHt5vLBkZX5BTwg==
X-Google-Smtp-Source: ABdhPJyC1RFA56n7jX4OaZitCuQ5VoFk7iom3j+Ez4Z9MCXFdonTHD2S2VHVDlI+ktsWQCMV2XY/yvTK6mgDrGuL3Zg=
X-Received: by 2002:aa7:9d84:0:b0:447:c2f4:4a39 with SMTP id
 f4-20020aa79d84000000b00447c2f44a39mr6611401pfq.86.1632189901949; Mon, 20 Sep
 2021 19:05:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic> <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic> <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <YUR8RTx9blI2ezvQ@zn.tnic>
In-Reply-To: <YUR8RTx9blI2ezvQ@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 Sep 2021 19:04:50 -0700
Message-ID: <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Borislav Petkov <bp@alien8.de>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Jane Chu <jane.chu@oracle.com>, 
	Luis Chamberlain <mcgrof@suse.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 17, 2021 at 4:30 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Sep 16, 2021 at 01:33:42PM -0700, Dan Williams wrote:
> > I am specifically talking about the memory_failure_dev_pagemap() path
> > taken from memory_failure().
> >
> > > But then I have no clue what the "DAX-memory_failure()" path is.
> >
> > Sorry, I should not have lazily used {PMEM,DAX} memory_failure() to
> > refer to the exact routine in question: memory_failure_dev_pagemap().
> > That path is taken when memory_failure() sees that a pfn was mapped by
> > memremap_pages(). It determines that the pfn does not represent a
> > dynamic page allocator page and may refer to a static page of storage
> > from a device like /dev/pmem, or /dev/dax.
>
> Aaaha, that's that innocent-looking pfn_to_online_page() call there in
> memory_failure() which would return NULL for pmem/dax pages.

Exactly.

>
> > The zeroing of the poison comes optionally later if userspace
> > explicitly asks for it to be cleared.
>
> I see.
>
> > Yes. The device driver avoids reconsumption of the same error by
> > recording the error in a "badblocks" structure (block/badblocks.c).
> > The driver consults its badblocks instance on every subsequent access
> > and preemptively returns EIO. The driver registers for machine-check
> > notifications and translates those events into badblocks entries. So,
> > repeat consumption is avoided unless/until the babblocks entry can be
> > cleared along with the poison itself.
>
> Sounds good.
>
> > I'll note that going forward the filesystem wants to be more involved
> > in tracking and managing these errors so the driver will grow the
> > ability to forward those notifications up the stack.
>
> ... which would save the ask-the-driver each time thing. Yap.
>
> > It does. In addition to machine-check synchronous notification of
> > poison, there are asynchronous scanning mechanisms that prepopulate
> > the badblocks entries to get ahead of consumption events.
>
> Probably something similar to patrol scrubbing on normal DRAM.

Yes, although I believe that DRAM patrol scrubbing is being done from
the host memory controller, these PMEM DIMMs have firmware and DMA
engines *in the DIMM* to do this scrub work.

> > ... Because the entire page is dead there is no need for UC because all
> > the cachelines are gone, nothing to read-around in this page. In short
> > DRAM and PMEM want to share the exact same policy here and use NP for
> > whole_page() and UC for not. Just the small matter of ignoring the
> > memtype by using _set_memory_uc().
>
> Hmm, so looking at this more:
>
>         else
>                 rc = set_memory_uc(decoy_addr, 1);
>
> ->  memtype_reserve(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
>
> ->  memtype_reserve(__pa(addr), __pa(addr) + 1,
>
> Looking at
>
>   17fae1294ad9 ("x86/{mce,mm}: Unmap the entire page if the whole page is affected and poisoned")
>
> it says
>
>     Fix is to check the scope of the poison by checking the MCi_MISC register.
>     If the entire page is affected, then unmap the page. If only part of the
>     page is affected, then mark the page as uncacheable.
>
> so I guess for normal DRAM we still want to map the page uncacheable so
> that other parts except that cacheline can still be read.

Perhaps, but I don't know how you do that if memory_failure() has
"offlined" the DRAM page, in the case of PMEM you can issue a
byte-aligned direct-I/O access to the exact storage locations around
the poisoned cachelines.

> And PMEM should be excluded from that treatise here because it needs to
> be WB, as you said earlier.
>
> Right?

PMEM can still go NP if the entire page is failed, so no need to
exclude PMEM from the treatise because the driver's badblocks
implementation will cover the NP page, and the driver can use
clear_mce_nospec() to recover the WB mapping / access after the poison
has been cleared.
