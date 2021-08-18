Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC432FAF
	for <nvdimm@lists.linux.dev>; Wed, 18 Aug 2021 17:11:02 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id i21so2797486pfd.8
        for <nvdimm@lists.linux.dev>; Wed, 18 Aug 2021 10:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a0h+TEUN+dwMuxMWfVo3bvlWUMIfpZXCfROxPjF14kk=;
        b=jDsABRYgBIIzrUssvhLgBVDGZE0Cf22oHKeXq227eBIsN2vBP9YrH/iXeV5oktQ1wT
         MDOsGDHaFL+mNosGVecwy6VMOUWLYny6ZrO/00J9/0F759bmWDSQCihcQ1MjVA6f2xpW
         agQZlkMoQK959gPQ5CKqAi/+MkBvk1YivITLoknQj4KYHgw74XQDL3qjxl4tpMYtvejl
         tjRH2ZHWo1jP3P4njwM94m2JVxmh0FimSMyqzoyCdqqIzO7Fa/CCjv5bEHYm7vMOipfO
         eYkEZ7cUvaJCVuf2qCApHQrS9TcUMGKlSKOzom110bFoLwum/gYX12zdGlb04yShzMrm
         KAsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a0h+TEUN+dwMuxMWfVo3bvlWUMIfpZXCfROxPjF14kk=;
        b=HVcSRIybQeO13M5JgKaL4aA+gCrySvm5ulqRF80THSMWL7oMV0VV1UqupZf48e/MaH
         4H1YQFnR4kLzJqXL1GaP+PP01+CaIFMm7qc7xaO0AQwftogHaHVv1gXA/bPO3Po13btw
         wMYVmfUhnannZhNpCL6v29Nw8OR3vAgnRMtfLmSdmYLGHTPPQmeuU/1fi5/wqjrWvFqb
         rfIgC2AkEEyEWOwqU8MG2laqyX/HI4+ES3zZSGzGWaERGNsX8Yfuw3Zfz3zGvuvJ2AXu
         wNIVZuPkW363FIQEbBwyk4S9IZQD+ATgbEsZuIUEP5M40/qHW2pX5gOf9cvhZ/YNYH2Z
         rayg==
X-Gm-Message-State: AOAM532mDorrSUXwUtf4wV7LOwz0i9yeYjdwGgqZh/HJ3KWYsmZ0g43I
	ZJkCRsl3KVRe04TZ5THsl1ccDi1RrC35g9AwFhNF3w==
X-Google-Smtp-Source: ABdhPJzdnb/dj0te4AmEpXNnOuagyYA3beOwcj2486U3TAeBRF2kxocNgKDFE/I3ReZg4NnJJpeR0A7dwtzSQubN+nk=
X-Received: by 2002:a05:6a00:16c6:b029:32d:e190:9dd0 with SMTP id
 l6-20020a056a0016c6b029032de1909dd0mr10326420pfc.70.1629306662392; Wed, 18
 Aug 2021 10:11:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
 <20210730100158.3117319-2-ruansy.fnst@fujitsu.com> <1d286104-28f4-d442-efed-4344eb8fa5a1@oracle.com>
 <de19af2a-e9e6-0d43-8b14-c13b9ec38a9d@oracle.com> <beee643c-0fd9-b0f7-5330-0d64bde499d3@oracle.com>
 <78c22960-3f6d-8e5d-890a-72915236bedc@oracle.com> <OSBPR01MB2920AD0C7FD02E238D0C387AF4FF9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB2920AD0C7FD02E238D0C387AF4FF9@OSBPR01MB2920.jpnprd01.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 Aug 2021 10:10:51 -0700
Message-ID: <CAPcyv4gS=sYbC3gzMN0uQ5SAhDJ8CAC81tz7AtMueqLfuzGDOw@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 1/9] pagemap: Introduce ->memory_failure()
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Cc: Jane Chu <jane.chu@oracle.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, 
	"djwong@kernel.org" <djwong@kernel.org>, "david@fromorbit.com" <david@fromorbit.com>, "hch@lst.de" <hch@lst.de>, 
	"agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 18, 2021 at 12:52 AM ruansy.fnst@fujitsu.com
<ruansy.fnst@fujitsu.com> wrote:
>
>
>
> > -----Original Message-----
> > From: Jane Chu <jane.chu@oracle.com>
> > Subject: Re: [PATCH RESEND v6 1/9] pagemap: Introduce ->memory_failure()
> >
> >
> > On 8/17/2021 10:43 PM, Jane Chu wrote:
> > > More information -
> > >
> > > On 8/16/2021 10:20 AM, Jane Chu wrote:
> > >> Hi, ShiYang,
> > >>
> > >> So I applied the v6 patch series to my 5.14-rc3 as it's what you
> > >> indicated is what v6 was based at, and injected a hardware poison.
> > >>
> > >> I'm seeing the same problem that was reported a while ago after the
> > >> poison was consumed - in the SIGBUS payload, the si_addr is missing:
> > >>
> > >> ** SIGBUS(7): canjmp=1, whichstep=0, **
> > >> ** si_addr(0x(nil)), si_lsb(0xC), si_code(0x4, BUS_MCEERR_AR) **
> > >>
> > >> The si_addr ought to be 0x7f6568000000 - the vaddr of the first page
> > >> in this case.
> > >
> > > The failure came from here :
> > >
> > > [PATCH RESEND v6 6/9] xfs: Implement ->notify_failure() for XFS
> > >
> > > +static int
> > > +xfs_dax_notify_failure(
> > > ...
> > > +    if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> > > +        xfs_warn(mp, "notify_failure() needs rmapbt enabled!");
> > > +        return -EOPNOTSUPP;
> > > +    }
> > >
> > > I am not familiar with XFS, but I have a few questions I hope to get
> > > answers -
> > >
> > > 1) What does it take and cost to make
> > >     xfs_sb_version_hasrmapbt(&mp->m_sb) to return true?
>
> Enable rmpabt feature when making xfs filesystem
>    `mkfs.xfs -m rmapbt=1 /path/to/device`
> BTW, reflink is enabled by default.
>
> > >
> > > 2) For a running environment that fails the above check, is it
> > >     okay to leave the poison handle in limbo and why?
> It will fall back to the old handler.  I think you have already known it.
>
> > >
> > > 3) If the above regression is not acceptable, any potential remedy?
> >
> > How about moving the check to prior to the notifier registration?
> > And register only if the check is passed?  This seems better than an
> > alternative which is to fall back to the legacy memory_failure handling in case
> > the filesystem returns -EOPNOTSUPP.
>
> Sounds like a nice solution.  I think I can add an is_notify_supported() interface in dax_holder_ops and check it when register dax_holder.

Shouldn't the fs avoid registering a memory failure handler if it is
not prepared to take over? For example, shouldn't this case behave
identically to ext4 that will not even register a callback?
