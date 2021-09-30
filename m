Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1016229CA
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 21:42:02 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id bb10so4981560plb.2
        for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 14:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3cQjmOqGfZtdYEZaumwfTk8rTCTRCH74D0sAAcjl6c4=;
        b=W9F73Hhc78lElknYnacc9pK8Tu7+XDbwFINBOF0YT4yQpUaJ0NYkxiqLT89eGGJ2aK
         u4Pw6tckQ7TgxX0DlVpkyIzqs82BbECT0yPiDaioO7yn9A5rs0S2/3czjCtjkdjpTl7o
         O/oYQutnxDHzUMGB4DVFgYf5ofcQ5PJJIeAGLHz5nn0XlHC9JXpxgHmguBAL90VtOAbb
         CSKnbRV8cX+PkgPwYyfgl1opt1nykXa92/hDkRKu/GI5I7lM3e+dM9DU5H2sfRQdgFxR
         JxThRk8IKmx/bUj9/iJJMT7hEFyGBBhrqMoHXCaNpZs/oZGYEAZkPmxq6MLwTpHb+H7m
         Y3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3cQjmOqGfZtdYEZaumwfTk8rTCTRCH74D0sAAcjl6c4=;
        b=kFf5A8NbVBToThyselqTVASd+HETddRJdSyq4vZdXtnFPvxuye9hVXSWLNGMrPOtnN
         C9ilGqZ8MCaB47mkUOoy79KSeThcwr+ylbgOe+uORm7v5djRzwyQ3DNwUFefoNASjrOk
         kxQBic9Zkm2nGuSn46UzvYsyqQzNRgfREE8WO8IJ0FTjD/y2IWVqtawBcSY3+VTMYosK
         WPnD9ShHagfzX/ouOM7siR/dZngKedec4/0y/Hvs9ropqVXzH8IfNzMdXdt2s8zCpfdR
         SZ9xWVFSTYXiSRPcJSkILX+oSCWHxAwMwPomOXz42zJhoDs8X8RbAcF2/Qg1jczYHG38
         KF/A==
X-Gm-Message-State: AOAM532a3zEti1yfKWplAs9x7vmYFalemmhnOymzgw85lxpDtXBoZl/Z
	7kI6AVqAjdHEo5NXfWoHGWNXS3p0LnXSKBVJ4VLajw==
X-Google-Smtp-Source: ABdhPJysTGx+BfVh/4DjEvNmikWn9MDRcSBm0RA5+CM9eA9+w9h1/dlICqtttp1BcGIWgyEBSVjtwKnjmeOa2JKJz90=
X-Received: by 2002:a17:902:e80f:b0:13b:721d:f750 with SMTP id
 u15-20020a170902e80f00b0013b721df750mr6343278plg.18.1633038122448; Thu, 30
 Sep 2021 14:42:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YVXxr3e3shdFqOox@zn.tnic> <3b3266266835447aa668a244ae4e1baf@intel.com>
 <YVYQPtQrlKFCXPyd@zn.tnic> <33502a16719f42aa9664c569de4533df@intel.com>
 <YVYXjoP0n1VTzCV7@zn.tnic> <2c4ccae722024a2fbfb9af4f877f4cbf@intel.com>
 <YVYe9xrXiwF3IqB2@zn.tnic> <CAPcyv4iHmcYV6Dc35Rfp_k9oMsr9qWEdALFs70-bNOvZK00f9A@mail.gmail.com>
 <YVYj8PpzIIo1qu1U@zn.tnic> <CAPcyv4jEby_ifqgPyfbSgouLJKseNRCCN=rcLHze_Y4X8BZC7g@mail.gmail.com>
 <YVYqJZhBiTMXezZJ@zn.tnic>
In-Reply-To: <YVYqJZhBiTMXezZJ@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Sep 2021 14:41:52 -0700
Message-ID: <CAPcyv4heNPRqA-2SMsMVc4w7xGo=xgu05yD2nsVbCwGELa-0hQ@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 30, 2021 at 2:21 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Sep 30, 2021 at 02:05:49PM -0700, Dan Williams wrote:
> > I.e. it's fine
>
> A lot of things are fine - question is, what makes sense and what makes
> this thing as simple as required to be.
>
> > if a DRAM page with a single cacheline error only gets marked UC.
> > Speculation is disabled and the page allocator will still throw it
> > away and never use it again.
>
> Normal DRAM is poisoned as a whole page, as we established.

It is not in all cases, as I read:

17fae1294ad9 x86/{mce,mm}: Unmap the entire page if the whole page is
affected and poisoned

...it is MSi_MISC that determines what happens and MSi_MISC is not
memory-type aware.

> So whatever
> it is marked with - UC or NP - it probably doesn't matter. But since
> the page won't be ever used, then that page is practically not present.
> So I say, let's mark normal DRAM pages which have been poisoned as not
> present and be done with it. Period.

Where would this routine learn the memory type? Pass it in via
memory_failure(), to what end?

> > Similarly NP is fine for PMEM when the machine-check-registers
> > indicate that the entire page is full of poison. The driver will
> > record that and block any attempt to recover any data in that page.
>
> So this is still kinda weird. We will mark it with either NP or UC but
> the driver has some special knowledge how to tiptoe around poison. So
> for simplicity, let's mark it with whatever fits best and be done with
> it - driver can handle it just fine.
>
> I hope you're cathing my drift: it doesn't really matter what's possible
> wrt marking - it matters what the practical side of the whole thing
> is wrt further page handling and recovery action. And we should do
> here whatever does not impede that further page handling even if other
> markings are possible.
>
> Ok?

I'm sorry, but I'm not tracking.

set_mce_nospec() just wants to prevent speculative consumption of
poison going forward. It has 2 options NP and UC. UC is suitable for
DRAM and desired for PMEM as long as MSi_MISC indicates a sub-page
size poison event.

If you want set_mce_nospec() to specify NP for the page even when
MSi_MISC indicates sub-page blast radius it would require extra
plumbing to convey the memory type to set_mce_nospec().

I fail to see the point of that extra plumbing when MSi_MISC
indicating "whole_page", or not is sufficient. What am I missing?
