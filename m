Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0F92C85
	for <nvdimm@lists.linux.dev>; Fri,  5 Nov 2021 00:46:27 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so2204145pjb.1
        for <nvdimm@lists.linux.dev>; Thu, 04 Nov 2021 17:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+MDx1GrQOub7zJ6Bty8NHKGO6IrOVwg4Q81dxTNGuQk=;
        b=z1/ZhSMbHBPL6xzuOjXk5p5q8nj06Ql+kZbdIIDYl2CXDWH4nHvtvPlsJceWFuEGIF
         myQd9Ksfn0kR9uPGa8zftxWOEOG59ZNoGv1CtLfKrvIUpSB7vYlJGNyyZekRAnKXBD7N
         hsybPk2pAfClRxwqPoUjS45Zg5Tq6fAbsnpeF1TjYVSUzg7Sa1GGmQMgocz6Ur7p+kyh
         NjRzOqs4+/kxpk/kJVoKkUYXZuLzbiNNMBoikc2mVwUAK+rMppBW6zq18u8KusKY6kd/
         kZS0fDZuKBAfOGbMeFC9mp4qg0YUwo8+QioiDMxufM4dq7qAm4W3NRici1vzeQprCAsJ
         OqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+MDx1GrQOub7zJ6Bty8NHKGO6IrOVwg4Q81dxTNGuQk=;
        b=YrJum/S/WVTQbeIAqWsI+3LBLUcT1bVuBX6OFLXL4KuxMs1aQqjyGBFP5Z0r6fJ5sY
         ldFTbh5N/PL50pMiQkpO4l7U2zNOqOzhu5vV8TK8h3oC1TCY1NSWlRE3lQ9IE1huASVG
         4dRz4n8RsY+V50baiocfHHvPHqxyM4m0sFgIxXhicreJ6Ezx9K9ZmLIDyNd4O4VLHYgZ
         3jifZJU+O4qgaPFMDe4dVmQPH5uqCrR5vkzLTY/ybYhrV7spvwm9CUdzCcL6eAc3JpTw
         ie2jySKYVsshCGPCK8SMUtwF9Lkg2xSXnxxaixfRkgCWEw6jNoIga0RXOD3KNBs+OBuw
         K+sQ==
X-Gm-Message-State: AOAM533dTezmh/rsDjOsk5/MFNc1+N73yNJy4pyXGbvO82WO2JKrKNnG
	vLrhV/aNyTgFq45hfVReMSQx/eR6amYndxI+opwz1w==
X-Google-Smtp-Source: ABdhPJzBlY9sEgYPXRy5uLLbIJXLqIS5AXvLIJiE838XFcN7i811yjUHS7Ho7WZmKGzY4qGtN0/EXqtZX8wW5x0PKF4=
X-Received: by 2002:a17:902:b697:b0:141:c7aa:e10f with SMTP id
 c23-20020a170902b69700b00141c7aae10fmr35263948pls.18.1636073186843; Thu, 04
 Nov 2021 17:46:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <YXFPfEGjoUaajjL4@infradead.org> <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
 <YXJN4s1HC/Y+KKg1@infradead.org> <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
 <YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
 <YYDYUCCiEPXhZEw0@infradead.org> <CAPcyv4j8snuGpy=z6BAXogQkP5HmTbqzd6e22qyERoNBvFKROw@mail.gmail.com>
 <YYK/tGfpG0CnVIO4@infradead.org> <CAPcyv4it2_PVaM8z216AXm6+h93frg79WM-ziS9To59UtEQJTA@mail.gmail.com>
 <YYOaOBKgFQYzT/s/@infradead.org> <CAPcyv4jKHH7H+PmcsGDxsWA5CS_U3USHM8cT1MhoLk72fa9z8Q@mail.gmail.com>
 <6d21ece1-0201-54f2-ec5a-ae2f873d46a3@oracle.com> <CAPcyv4hJjcy2TnOv-Y5=MUMHeDdN-BCH4d0xC-pFGcHXEU_ZEw@mail.gmail.com>
 <342eb71c-0aff-77e5-3c71-92224d7d48e0@oracle.com>
In-Reply-To: <342eb71c-0aff-77e5-3c71-92224d7d48e0@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 4 Nov 2021 17:46:17 -0700
Message-ID: <CAPcyv4hVu+A0PXgXTwWj3SBimP5pjX_97g+sfGeT47P0-SJkiQ@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with RWF_RECOVERY_DATA flag
To: Jane Chu <jane.chu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	"david@fromorbit.com" <david@fromorbit.com>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, 
	"dave.jiang@intel.com" <dave.jiang@intel.com>, "agk@redhat.com" <agk@redhat.com>, 
	"snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, 
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "willy@infradead.org" <willy@infradead.org>, 
	"vgoyal@redhat.com" <vgoyal@redhat.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 4, 2021 at 1:27 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 11/4/2021 12:00 PM, Dan Williams wrote:
>
> >>
> >> If this understanding is in the right direction, then I'd like to
> >> propose below changes to
> >>     dax_direct_access(), dax_copy_to/from_iter(), pmem_copy_to/from_iter()
> >>     and the dm layer copy_to/from_iter, dax_iomap_iter().
> >>
> >> 1. dax_iomap_iter() rely on dax_direct_access() to decide whether there
> >>      is likely media error: if the API without DAX_F_RECOVERY returns
> >>      -EIO, then switch to recovery-read/write code.  In recovery code,
> >>      supply DAX_F_RECOVERY to dax_direct_access() in order to obtain
> >>      'kaddr', and then call dax_copy_to/from_iter() with DAX_F_RECOVERY.
> >
> > I like it. It allows for an atomic write+clear implementation on
> > capable platforms and coordinates with potentially unmapped pages. The
> > best of both worlds from the dax_clear_poison() proposal and my "take
> > a fault and do a slow-path copy".
> >
> >> 2. the _copy_to/from_iter implementation would be largely the same
> >>      as in my recent patch, but some changes in Christoph's
> >>      'dax-devirtualize' maybe kept, such as DAX_F_VIRTUAL, obviously
> >>      virtual devices don't have the ability to clear poison, so no need
> >>      to complicate them.  And this also means that not every endpoint
> >>      dax device has to provide dax_op.copy_to/from_iter, they may use the
> >>      default.
> >
> > Did I miss this series or are you talking about this one?
> > https://lore.kernel.org/all/20211018044054.1779424-1-hch@lst.de/
>
> I was referring to
>
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-devirtualize
> that has not come out yet, I said early on that I'll rebase on it,
> but looks like we still need pmem_copy_to/from_iter(), so.

Yeah, since the block-layer divorce gets rid of the old poison
clearing path, then we're back to pmem_copy_to_iter() (or something
like it) needing to pick up the slack for poison clearing. I do agree
it would be nice to clean up all the unnecessary boilerplate, but the
error-list coordination requires a driver specific callback. At least
the DAX_F_VIRTUAL flag can eliminate the virtiofs and fuse callbacks.
