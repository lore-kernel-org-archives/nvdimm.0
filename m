Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EF129CA
	for <nvdimm@lists.linux.dev>; Fri,  1 Oct 2021 18:29:53 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id n18so10168231pgm.12
        for <nvdimm@lists.linux.dev>; Fri, 01 Oct 2021 11:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+wE0zthEas3DeeQ/jV8qmqxLeJVtQ8JZ8Ne7Duf8CAo=;
        b=LE+AOCuSD5HXhtjXhHqmhB/4uh++AzHVDoa79fJMX0USiBHTLYqMZp7T+4Lh6UXldz
         xeC6SYO/JiaHSJ4H0kj22czQ4gHP0rDFy7m57I5Ziu7O51tVKB+l08RXCmjRjQWpptNE
         guuh7fJdIQnf7l/xm2jxqezvghVJHnygKNB+EXXCGjOOAaWSHUQdqnHMVDbozu/SnKzB
         /w9Es8/YbKcWvDRsYnYLTtdrcHB4PYMVRdGZCTO5pIzd1ygHRbIaIuajybD5CGBnB+1y
         RqM4d81Zo4ItafMDCc0CXLrN6ADy5lj2JBXY21QeFOrCGZutZUD18PJz8EJ6vtyJzAa/
         pEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+wE0zthEas3DeeQ/jV8qmqxLeJVtQ8JZ8Ne7Duf8CAo=;
        b=XJGeC9ioHwFGyAF3NLrpk3Xr8EcLOruECt9JX3xBgKnRfQn1uMVpBgSmVZLDcZHUL7
         R2VnMcOuHyEKXEryRz3OF/lb4amf321CNhDmnlrzohmFQmHTQhj1OeFg5MM/GYHBSH/R
         rDAXY+c0aUU70S/lMrYzXiEwjGKBqtbPXlMs/LHHg47L0b7wasAwa+sgfCV4SNVfzb43
         +7LuyEaKQGGQal86cHIhUQf42OYT12JBhdnQAFLSa93ga3vsfPtefSd6uDSS6bYVtWgR
         tUF8194/l7e36bb0qr0TvQ3YIO+DeFFTluRc1bx73rEvHhNNDXNn4+UCwWqaiudfeDVu
         NPMQ==
X-Gm-Message-State: AOAM530r7xf5264w5q1OGvkM5BfT4Kpz7zp9yxLYDIg6HG3WHOz3OO6X
	MTI5mlpDths7tTiyDbDqKU0lpf0Yk+VHsM2I4jycJw==
X-Google-Smtp-Source: ABdhPJysmQES+alWiVF3ObnB9v4Hwr1vCva/ycdoQtvNPFH3eaJT97z0Btg1fvomPajYX1udMhlt3ymeujvxI4XDksU=
X-Received: by 2002:a63:1262:: with SMTP id 34mr10794147pgs.356.1633112993021;
 Fri, 01 Oct 2021 11:29:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic> <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic> <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic> <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
 <CAPcyv4j9KH+Y4hperuCwBMLOSPHKfbbku_T8uFNoqiNYrvfRdA@mail.gmail.com>
 <YVbn3ohRhYkTNdEK@zn.tnic> <CAPcyv4i4r5-0i3gpZxwP7ojndqbrSmebtDcGbo8JR346B-2NpQ@mail.gmail.com>
 <YVdPWcggek5ykbft@zn.tnic>
In-Reply-To: <YVdPWcggek5ykbft@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Oct 2021 11:29:43 -0700
Message-ID: <CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Borislav Petkov <bp@alien8.de>
Cc: Jane Chu <jane.chu@oracle.com>, "Luck, Tony" <tony.luck@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 1, 2021 at 11:12 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Fri, Oct 01, 2021 at 09:52:21AM -0700, Dan Williams wrote:
> > I think that puts us back in the situation that Tony fixed in:
> >
> > 17fae1294ad9 x86/{mce,mm}: Unmap the entire page if the whole page is
> > affected and poisoned
> >
> > ...where the clflush in _set_memory_uc() causes more unwanted virtual
> > #MC injection.
>
> Hmm, lemme read that commit message again: so the guest kernel sees a
> *second* MCE while doing set_memory_uc().
>
> So what prevents the guest kernel from seeing a second MCE when it does
> set_memory_np() instead?
>
> "Further investigation showed that the VMM had passed in another machine
> check because is appeared that the guest was accessing the bad page."
>
> but then the beginning of the commit message says:
>
> "The VMM unmapped the bad page from guest physical space and passed the
> machine check to the guest."
>
> so I'm really confused here what actually happens. Did the VMM manage to
> unmap it or not really? Because if the VMM had unmapped it, then how was
> the guest still accessing the bad page? ... Maybe I'm reading that wrong.

My read is that the guest gets virtual #MC on an access to that page.
When the guest tries to do set_memory_uc() and instructs cpa_flush()
to do clean caches that results in taking another fault / exception
perhaps because the VMM unmapped the page from the guest? If the guest
had flipped the page to NP then cpa_flush() says "oh, no caching
change, skip the clflush() loop".

>
> > I think that means that we have no choice but to mark the page NP
> > unconditionally and do the work to ensure that the driver has updated
> > its poisoned cacheline tracking for data recovery requests.
>
> So a couple of emails earlier I had this:
>
> |Well, the driver has special knowledge so *actually* it could go and use
> |the NP marking as "this page has been poisoned" and mark it NC only for
> |itself, so that it gets the job done. Dunno if that would end up being
> |too ugly to live and turn into a layering violation or so.
>
> So if we have marked the page NP, then nothing would be able to access
> it anymore and it will be marked as hwpoison additionally, which will
> prevent that access too.
>
> Then, the PMEM driver would go and map the page however it wants to, it
> could even remove it from the direct map so that nothing else accesses
> it, even in the kernel, and then do all kinds of recovery.
>
> Hmm?

Yeah, I thought UC would make the PMEM driver's life easier, but if it
has to contend with an NP case at all, might as well make it handle
that case all the time.

Safe to say this patch of mine is woefully insufficient and I need to
go look at how to make the guarantees needed by the PMEM driver so it
can handle NP and set up alias maps.

This was a useful discussion. It proves that my commit:

284ce4011ba6 x86/memory_failure: Introduce {set, clear}_mce_nospec()

...was broken from the outset.
