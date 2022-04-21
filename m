Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F5A4690
	for <nvdimm@lists.linux.dev>; Thu, 21 Apr 2022 02:20:18 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so6508988pjb.2
        for <nvdimm@lists.linux.dev>; Wed, 20 Apr 2022 19:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kQqxPFkBgwTTXmjwogf+rVXv18PbhFLAuuZBC/yrNE8=;
        b=gAbcEDXLXf1cJAOuQcMz7KFmTi65M0OI1L+R+LrFk1NUI5eLmqLTlOn4vgPrp6nUY/
         dQ8EWp0H2qkMBdjvMBYO2wzIIvsjpy1iaePWXigztNdFtdY4LjushgcYLJ6wLueUQzot
         +RTTlMBVrTFQaSuWyKg+rIkYVajru6hHk0/PWkn6Rwqdm6vMiEKgtp+6Fz8196U+b17H
         fLrovoP/NJEM3D+FfmWiLY9b98NXC3/IQGMrd8WFDXu+foGy5FbJiYgmZGYgDlw9+TBZ
         J2IJXxjM35dgR6Lar9GJuiBhtnJAlH2enb2vdZWofi4fdk+FwKypjUep97zBA+AIoRjN
         +R+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kQqxPFkBgwTTXmjwogf+rVXv18PbhFLAuuZBC/yrNE8=;
        b=j3OscFalw01MILXzFdu7Q2o18Es6Rn1OQSLsXjPaQvzckes9LvYQYQ9I8T/8KwZN/r
         fq08+Xg/6EwTdZN5KPzlAQdb/ZMf8JPncKLj5gYhAjUC2EvsXY147+fOeNqZGZzoPv4w
         0iFt6mlc0blgTGBmXU8h3EsfdRCjgYu385psbADRbYeW/83XhYzkSlpa0uD2UyKoupY5
         IEC5xpdqnmXGTSXsmdvk/s0P/OGeGjz6vROiM8x4fCLYDWT/o19vkPMea/48zg4PYxCu
         4qJkR54b+et/woQEXaTjPv8K5CkSyqrowSISI+R8iKpWMyITiv57pG7TCf1XCdzf5JgM
         VoWA==
X-Gm-Message-State: AOAM530rm3K5I1eUUOl0RlxpVoghOxGRLxGZ8BV33Whg5jV/XfvS8xqG
	o/6KjdmbCyF5KZZ1ul7evK4Vojx59FQFnhup6jCD/A==
X-Google-Smtp-Source: ABdhPJxALQ7XKx0NqGhsKF79EfC7DnemDTaSi9ZA4BMtPhmpe2U+v+sShPr+O2cHd+WfhRLhxANO+I6PBVY9QBU08gY=
X-Received: by 2002:a17:902:ea57:b0:15a:6173:87dd with SMTP id
 r23-20020a170902ea5700b0015a617387ddmr1322664plg.147.1650507618157; Wed, 20
 Apr 2022 19:20:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220419045045.1664996-1-ruansy.fnst@fujitsu.com>
 <20220421012045.GR1544202@dread.disaster.area> <86cb0ada-208c-02de-dbc9-53c6014892c3@fujitsu.com>
In-Reply-To: <86cb0ada-208c-02de-dbc9-53c6014892c3@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Apr 2022 19:20:07 -0700
Message-ID: <CAPcyv4i0Noum8hqHtCpdM5HMVdmNHm3Aj2JCnZ+KZLgceiXYaA@mail.gmail.com>
Subject: Re: [PATCH v13 0/7] fsdax: introduce fs query to support reflink
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Dave Chinner <david@fromorbit.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Naoya Horiguchi <naoya.horiguchi@nec.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[ add Andrew and Naoya ]


On Wed, Apr 20, 2022 at 6:48 PM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrot=
e:
>
> Hi Dave,
>
> =E5=9C=A8 2022/4/21 9:20, Dave Chinner =E5=86=99=E9=81=93:
> > Hi Ruan,
> >
> > On Tue, Apr 19, 2022 at 12:50:38PM +0800, Shiyang Ruan wrote:
> >> This patchset is aimed to support shared pages tracking for fsdax.
> >
> > Now that this is largely reviewed, it's time to work out the
> > logistics of merging it.
>
> Thanks!
>
> >
> >> Changes since V12:
> >>    - Rebased onto next-20220414
> >
> > What does this depend on that is in the linux-next kernel?
> >
> > i.e. can this be applied successfully to a v5.18-rc2 kernel without
> > needing to drag in any other patchsets/commits/trees?
>
> Firstly, I tried to apply to v5.18-rc2 but it failed.
>
> There are some changes in memory-failure.c, which besides my Patch-02
>    "mm/hwpoison: fix race between hugetlb free/demotion and
> memory_failure_hugetlb()"
>
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commi=
t/?id=3D423228ce93c6a283132be38d442120c8e4cdb061
>
> Then, why it is on linux-next is: I was told[1] there is a better fix
> about "pgoff_address()" in linux-next:
>    "mm: rmap: introduce pfn_mkclean_range() to cleans PTEs"
>
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commi=
t/?id=3D65c9605009f8317bb3983519874d755a0b2ca746
> so I rebased my patches to it and dropped one of mine.
>
> [1] https://lore.kernel.org/linux-xfs/YkPuooGD139Wpg1v@infradead.org/

From my perspective, once something has -mm dependencies it needs to
go through Andrew's tree, and if it's going through Andrew's tree I
think that means the reflink side of this needs to wait a cycle as
there is no stable point that the XFS tree could merge to build on top
of.

The last reviewed-by this wants before going through there is Naoya's
on the memory-failure.c changes.
