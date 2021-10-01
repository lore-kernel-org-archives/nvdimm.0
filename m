Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27722FAE
	for <nvdimm@lists.linux.dev>; Fri,  1 Oct 2021 02:02:24 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id q23so6588288pfs.9
        for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 19:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uWbjmqIQa2reMVNjIo6F/5ZGADfxEbHbUISfX46rOmM=;
        b=FmbXYtcpfERu0PrQD9kTpqky8Ds3TACfFnhkXAroJVW7lGNcZwE8a6M3dZvB9yAKUq
         fjbej6mhcTpjylaMk5Gqyuk8/GcRmbu8FpNOf+SgZeO8x3v1vu2kaQm5JA2HFCmOrMgB
         fYCaqnA9ml32nYCGdZQgInnBHrTK2Q+8GpK1cO96a7W8m+SQvepjzrhTro9R9Ll0xgTS
         XiykTBx+8gVbW/9Bhx4pefI//frP6aoYmn5jA8FkpXny7qJmVqw4R/4npaH8b7xmdik2
         sjEyAJDTDIxQcEiqdGHw1e0V//G4mepbk1Ali/wXmTJEYmH2JubVAIiCGsiwrUT+W78q
         DIhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uWbjmqIQa2reMVNjIo6F/5ZGADfxEbHbUISfX46rOmM=;
        b=kDd2VMAKD+rjkbwNCnumwpesQM65nWUw/gXeFY13bli64thX7JnM+5VWe4g2smy39E
         MOpIY1HEXRbvr7i1eA4Iu4QPndvDAGKZNt5FgaUJJKFVnxNWUmPkb/LA+2g0A42+NMp1
         ftKSuXf2myuWY2irwhd6NQlI7ntEtT/qbIxtdLyCrVH1r9Z8MTZfmbLgJPFZ7i/i0ZfD
         EPChnJdE7B44xagJ+TS6aYE9DOMrWbGhD0SryQts3xroV6dKR24hnYyyKscqWtYvTvmI
         EEe4ofKvXXohxNkAMWtFwft32wJHagofgxwGQGOCYkjceydQ+NIQj9QJRhjvH1mitd1C
         4eNw==
X-Gm-Message-State: AOAM532HtEK4Rr6Bzu1NisrQUswFJ28KsOF/vyBw1H2v7odNU3mIRNJ+
	taE/X07yyxMJaoRl0jc3B+Gyn11HQ0dFfcWDJHyjWA==
X-Google-Smtp-Source: ABdhPJzpuIw/AtHIgY4B0Y6qRu+AcldPAbLVsH2sibeM9Ocf40D3lTO65Kk/MqoP0nHGYMoI7Fcmtjfk5TWmhgTYxDA=
X-Received: by 2002:a63:d709:: with SMTP id d9mr7576700pgg.377.1633053744075;
 Thu, 30 Sep 2021 19:02:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YVYQPtQrlKFCXPyd@zn.tnic> <33502a16719f42aa9664c569de4533df@intel.com>
 <YVYXjoP0n1VTzCV7@zn.tnic> <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>
 <YVYe9xrXiwF3IqB2@zn.tnic> <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic> <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic> <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
 <YVY7wY/mhMiRLATk@zn.tnic> <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
In-Reply-To: <ba3b12bf-c71e-7422-e205-258e96f29be5@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Sep 2021 19:02:13 -0700
Message-ID: <CAPcyv4j9KH+Y4hperuCwBMLOSPHKfbbku_T8uFNoqiNYrvfRdA@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, "Luck, Tony" <tony.luck@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 30, 2021 at 5:43 PM Jane Chu <jane.chu@oracle.com> wrote:
>
>
> On 9/30/2021 3:35 PM, Borislav Petkov wrote:
> > On Thu, Sep 30, 2021 at 02:41:52PM -0700, Dan Williams wrote:
> >> I fail to see the point of that extra plumbing when MSi_MISC
> >> indicating "whole_page", or not is sufficient. What am I missing?
> >
> > I think you're looking at it from the wrong side... (or it is too late
> > here, but we'll see). Forget how a memory type can be mapped but think
> > about how the recovery action looks like.
> >
> > - DRAM: when a DRAM page is poisoned, it is only poisoned as a whole
> > page by memory_failure(). whole_page is always true here, no matter what
> > the hardware says because we don't and cannot do any sub-page recovery
> > actions. So it doesn't matter how we map it, UC, NP... I suggested NP
> > because the page is practically not present if you want to access it
> > because mm won't allow it...
> >
> > - PMEM: reportedly, we can do sub-page recovery here so PMEM should be
> > mapped in the way it is better for the recovery action to work.
> >
> > In both cases, the recovery action should control how the memory type is
> > mapped.
> >
> > Now, you say we cannot know the memory type when the error gets
> > reported.
> >
> > And I say: for simplicity's sake, we simply go and work with whole
> > pages. Always. That is the case anyway for DRAM.
>
> Sorry, please correct me if I misunderstand. The DRAM poison handling
> at page frame granularity is a helpless compromise due to lack of
> guarantee to decipher the precise error blast radius given all
> types of DRAM and architectures, right?  But that's not true for
> the PMEM case. So why should PMEM poison handling follow the lead
> of DRAM?

If I understand the proposal correctly Boris is basically saying
"figure out how to do your special PMEM stuff in the driver directly
and make it so MCE code has no knowledge of the PMEM case". The flow
is:

memory_failure(pfn, flags)
nfit_handle_mce(...) <--- right now this on mce notifier chain
set_mce_nospec(pfn) <--- drop the "whole page" concept

This poses a problem because not all memory_failure() paths trigger
set_mce_nospec() or the mce notifier chain. If that disconnect
happens, attempts to read PMEM pages that have been signalled to
memory_failure() will now crash in the driver without workarounds for
NP pages.

So memory_failure() needs to ensure that it communicates with the
driver before any possible NP page attribute changes. I.e. the driver
needs to know that regardless of how many cachelines are poisoned the
entire page is always unmapped in the direct map.

Then, when the driver is called with the new RWF_RECOVER_DATA flag, it
can set up a new UC alias mapping for the pfn and access the good data
in the page while being careful to read around the poisoned cache
lines.

In my mind this moves the RWF_RECOVER_DATA flag proposal from "nice to
have" to "critical for properly coordinating with memory_failure() and
mce expectations"
