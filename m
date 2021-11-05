Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE44C2C80
	for <nvdimm@lists.linux.dev>; Fri,  5 Nov 2021 16:41:26 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id q126so4894060pgq.13
        for <nvdimm@lists.linux.dev>; Fri, 05 Nov 2021 09:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5amwjTWIRqLe2fTBGlO6hAxlM9gBL72qHsZ42zn9EgA=;
        b=w2UkjvmMa0b3Jj3bRnCOzLOOnJhzHram0qUr+hyVoF7QF9wO0sS98CValsAS4SqqGs
         bJ9t/C20kldIAxthpkaMWhjpJgzWIlNQDDNN5E+rqF+YU7F1SGGuyX8PDpHk8SudRGlQ
         zw2wsAtBlstMfy+CtBPresI5dAl4hU2isZxvNFFptJ4pa4O4izJIV2fD2GUXU6eS+jah
         kKKiufRF1OgboBlVcSu8bleHvoc0e/emRjRHSuPKNAtlXDaPJ9MCPEgbxIWIxEzZJCSE
         0JrTPTicicUFnp/AAJ/njGjb9Bl+Ka1UvAchQ2vB4em9ZYUfNBe/4jBKFac75OxFICzw
         XrnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5amwjTWIRqLe2fTBGlO6hAxlM9gBL72qHsZ42zn9EgA=;
        b=uuaJcxQPvhPZ3hs2fyZKdY5QrilLsZePNMQNMdz3rWhakS5KzDk/HPe8q49QtTU8x9
         slCNgFO+h9uhshJiV3KE13r2wbBjBuvrwANaBP7Dm1Nw01lCnSO3TgL4hm2NeM2xL5wS
         silBu9wtRWj2xzED+Pxo8lI2J4s3FamjKfvw6kixBqNQpZ8G/bS3HdJ2pB57JjDZOpXJ
         6t4OX+8OhojX8s94S750py2TOrFQONSCq3IuWXOb+iXDbx8nHvtMuTupl2VyjlFACRiA
         He07z/Jalp+7trFbMmHeNvNPgk1ZrfdF5pFXn3kC2dPm1U7V5i/mVnI6M1V0uT3QAmLG
         eh7Q==
X-Gm-Message-State: AOAM533xMj3c4iZaSsp6ova9cp931ING3BOPO+dNlErbVXBbLeHY3Pft
	4iaxswl197bDlNgmURlCgEx3LYQoKdBy+Pt2w1ovEg==
X-Google-Smtp-Source: ABdhPJy88KlTg/YTg27YWTdBpEzIk+qBEUkjukz8u9LiS5ucVjPUeY/wW29fEVui4yjEuSG2RwuDHI2MPSDUqYsWP6o=
X-Received: by 2002:a63:6302:: with SMTP id x2mr27989241pgb.5.1636130486183;
 Fri, 05 Nov 2021 09:41:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-8-joao.m.martins@oracle.com> <CAPcyv4jqdPaLPOydb_GWvVP4d+hRkcu7CnP_Ud-CQXHcqTLWKw@mail.gmail.com>
 <bfc9f754-e927-f6fa-7da8-2811fe5c8808@oracle.com>
In-Reply-To: <bfc9f754-e927-f6fa-7da8-2811fe5c8808@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 5 Nov 2021 09:41:15 -0700
Message-ID: <CAPcyv4gXHaH=wHTbA3GsUgGvrcoXHxtrnD55iFtg7ZGHD8cMxg@mail.gmail.com>
Subject: Re: [PATCH v4 07/14] device-dax: compound devmap support
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Naoya Horiguchi <naoya.horiguchi@nec.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 5, 2021 at 7:10 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
> On 11/5/21 00:38, Dan Williams wrote:
> > On Fri, Aug 27, 2021 at 7:59 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> >>
> >> Use the newly added compound devmap facility which maps the assigned dax
> >> ranges as compound pages at a page size of @align. Currently, this means,
> >> that region/namespace bootstrap would take considerably less, given that
> >> you would initialize considerably less pages.
> >>
> >> On setups with 128G NVDIMMs the initialization with DRAM stored struct
> >> pages improves from ~268-358 ms to ~78-100 ms with 2M pages, and to less
> >> than a 1msec with 1G pages.
> >>
> >> dax devices are created with a fixed @align (huge page size) which is
> >> enforced through as well at mmap() of the device. Faults, consequently
> >> happen too at the specified @align specified at the creation, and those
> >> don't change through out dax device lifetime.
> >
> > s/through out/throughout/
> >
> >> MCEs poisons a whole dax huge page, as well as splits occurring at the configured page size.
> >
> > A clarification here, MCEs trigger memory_failure() to *unmap* a whole
> > dax huge page, the poison stays limited to a single cacheline.
> >
> Ah, yes. I'll fix it for v5.
>
> > Otherwise the patch looks good to me.
> >
> Thanks!
>
> Btw, does 'looks good' == Reviewed-by (with the commit message clarification above) or is
> it that 'should be good with the ammend above and you get the tag in the next round' ?

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

> Asking as IIRC you mentioned this too some other time(s) (in the simpler sparse-vmemmap
> patches) hence just clarifying to understand your expected 'process' better.
>
> Also, I will be splitting this series as mentioned in the other discussion ...
>
> https://lore.kernel.org/linux-mm/20211019160136.GH3686969@ziepe.ca/
>
> ... So this patch and the previous one should be the last two patches of the series
> and the rest (gup, sparse-vmemmmap) will go in parallel.

Sounds good.
