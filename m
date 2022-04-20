Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9971867
	for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 17:06:09 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id h5so2155850pgc.7
        for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 10:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S6WRgsV29at1u8BYECoaCAIUEhBO/TRLPFjdvW2DSKY=;
        b=evjw5k1x3EAw9uJs5q2tETiXT+pKUtC4XYcufWkJsAHLg9hXUQrAWQMq0wiRFnln32
         spAzzDjfjw7BI0gUWKScZ4cr58Qby2B8mefJOwzhW4cd4tmY9kaq+e+ALMjVY9ZkE0cl
         nE4L215/WYnmDJHpTZGmwXNncbEyunYyHKwJC8+2r92NR+QL+/lpwXByvNQEIhsWG+N+
         A3iGQ442+417QNeCiqJ5SynC60yv0aCTOyOw7uduV9Idg+pfymRL64fPWSVzJaOL1cE1
         bF8zUDoVWgAnHqSIC1/loS/BL9Ti6C5qCBN8M/DzOmEoJtCeFp6YQmfXZASB+uFLc/n8
         WcYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S6WRgsV29at1u8BYECoaCAIUEhBO/TRLPFjdvW2DSKY=;
        b=Sfhtq8+bDtmQM1CuGTeCuRtCBcQoFRlERgSSDz4vzJ3qkqMFxo3NjFYUp7kn9oxSEE
         WpjCM6IX9RgQJp6225WO2j5rE79fImBa7fyHHuD9G6iGP2VCJptfbMXASCDkTbKfLFDo
         SqsbmS7RtGbBEtpgTZwPAZ2psz+osCy6fl6o8eOvXTzMIdSWTvXlIuxrNydwu+owlBgM
         lV/MeUDcMNqpN8DEEFaIGbM4ZQ2GlZzYiNCDRb1z3g4Uip09/WDWh/85u3jBM5ORQchW
         4UYBz+vU9J6Hym5/Ookmq5LLfaEEsdaaPVtFMFqAGH4ATckOiEKQg5hL90EY3K2PmEfN
         iLUA==
X-Gm-Message-State: AOAM530+NPZGsSYKIE3muu0AtFxvHXi+DvLubsgLJXFI/WbnsDcG1Qir
	XSVAU3PgAMXBThGPDzL/4QqoYAJOOGeCuVrg9gxegA==
X-Google-Smtp-Source: ABdhPJzjQxymGokqig+0dj9VMt0ZqpBg1SOZJb6EMhrcm6mpZ6hjDlL3AyoRVlLWi7CJ5RGG6wX7y+j7PIoYCPOrIBE=
X-Received: by 2002:a05:6a00:2992:b0:505:cf4b:baef with SMTP id
 cj18-20020a056a00299200b00505cf4bbaefmr24081084pfb.61.1650474369443; Wed, 20
 Apr 2022 10:06:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220420020435.90326-1-jane.chu@oracle.com> <20220420020435.90326-8-jane.chu@oracle.com>
 <CAPcyv4gs2rEs71c6Lmtk1La2g3POhzBrppLvM0pkGxx+QZ3SbA@mail.gmail.com> <d48f9641-30e3-f459-2376-386c28a69026@oracle.com>
