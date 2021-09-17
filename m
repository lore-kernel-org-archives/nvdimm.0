Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ABE3FC3
	for <nvdimm@lists.linux.dev>; Fri, 17 Sep 2021 20:21:36 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id g184so10673808pgc.6
        for <nvdimm@lists.linux.dev>; Fri, 17 Sep 2021 13:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8P/ocM2t2YFJb3hFlVvikABipXfDcrvJYjnQI/Pc2oY=;
        b=jKkIebtQy/64rwoKx8BBORdPcS7pcRGFeer2ZITl4fQMj2Dxupuu8/2V6F2WUIiRkZ
         hzsm7e1i/2VHuxg0VSqvFlJiKo0v4Ui286Ovcg3zT9OmLgSeGd97TauIHY6gvxDuYaPp
         Xj+s4AdSeqmWM5KrlaKW2FozE8SCoJQUnUsnXpBY44rpHE1ZTdbB6LEpZu88MrQjep7R
         6dK6ZFuyRSzTvKBe7D2Cd1RDp4FaHAL4h9/IOxlpja4CPXC+Ksd+iP2Pp841IZmCD9v1
         iMe6lGen3gv7yEW9D29g9Eu7JJhJY6VQ+yL8ECvjWeyHbczH3lmWBhnQQBjQeyP1/+Bk
         PMMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8P/ocM2t2YFJb3hFlVvikABipXfDcrvJYjnQI/Pc2oY=;
        b=pKoX5SS541hs0SN27QES3DxTkenrcyMVZYhnLGqqzSMlMP3RxJBaMza3Gj/dap60rM
         Jvcv1LcyQOAzX4HkvqBR0F3D9EXabPrXPIF8Atht0p/AQB9nO8cEeFIB+8VVuLKlZyX+
         RuabO32o84RrqzdsH8LyFPVstHOssiuvlgIOTihYxdhfqpDUjJmubOCATK2LaSsUva2j
         6TtPAIUJ5U0R8ogzb3v8ZWtlGy/8i7n/MyLaZZfCz5dwXppxweV7lonlUd1P3XJ5Do67
         32a4JBVxuVGiHQmdESXHrcR/0vA4mlYEX7UjGwv7C2Kz4BOwTBL8hj3x36gtCDDGgvbc
         IU4Q==
X-Gm-Message-State: AOAM531S3AznEirWLG88uM5n3Urmm7gkdAPdG7YRxgraMUP0emW+HgkJ
	xzQ1cCEBLQp0CNSnLhyw8Y40WbsxvKkiknU4MV5FXQ==
X-Google-Smtp-Source: ABdhPJz6pZs8b4rTLRF6l/MEXnlyU2zD0PW32CvHmSHzYJ5xyUpo5M5M+k1BM1hqEEwhlnAIyc7OUqqASaST32B6YnI=
X-Received: by 2002:a63:1262:: with SMTP id 34mr11373646pgs.356.1631910096519;
 Fri, 17 Sep 2021 13:21:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210914233132.3680546-1-jane.chu@oracle.com> <CAPcyv4h3KpOKgy_Cwi5fNBZmR=n1hB33mVzA3fqOY7c3G+GrMA@mail.gmail.com>
 <516ecedc-38b9-1ae3-a784-289a30e5f6df@oracle.com> <20210915161510.GA34830@magnolia>
 <CAPcyv4jaCiSXU61gsQTaoN_cdDTDMvFSfMYfBz2yLKx11fdwOQ@mail.gmail.com>
 <YULuMO86NrQAPcpf@infradead.org> <CAPcyv4g_qPBER2W+OhCf29kw-+tjs++TsTiRGWgX3trv11+28A@mail.gmail.com>
 <YUSPzVG0ulHdLWn7@infradead.org> <20210917152744.GA10250@magnolia>
In-Reply-To: <20210917152744.GA10250@magnolia>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 17 Sep 2021 13:21:25 -0700
Message-ID: <CAPcyv4iAr_Vwwgqw+4wz0RQUXhUUJGGz7_T+p+W6tC4T+k+zNw@mail.gmail.com>
Subject: Re: [PATCH 0/3] dax: clear poison on the fly along pwrite
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 17, 2021 at 8:27 AM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Sep 17, 2021 at 01:53:33PM +0100, Christoph Hellwig wrote:
> > On Thu, Sep 16, 2021 at 11:40:28AM -0700, Dan Williams wrote:
> > > > That was my gut feeling.  If everyone feels 100% comfortable with
> > > > zeroingas the mechanism to clear poisoning I'll cave in.  The most
> > > > important bit is that we do that through a dedicated DAX path instead
> > > > of abusing the block layer even more.
> > >
> > > ...or just rename dax_zero_page_range() to dax_reset_page_range()?
> > > Where reset == "zero + clear-poison"?
> >
> > I'd say that naming is more confusing than overloading zero.
>
> How about dax_zeroinit_range() ?

Works for me.

>
> To go with its fallocate flag (yeah I've been too busy sorting out -rc1
> regressions to repost this) FALLOC_FL_ZEROINIT_RANGE that will reset the
> hardware (whatever that means) and set the contents to the known value
> zero.
>
> Userspace usage model:
>
> void handle_media_error(int fd, loff_t pos, size_t len)
> {
>         /* yell about this for posterior's sake */
>
>         ret = fallocate(fd, FALLOC_FL_ZEROINIT_RANGE, pos, len);
>
>         /* yay our disk drive / pmem / stone table engraver is online */

The fallocate mode can still be error-aware though, right? When the FS
has knowledge of the error locations the fallocate mode could be
fallocate(fd, FALLOC_FL_OVERWRITE_ERRORS, pos, len) with the semantics
of attempting to zero out any known poison extents in the given file
range? At the risk of going overboard on new fallocate modes there
could also (or instead of) be FALLOC_FL_PUNCH_ERRORS to skip trying to
clear them and just ask the FS to throw error extents away.

> }
>
> > > > I'm really worried about both patartitions on DAX and DM passing through
> > > > DAX because they deeply bind DAX to the block layer, which is just a bad
> > > > idea.  I think we also need to sort that whole story out before removing
> > > > the EXPERIMENTAL tags.
> > >
> > > I do think it was a mistake to allow for DAX on partitions of a pmemX
> > > block-device.
> > >
> > > DAX-reflink support may be the opportunity to start deprecating that
> > > support. Only enable DAX-reflink for direct mounting on /dev/pmemX
> > > without partitions (later add dax-device direct mounting),
> >
> > I think we need to fully or almost fully sort this out.
> >
> > Here is my bold suggestions:
> >
> >  1) drop no drop the EXPERMINTAL on the current block layer overload
> >     at all
>
> I don't understand this.
>
> >  2) add direct mounting of the nvdimm namespaces ASAP.  Because all
> >     the filesystem currently also need the /dev/pmem0 device add a way
> >     to open the block device by the dax_device instead of our current
> >     way of doing the reverse
> >  3) deprecate DAX support through block layer mounts with a say 2 year
> >     deprecation period
> >  4) add DAX remapping devices as needed
>
> What devices are needed?  linear for lvm, and maybe error so we can
> actually test all this stuff?

The proposal would be zero lvm support. The nvdimm namespace
definition would need to grow support for concatenation + striping.
Soft error injection could be achieved by writing to the badblocks
interface.
