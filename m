Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C87D29CA
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 21:05:59 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id s16so6138336pfk.0
        for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 14:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vaQVQxeY/oYNlxuN6MqVHazuPbn0qOsOuC4s9sluQm8=;
        b=PB5BQbyaMOnMxqgW09QZ14FkrG7oVURfVM69oQYrvnzVNcV7NvSdLvpvv/sv2u/tHc
         BmHpZKprpS4RJfF5eFU5EJFj3JwirudvfGf4SoRGTLKvCM98+6yTd5XHIodASyKUgxa4
         9aV3ZeyCo3+v7TeRYOofwQsYLxvM38cPskh/pKethX5vRElVUj9g1bOhdKa5IbFCxBOb
         RZXHqPumfeX3CJXbI33r/KJ8JAOKKo58piabVJEkhiFS+vsnuukiFFML+7NJ4DwdzfdL
         aI+xhHFPw87XurdpNV+/dSswER601hm6po0BRsJoXhNaqKJrjBWwvrLEbzYHRyj1E/Ii
         usuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vaQVQxeY/oYNlxuN6MqVHazuPbn0qOsOuC4s9sluQm8=;
        b=RNLbU8YUo2U3Gz5wVCMtarV9RWl+NhfgOuNvWLMFA5LLWu4+8yKHiVyTiPfDAKsLgX
         AGlWtIWMM3AOYPXYLDt2RMh1JofJbkYfsnTRscu2NFQ6z3k0ESrvdXmWgwb/YzIIKdli
         m0sYmuzarfIThHqHcPfdhhZNBKzgSo8ZodMgakSYMNuJkV8Ui2kY8cLIQnxXqhI8gRkZ
         rdK/yVLHLfCocOcq/jtWVeKPWxDF5uSuuNWg+qAc4W2uXOzpxSwH7ibOyj9SEnXrWCL1
         nWNQGVwGse9U/S4M9/VG/ZD++/6wPUB0rFmu5gZJNw4oo7I6KYJzGghWAle9c3YhSMrk
         m0fw==
X-Gm-Message-State: AOAM532iNdZBfcOKj+44HXM92u3/na/LzvHGWGA/iWIAEP65O/MGG2uq
	XhlosaL1X28uhMoke2QUAKXev73/t3rxEiZzgPm87ptCzHg=
X-Google-Smtp-Source: ABdhPJxw4QrkH4bD+0nrvpMnfY1YC2IGNSI+w7lPIFQ5aOLN7MtrvAG3pAV355Be7puFaMygFHSpQoZcpE/QyHxfpEk=
X-Received: by 2002:a63:1262:: with SMTP id 34mr6598223pgs.356.1633035959408;
 Thu, 30 Sep 2021 14:05:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YUR8RTx9blI2ezvQ@zn.tnic> <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
 <YVXxr3e3shdFqOox@zn.tnic> <3b3266266835447aa668a244ae4e1baf@intel.com>
 <YVYQPtQrlKFCXPyd@zn.tnic> <33502a16719f42aa9664c569de4533df@intel.com>
 <YVYXjoP0n1VTzCV7@zn.tnic> <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>
 <YVYe9xrXiwF3IqB2@zn.tnic> <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic>
In-Reply-To: <YVYj8PpzIIo1qu1U@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Sep 2021 14:05:49 -0700
Message-ID: <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 30, 2021 at 1:54 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Sep 30, 2021 at 01:39:03PM -0700, Dan Williams wrote:
> > Yes, that's a good way to think about it. The only way to avoid poison
> > for page allocator pages is to just ditch the page. In the case of
> > PMEM the driver can do this fine grained dance because it gets precise
> > sub-page poison lists to consult and implements a non-mmap path to
> > access the page contents.
>
> Ok, good.
>
> Now, before we do anything further here, I'd like for this very much
> non-obvious situation to be documented in detail so that we know what's
> going on there and what that whole_page notion even means. Because this
> is at least bending the meaning of page states like poison and what that
> really means for the underlying thing - PMEM or general purpose DIMMs.

Hmm, memory type does not matter in this path.

>
> And then that test could be something like:
>
>         /*
>          * Normal DRAM gets poisoned as a whole page, yadda yadda...

No, the whole_page case is equally relevant for PMEM...

>          /
>         if (whole_page) {
>
>         /*
>          * Special handling for PMEM case, driver can handle accessing sub-page ranges
>          * even if the whole "page" is poisoned, blabla
>         } else {

...and UC is acceptable to DRAM.

>                 rc = _set_memory_uc(decoy_addr, 1);
>         ...
>
> so that it is crystal clear what's going on there.
>

The only distinction that matters here is whether the reported
blast-radius of the poison reported by the hardware is a sub-page or
whole-page. Memory type does not matter.

I.e. it's fine if a DRAM page with a single cacheline error only gets
marked UC. Speculation is disabled and the page allocator will still
throw it away and never use it again. Similarly NP is fine for PMEM
when the machine-check-registers indicate that the entire page is full
of poison. The driver will record that and block any attempt to
recover any data in that page.