In-Reply-To: <d48f9641-30e3-f459-2376-386c28a69026@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Apr 2022 10:05:58 -0700
Message-ID: <CAPcyv4jTqBo+hRuza0WQhmn=D3uyOWU9u2dtk2C=AXYDqeMh5w@mail.gmail.com>
Subject: Re: [PATCH v8 7/7] pmem: implement pmem_recovery_write()
To: Jane Chu <jane.chu@oracle.com>
Cc: Borislav Petkov <bp@alien8.de>, Christoph Hellwig <hch@infradead.org>, Dave Hansen <dave.hansen@intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, david <david@fromorbit.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	device-mapper development <dm-devel@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Apr 20, 2022 at 10:02 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 4/19/2022 11:26 PM, Dan Williams wrote:
> > On Tue, Apr 19, 2022 at 7:06 PM Jane Chu <jane.chu@oracle.com> wrote:
> >>
> >> The recovery write thread started out as a normal pwrite thread and
> >> when the filesystem was told about potential media error in the
> >> range, filesystem turns the normal pwrite to a dax_recovery_write.
> >>
> >> The recovery write consists of clearing media poison, clearing page
> >> HWPoison bit, reenable page-wide read-write permission, flush the
> >> caches and finally write.  A competing pread thread will be held
> >> off during the recovery process since data read back might not be
> >> valid, and this is achieved by clearing the badblock records after
> >> the recovery write is complete. Competing recovery write threads
> >> are serialized by pmem device level .recovery_lock.
> >>
> >> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> >> ---
> >>   drivers/nvdimm/pmem.c | 56 ++++++++++++++++++++++++++++++++++++++++++-
> >>   drivers/nvdimm/pmem.h |  1 +
> >>   2 files changed, 56 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> >> index c3772304d417..134f8909eb65 100644
> >> --- a/drivers/nvdimm/pmem.c
> >> +++ b/drivers/nvdimm/pmem.c
> >> @@ -332,10 +332,63 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
> >>          return __pmem_direct_access(pmem, pgoff, nr_pages, mode, kaddr, pfn);
> >>   }
> >>
> >> +/*
> >> + * The recovery write thread started out as a normal pwrite thread and
> >> + * when the filesystem was told about potential media error in the
> >> + * range, filesystem turns the normal pwrite to a dax_recovery_write.
> >> + *
> >> + * The recovery write consists of clearing media poison, clearing page
> >> + * HWPoison bit, reenable page-wide read-write permission, flush the
> >> + * caches and finally write.  A competing pread thread will be held
> >> + * off during the recovery process since data read back might not be
> >> + * valid, and this is achieved by clearing the badblock records after
> >> + * the recovery write is complete. Competing recovery write threads
> >> + * are serialized by pmem device level .recovery_lock.
> >> + */
> >>   static size_t pmem_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
> >>                  void *addr, size_t bytes, struct iov_iter *i)
> >>   {
> >> -       return 0;
> >> +       struct pmem_device *pmem = dax_get_private(dax_dev);
> >> +       size_t olen, len, off;
> >> +       phys_addr_t pmem_off;
> >> +       struct device *dev = pmem->bb.dev;
> >> +       long cleared;
> >> +
> >> +       off = offset_in_page(addr);
> >> +       len = PFN_PHYS(PFN_UP(off + bytes));
> >> +       if (!is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) >> SECTOR_SHIFT, len))
> >> +               return _copy_from_iter_flushcache(addr, bytes, i);
> >> +
> >> +       /*
> >> +        * Not page-aligned range cannot be recovered. This should not
> >> +        * happen unless something else went wrong.
> >> +        */
> >> +       if (off || !PAGE_ALIGNED(bytes)) {
> >> +               dev_warn(dev, "Found poison, but addr(%p) or bytes(%#lx) not page aligned\n",
> >> +                       addr, bytes);
> >
> > If this warn stays:
> >
> > s/dev_warn/dev_warn_ratelimited/
> >
> > The kernel prints hashed addresses for %p, so I'm not sure printing
> > @addr is useful or @bytes because there is nothing actionable that can
> > be done with that information in the log. @pgoff is probably the only
> > variable worth printing (after converting to bytes or sectors) as that
> > might be able to be reverse mapped back to the impacted data.
>
> The intention with printing @addr and @bytes is to show the
> mis-alignment. In the past when UC- was set on poisoned dax page,
> returning less than a page being written would cause dax_iomap_iter to
> produce next iteration with @addr and @bytes not-page-aligned.  Although
> UC- doesn't apply here, I thought it might still be worth while to watch
> for similar scenario.  Also that's why @pgoff isn't helpful.
>
> How about s/dev_warn/dev_dbg/ ?
>
> >
> >> +               return 0;
> >> +       }
> >> +
> >> +       mutex_lock(&pmem->recovery_lock);
> >> +       pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
> >> +       cleared = __pmem_clear_poison(pmem, pmem_off, len);
> >> +       if (cleared > 0 && cleared < len) {
> >> +               dev_warn(dev, "poison cleared only %ld out of %lu bytes\n",
> >> +                       cleared, len);
> >
> > This looks like dev_dbg() to me, or at minimum the same
> > dev_warn_ratelimited() print as the one above to just indicate a write
> > to the device at the given offset failed.
>
> Will s/dev_warn/dev_dbg/
>
> >
> >> +               mutex_unlock(&pmem->recovery_lock);
> >> +               return 0;
> >> +       }
> >> +       if (cleared < 0) {
> >> +               dev_warn(dev, "poison clear failed: %ld\n", cleared);
> >
> > Same feedback here, these should probably all map to the identical
> > error exit ratelimited print.
>
> Will s/dev_warn/dev_dbg/
>
> >
> >> +               mutex_unlock(&pmem->recovery_lock);
> >
> > It occurs to me that all callers of this are arriving through the
> > fsdax iomap ops and all of these callers take an exclusive lock to
> > prevent simultaneous access to the inode. If recovery_write() is only
> > used through that path then this lock is redundant. Simultaneous reads
> > are protected by the fact that the badblocks are cleared last. I think
> > this can wait to add the lock when / if a non-fsdax access path
> > arrives for dax_recovery_write(), and even then it should probably
> > enforce the single writer exclusion guarantee of the fsdax path.
> >
>
> Indeed, the caller dax_iomap_rw has already held the writer lock.
>
> Will remove .recovery_lock for now.
>
> BTW, how are the other patches look to you?

First pass looked good, so I'll do one more lookover, but this is
coming together nicely. Thanks for all the effort on this!
