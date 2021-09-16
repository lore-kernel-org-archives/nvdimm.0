Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34CD3FC5
	for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 18:40:39 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id u18so7103327pgf.0
        for <nvdimm@lists.linux.dev>; Thu, 16 Sep 2021 11:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wf67Cflfm8IYYsTzaYKBdKTyyIkowqSuJvIyiG8CUCY=;
        b=LvlvtWTKlD9s/EDivdE4mILBwFWDacQU+lTor8a93tgHOXWU9Jp17vq0h3RX4ogJjN
         DVLh6goKK3t5EHBKcD6gMMpy7qnqsMS/0B6dWGUuyi4lJ0Z/Zgl4lhfSEARlWNyDkJk8
         PTt3irJB9bwoir0gqUfmv7MClmERI2AdcVOEJYG8BrkHFLVEDTLbempK83vBXFiIFhXq
         P+E12qv6w7MDRccMJuObh/6EEkzrslmfLzfOtkIqPvTt5XDZJ8JVeY9yc6l4TZ0k1GwY
         HnuSiSoamLaphKntM41GgfAPVBlUnM1GwZZLJl9I/3psnuonX+9T+KuqE/5ruoj2w6f+
         h4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wf67Cflfm8IYYsTzaYKBdKTyyIkowqSuJvIyiG8CUCY=;
        b=u93/0PwxGJ+6Zy541o0x8VmSlB8zh8MJvZNZlvA8JPhRqOZtcm/vqaDXhkSMxNvL3h
         WNpGTjtpTxwlGrz7cxi6aeF3ZvMkyvN7Dg7TI78qmt8LNc3cQo5yIT1gqszFQyw6h9SB
         rJUTK/y/SSTHpzcJBi2vDWOrFnqMV7pIaDiYiUE2YKGRqO1iuYRiD1znCqmiRd08QKJB
         RudUpwByT/xfpX7HvIw4A8BgqnIOZfeFIT0Tpa2PaV1kSseVzIPdAWtIz05m0zvwizfy
         klUd0N2NF9LibFXBejaonQKfc+o8tFb6QI3uOoKo/oyd5xCcRSmGle0uBgF00OGwVbkg
         2ugQ==
X-Gm-Message-State: AOAM5322Iyv1tBC6omjcH7fTw+td892x6SldjlWTD7OuvDkEZfVok8f0
	Lg9AuOS+xTWXZJuokXVt3ZdnVhXFDDdgRBXaEOCVrA==
X-Google-Smtp-Source: ABdhPJzELJdpBHezctnL7cSPyzwljRxL/PM+INjo/MR1amWdcvrpzwpjsPu/TvVdYHWHVeKNatCqBtUgaI9XGGs40LI=
X-Received: by 2002:a62:1b92:0:b0:3eb:3f92:724 with SMTP id
 b140-20020a621b92000000b003eb3f920724mr6491253pfb.3.1631817639221; Thu, 16
 Sep 2021 11:40:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210914233132.3680546-1-jane.chu@oracle.com> <CAPcyv4h3KpOKgy_Cwi5fNBZmR=n1hB33mVzA3fqOY7c3G+GrMA@mail.gmail.com>
 <516ecedc-38b9-1ae3-a784-289a30e5f6df@oracle.com> <20210915161510.GA34830@magnolia>
 <CAPcyv4jaCiSXU61gsQTaoN_cdDTDMvFSfMYfBz2yLKx11fdwOQ@mail.gmail.com> <YULuMO86NrQAPcpf@infradead.org>
In-Reply-To: <YULuMO86NrQAPcpf@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 16 Sep 2021 11:40:28 -0700
Message-ID: <CAPcyv4g_qPBER2W+OhCf29kw-+tjs++TsTiRGWgX3trv11+28A@mail.gmail.com>
Subject: Re: [PATCH 0/3] dax: clear poison on the fly along pwrite
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Jane Chu <jane.chu@oracle.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 16, 2021 at 12:12 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Sep 15, 2021 at 01:27:47PM -0700, Dan Williams wrote:
> > > Yeah, Christoph suggested that we make the clearing operation explicit
> > > in a related thread a few weeks ago:
> > > https://lore.kernel.org/linux-fsdevel/YRtnlPERHfMZ23Tr@infradead.org/
> >
> > That seemed to be tied to a proposal to plumb it all the way out to an
> > explicit fallocate() mode, not make it a silent side effect of
> > pwrite().
>
> Yes.
>
> > >
> > > Each of the dm drivers has to add their own ->clear_poison operation
> > > that remaps the incoming (sector, len) parameters as appropriate for
> > > that device and then calls the lower device's ->clear_poison with the
> > > translated parameters.
> > >
> > > This (AFAICT) has already been done for dax_zero_page_range, so I sense
> > > that Dan is trying to save you a bunch of code plumbing work by nudging
> > > you towards doing s/dax_clear_poison/dax_zero_page_range/ to this series
> > > and then you only need patches 2-3.
> >
> > Yes, but it sounds like Christoph was saying don't overload
> > dax_zero_page_range(). I'd be ok splitting the difference and having a
> > new fallocate clear poison mode map to dax_zero_page_range()
> > internally.
>
> That was my gut feeling.  If everyone feels 100% comfortable with
> zeroingas the mechanism to clear poisoning I'll cave in.  The most
> important bit is that we do that through a dedicated DAX path instead
> of abusing the block layer even more.

...or just rename dax_zero_page_range() to dax_reset_page_range()?
Where reset == "zero + clear-poison"?

> > > > BTW, our customer doesn't care about creating dax volume thru DM, so.
> > >
> > > They might not care, but anything going upstream should work in the
> > > general case.
> >
> > Agree.
>
> I'm really worried about both patartitions on DAX and DM passing through
> DAX because they deeply bind DAX to the block layer, which is just a bad
> idea.  I think we also need to sort that whole story out before removing
> the EXPERIMENTAL tags.

I do think it was a mistake to allow for DAX on partitions of a pmemX
block-device.

DAX-reflink support may be the opportunity to start deprecating that
support. Only enable DAX-reflink for direct mounting on /dev/pmemX
without partitions (later add dax-device direct mounting), change
DAX-experimental warning to a deprecation notification for DAX on
DM/partitions, continue to fail / never fix DAX-reflink for
DM/partitions, direct people to use namespace provisioning for
sub-divisions of PMEM capacity, and finally look into adding
concatenation and additional software striping support to the new CXL
region creation facility.
