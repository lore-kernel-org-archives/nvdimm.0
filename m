Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74632FB2
	for <nvdimm@lists.linux.dev>; Mon, 14 Jun 2021 23:07:48 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id g24so10655859pji.4
        for <nvdimm@lists.linux.dev>; Mon, 14 Jun 2021 16:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d34POHKKhyaLMu0FO3W3g/xVgLokZvIMWmd2dthb3bw=;
        b=lLlmi4tC13F1TK45l2XTdQeNZ8/hL8EOzQ7ZBIzYU+7Vqf7wRYUhN+8vihBfpZhddp
         Ko2y8bGBk8EnS8suRS3z19vLz6IsjFTUStnKTmT3tD3H+EnnKMRilwnvpdHdWcyrlkrB
         mS+9OjzphYSEotypDl01bsuMjmoFIv3uzEJFbQKdjd4cr21EY6fXjLOoLIpemO2N96ZA
         A/i4IzMeRUaARe+dRpXrGQKynRnO5oquomKOvayiTCU4yhARB5TDzl7DBbczNW9uygR2
         ijuXdjBIFnSUtTJVBp2D0F8MCiO3T+0oz9YG6JtZLZjiGFlMNSJi5rGl48sYlRTE6Ot6
         JBFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d34POHKKhyaLMu0FO3W3g/xVgLokZvIMWmd2dthb3bw=;
        b=j5izAmHtfL0baPR58gBRp0//TQYGcyqWMxzF58+sUoqL/65+Hp+UPEnBAvFlNtzD8B
         ZPf4POxbdL+iHcn9r9nKnF4FGOgZHyUBLtWkY+PwM8DiQ9RykkkRqjOzJRCTNYBUPw+j
         c043/1HqckocTZ23ebfZBr07cDLHKu/r6GZakkzXMSMA313pnu1c+h67blRRlLq+KlzN
         DOjHHiNu1KU8XemQBTSXyAwvb/3Ltuizf8GCIMdAyEGyp7TccL0ehOsK1a+LOaJ5vIJx
         IKbVUDETcR5a9yOx4SFnPinI5jLsPbpVzOxZyEOUdaiIrtZPfG3MPln5ToPUr2Wo5yIr
         H1lw==
X-Gm-Message-State: AOAM5302c2tP+doO5wtlV92oJv/YVLl8GLqRLACYJcNDXq/adgtqvV56
	utyoo6R1x//Y/ns8bfEsqgU7LgkUA9Qw1MxNVl2o+w==
X-Google-Smtp-Source: ABdhPJye2JFs2r7cRXUYh1/xlrBndOcwMtVHEgzynnDM5vubY5fSvn4OJLEvPnFlctR1jXG5IvrBQrcEdckMP6zUzVo=
X-Received: by 2002:a17:90a:ea8c:: with SMTP id h12mr1496149pjz.149.1623712068139;
 Mon, 14 Jun 2021 16:07:48 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210325230938.30752-1-joao.m.martins@oracle.com>
 <20210325230938.30752-10-joao.m.martins@oracle.com> <CAPcyv4gtSqfmuAaX9cs63OvLkf-h4B_5fPiEnM9p9cqLZztXpg@mail.gmail.com>
 <840290bd-55cc-e77a-b13d-05c6fd361865@oracle.com> <CAPcyv4hJtqVGoA3ppCMfVQ4ZnWUa7jKtp=Huxu9mcSk4huq_7Q@mail.gmail.com>
 <0c6a4dab-296d-94b2-f885-2371292f9e0d@oracle.com>
In-Reply-To: <0c6a4dab-296d-94b2-f885-2371292f9e0d@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Jun 2021 16:07:36 -0700
Message-ID: <CAPcyv4jdNWW447-cu_eZE+UPMSRgv1GPQADJzxGtzC7Jxjg8Mg@mail.gmail.com>
Subject: Re: [PATCH v1 09/11] mm/page_alloc: reuse tail struct pages for
 compound pagemaps
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Ira Weiny <ira.weiny@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Muchun Song <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 14, 2021 at 11:42 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>
>
>
> On 6/7/21 8:32 PM, Dan Williams wrote:
> > On Mon, Jun 7, 2021 at 6:49 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> > [..]
> >>> Given all of the above I'm wondering if there should be a new
> >>> "compound specific" flavor of this routine rather than trying to
> >>> cleverly inter mingle the old path with the new. This is easier
> >>> because you have already done the work in previous patches to break
> >>> this into helpers. So just have memmap_init_zone_device() do it the
> >>> "old" way and memmap_init_compound() handle all the tail page init +
> >>> optimizations.
> >>>
> >> I can separate it out, should be easier to follow.
> >>
> >> Albeit just a note, I think memmap_init_compound() should be the new normal as metadata
> >> more accurately represents what goes on the page tables. That's regardless of
> >> vmemmap-based gains, and hence why my train of thought was to not separate it.
> >>
> >> After this series, all devmap pages where @geometry matches @align will have compound
> >> pages be used instead. And we enable that in device-dax as first user (in the next patch).
> >> altmap or not so far just differentiates on the uniqueness of struct pages as the former
> >> doesn't reuse base pages that only contain tail pages and consequently makes us initialize
> >> all tail struct pages.
> >
> > I think combining the cases into a common central routine makes the
> > code that much harder to maintain. A small duplication cost is worth
> > it in my opinion to help readability / maintainability.
> >
> I am addressing this comment and taking a step back. By just moving the tail page init to
> memmap_init_compound() this gets a lot more readable. Albeit now I think having separate
> top-level loops over pfns, doesn't bring much improvement there.
>
> Here's what I have by moving just tails init to a separate routine. See your original
> suggestion after the scissors mark. I have a slight inclination towards the first one, but
> no really strong preference. Thoughts?

I like your "first one" too.
