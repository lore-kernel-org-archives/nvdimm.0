Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E27529CA
	for <nvdimm@lists.linux.dev>; Fri,  1 Oct 2021 16:52:31 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id h1so4361480pfv.12
        for <nvdimm@lists.linux.dev>; Fri, 01 Oct 2021 09:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o822k0eJGiJhfH9+cu7IqnxKV0hd1X9zpJkmtclykIc=;
        b=2THcd3i23IgrmFelSzN24Xiii+Vib/1TMKjTEQP8BT9VvAJubmbw7hz1wKHX619gip
         /EOxbJjdFVWcaydjFPX5U9nZQSoZS3vYdF3N1sKZuwpeTJ4PWtQCMHGv3K7uzCrq2Tl+
         dlPjAELglP7n70Yi8FJpxrv8XI4cKQK0EK0kNzknI3n+TWrCoxdW7BXni3D9+SOMC9nh
         YnhoFOAwgUyBnHnfc/8tlUmNmncLz5PvX7EwNGp008+M+1FgmmviWOwrse+E7fw2FCSt
         6He4z+y46RJcVt8arv0V2thg8nR910N5NpRHboNuEwA0SHsl/GlMALTnnuU1mmBtzqwo
         Njcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o822k0eJGiJhfH9+cu7IqnxKV0hd1X9zpJkmtclykIc=;
        b=U8TmfpBcv55x42yCzf2J79x4wfm/ieUwnG5j2U/ULRXwnrmkfZAtjqbQqYVyKkb0AX
         ucoyDmQwSP7L0+HKoaijeLwoygTvtJIRF47EI9eM8FtT6sgTtUKvRMXNS7+N+DKodU3r
         RTlfFvxrBsNGwLOtc6P31K5JCRD30IGfuYoa5jdVjPwgms6VrN48WmT7LmqJog4v4ZU+
         5peshZ5wmW0QmdZTd7+JyIL2/+qYbHRpA72JJONvG0nuGyBFQXwlARSa+jQ3kOIxgml2
         IBA6cWwGWBA5MbHyXaKU5PhJYqVoJSX90rxYV3eLexb6csNhdSzfr9mU7cklun4SfKSq
         SI/Q==
X-Gm-Message-State: AOAM530yLW6p4szoqCDhlEzqqz3XqIvqiWPGHblPFMDsk/bO5OGwyzaP
	QynzvlZSwjF5P9r/aRLhaE/G762wP30qtgYGbqGoiw==
X-Google-Smtp-Source: ABdhPJwNlei3mTTjxwfLdw4z3UWE5ypht+vCRL+3yll6AcvdxOfNbFtA8T47AEywyX/ndgDfPLwb/r0QcOF3a6/d+lU=
X-Received: by 2002:a62:7f87:0:b0:444:b077:51ef with SMTP id
 a129-20020a627f87000000b00444b07751efmr11034508pfd.61.1633107150966; Fri, 01
 Oct 2021 09:52:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com> <YVYe9xrXiwF3IqB2@zn.tnic>
 <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic> <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic> <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic> <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
 <CAPcyv4j9KH+Y4hperuCwBMLOSPHKfbbku_T8uFNoqiNYrvfRdA@mail.gmail.com> <YVbn3ohRhYkTNdEK@zn.tnic>
In-Reply-To: <YVbn3ohRhYkTNdEK@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Oct 2021 09:52:21 -0700
Message-ID: <CAPcyv4i4r5-0i3gpZxwP7ojndqbrSmebtDcGbo8JR346B-2NpQ@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Borislav Petkov <bp@alien8.de>
Cc: Jane Chu <jane.chu@oracle.com>, "Luck, Tony" <tony.luck@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 1, 2021 at 3:50 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Sep 30, 2021 at 07:02:13PM -0700, Dan Williams wrote:
> > If I understand the proposal correctly Boris is basically saying
> > "figure out how to do your special PMEM stuff in the driver directly
> > and make it so MCE code has no knowledge of the PMEM case".
>
> I don't mind if it has to because of a good reason X - I'm just trying
> to simplify things and not do stuff which is practically unnecessary.
>
> > The flow
> > is:
> >
> > memory_failure(pfn, flags)
> > nfit_handle_mce(...) <--- right now this on mce notifier chain
> > set_mce_nospec(pfn) <--- drop the "whole page" concept
> >
> > This poses a problem because not all memory_failure() paths trigger
> > set_mce_nospec() or the mce notifier chain.
>
> Hmm, so this sounds like more is needed than this small patch.
>
> > If that disconnect happens, attempts to read PMEM pages that have been
> > signalled to memory_failure() will now crash in the driver without
> > workarounds for NP pages.
> >
> > So memory_failure() needs to ensure that it communicates with the
> > driver before any possible NP page attribute changes. I.e. the driver
> > needs to know that regardless of how many cachelines are poisoned the
> > entire page is always unmapped in the direct map.
>
> Ok, so those errors do get reported through MCE so MCE code does need to
> know about them.
>
> So the question is, how should MCE mark them so that the driver can deal
> with them properly.
>
> > Then, when the driver is called with the new RWF_RECOVER_DATA flag, it
> > can set up a new UC alias mapping for the pfn and access the good data
> > in the page while being careful to read around the poisoned cache
> > lines.
>
> See my other mail - that sounds good.
>
> > In my mind this moves the RWF_RECOVER_DATA flag proposal from "nice to
> > have" to "critical for properly coordinating with memory_failure() and
> > mce expectations"
>
> Right, so to reiterate: I don't mind if the MCE code knows about this -
> in the end of the day, it is that code which does the error reporting.
> My goal is to make that reporting and marking optimal so that the driver
> can work with that marking and simplify and document *why* we're doing
> that so that future MCE changes can keep that in mind.
>
> So to sum up: it sounds to me like it should simply mark *whole* pages
> as NC:
>
> 1. this should prevent the spec. access for DRAM.
> 2. PMEM can do UC alias mapping and do sub-page access to salvage data.
>
> How's that?

I think that puts us back in the situation that Tony fixed in:

17fae1294ad9 x86/{mce,mm}: Unmap the entire page if the whole page is
affected and poisoned

...where the clflush in _set_memory_uc() causes more unwanted virtual
#MC injection.

I think that means that we have no choice but to mark the page NP
unconditionally and do the work to ensure that the driver has updated
its poisoned cacheline tracking for data recovery requests.

Right?
