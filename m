Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7313FC3
	for <nvdimm@lists.linux.dev>; Fri, 27 Aug 2021 05:00:34 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id 7so4665757pfl.10
        for <nvdimm@lists.linux.dev>; Thu, 26 Aug 2021 22:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5od/kUgahC3y4f1RegWK6+73V4iglz5jm4qob9t0vVA=;
        b=BSu7p4nmJtMlK80d5oAhh7aFXPoGGP+gl+hWZhWWIym1U6RhBLlAe/5bDvao/kKQAb
         F39MWe9mIjaOnTpfH0sgCcSh4cuXrGB6gDl0qrmlTddQzhzT8/Y7tfrP9EJm+wgSKeyR
         YI9BJmpRsJNULOYGZDCFXG3Z52Al39rgl3cMQTZmGMp3uZyNRxFbN0typYd/gfbgCyan
         LNge0leybWB0kT3kk7W1+86pqLCXA7QIHKUc7zyBr5jt3Z5THZ430BUoxy/REUuce2/G
         Fv36xRBwtc6uC6mupKmmmNaDkbND8kdsV+OgqlhOEw0jJEjDLFYZJIJerQd+Kcj1mqEm
         8U9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5od/kUgahC3y4f1RegWK6+73V4iglz5jm4qob9t0vVA=;
        b=MHTtTizm+AXXAn2GnK7PdEThYy/Dr2gQZ5/9ThcW1vg72w0x6unVWftnJTba7zWjhi
         yrSfwi9eiCxMUP7dHX3LDw3rssp/FTj1rgmnGrcJ9rBrxh0kw+BwFxvo46Pa6GpvH8gB
         gguc/FjbHFAnsFYPYSI2iBoFZj9nAA5GxtlCXFj38eWAcgGhebm1Trhlmco9kLE1orAg
         OTPzrCt76NagLneWxWnZnM66KI3QxXE5Z/Mlu4Kknqo9Op9VuJkXpHE3eOelAq+zl8Av
         stRP5KriIv42rmh49UD23+/xTzyFYCLw+cc5emQWSw+zmYzYqmU2dDmvulnnD7mkHwLf
         wz6g==
X-Gm-Message-State: AOAM531mbYiPaCb5H+k2+zZtKiXOgHFmSD3DhwTSCrC/+5dntfq/Pgcb
	4RVdEp1gqXLlCUVnLmSq95Wh7Th2zA3MVKTSPh7xIA==
X-Google-Smtp-Source: ABdhPJyVQVbVkfVdq/1PF6yl6SVsfHp0Hfz/wCeBu9gUupv+ehQ3Plpx7tr9qo13kJxyJjLGTC4u6L4dvPb+Co2Q9YQ=
X-Received: by 2002:aa7:818c:0:b0:3f1:e024:dcbc with SMTP id
 g12-20020aa7818c000000b003f1e024dcbcmr7357771pfi.31.1630040433928; Thu, 26
 Aug 2021 22:00:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com>
 <20210816060359.1442450-4-ruansy.fnst@fujitsu.com> <CAPcyv4iOSxoy-qGfAd3i4uzwfDX0t1xTmyM0pNd+-euVMDUwrQ@mail.gmail.com>
 <20210823125715.GA15536@lst.de> <d4f07aef-ad9f-7de9-c112-a40e2022b399@fujitsu.com>
In-Reply-To: <d4f07aef-ad9f-7de9-c112-a40e2022b399@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 26 Aug 2021 22:00:23 -0700
Message-ID: <CAPcyv4j832cg0_=h31nTdjFoqgvWsCWqqcY_K_fMRg93JsWU-Q@mail.gmail.com>
Subject: Re: [PATCH v7 3/8] fsdax: Replace mmap entry in case of CoW
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	david <david@fromorbit.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Goldwyn Rodrigues <rgoldwyn@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>, Goldwyn Rodrigues <rgoldwyn@suse.com>, 
	Ritesh Harjani <riteshh@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 26, 2021 at 8:22 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
>
>
> On 2021/8/23 20:57, Christoph Hellwig wrote:
> > On Thu, Aug 19, 2021 at 03:54:01PM -0700, Dan Williams wrote:
> >>
> >> static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
> >>                                const struct iomap_iter *iter, void
> >> *entry, pfn_t pfn,
> >>                                unsigned long flags)
> >>
> >>
> >>>   {
> >>> +       struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> >>>          void *new_entry = dax_make_entry(pfn, flags);
> >>> +       bool dirty = insert_flags & DAX_IF_DIRTY;
> >>> +       bool cow = insert_flags & DAX_IF_COW;
> >>
> >> ...and then calculate these flags from the source data. I'm just
> >> reacting to "yet more flags".
> >
> > Except for the overly long line above that seems like a good idea.
> > The iomap_iter didn't exist for most of the time this patch has been
> > around.
> >
>
> So should I reuse the iter->flags to pass the insert_flags? (left shift
> it to higher bits)

No, the advice is to just pass the @iter to dax_insert_entry directly
and calculate @dirty and @cow internally.
