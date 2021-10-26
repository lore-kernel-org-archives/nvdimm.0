Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CF42C9F
	for <nvdimm@lists.linux.dev>; Tue, 26 Oct 2021 17:35:05 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so40611pjb.3
        for <nvdimm@lists.linux.dev>; Tue, 26 Oct 2021 10:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=of5GtbZqbhHVx+dOWsGvvpEIVNxdSQaBpNzwnrsb+Ao=;
        b=xCUtyySmV659y3OQ1UzoNs5pioWuKK9jNxl066g2uPoS+5a36qt0I6esU+8lXztjOw
         aPgxdD6Zi/w+lTehbGFiG6M3KnBDLuoFEU4hp28ZMqaKQgaLya9aZ3DyqGDFsUY4wtwd
         TcFd/Kjgv4/Tj2FoGzikncy4F4GaqvubgASmrqRv/pGVEzDLETqSUSIKO9ZYSLvTcxkY
         QkWQzNIISK8tdBbgcX/bgdZoGcLoc5t+jXRhakbvYX+bX+L+BBKxnLqiaMZRMgB3NPoH
         BcVp4vUJxyrvS7vsBSi5gxCQpjcXNLzDLawGM7MaEi+hFcVWiJfp6cRjhLHTaxrXY6ux
         x18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=of5GtbZqbhHVx+dOWsGvvpEIVNxdSQaBpNzwnrsb+Ao=;
        b=Bw3o/f2kg+ZTEorxluGSm5sLlYRUx5UD9EcX7FwljcjpS3ArwZ0MuH8fzVMHz4GeZR
         YdEMYiWkAH2nx5psudJki+t0mJT+0gWMvrh9owjtUzFzRfHHu+k/EJVLGbHqn5gCH4nU
         OVBFctAoRu6nqh8GXCQF2Ut7Q1nfGwBg64QZvbLLGn7MXa7JcYi4+203bo0OH4sHEnOn
         uqI9AmeswGjatr3TX0taZVGJz7744LKmPvzvrT2wT3H7myCzTgTOaIrFuwnJkUQE5jqc
         AyHZrpUfo8pWrbMBQdkbldB/WoRCluL30Ci9uJrc6EJDoNKrzMoTpwMpNGuCFgym3ois
         9MzQ==
X-Gm-Message-State: AOAM5300FTV+DMAoxkEifQHrKd6NEIJQ8OMU6g+6WQCVH0rPADokJB+R
	LZiAAwjhBR3NSTwWwlRgw54Qbhl305ewLWeWotSBSQ==
X-Google-Smtp-Source: ABdhPJz6b1TQqXnVPsNW0kwH4xwJkTCzWqY09iZhEhC7plTMGhoiQ7DXEfRBokhKtNXhaHwO5xhksNz/0m/FDjsjodY=
X-Received: by 2002:a17:902:8a97:b0:13e:6e77:af59 with SMTP id
 p23-20020a1709028a9700b0013e6e77af59mr23361883plo.4.1635269704573; Tue, 26
 Oct 2021 10:35:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211019073641.2323410-1-hch@lst.de> <20211019073641.2323410-3-hch@lst.de>
 <YXFtwcAC0WyxIWIC@angband.pl> <20211022055515.GA21767@lst.de>
 <CAPcyv4joX3K36ovKn2K95iDtW77jJwoAgAs5JSRMcETff=-brg@mail.gmail.com>
 <CAPcyv4gFCRs_OJ1TutBi-tmWWS2pU_D+bqJVwCcp=7dCMkhGEw@mail.gmail.com> <20211026055352.GA30117@lst.de>
In-Reply-To: <20211026055352.GA30117@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Oct 2021 10:34:53 -0700
Message-ID: <CAPcyv4iuE6xErQJm+eBodsoVWvJdxRAK7k3KcPrzuVjV49CDgQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] memremap: remove support for external pgmap refcounts
To: Christoph Hellwig <hch@lst.de>
Cc: Adam Borowski <kilobyte@angband.pl>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Jens Axboe <axboe@kernel.dk>, 
	Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 25, 2021 at 10:54 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Oct 25, 2021 at 06:42:51PM -0700, Dan Williams wrote:
> > On Fri, Oct 22, 2021 at 8:43 AM Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > On Thu, Oct 21, 2021 at 10:55 PM Christoph Hellwig <hch@lst.de> wrote:
> > > >
> > > > On Thu, Oct 21, 2021 at 03:40:17PM +0200, Adam Borowski wrote:
> > > > > This breaks at least drivers/pci/p2pdma.c:222
> > > >
> > > > Indeed.  I've updated this patch, but the fix we need to urgently
> > > > get into 5.15-rc is the first one only anyway.
> > > >
> > > > nvdimm maintainers, can you please act on it ASAP?
> > >
> > > Yes, I have been pulled in many directions this past week, but I do
> > > plan to get this queued for v5.15-rc7.
> >
> > Ok, this is passing all my tests and will be pushed out to -next tonight.
>
> FYI, patch 2 needs a trivial compile fix for the p2p case.  But I suspect
> given how late in the cycle we are you're only picking up patch 1 anyway.

Yeah, patch1 I'll push for v5.15-final and patch2 for v5.16-rc1. Send
me that fixed up patch and I'll queue it up.
