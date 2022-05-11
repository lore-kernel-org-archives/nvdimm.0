Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DC115A7
	for <nvdimm@lists.linux.dev>; Wed, 11 May 2022 01:56:02 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id j6so680774pfe.13
        for <nvdimm@lists.linux.dev>; Tue, 10 May 2022 18:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TkVkCo+AEqF0i40htkHNCtoH0Rbet/ikc5+1DL9KmSo=;
        b=Hi5aqq1+m/Ej+vEenvxjgpdjskjWHa8HcLWWVrtyiqSRIgdPRYcdyTMaLzlDyQMAKz
         hlTV9+BhNIFpEMn3zSVZWxWdrXpT2fH5AFkxhKaw3lHtgS3Vux29n80lupydfOUZD67S
         xaDCcCpZYZmO17Upd/ga/rOBpLackfaJj+oiKTcWZ53uEetfaIi+btgGotGImVV69IqN
         lnv4N0Kx2TQayXO2t/IA1LNXLRMllhs2tpW1+kEDqvGIhc7+Tv6Qybg1MjvOZV1bQFuR
         L/6GLMXKGmf8Cn5kzsJLn2NNPN3ugYfuVN51A5bMRmdo5/VQf2sfe9fivmRpGFtiIjB2
         po6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TkVkCo+AEqF0i40htkHNCtoH0Rbet/ikc5+1DL9KmSo=;
        b=T8lIpSuec8Ddv3uc/lDmCItJjDinHrEaZzgBAncbhi7J7chqMVzfTWadKBQaoiD6qB
         9ovfjyMpDZThtJpmXKbBRsSJ6uRZf3Zz3Jws+JgZxnoeddZd3d1kGk/dRODDiBbqen+q
         xW0PpPEVqcPgXcrAcFv8Qe1Y7ZL4C4c4Ru714ntzMu552MFc/CXCg6ZxWs66uvK12bEN
         mdYHJJB302NO1770jc0BRoecvl/ySPE/ETzO50f8ZDCaeHfIm6kgez98RvK4C0kiavGF
         NmvHk8Q7rB20JNV1DjXxOYsCC3ow1YikoktHQf+hYMVEmTGEEWPMjBhWd+iIx3Lyx4z/
         2PdA==
X-Gm-Message-State: AOAM532cY1snhiJjSyAzyFbLUZdUfELqANuoXYI8C0Tz3nqhNA5XztGy
	gwH4D6dTV4mOmwA31JkN9AFJ5th+C379jlZvYuLA7w==
X-Google-Smtp-Source: ABdhPJxTwIrZK3os2Y5Gy2M9XbVTxVNnvEv6gF+cVyLYFsVX8OyNesDt7qGu7dcx91JA1iqzYWRqknggbdHvQFq8KGg=
X-Received: by 2002:a05:6a00:22d4:b0:510:6d75:e3da with SMTP id
 f20-20020a056a0022d400b005106d75e3damr23281842pfj.3.1652234161869; Tue, 10
 May 2022 18:56:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
 <20220511000352.GY27195@magnolia> <20220511014818.GE1098723@dread.disaster.area>
In-Reply-To: <20220511014818.GE1098723@dread.disaster.area>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 May 2022 18:55:50 -0700
Message-ID: <CAPcyv4h0a3aT3XH9qCBW3nbT4K3EwQvBSD_oX5W=55_x24-wFA@mail.gmail.com>
Subject: Re: [PATCHSETS] v14 fsdax-rmap + v11 fsdax-reflink
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Jane Chu <jane.chu@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>, 
	Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	Naoya Horiguchi <naoya.horiguchi@nec.com>, linmiaohe@huawei.com, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

[ add Andrew ]


On Tue, May 10, 2022 at 6:49 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, May 10, 2022 at 05:03:52PM -0700, Darrick J. Wong wrote:
> > On Sun, May 08, 2022 at 10:36:06PM +0800, Shiyang Ruan wrote:
> > > This is a combination of two patchsets:
> > >  1.fsdax-rmap: https://lore.kernel.org/linux-xfs/20220419045045.1664996-1-ruansy.fnst@fujitsu.com/
> > >  2.fsdax-reflink: https://lore.kernel.org/linux-xfs/20210928062311.4012070-1-ruansy.fnst@fujitsu.com/
> > >
> > >  Changes since v13 of fsdax-rmap:
> > >   1. Fixed mistakes during rebasing code to latest next-
> > >   2. Rebased to next-20220504
> > >
> > >  Changes since v10 of fsdax-reflink:
> > >   1. Rebased to next-20220504 and fsdax-rmap
> > >   2. Dropped a needless cleanup patch: 'fsdax: Convert dax_iomap_zero to
> > >       iter model'
> > >   3. Fixed many conflicts during rebasing
> > >   4. Fixed a dedupe bug in Patch 05: the actuall length to compare could be
> > >       shorter than smap->length or dmap->length.
> > >   PS: There are many changes during rebasing.  I think it's better to
> > >       review again.
> > >
> > > ==
> > > Shiyang Ruan (14):
> > >   fsdax-rmap:
> > >     dax: Introduce holder for dax_device
> > >     mm: factor helpers for memory_failure_dev_pagemap
> > >     pagemap,pmem: Introduce ->memory_failure()
> > >     fsdax: Introduce dax_lock_mapping_entry()
> > >     mm: Introduce mf_dax_kill_procs() for fsdax case
> >
> > Hmm.  This patchset touches at least the dax, pagecache, and xfs
> > subsystems.  Assuming it's too late for 5.19, how should we stage this
> > for 5.20?
>
> Yeah, it's past my "last date for this merge cycle" which was
> -rc6. I expected stuff might slip a little - as it has with the LARP
> code - but I don't have the time and bandwidth to start working
> on merging another feature from scratch before the merge window
> comes around.
>
> Getting the dax+reflink stuff in this cycle was always an optimistic
> stretch, but I wanted to try so that there was no doubt it would be
> ready for merge in the next cycle...
>
> > I could just add the entire series to iomap-5.20-merge and base the
> > xfs-5.20-merge off of that?  But I'm not sure what else might be landing
> > in the other subsystems, so I'm open to input.
>
> It'll need to be a stable branch somewhere, but I don't think it
> really matters where al long as it's merged into the xfs for-next
> tree so it gets filesystem test coverage...

So how about let the notify_failure() bits go through -mm this cycle,
if Andrew will have it, and then the reflnk work has a clean v5.19-rc1
baseline to build from?
