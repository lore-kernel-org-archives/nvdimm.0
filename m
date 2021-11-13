Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3192B72
	for <nvdimm@lists.linux.dev>; Sat, 13 Nov 2021 20:47:44 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id g19so11432024pfb.8
        for <nvdimm@lists.linux.dev>; Sat, 13 Nov 2021 12:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=55CMEMA35quLDepEyg0U07NPDi3wTMlkvrVkrXBp4no=;
        b=70COXcVqm6Jq6AGqYQnyNGTyOklaFz86V/bRbhVFiiEgahrDUTe2rCLNNxzWu6+9O+
         nNZjWPzwrzQ2npORFpLaHQbMfKdA33n7iI6N2BFmHOXYr0SnBJnaMkyHKPDpkWaJpyRM
         hNwmzBQp2wXoPH3DE245X2CsXRuYYDaqoeYexJPY60ny4o3dHidT2ZuQU65PVqrWYn86
         gcnW1Yd4qGOKY2UfRK1vhnzn0MLEu2A4ysahzYzknOTeoIMVI02rMg081a/lnfgT0Tdx
         YRzwDFIY2KhLGNP+3s6GjKUiQO9WA3JdZGwhM5RrUuLVCmsrNoP5d/Idrjwf5TIbYWoG
         CzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=55CMEMA35quLDepEyg0U07NPDi3wTMlkvrVkrXBp4no=;
        b=syNz8odEZHbIQ6+kaZa4SCKi5eDXMFrcPuxoP3FDRnDy+Hg7d3hCrcO89hpWkpP+eG
         tAh6x5b+jOoNs59hzuaQkj/d4NS2xbuBSYHvJpiVAJU+K3vQVkysjRYtYY1/oKmBXZiv
         msADKfv3j4xradtdaHhV4fHqWPikiAOqSr9GWurn5nwMzLlnA2H0OPzTTRsH5svJwjhf
         JidrBDOpbx62Gh7oxxxbZqQUAlwEs78wF207/d2fpMQHDfzB2OLZ8xkruhyoGsRkTpOg
         7FBSE1njK0fF8CNA6aewLRCv2vVt3n2NGZga9NrpF3AgWrb/VlF6kS942R2rLWHFTMB1
         Ef8g==
X-Gm-Message-State: AOAM532t4u+iHQTXlFmA9tueZaTRGMYX5lrVHWmMT5kt+u8RU06lT60A
	4Dj0PP9thHBmU7DF4pCclPtEOZ22hyiqFF0Jvc3F/iCJDVc=
X-Google-Smtp-Source: ABdhPJwmYiOZN35swnzYyxOV59mhLnoqiPdXwk84oSJRpFXPxX1ovBcYoOEDtvOtcrYvHc6i+nmCO74IC0evyfhDgfk=
X-Received: by 2002:a05:6a00:140e:b0:444:b077:51ef with SMTP id
 l14-20020a056a00140e00b00444b07751efmr22303959pfu.61.1636836463529; Sat, 13
 Nov 2021 12:47:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic> <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic> <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
 <CAPcyv4j9KH+Y4hperuCwBMLOSPHKfbbku_T8uFNoqiNYrvfRdA@mail.gmail.com>
 <YVbn3ohRhYkTNdEK@zn.tnic> <CAPcyv4i4r5-0i3gpZxwP7ojndqbrSmebtDcGbo8JR346B-2NpQ@mail.gmail.com>
 <YVdPWcggek5ykbft@zn.tnic> <CAPcyv4hrXPb1tASBZUg-GgdVs0OOFKXMXLiHmktg_kFi7YBMyQ@mail.gmail.com>
 <YVgxnPWX2xCcbv19@zn.tnic> <48c47c52-499a-8721-350a-5ac55a9a70de@oracle.com>
 <7ae58b24-ad48-7afa-c023-23ccf28e3994@oracle.com> <CAPcyv4imjWNuwsQKhWinq+vtuSgXAznhLXVfsy69Dq7q7eiXbA@mail.gmail.com>
 <f80d03c6-e650-49df-81d1-309dd138de8f@oracle.com> <CAPcyv4hPRyPtAJoDdOn+UnJQYgQW7XQTnMveKu9YdYXxekUg8A@mail.gmail.com>
 <a3c07537-f623-17fb-d2b7-45500093c337@oracle.com> <CAPcyv4iF0bQx0J0qrXVdCfRcS4QWaCyR1-DuXaoe59ofzH-FEw@mail.gmail.com>
 <1b1600b0-b50b-3e35-3609-9503b8b960b8@oracle.com>
