Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9420F2FAE
	for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 19:41:26 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so5615618pjb.1
        for <nvdimm@lists.linux.dev>; Thu, 30 Sep 2021 12:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SYij1MM1Y/2PJo3VKxGFT4E7qRMlwkgkKqifnJ3bvrA=;
        b=yCruSBk6Sqx0TkJS3wA9xeAlOfPDV9kacYbEW+mre5mooHFZQQVA8TiYK5xLN9mknm
         2pc5nm9wykW0hnTxtbSCbbBu65AQ1kkJ1fSWvAavElNZm7wDNbzfaXSAPElhn8Am5mjH
         0e5UrBqD9Kb6D9ZQPNZboAfuWA5qp85DPQk0a/rJ11K+vJfrqbIZk6Qiw3HBt2Le0Dc7
         0MsjtfEVrf3dI0yzEN2IDEhBKb3MCCTFB61LAEaS/R5kPXsZwYKlxybZYenPY/djnGdb
         jDo+Q9Tg9ZmnCkXfEZv2PEKARD+dgHqTZBKF7SbtibMCIBP9HJtV983HGqqLFVfbQjWx
         KcIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SYij1MM1Y/2PJo3VKxGFT4E7qRMlwkgkKqifnJ3bvrA=;
        b=CHgAy2Znfr2PeZEZfkcgqWyzfD1RqpOH5mFRTsm2LMxS2csTeajyqslBru7QyJ+XU0
         sH8MLHusS/vZfxN2BgrLmyw36YJz4H3B0PvaKeY/FPj+Of3HT5XafEFWCNUtt6IGID+n
         uRclyHUppXNvOOGSKR9cIQ7mNcM8S5Mx9T9HmmyBWdIh75vdSxpibDqPvoqL5aQD/YYp
         VIeqRG+ksieIyZGEcY7i/Cilsy6m+EqvIVkv99vJ+xrPA2cpwdLcS6WXNQBMwEnbDaJf
         Q+MtWgv8wDQUcHn8eNXpcifTmR8ATBH+vPy9KDz05RkA5KMK8tjsbAj2ME26CQBOwoW5
         Mlfg==
X-Gm-Message-State: AOAM533pncRQn2xqlmz/Cv0UV27PR3jHZRwNkRxdYlUx64BjC4n112l8
	kcGOUTf+8s/AAi0iSoEK+zTRA85AlWwwQ8qpV4gR+g==
X-Google-Smtp-Source: ABdhPJzZm1qX/Rrt928DDBI/2XbtLIEB7ccaEPS+EIb5oGCXn4POHdB7lFGnorGvgTyrbSftbgzxzQkhWkK6ErnucPw=
X-Received: by 2002:a17:90b:3ec3:: with SMTP id rm3mr7427901pjb.93.1633030886056;
 Thu, 30 Sep 2021 12:41:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
 <YT8n+ae3lBQjqoDs@zn.tnic> <CAPcyv4hNzR8ExvYxguvyu6N6Md1x0QVSnDF_5G1WSruK=gvgEA@mail.gmail.com>
 <YUHN1DqsgApckZ/R@zn.tnic> <CAPcyv4hABimEQ3z7HNjaQBWNtq7yhEXe=nbRx-N_xCuTZ1D_-g@mail.gmail.com>
 <YUR8RTx9blI2ezvQ@zn.tnic> <CAPcyv4jOk_Ej5op9ZZM+=OCitUsmp0RCZNH=PFqYTCoUeXXCCg@mail.gmail.com>
 <YVXxr3e3shdFqOox@zn.tnic> <3b3266266835447aa668a244ae4e1baf@intel.com> <YVYQPtQrlKFCXPyd@zn.tnic>
In-Reply-To: <YVYQPtQrlKFCXPyd@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 Sep 2021 12:41:15 -0700
Message-ID: <CAPcyv4gBAZiT-PW5wF_jjZzM_HEc4XDMTiznQN8KBgF5GozNOA@mail.gmail.com>
Subject: Re: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 30, 2021 at 12:30 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Sep 30, 2021 at 05:28:12PM +0000, Luck, Tony wrote:
> > > Question is, can we even access a hwpoisoned page to retrieve that data
> > > or are we completely in the wrong weeds here? Tony?
> >
> > Hardware scope for poison is a cache line (64 bytes for DDR, may be larger
> > for the internals of 3D-Xpoint memory).
>
> I don't mean from the hw aspect but from the OS one: my simple thinking
> is, *if* a page is marked as HW poison, any further mapping or accessing
> of the page frame is prevented by the mm code.
>
> So you can't access *any* bits there so why do we even bother with whole
> or not whole page? Page is gone...

I think the disconnect is that in the
typical-memory-from-the-page-allocator case it's ok to throw away the
whole page and get another one, they are interchangeable. In the PMEM
case they are not, they are fixed physical offsets known to things
like filesystem-metadata. So PageHWPoison in this latter case is just
a flag to indicate that poison mitigations are in effect, page marked
UC or NP, and the owner of that page, PMEM driver, knows how to
navigate around that poison to maximize data recovery flows. The owner
of the page in the latter / typical case, page allocator, says "bah,
I'll just throw the whole thing away because there's no chance at
repair and consumers can just as well use a different pfn for the same
role."
