Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7352C9E
	for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 14:39:27 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so12857530pjb.2
        for <nvdimm@lists.linux.dev>; Sun, 12 Dec 2021 06:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c2zny3Bx2o60PdHAHhyf6q+y4E1Ceap0f1n6TKcneOk=;
        b=AlZ4MjqeDEThHEH1FVUzZvmPycukh+PxUwoNaVX5obBJ1cbGHWrTFXhwDvkeLPtwLI
         NHAB8xNArm8PU3DO00Z4REhsm+1Qob5/1ys9INe5D2L2b/t2UBCbCv2eWNYhhKTCINNS
         Q1t8/d3A1COiZ95VaH5Rk1yRA9uPc1Tw8y+dLInqS/mvz45lXPDFlTg+rjL2gA8569Ct
         GL+IVMJJ/wrJ7C7lHVb1smufdMBPNjTAQrn9bTN7CY+SsdNimDU+ZrBJWQpMBVJ2jVq1
         uXY8Bk9o5/8ZSmZHwswsew7WhsFfZauh8tlr+PdX0FkYdSaEagRCltJHMUxaIZv/WTkL
         iliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c2zny3Bx2o60PdHAHhyf6q+y4E1Ceap0f1n6TKcneOk=;
        b=0IvaqmGQEU+/VfZB5LR9Xbj+cL0ki1pCzsxrDkXfqSs+6esJVaA4oOL8ynMVoBDSe3
         4BqjXIG68Em2Akho7iE7kw2ivyB0FHJarBJI0tCwd3xofKeHOg8G9PjHBFCwIvHNW3Jb
         aILCjNt/3m1bNWKUX9Jhvc8uAYNt4V0l6dlyAnBqBrX9jPlZtG3iVK/YvZWLw/CaKkNv
         +QbZnLyYrDKBptfd/LCG+OuYfbbZfyXTA7n19iv7hv6USomOls+Ey7xW6mlAKE5xWuP+
         6bZvOHoJZoQ6UcEM7+xiFklieEVDs8sIMRL2mWmpQq9GVJyThsAdDLdCR64WwZrKMeha
         lc+Q==
X-Gm-Message-State: AOAM532iLVERzNpYD4BXJv9fJCyPd4N8dxQL9Y6XyXlIkr5rBAK61fcN
	aWKI0CjUNakUsxwFeW9FurZ6xtKrXWCOrFV6f1BfsQ==
X-Google-Smtp-Source: ABdhPJz2lbfhBkbKpu43+79k6Z3alD86owZO4X5IPgFqiWUlbzwsnwFTD+5Dey+ZqI2i+TrJIWAD/hQxem3DZ5dPHCE=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr37441884pjb.93.1639319967232;
 Sun, 12 Dec 2021 06:39:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-5-hch@lst.de>
In-Reply-To: <20211209063828.18944-5-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 06:39:16 -0800
Message-ID: <CAPcyv4gZjkVW0vwNLChXCCBVF8CsSZityzSVmcGAk79-mt9yOw@mail.gmail.com>
Subject: Re: [PATCH 4/5] dax: remove the copy_from_iter and copy_to_iter methods
To: Christoph Hellwig <hch@lst.de>
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@de.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Matthew Wilcox <willy@infradead.org>, device-mapper development <dm-devel@redhat.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, linux-s390 <linux-s390@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 8, 2021 at 10:38 PM Christoph Hellwig <hch@lst.de> wrote:
>
> These methods indirect the actual DAX read/write path.  In the end pmem
> uses magic flush and mc safe variants and fuse and dcssblk use plain ones
> while device mapper picks redirects to the underlying device.
>
> Add set_dax_virtual() and set_dax_nomcsafe() APIs for fuse to skip these
> special variants, then use them everywhere as they fall back to the plain
> ones on s390 anyway and remove an indirect call from the read/write path
> as well as a lot of boilerplate code.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c           | 36 ++++++++++++++--
>  drivers/md/dm-linear.c        | 20 ---------
>  drivers/md/dm-log-writes.c    | 80 -----------------------------------
>  drivers/md/dm-stripe.c        | 20 ---------
>  drivers/md/dm.c               | 50 ----------------------
>  drivers/nvdimm/pmem.c         | 20 ---------
>  drivers/s390/block/dcssblk.c  | 14 ------
>  fs/dax.c                      |  5 ---
>  fs/fuse/virtio_fs.c           | 19 +--------
>  include/linux/dax.h           |  9 ++--
>  include/linux/device-mapper.h |  4 --
>  11 files changed, 37 insertions(+), 240 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e81d5ee57390f..ff676a07480c8 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -105,6 +105,10 @@ enum dax_device_flags {
>         DAXDEV_WRITE_CACHE,
>         /* flag to check if device supports synchronous flush */
>         DAXDEV_SYNC,
> +       /* do not use uncached operations to write data */
> +       DAXDEV_CACHED,
> +       /* do not use mcsafe operations to read data */
> +       DAXDEV_NOMCSAFE,

Linus did not like the mcsafe name, and this brings it back. Let's
flip the polarity to positively indicate which routine to use, and to
match the 'nofault' style which says "copy and handle faults".

/* do not leave the caches dirty after writes */
DAXDEV_NOCACHE

/* handle CPU fetch exceptions during reads */
DAXDEV_NOMC

...and then flip the use cases around.

Otherwise, nice cleanup. In retrospect I took the feedback to push
this decision to a driver a bit too literally, this is much better.
