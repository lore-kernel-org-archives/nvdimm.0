Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6075D202B75DB
 for <linux-nvdimm@lists.01.org>; Wed, 14 Aug 2019 14:08:40 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id t24so35750oij.13
 for <linux-nvdimm@lists.01.org>; Wed, 14 Aug 2019 14:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190809074520.27115-1-aneesh.kumar@linux.ibm.com>
 <20190809074520.27115-3-aneesh.kumar@linux.ibm.com>
 <8736i9r6po.fsf@linux.ibm.com>
In-Reply-To: <8736i9r6po.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Aug 2019 14:06:24 -0700
Message-ID: <CAPcyv4h+xY9hmb6bznp4ciJdrtDc_p7HLQhOz1JLqzLf+BVUug@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm/nvdimm: Add page size and struct page size to
 pfn superblock
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 9, 2019 at 9:21 PM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:
>
>         case PFN_MODE_PMEM:
> > @@ -475,6 +484,20 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
> >               align = 1UL << ilog2(offset);
> >       mode = le32_to_cpu(pfn_sb->mode);
> >
> > +     if (le32_to_cpu(pfn_sb->page_size) != PAGE_SIZE) {

I think this is too strict. It's only a potential problem in the
"pfn_sb->page_size > PAGE_SIZE" case, because only then might the
existing reservation for the memmap be too small. Otherwise, unless
I'm missing something, there should be no ill effects for
under-utilizing the reservation.

> > +             dev_err(&nd_pfn->dev,
> > +                     "init failed, page size mismatch %d\n",
> > +                     le32_to_cpu(pfn_sb->page_size));
> > +             return -EOPNOTSUPP;
> > +     }
> > +
> > +     if (le16_to_cpu(pfn_sb->page_struct_size) < sizeof(struct page)) {
> > +             dev_err(&nd_pfn->dev,
> > +                     "init failed, struct page size mismatch %d\n",
> > +                     le16_to_cpu(pfn_sb->page_struct_size));
> > +             return -EOPNOTSUPP;
> > +     }
> > +
>
> We need this here?

Yes, both ->page_struct_size and ->page_size are only relevant in the
PFN_MODE_PMEM case because PFN_MODE_RAM assumes all pages are
allocated dynamically and the size does not matter.


>
> From 9885b2f9ed81a2438fc81507cfcdbdb1aeab756c Mon Sep 17 00:00:00 2001
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
> Date: Fri, 9 Aug 2019 22:10:08 +0530
> Subject: [PATCH] nvdimm: check struct page size only if pfn node is PMEM
>
> We should do the check only with PFN_MODE_PMEM. If we use
> memory for backing vmemmap, we should be able to enable
> the namespace even if struct page size change.

Same as the other patches please drop the usage of "we" in the changelog.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
