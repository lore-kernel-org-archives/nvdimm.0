Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141AB173
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 09:08:15 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id k31so47467361ybj.4
        for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 01:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mo+uj8+53Ax7tIU91723WHax5XvtDO7oGefV09g/Eiw=;
        b=Lag6Tc/VjcamDe0m5xYuMi0i4GEJpQqzDv2xv15qjoOeqbVWxK+nR+z87z3/Uds7yJ
         xVMZsrEWXOp0quH66zVcVy5D9zyeeMNJ8MBFrQnj3VltAmEoKjttsv3dlG98dSbynjqk
         PFnaOxWJQVmTUr0iugE5+mXiRzDIDnlGpq+Atf0UWF/05kXEtP98JOBc8mLU8YHEPRFF
         F4B6lwfKhGX8rPNJo3AwlCueRsN7Pt4RrmA0biTfkV0Baij7u6nDkDnXHHN+LcrqhAqH
         CShC3LlIw2tHICgexcSbDwofHLOvSY3OXjtQdxIIJaw/jzgvcxhEH1G/dQIPzOMr2C70
         ai4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mo+uj8+53Ax7tIU91723WHax5XvtDO7oGefV09g/Eiw=;
        b=SqerOpO4Apdr/J/h1TK+X6svc+509A4SA0r7XGTSleRWUJEHNTgnCuok/tNuy5dPr7
         2PRaHKCAlbktkdeePDtkOs6c/WdgP9haO+4ZOLCt7YTvzwzszidMaVfCEoupxQZOBiBD
         AZHV104UK/5jR7TsGPEibXrVO76h8bVdWjCnhrTyMfXU6qH7MAVSqMtDB1MVGJDzWTt+
         8R4ABfcsosjhryrFHLYE1IBMWxnOUIiVgDo5NyMdp4aiOD5kTQmZrvGoV94Fr8Aw3fdw
         CaJ5re7qcp/NrFF8zn3hTgrGQ28v/tAfobZJy8L9tZZXYHvEOlRO55Iregkd00pW2S07
         SBQA==
X-Gm-Message-State: AOAM53389H5zljIOhSA4/YYkpC98zkKdrBQHSWYjlgm3VHvrQCcZ2me0
	IUx7O84PJG/BfwgmODzN9PBebQP3TvkW8T/aa87YXyRIXJbQM9qM
X-Google-Smtp-Source: ABdhPJxR2sNnK1U8ZMv0TLocVVFDh5rCZxvNsQJUvLgq5oQIsKgHQM/iDQMQSKuzKm7osYadMtzCvSPfXA2+9Ul2f20=
X-Received: by 2002:a05:6902:100c:: with SMTP id w12mr6231737ybt.317.1643015294113;
 Mon, 24 Jan 2022 01:08:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220121075515.79311-1-songmuchun@bytedance.com>
 <20220121075515.79311-4-songmuchun@bytedance.com> <Ye5YNbBbVymwfPB0@infradead.org>
In-Reply-To: <Ye5YNbBbVymwfPB0@infradead.org>
From: Muchun Song <songmuchun@bytedance.com>
Date: Mon, 24 Jan 2022 17:07:38 +0800
Message-ID: <CAMZfGtUb+xF9nFd21g8tagjRTCYg7R=HOVmXvVZhbtx8im3FDQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] dax: fix missing writeprotect the pte entry
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	Yang Shi <shy828301@gmail.com>, rcampbell@nvidia.com, Hugh Dickins <hughd@google.com>, 
	Xiyu Yang <xiyuyang19@fudan.edu.cn>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, zwisler@kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, nvdimm@lists.linux.dev, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 24, 2022 at 3:41 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Jan 21, 2022 at 03:55:14PM +0800, Muchun Song wrote:
> > Reuse some infrastructure of page_mkclean_one() to let DAX can handle
> > similar case to fix this issue.
>
> Can you split out some of the infrastructure changes into proper
> well-documented preparation patches?

Will do. I'll introduce page_vma_mkclean_one in a prepared patch
and then fix the DAX issue in a separate patch. Thanks for your
suggestions.

>
> > +     pgoff_t pgoff_end = pgoff_start + npfn - 1;
> >
> >       i_mmap_lock_read(mapping);
> > -     vma_interval_tree_foreach(vma, &mapping->i_mmap, index, index) {
> > -             struct mmu_notifier_range range;
> > -             unsigned long address;
> > -
> > +     vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff_start, pgoff_end) {
>
> Please avoid the overly long lines here.  Just using start and end
> might be an easy option.
>

Will do.

Thanks.