In-Reply-To: <1b1600b0-b50b-3e35-3609-9503b8b960b8@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 13 Nov 2021 12:47:30 -0800
Message-ID: <CAPcyv4jBHnYtqoxoJY1NGNE1DXOv3bAg0gBzjZ=eOvarVXDRbA@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 12, 2021 at 9:50 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 11/12/2021 3:08 PM, Dan Williams wrote:
> > On Fri, Nov 12, 2021 at 2:35 PM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> On 11/12/2021 11:24 AM, Dan Williams wrote:
> >>> On Fri, Nov 12, 2021 at 9:58 AM Jane Chu <jane.chu@oracle.com> wrote:
> >>>>
> >>>> On 11/11/2021 4:51 PM, Dan Williams wrote:
> >>>>> On Thu, Nov 11, 2021 at 4:30 PM Jane Chu <jane.chu@oracle.com> wrote:
> >>>>>>
> >>>>>> Just a quick update -
> >>>>>>
> >>>>>> I managed to test the 'NP' and 'UC' effect on a pmem dax file.
> >>>>>> The result is, as expected, both setting 'NP' and 'UC' works
> >>>>>> well in preventing the prefetcher from accessing the poisoned
> >>>>>> pmem page.
> >>>>>>
> >>>>>> I injected back-to-back poisons to the 3rd block(512B) of
> >>>>>> the 3rd page in my dax file.  With 'NP', the 'mc_safe read'
> >>>>>> stops  after reading the 1st and 2nd pages, with 'UC',
> >>>>>> the 'mc_safe read' was able to read [2 pages + 2 blocks] on
> >>>>>> my test machine.
> >>>>>
> >>>>> My expectation is that dax_direct_access() / dax_recovery_read() has
> >>>>> installed a temporary UC alias for the pfn, or has temporarily flipped
> >>>>> NP to UC. Outside of dax_recovery_read() the page will always be NP.
> >>>>>
> >>>>
> >>>> Okay.  Could we only flip the memtype within dax_recovery_read, and
> >>>> not within dax_direct_access?  dax_direct_access does not need to
> >>>> access the page.
> >>>
> >>> True, dax_direct_access() does not need to do the page permission
> >>> change, it just needs to indicate if dax_recovery_{read,write}() may
> >>> be attempted. I was thinking that the DAX pages only float between NP
> >>> and WB depending on whether poison is present in the page. If
> >>> dax_recovery_read() wants to do UC reads around the poison it can use
> >>> ioremap() or vmap() to create a temporary UC alias. The temporary UC
> >>> alias is only possible if there might be non-clobbered data remaining
> >>> in the page. I.e. the current "whole_page()" determination in
> >>> uc_decode_notifier() needs to be plumbed into the PMEM driver so that
> >>> it can cooperate with a virtualized environment that injects virtual
> >>> #MC at page granularity. I.e. nfit_handle_mce() is broken in that it
> >>> only assumes a single cacheline around the failure address is
> >>> poisoned, it needs that same whole_page() logic.
> >>>
> >>
> >> I'll have to take some time to digest what you proposed, but alas, why
> >> couldn't we let the correct decision (about NP vs UC) being made when
> >> the 'whole_page' test has access to the MSi_MISC register, instead of
> >> having to risk mistakenly change NP->UC in dax_recovery_read() and
> >> risk to repeat the bug that Tony has fixed?  I mean a PMEM page might
> >> be legitimately not-accessible due to it might have been unmapped by
> >> the host, but dax_recovery_read() has no way to know, right?
> >
> > It should know because the MCE that unmapped the page will have
> > communicated a "whole_page()" MCE. When dax_recovery_read() goes to
> > consult the badblocks list to try to read the remaining good data it
> > will see that every single cacheline is covered by badblocks, so
> > nothing to read, and no need to establish the UC mapping. So the the
> > "Tony fix" was incomplete in retrospect. It neglected to update the
> > NVDIMM badblocks tracking for the whole page case.
>
> So the call in nfit_handle_mce():
>    nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
>                  ALIGN(mce->addr, L1_CACHE_BYTES),
>                  L1_CACHE_BYTES);
> should be replaced by
>    nvdimm_bus_add_badrange(acpi_desc->nvdimm_bus,
>                  ALIGN(mce->addr, L1_CACHE_BYTES),
>                  (1 << MCI_MISC_ADDR_LSB(m->misc)));
> right?

