Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3132C80
	for <nvdimm@lists.linux.dev>; Thu, 25 Nov 2021 00:16:12 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id t4so3548100pgn.9
        for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 16:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uUUQjs/pBmHAN/W+SUU/EXK8L3S8hFjZgOd+JkQS5So=;
        b=i7cLou8vQ2/aOQoLh2sCopA9cS7fWv9AwHYbSZrWkFGSIXnL2Mnhdz7sM5RHluzZ/Q
         IV17J0+MfxCrCe/V40xVNNekO8N22LIjwbOsEwKk7Z2YEP8X5R48kgAuy6QwRn66ZnzF
         Y5VaW8vAXpAIht+oMk4n6L27NTPzrozgx7+z2oe3ixx/4gxCgUrPVUAe7xe0BKh+dw8m
         1wH+fwyslySZoS7PMivSCaPviLqp03qnLdHof4cySGwz4Vg0zEDBRg5pwftP1FFkx7aA
         MneDiStApJw9zP0kGLEQ4G/3zK0yAvizjJbCce63D9IvndMa4DRdB/vTR59hvXCGVC5t
         +SAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uUUQjs/pBmHAN/W+SUU/EXK8L3S8hFjZgOd+JkQS5So=;
        b=i6MvvMMLwY1YyGRlJb2oi2AcA/R3ovYMp0jmNjemqpaOtY+oROc+sMDQOa7LlqFd4q
         inGcyQt2TarJQZWl6km1GFLeFCJFZUCASFO0biyu86QQgmL1OJ4LFcKVhK2BvNzBmtW+
         5SX1AU2S+JXJhbKG8jQhrB1yx5OsBAEdbahSqBBKJmgTOCABJ+ejhWgEI7z1PS/dlH/m
         q2STM4X8bmHL8WS2yOkvbDef0Q4GDZQDnPqLV5HwKlhnSQF+GfNhpBWmJIWFlIEeWRyF
         S+PHqju5k4Ym64YV57Yp3M1A3EDmG4tbVTCB0Wpu7XkfdPXGgAHiRErMNOhRFQQE4JFE
         qxYw==
X-Gm-Message-State: AOAM530uLpZCYnC/7j8I66GLzeSUotEwybrQljgxjlS7JnpvWEyNB5Z7
	d84COCxZ60CdK7ygyt3Jx3VYebNV9gky0iSB1cpzDA==
X-Google-Smtp-Source: ABdhPJwKMhK5S/OXjF0sWlyVa52YPSi/BNanTFbWux6uelstSy2W7+MKd87CDqFbkcgRd76axBj2BHzxCXVGwnN31Kc=
X-Received: by 2002:a63:5401:: with SMTP id i1mr13413319pgb.356.1637799372374;
 Wed, 24 Nov 2021 16:16:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic> <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
 <CAPcyv4j9KH+Y4hperuCwBMLOSPHKfbbku_T8uFNoqiNYrvfRdA@mail.gmail.com>
 <YVbn3ohRhYkTNdEK@zn.tnic> <CAPcyv4i4r5-0i3gpZxwP7ojndqbrSmebtDcGbo8JR346B-2NpQ@mail.gmail.com>
 <YVdPWcggek5ykbft@zn.tnic> <CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com>
 <YVgxnPWX2xCcbv19@zn.tnic> <48c47c52-499a-8721-350a-5ac55a9a70de@oracle.com>
 <7ae58b24-ad48-7afa-c023-23ccf28e3994@oracle.com> <CAPcyv4imjWNuwsQKhWinq+vtuSgXAznhLXVfsy69Dq7q7eiXbA@mail.gmail.com>
 <f80d03c6-e650-49df-81d1-309dd138de8f@oracle.com> <CAPcyv4hPRyPtAJoDdOn+UnJQYgQW7XQTnMveKu9YdYXxekUg8A@mail.gmail.com>
 <a3c07537-f623-17fb-d2b7-45500093c337@oracle.com> <CAPcyv4iF0bQx0J0qrXVdCfRcS4QWaCyR1-DuXaoe59ofzH-FEw@mail.gmail.com>
 <1b1600b0-b50b-3e35-3609-9503b8b960b8@oracle.com> <CAPcyv4jBHnYtqoxoJY1NGNE1DXOv3bAg0gBzjZ=eOvarVXDRbA@mail.gmail.com>
 <b51fb3d6-6d39-c450-e0a1-94a1645a22ec@oracle.com>
