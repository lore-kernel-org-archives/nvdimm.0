Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FD715A8
	for <nvdimm@lists.linux.dev>; Thu, 14 Apr 2022 02:02:15 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id v12so3495827plv.4
        for <nvdimm@lists.linux.dev>; Wed, 13 Apr 2022 19:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z/AZcNPpuzZDgumlPPShqA1y0wj8q3uDg5REQ7nWe+g=;
        b=CwUaIxkVnLJ5l46nXB2s1sou59hINQM/ZRPp8PgQSytaOTFdj5NPDAXKC18NHxovTf
         CNDUOsT39v7D12dS5ZQ5VyZCYQgsubRrs6eE1p6NOiKJwAVQat/29+jKEAzO88iWgLjp
         HPfJAccDb5kf57+DK4SqQvGN9fk4p69oMWY/rZMpZW5mukjDtmuPneOpczL+g866T1zU
         8H97LSBoYZFA4oXZ1O7XIzloSk/4XvVfoFgijXJAOAP7uz+a0wUxgTYGwM3ohg2+IOV1
         xRawiPehfXvAI+97iMxaM4Bw3aLd8i2lcauheW1rlBaAIR435lzflqVSUD5yc2Jx95Ia
         w1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z/AZcNPpuzZDgumlPPShqA1y0wj8q3uDg5REQ7nWe+g=;
        b=7nCWHETx1rBNcJaHXQY26SCe9c6mOVQIIWXyb18zu2cKnqMRZ2d/v4bxz3jSmuYFHw
         BNqJhiTYyX+s9jZjunFGCOnKOMcB1+xIVYsef0XT0Otk4qdtWxAmbvkJXlvXpgQ2Kr4s
         bQsOE4jqjFI8yYMRbmgDjZGmlELLWtgRbhKwqrsGKtq75VajduIRCc8UyMa8EZ+HhckG
         Hl/gTORQVHMsL1juE22V2XIeRxV/Mg0Cc3CIvwvzGd3oSaOFC3PNOp7h0fcXEGerJ/6x
         Cv4pXR3J0lKf3RRkibvEbdKnrUWscltAP3OETwIaUK739JmW0IH7QGofbkjeh3hYn4HX
         kquQ==
X-Gm-Message-State: AOAM531oGK7A5Cxd7AzAC5ZIoqTsUM2FeV0635lfNeIN1bpfZPtvfM+X
	ergLYzvgStRNQL4ygm/ZhUzNI3dx1OylA8xqvLRXsg==
X-Google-Smtp-Source: ABdhPJwLDKKH3DT9JFgarja/Tnh6p2mmAGJ/wOpJuSGyolYLRI59NHTREVIMzFOVSkYOQVAxzofLTctfLriOkXyPajc=
X-Received: by 2002:a17:90a:ca:b0:1ca:5253:b625 with SMTP id
 v10-20020a17090a00ca00b001ca5253b625mr1171605pjd.220.1649901734577; Wed, 13
 Apr 2022 19:02:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com> <20220405194747.2386619-6-jane.chu@oracle.com>
 <CAPcyv4h4NGa7_mTrrY0EqXdGny5p9JtQZx+CVBcHxX6_ZuO9pg@mail.gmail.com> <9b01d57a-0170-5977-fcda-184617d8e2eb@oracle.com>
In-Reply-To: <9b01d57a-0170-5977-fcda-184617d8e2eb@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Apr 2022 19:02:03 -0700
Message-ID: <CAPcyv4jrtUDf0zPB8aefVs2MsV8tW2Kmx2yq3D4ze2wr7SshsA@mail.gmail.com>
Subject: Re: [PATCH v7 5/6] pmem: refactor pmem_clear_poison()
To: Jane Chu <jane.chu@oracle.com>
Cc: david <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	device-mapper development <dm-devel@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 13, 2022 at 5:55 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 4/11/2022 9:26 PM, Dan Williams wrote:
> > On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> Refactor the pmem_clear_poison() in order to share common code
> >> later.
> >>
> >
> > I would just add a note here about why, i.e. to factor out the common
> > shared code between the typical write path and the recovery write
> > path.
>
> Okay.
>
> >
> >> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> >> ---
> >>   drivers/nvdimm/pmem.c | 78 ++++++++++++++++++++++++++++---------------
> >>   1 file changed, 52 insertions(+), 26 deletions(-)
> >>
> >> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> >> index 0400c5a7ba39..56596be70400 100644
> >> --- a/drivers/nvdimm/pmem.c
> >> +++ b/drivers/nvdimm/pmem.c
> >> @@ -45,10 +45,27 @@ static struct nd_region *to_region(struct pmem_device *pmem)
> >>          return to_nd_region(to_dev(pmem)->parent);
> >>   }
> >>
> >> -static void hwpoison_clear(struct pmem_device *pmem,
> >> -               phys_addr_t phys, unsigned int len)
> >> +static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
> >>   {
> >> +       return (pmem->phys_addr + offset);
> >
> > Christoph already mentioned dropping the unnecessary parenthesis.
> >
> >> +}
> >> +
> >> +static sector_t to_sect(struct pmem_device *pmem, phys_addr_t offset)
> >> +{
> >> +       return (offset - pmem->data_offset) >> SECTOR_SHIFT;
> >> +}
> >> +
> >> +static phys_addr_t to_offset(struct pmem_device *pmem, sector_t sector)
> >> +{
> >> +       return ((sector << SECTOR_SHIFT) + pmem->data_offset);
> >> +}
> >> +
> >> +static void pmem_clear_hwpoison(struct pmem_device *pmem, phys_addr_t offset,
> >> +               unsigned int len)
> >
> > Perhaps now is a good time to rename this to something else like
> > pmem_clear_mce_nospec()? Just to make it more distinct from
> > pmem_clear_poison(). While "hwpoison" is the page flag name
> > pmem_clear_poison() is the function that's actually clearing the
> > poison in hardware ("hw") and the new pmem_clear_mce_nospec() is
> > toggling the page back into service.
>
> I get your point. How about calling the function explicitly
> pmem_mkpage_present()?

Sure, I like pmem_mkpage_present().
