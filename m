Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DF62C85
	for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 23:08:38 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so8153044pjb.5
        for <nvdimm@lists.linux.dev>; Fri, 12 Nov 2021 15:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SX4z41MjkObS1BVeEHl9LDgOFdz0zFnZViG5d8oiXME=;
        b=ePSCrD2cakWrG5JQCclb3InwVKMgM+QtPQoKWRY0D8YUP/KjkGU9jFGMt0wOyNNJjW
         sLzJJ+qvCNU7nemEtCJQGk8QjMLmuyBTJhfflMAuUviugrsoD9N7wTRhhv50/91xaIFK
         C0ZLcPtGOwpTzuvlB5v00PKN+EH29/LE+F3jinwN2tU9ZmepAiLsNWZYbUOwcVmCp5x2
         PZFO35VK/WHq2DOlyJL9wlBqo3w/gpqdmGWSRsL0jim0rNiy10fwX2gcv1++zJHOywuz
         ixxOI3Bkd4g+5WcD+aX4bo4eQ4hiLOUNkA4jRRqg5C7Vw9WPffCMgb/aOJnIM7n8TMmB
         EIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SX4z41MjkObS1BVeEHl9LDgOFdz0zFnZViG5d8oiXME=;
        b=oiyTj+miXh5QNiHMZCVfQ/xr8qixr8JfXjQMqeIuY3DPskwdyT4OQLMXxW/wrySCah
         O/t3tiHtoCGbCnK5kYhol8kWXIGnTeHpG/dRTIyA0I/cYnLYUKafVXQfDTD8z2/sVdyy
         FTYn1fXHOmc5PgM+2AJA7bHWIdZWD6cADQMM0Ro8i5XK/+Vds4Th/eRrXxSqofjgoX6s
         uBM50thoIF5RCaCaF9s2rhWPvkEUnPpg7lMoZag0p+Ib0sRYLFia7vkT4fFutgjSOZnt
         tUqp8Opmhvwq8bBNkm7UnLbEtbdp4IXCtDzq8IXQAkCzRw/yrpeAkmFjQdf8z+vkChTD
         JQeQ==
X-Gm-Message-State: AOAM531cskOISnnVBE6ZzRowzlQwCCByWXRRtK+mdCdajFJ+ZIOJz9id
	G1lvME/2v8iKA+SubonIrno5RfCWJ18Ss3bCqVEUxg==
X-Google-Smtp-Source: ABdhPJzrXED3hduMbKMSp+dZpd99j9nemkY8I85H4WE8+oSFFKmNYmJ/kxGbQtKkeLrr9kET37eEOMMBfS5gfI46zno=
X-Received: by 2002:a17:90b:1e49:: with SMTP id pi9mr22010692pjb.220.1636758518345;
 Fri, 12 Nov 2021 15:08:38 -0800 (PST)
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
 <a3c07537-f623-17fb-d2b7-45500093c337@oracle.com>
In-Reply-To: <a3c07537-f623-17fb-d2b7-45500093c337@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 12 Nov 2021 15:08:27 -0800
Message-ID: <CAPcyv4iF0bQx0J0qrXVdCfRcS4QWaCyR1-DuXaoe59ofzH-FEw@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 12, 2021 at 2:35 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 11/12/2021 11:24 AM, Dan Williams wrote:
> > On Fri, Nov 12, 2021 at 9:58 AM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> On 11/11/2021 4:51 PM, Dan Williams wrote:
> >>> On Thu, Nov 11, 2021 at 4:30 PM Jane Chu <jane.chu@oracle.com> wrote:
> >>>>
> >>>> Just a quick update -
> >>>>
> >>>> I managed to test the 'NP' and 'UC' effect on a pmem dax file.
> >>>> The result is, as expected, both setting 'NP' and 'UC' works
> >>>> well in preventing the prefetcher from accessing the poisoned
> >>>> pmem page.
> >>>>
> >>>> I injected back-to-back poisons to the 3rd block(512B) of
> >>>> the 3rd page in my dax file.  With 'NP', the 'mc_safe read'
> >>>> stops  after reading the 1st and 2nd pages, with 'UC',
> >>>> the 'mc_safe read' was able to read [2 pages + 2 blocks] on
> >>>> my test machine.
> >>>
> >>> My expectation is that dax_direct_access() / dax_recovery_read() has
> >>> installed a temporary UC alias for the pfn, or has temporarily flipped
> >>> NP to UC. Outside of dax_recovery_read() the page will always be NP.
> >>>
> >>
> >> Okay.  Could we only flip the memtype within dax_recovery_read, and
> >> not within dax_direct_access?  dax_direct_access does not need to
> >> access the page.
> >
> > True, dax_direct_access() does not need to do the page permission
> > change, it just needs to indicate if dax_recovery_{read,write}() may
> > be attempted. I was thinking that the DAX pages only float between NP
> > and WB depending on whether poison is present in the page. If
> > dax_recovery_read() wants to do UC reads around the poison it can use
> > ioremap() or vmap() to create a temporary UC alias. The temporary UC
> > alias is only possible if there might be non-clobbered data remaining
> > in the page. I.e. the current "whole_page()" determination in
> > uc_decode_notifier() needs to be plumbed into the PMEM driver so that
> > it can cooperate with a virtualized environment that injects virtual
> > #MC at page granularity. I.e. nfit_handle_mce() is broken in that it
> > only assumes a single cacheline around the failure address is
> > poisoned, it needs that same whole_page() logic.
> >
>
> I'll have to take some time to digest what you proposed, but alas, why
> couldn't we let the correct decision (about NP vs UC) being made when
> the 'whole_page' test has access to the MSi_MISC register, instead of
> having to risk mistakenly change NP->UC in dax_recovery_read() and
> risk to repeat the bug that Tony has fixed?  I mean a PMEM page might
> be legitimately not-accessible due to it might have been unmapped by
> the host, but dax_recovery_read() has no way to know, right?

It should know because the MCE that unmapped the page will have
communicated a "whole_page()" MCE. When dax_recovery_read() goes to
consult the badblocks list to try to read the remaining good data it
will see that every single cacheline is covered by badblocks, so
nothing to read, and no need to establish the UC mapping. So the the
"Tony fix" was incomplete in retrospect. It neglected to update the
NVDIMM badblocks tracking for the whole page case.

> The whole UC <> NP arguments to me seems to be a
>   "UC being harmless/workable solution to DRAM and PMEM"  versus
>   "NP being simpler regardless what risk it brings to PMEM".
> To us, PMEM is not just another driver, it is treated as memory by our
> customer, so why?

It's really not a question of UC vs NP, it's a question of accurately
tracking how many cachelines are clobbered in an MCE event so that
hypervisors can punch out entire pages from any future guest access.
This also raises another problem in my mind, how does the hypervisor
learn that the poison was repaired? Presumably the "Tony fix" was for
a case where the guest thought the page was still accessible, but the
hypervisor wanted the whole thing treated as poison. It may be the
case that we're missing a mechanism to ask the hypervisor to consider
that the guest has cleared the poison. At least for PMEM described by
ACPI the existing ClearError DSM in the guest could be trapped by the
hypervisor to handle this case, but I'm not sure what to do about
guests that later want to use MOVDIR64B to clear errors.