In-Reply-To: <b51fb3d6-6d39-c450-e0a1-94a1645a22ec@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Nov 2021 16:16:02 -0800
Message-ID: <CAPcyv4g4mEVDcUw2Ph0oMH1=ZQgCbnLx+ZdgoavyOQt+9q6aVw@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Luis Chamberlain <mcgrof@suse.com>, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 18, 2021 at 11:04 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 11/13/2021 12:47 PM, Dan Williams wrote:
> <snip>
> >>> It should know because the MCE that unmapped the page will have
> >>> communicated a "whole_page()" MCE. When dax_recovery_read() goes to
> >>> consult the badblocks list to try to read the remaining good data it
> >>> will see that every single cacheline is covered by badblocks, so
> >>> nothing to read, and no need to establish the UC mapping. So the the
> >>> "Tony fix" was incomplete in retrospect. It neglected to update the
> >>> NVDIMM badblocks tracking for the whole page case.
> >>
> >> So the call in nfit_handle_mce():
> >>     nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
> >>                   ALIGN(mce->addr, L1_CACHE_BYTES),
> >>                   L1_CACHE_BYTES);
> >> should be replaced by
> >>     nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
> >>                   ALIGN(mce->addr, L1_CACHE_BYTES),
> >>                   (1 << MCI_MISC_ADDR_LSB(m->misc)));
> >> right?
> >
> > Yes.
> >
> >>
> >> And when dax_recovery_read() calls
> >>     badblocks_check(bb, sector, len / 512, &first_bad, &num_bad)
> >> it should always, in case of 'NP', discover that 'first_bad'
> >> is the first sector in the poisoned page,  hence no need
> >> to switch to 'UC', right?
> >
> > Yes.
> >
> >>
> >> In case the 'first_bad' is in the middle of the poisoned page,
> >> that is, dax_recover_read() could potentially read some clean
> >> sectors, is there problem to
> >>     call _set_memory_UC(pfn, 1),
> >>     do the mc_safe read,
> >>     and then call set_memory_NP(pfn, 1)
> >> ?
> >> Why do we need to call ioremap() or vmap()?
> >
> > I'm worried about concurrent operations and enabling access to threads
> > outside of the one currently in dax_recovery_read(). If a local vmap()
> > / ioremap() is used it effectively makes the access thread local.
> > There might still need to be an rwsem to allow dax_recovery_write() to
> > fixup the pfn access and syncrhonize with dax_recovery_read()
> > operations.
> >
>
> <snip>
> >> I didn't even know that guest could clear poison by trapping hypervisor
> >> with the ClearError DSM method,
> >
> > The guest can call the Clear Error DSM if the virtual BIOS provides
> > it. Whether that actually clears errors or not is up to the
> > hypervisor.
> >
> >> I thought guest isn't privileged with that.
> >
> > The guest does not have access to the bare metal DSM path, but the
> > hypervisor can certainly offer translation service for that operation.
> >
> >> Would you mind to elaborate about the mechanism and maybe point
> >> out the code, and perhaps if you have test case to share?
> >
> > I don't have a test case because until Tony's fix I did not realize
> > that a virtual #MC would allow the guest to learn of poisoned
> > locations without necessarily allowing the guest to trigger actual
> > poison consumption.
> >
> > In other words I was operating under the assumption that telling
> > guests where poison is located is potentially handing the guest a way
> > to DoS the VMM. However, Tony's fix shows that when the hypervisor
> > unmaps the guest physical page it can prevent the guest from accessing
> > it again. So it follows that it should be ok to inject virtual #MC to
> > the guest, and unmap the guest physical range, but later allow that
> > guest physical range to be repaired if the guest asks the hypervisor
> > to repair the page.
> >
> > Tony, does this match your understanding?
> >
> >>
> >> but I'm not sure what to do about
> >>> guests that later want to use MOVDIR64B to clear errors.
> >>>
> >>
> >> Yeah, perhaps there is no way to prevent guest from accidentally
> >> clear error via MOVDIR64B, given some application rely on MOVDIR64B
> >> for fast data movement (straight to the media). I guess in that case,
> >> the consequence is false alarm, nothing disastrous, right?
> >
> > You'll just continue to get false positive failures because the error
> > tracking will be out-of-sync with reality.
> >
> >> How about allowing the potential bad-block bookkeeping gap, and
> >> manage to close the gap at certain checkpoints? I guess one of
> >> the checkpoints might be when page fault discovers a poisoned
> >> page?
> >
> > Not sure how that would work... it's already the case that new error
> > entries are appended to the list at #MC time, the problem is knowing
> > when to clear those stale entries. I still think that needs to be at
> > dax_recovery_write() time.
> >
>
> Thanks Dan for taking the time elaborating so much details!
>
> After some amount of digging, I have a feel that we need to take
> dax error handling in phases.
>
> Phase-1: the simplest dax_recovery_write on page granularity, along
>           with fix to set poisoned page to 'NP', serialize
>           dax_recovery_write threads.

You mean special case PAGE_SIZE overwrites when dax_direct_access()
fails, but leave out the sub-page error handling and
read-around-poison support?

That makes sense to me. Incremental is good.

> Phase-2: provide dax_recovery_read support and hence shrink the error
>           recovery granularity.  As ioremap returns __iomem pointer
>           that is only allowed to be referenced with helpers like
>           readl() which do not have a mc_safe variant, and I'm
>           not sure whether there should be.  Also the synchronization
>           between dax_recovery_read and dax_recovery_write threads.

You can just use memremap() like the driver does to drop the iomem annotation.

> Phase-3: the hypervisor error-record keeping issue, suppose there is
>           an issue, I'll need to figure out how to setup a test case.
> Phase-4: the how-to-mitigate-MOVDIR64B-false-alarm issue.

My expectation is that CXL supports MOVDIR64B error clearing without
needing to send the Clear Poison command. I think this can be phase3,
phase4 is the more difficult question about how / if to coordinate
with VMM poison tracking. Right now I don't see a choice but to make
it paravirtualized.

>
> Right now, it seems to me providing Phase-1 solution is urgent, to give
> something that customers can rely on.
>
> How does this sound to you?

Sounds good.
