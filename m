Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C95033C3
	for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 21:24:01 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id r9so2605615pjo.5
        for <nvdimm@lists.linux.dev>; Tue, 26 Apr 2022 14:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TsSa6VaLs57dKmXg2s3pxn9dn7rByUkVCtFDZcxwerc=;
        b=pe9wDomjTOToFeLKVTleftcgp7m2fRZrmKr5KPQ0nv2E4uDfTacDuvXuZqc358uPcC
         SB6f3bmnQSwDmID1QpkqGSpLppvitE8INvcPu7kvcCGO5vvGf7ivOQq1VBAqSOUyObfB
         s4Myf19fUwSzcncdyDnFQZg97tMcWbgLCReWQPr3NCesYY+N7WtLmt3ma1zIb/f4BEtI
         nJLy416HKLPh2pCOrb+RCZNRakcpJGa+rRmNpsNU+MWh09wdzMLnaII0qHf1bvgGdRlG
         n2P6zg8Ou5uZsIaZAWRk831jKnOfjoSEsRVi1TtILdYn0AIcYy4Q6/ObK1I3WOh3S4cU
         OGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TsSa6VaLs57dKmXg2s3pxn9dn7rByUkVCtFDZcxwerc=;
        b=6iwYZoxJcSt4I5I48W3sI6TiPHYyYDD5MShoN0gu7R8MgSzigRWtuW5BeI8bT/Ib9d
         SuJUKKR7M1aEEYghMJ3ia526L8ei5nDqFz5uGO4Ndac1ZyHWQIglbYhS6t2BDqlOR4gJ
         SO1IbFGYmyRrv2zAcaLvW/ejra7rnu/DPJCps5N0vy4GH3n8VeEX+PGjd/ErvNY6SUZB
         o0TyHuhPfkXXv6q2wvIZ9Hdi6SLHaGXRI22rtuwoQGn3EcR+iQQLxiFMsfJOVUJ2adDk
         DaMepm8r6e7H/TkhHl+vI5AUAha+rV6uIB//gHVBANDzLkFj7lnPVo362rWwbrS+e5cR
         /r8w==
X-Gm-Message-State: AOAM532sq+I5pzZfSY5CwfPnqRruiD97wXz99I+gGXKF9zwiy3gYZxwI
	/6vG5BzcW00zSp1WzjotekIFToD+2VLOU5mFz+9pEXSjFQI=
X-Google-Smtp-Source: ABdhPJxDuXKGfzq/ZEbILVEYB+Fb9rZrT41tq9CNRe5th74iRMvHtTp0UuSIUtyqxXi0DX/Ng600qUrs8+wE5KP991Y=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr25218680pll.132.1651008240570; Tue, 26
 Apr 2022 14:24:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <PH0PR18MB50713BB676BBFCBAD8C1C05BA9FB9@PH0PR18MB5071.namprd18.prod.outlook.com>
In-Reply-To: <PH0PR18MB50713BB676BBFCBAD8C1C05BA9FB9@PH0PR18MB5071.namprd18.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Apr 2022 14:23:49 -0700
Message-ID: <CAPcyv4hGWAHBth+yF4DoEuyZN-O3-Tsfy4BU9PCyoTwaY-kKWw@mail.gmail.com>
Subject: Re: How to map my PCIe memory as a devdax device (/dev/daxX.Y)
To: An Sarpal <ansrk2001@hotmail.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 26, 2022 at 1:58 PM An Sarpal <ansrk2001@hotmail.com> wrote:
>
> I have a PCIe FPGA device (single function) that has a 2GB RAM mapped via a single 64-bit PCIe BAR of length 2GB.
>
> I would like to make this memory available as /dev/daxX.Y character device so some applications that I already have that work with these character devices can be used.
>
> I am thinking of modifying drivers/dax/device.c for my implementation.
>
> To test drivers/dax/device.c, I added memmap to my kernel command line and rebooted. I noticed I have /dev/pmem0 of the same length show up. ndctl shows this device. This is obviously of type fsdax.
> I then ran ndctl create-namespace -mem=devdax on this device which converted it to /dev/daxX.Y.
>
> When I ran ndctl that converted from fsdax to devdax, I noticed that the probe routine was called with the base and length as expected.
>
> So I am hoping using drivers/dax/device.c is the best way to go to expose my PCIe memory as /dev/daxX.Y.

That will give the *appearance* that a PCI BAR is acting as memory,
but it will break in subtle and unpredictable ways due to the lack of
cache coherence for PCI memory. So there is no way to safely expose
PCIe memory as general "System RAM" like other DDR.
