Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C6868
	for <nvdimm@lists.linux.dev>; Mon, 13 Dec 2021 16:43:41 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id r130so15469660pfc.1
        for <nvdimm@lists.linux.dev>; Mon, 13 Dec 2021 08:43:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vyYw8u6XfcAGXDXzJlsX3xmu/UHpiQrY1MTgK5iKFVw=;
        b=XiFSVO0CJWFC7lIKOLyuO0nHL/iPwSF4yirvRxBS9+af4O56S0PGNlreHbXCXAaP84
         x2MkNIYnCkZJt6nRR1y/F1eTxY8BTD2UTKonNUg1K9JCTv5/HxLzy4/3O4lDerPuxb55
         wNtDkDmWlrkFMyWmBiAeQkwSnBjf/wORUGNGO8dSmKbze+5/JaWYPD9N08wNZ0JG4NX5
         V5TENSR5i/EgX/lga+UxQPOKVhl3og9dvfA8/wemUHLC0j89nVhG5b5aGetkDZb95bLg
         03KLqIXXPUyeJvGWehZAJvknBTiZVAVi0MM6Ds9ewRhMTodjq4P/YqW0RLoUsUcR6kHt
         RQ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vyYw8u6XfcAGXDXzJlsX3xmu/UHpiQrY1MTgK5iKFVw=;
        b=j5gyNuND0b/2U3aVWfxLLMBNqKQYGGSSTpRv4VYwUKDnqiT7A3NqPLDO84q3euhpZ4
         deRlFAxvIPE2mHmHJPWBy33RHPtavqeJE9627De4J1icSy7wF9A1wIwKtRFVC/SO03uj
         aXiGAJptmdxaNuIm+kIk/ALsPAVrfPNc+ffGeF8o6U+/v4b6M9v9H0ShXdhZ69ShpoJB
         zEMPqi1mzwrgQZIYpnVVssxR41O5BMK/+VGM4Xpoh4Y2Owjj0mtQAJerc53I5RXB1PlD
         6IOkpXzsfPYIXbiY/h3r5GLiapWHp0uQvEo8oS5rsFNYDPdhD2xOKu7nSf5jT72cvhrO
         Sd0g==
X-Gm-Message-State: AOAM533Z5QohRTqDUpBwndpD2jAvKuVzH3E6aJQPUtAMs91dkbS5RmMp
	86KjJgweks/rLqMWIMoj8+KgM+ufksFuFqvv7YMaUQ==
X-Google-Smtp-Source: ABdhPJx2n8q1onN4jQzvRQyQbTXEvg1DJxhgaWZFSAWB2OQ1hhJNCq2enXcdrfYzpDge5Iz394R2nbo3Ocn0tDkMu6w=
X-Received: by 2002:aa7:8d0a:0:b0:4a2:82d7:1695 with SMTP id
 j10-20020aa78d0a000000b004a282d71695mr34765307pfe.86.1639413821384; Mon, 13
 Dec 2021 08:43:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-6-hch@lst.de>
 <YbNejVRF5NQB0r83@redhat.com> <CAPcyv4i_HdnMcq6MmDMt-a5p=ojh_vsoAiES0vUYEh7HvC1O-A@mail.gmail.com>
 <20211213082020.GA21462@lst.de>
In-Reply-To: <20211213082020.GA21462@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Dec 2021 08:43:32 -0800
Message-ID: <CAPcyv4g-_hth2LMUS=k3FwMCfVsSkgFOJ53-uE1wzsDVuEs_eg@mail.gmail.com>
Subject: Re: [PATCH 5/5] dax: always use _copy_mc_to_iter in dax_copy_to_iter
To: Christoph Hellwig <hch@lst.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	Ira Weiny <ira.weiny@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Matthew Wilcox <willy@infradead.org>, device-mapper development <dm-devel@redhat.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 13, 2021 at 12:20 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Sun, Dec 12, 2021 at 06:48:05AM -0800, Dan Williams wrote:
> > On Fri, Dec 10, 2021 at 6:05 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Thu, Dec 09, 2021 at 07:38:28AM +0100, Christoph Hellwig wrote:
> > > > While using the MC-safe copy routines is rather pointless on a virtual device
> > > > like virtiofs,
> > >
> > > I was wondering about that. Is it completely pointless.
> > >
> > > Typically we are just mapping host page cache into qemu address space.
> > > That shows as virtiofs device pfn in guest and that pfn is mapped into
> > > guest application address space in mmap() call.
> > >
> > > Given on host its DRAM, so I would not expect machine check on load side
> > > so there was no need to use machine check safe variant.
> >
> > That's a broken assumption, DRAM experiences multi-bit ECC errors.
> > Machine checks, data aborts, etc existed before PMEM.
>
> So the conclusion here is that we should always use the mc safe variant?

The proposal is one of the following:

1/ any paths not currently using the mc safe variant should continue
not using it to avoid the performance regression on older platforms,
i.e. drop this patch.

2/ add plumbing to switch to mcsafe variant, but only on newer
platforms, incremental new patch

3/ always use the mc safe variant, keep this patch

We could go with 3/ and see who screams, because 3/ is smallest
ongoing maintenance burden. However, I feel like 1/ is the path of
least resistance until the platforms with the need to do 'careful'
copying age out of use.