Yes.

>
> And when dax_recovery_read() calls
>    badblocks_check(bb, sector, len / 512, &first_bad, &num_bad)
> it should always, in case of 'NP', discover that 'first_bad'
> is the first sector in the poisoned page,  hence no need
> to switch to 'UC', right?

Yes.

>
> In case the 'first_bad' is in the middle of the poisoned page,
> that is, dax_recover_read() could potentially read some clean
> sectors, is there problem to
>    call _set_memory_UC(pfn, 1),
>    do the mc_safe read,
>    and then call set_memory_NP(pfn, 1)
> ?
> Why do we need to call ioremap() or vmap()?

I'm worried about concurrent operations and enabling access to threads
outside of the one currently in dax_recovery_read(). If a local vmap()
/ ioremap() is used it effectively makes the access thread local.
There might still need to be an rwsem to allow dax_recovery_write() to
fixup the pfn access and syncrhonize with dax_recovery_read()
operations.

>
> >
> >> The whole UC <> NP arguments to me seems to be a
> >>    "UC being harmless/workable solution to DRAM and PMEM"  versus
> >>    "NP being simpler regardless what risk it brings to PMEM".
> >> To us, PMEM is not just another driver, it is treated as memory by our
> >> customer, so why?
> >
> > It's really not a question of UC vs NP, it's a question of accurately
> > tracking how many cachelines are clobbered in an MCE event so that
> > hypervisors can punch out entire pages from any future guest access.
> > This also raises another problem in my mind, how does the hypervisor
> > learn that the poison was repaired?
>
> Good question!
>
> Presumably the "Tony fix" was for
> > a case where the guest thought the page was still accessible, but the
> > hypervisor wanted the whole thing treated as poison. It may be the
> > case that we're missing a mechanism to ask the hypervisor to consider
> > that the guest has cleared the poison. At least for PMEM described by
> > ACPI the existing ClearError DSM in the guest could be trapped by the
> > hypervisor to handle this case,
>
> I didn't even know that guest could clear poison by trapping hypervisor
> with the ClearError DSM method,

The guest can call the Clear Error DSM if the virtual BIOS provides
it. Whether that actually clears errors or not is up to the
hypervisor.

> I thought guest isn't privileged with that.

The guest does not have access to the bare metal DSM path, but the
hypervisor can certainly offer translation service for that operation.

> Would you mind to elaborate about the mechanism and maybe point
> out the code, and perhaps if you have test case to share?

I don't have a test case because until Tony's fix I did not realize
that a virtual #MC would allow the guest to learn of poisoned
locations without necessarily allowing the guest to trigger actual
poison consumption.

In other words I was operating under the assumption that telling
guests where poison is located is potentially handing the guest a way
to DoS the VMM. However, Tony's fix shows that when the hypervisor
unmaps the guest physical page it can prevent the guest from accessing
it again. So it follows that it should be ok to inject virtual #MC to
the guest, and unmap the guest physical range, but later allow that
guest physical range to be repaired if the guest asks the hypervisor
to repair the page.

Tony, does this match your understanding?

>
> but I'm not sure what to do about
> > guests that later want to use MOVDIR64B to clear errors.
> >
>
> Yeah, perhaps there is no way to prevent guest from accidentally
> clear error via MOVDIR64B, given some application rely on MOVDIR64B
> for fast data movement (straight to the media). I guess in that case,
> the consequence is false alarm, nothing disastrous, right?

You'll just continue to get false positive failures because the error
tracking will be out-of-sync with reality.

> How about allowing the potential bad-block bookkeeping gap, and
> manage to close the gap at certain checkpoints? I guess one of
> the checkpoints might be when page fault discovers a poisoned
> page?

Not sure how that would work... it's already the case that new error
entries are appended to the list at #MC time, the problem is knowing
when to clear those stale entries. I still think that needs to be at
dax_recovery_write() time.
