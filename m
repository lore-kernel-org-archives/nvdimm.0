Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7309572
	for <nvdimm@lists.linux.dev>; Mon,  7 Jun 2021 21:57:25 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d16so14101807pfn.12
        for <nvdimm@lists.linux.dev>; Mon, 07 Jun 2021 14:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1gPdlyJaM9Fys743qj55JEQeJ2R3PSv9Ivj/ZS6vyPw=;
        b=tX6NiDePGIyfCriXl0nKJe0h9DOty2l1dKErn1h6NkjPCzY1Nih4tF4RbMghsVd2/v
         igwlGbQZvYKyKURJljTBdxdAnpxgDzLU9VGQQgQctL7pMq7hhwCVVck6+VYZbWZIDPrx
         WPeAUGrxwMrV5VzdNf+i3sCFBpalmlYvsb6bnWsUyOowegd3E7ougEEy60D48CfUArNb
         UeG3pSo6EAyltPl8XiAtU4Xl9y27UnteDgut8+44nrqFN0NKPerJA6lQg3Uy0XY8gOSY
         6peRXgtKC2COAqy08mCH9/PcKfjPESVT2h+ZN5aALWqUsN0ksPhfTBQ7VQRD1tvIz9Jp
         6aiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1gPdlyJaM9Fys743qj55JEQeJ2R3PSv9Ivj/ZS6vyPw=;
        b=rug7BeyTjF30Xgm27Er7LSqJ9e7G6EnIQpny1MMkuvbaExdcvmTBhMg8rl2zEt4aa2
         1FaDabw/lDwgOXBHpdzbrofDWSlOl7vHNiS8fScICmSsjtGGYPMHos9Yj8cIAyh6qNqA
         lIecypmu0oZGdLvsgw10rfjKC2p/CsbVZEBhwrCAnEv0JuqN3JVd32f5EUeOuEUO/mKT
         wFbBQ041hfaK+3ASpx3wXhwC/+Ta8OcZzMDK7/5dxZwaxTrjbAVrtlyTk1V7nd9daxAc
         swzhcoAvfomwSiVYrxbcx8NVf1ur8PptAFBnMBVLCut+rgFsMNNRxMntCEz67CbMYqKg
         hkhQ==
X-Gm-Message-State: AOAM530LbJueusXcCpnlq/85Eu8w4ivfZSrGbdVRHdp2v5DyuLAhIZMj
	++hQUBG37brKAWZryKt5dpZV7YI2fF/vWqtZlJLvkw==
X-Google-Smtp-Source: ABdhPJxs8ADfEtgRQstVYP6meeHoIfi7ZhKe1swGTzQ8vQQcJ93k/cAtpwZhdSNITs1Ou9q/+RwcoTmkDkaVSTSHyP4=
X-Received: by 2002:a05:6a00:234f:b029:2c4:b8d6:843 with SMTP id
 j15-20020a056a00234fb02902c4b8d60843mr18908056pfj.71.1623103044831; Mon, 07
 Jun 2021 14:57:24 -0700 (PDT)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210325230938.30752-1-joao.m.martins@oracle.com>
 <20210325230938.30752-5-joao.m.martins@oracle.com> <CAPcyv4gs_rHL7FPqyQEb3yT4jrv8Wo_xA2ojKsppoBfmDocq8A@mail.gmail.com>
 <cd1c9849-8660-dbdc-718a-aa4ba5d48c01@oracle.com> <CAPcyv4jG8+S6xJyp=1S2=dpit0Hs2+HgGwpWeRROCRuJnQYAxQ@mail.gmail.com>
 <56a3e271-4ef8-ba02-639e-fd7fe7de7e36@oracle.com> <8c922a58-c901-1ad9-5d19-1182bd6dea1e@oracle.com>
 <CAPcyv4j_PdzytEeabe95FrUiNVNobdJRvUE9M9j0krKQ1defBg@mail.gmail.com>
 <e22ef769-5eb2-1812-497f-6d069d632cd0@oracle.com> <f7cb0917-4d22-3418-f1c9-1d569647a2e2@oracle.com>
In-Reply-To: <f7cb0917-4d22-3418-f1c9-1d569647a2e2@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 7 Jun 2021 14:57:14 -0700
Message-ID: <CAPcyv4ifgp45tbNmrgsya1nVUg5XQjiH6gvV360eDt_LEYLB0Q@mail.gmail.com>
Subject: Re: [PATCH v1 04/11] mm/memremap: add ZONE_DEVICE support for
 compound pages
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Linux MM <linux-mm@kvack.org>, Ira Weiny <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Jane Chu <jane.chu@oracle.com>, 
	Muchun Song <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 7, 2021 at 2:02 PM Joao Martins <joao.m.martins@oracle.com> wrote:
[..]
> > But naming aside, I was trying to get at was to avoid a second geometry value validation
> > i.e. to be validated the value and set with a value such as DEVMAP_PTE, DEVMAP_PMD and
> > DEVMAP_PUD.
>
> Sorry my english keeps getting broken, I meant this instead:
>
> But naming aside, what I am trying to get at is to remove the second geometry value
> validation i.e. for @geometry to not be validated a second time to be set to DEVMAP_PTE,
> DEVMAP_PMD or DEVMAP_PUD.
>
> > That to me sounds a little redundant, when the geometry value depends on what
> > align is going to be used from. Here my metnion of @align refers to what's used to create
> > the dax device, not the mmap() align [which can be lower than the device one]. The dax
> > device align is the one used to decide whether to use PTEs, PMDs or PUDs at dax fault handler.
> >
> > So separate concepts, but still its value dependent on one another. At least unless we
> > want to allow geometry values different than those set by --align as Jane suggested.
> >
>
> And I should add:
>
> I can maintain the DEVMAP_* enum values, but then these will need to be changed in tandem
> anytime a new @align value is supported. Or instead we use the name @geometry albeit with
> still as an unsigned long type . Or rather than an unsigned long perhaps making another
> type and its value obtained/changed with getter/setter.

No, feel free to drop the enum and use an explicit "geometry" value
for the vmemmap.
