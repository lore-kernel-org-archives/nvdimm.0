Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4309C72
	for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 23:48:05 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id d12so4156568pgd.9
        for <nvdimm@lists.linux.dev>; Wed, 14 Jul 2021 16:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RYJwbh9KOD42Nf9grsOeUnqWk613NdX1cSceZQgmFzY=;
        b=la5Lzin/p9l6kMKFGi0nSnGoTD6/D3mcyh4lmt+Zx3MPG/CRQRg1LvlrPpYxvATPsH
         NltxhoZzZIIklEW1LExZH+14Um8mvy632/UM6d9us1de7T5yN7zFfDjsZX88Y3m5ncow
         Z8pjNyH1nXg7FY3zgD/vxEZRDlsUtERtYWTfkjVHxDsYFEa4cEFMp+Ks1BVr6Wi6zRkY
         PlCr8h5ooOIk5PADZpi2Nvo8AzjQHLSIbpnjaQSeL79IDJ9azobM6NlplSs0/zjxUN9Y
         VGLNeFK+YLgk/Gplp4Dlt6yPwlUvvUnmNOhl1PYuoJdbSZ2cIjamdnVMPAIfNxVtblGf
         97jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RYJwbh9KOD42Nf9grsOeUnqWk613NdX1cSceZQgmFzY=;
        b=jwyWv8Ma7svgOh8daR6QNXdrofd8keTrhWfHZy6FBjhfVLf3JztPBx/kJD63/yWRjg
         4KD5f6/zs5OmUq22a2JKYHg5T6rGt7JTrj80p5k6ccknivf79PGSi2ogx6jUu/5ocsIM
         vCX09XXlAvlKs+2wuAxXesNneU239GWw0jPVqUSefj1IdkcWniCGoZISZrLSEiZX27DB
         Zj+go0izdERy1LOVkzP26s4t9qhzmTf6IiRM9tQBoFVmZx8nw1G8LlMezXuXJrkUV8x4
         aAdPdbiz/3M1DhETtPloDEd+Hvz3lfKLHiczhzMl2R6ImrhVEZQ4Gp+j9bOIZI8Lza4E
         XHfw==
X-Gm-Message-State: AOAM532CqHu9o0mJFHDK7+QYcvA+Y+RYUWw/o9WjlOHQ0ZVEwhwMb1+6
	oDN0p/VcVCfXOV8a9Cw4fmzzLoRulnSN696pG3fdyQ==
X-Google-Smtp-Source: ABdhPJwneGCuIIVoUCtM9q9uOOW140VZfTV5NbZkp/6lBrGpkRU0Bdxnv37+tn9M3sWDwBLiq5jWR9FnjE1VcTRpaKk=
X-Received: by 2002:a63:4c3:: with SMTP id 186mr587774pge.240.1626306484737;
 Wed, 14 Jul 2021 16:48:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210714193542.21857-1-joao.m.martins@oracle.com> <20210714144830.29f9584878b04903079ef7eb@linux-foundation.org>
In-Reply-To: <20210714144830.29f9584878b04903079ef7eb@linux-foundation.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Jul 2021 16:47:53 -0700
Message-ID: <CAPcyv4gotCqOnssJk6QzU9rXyfC+6qJi_4iDR5HkTUv9Waxqiw@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] mm, sparse-vmemmap: Introduce compound pagemaps
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joao Martins <joao.m.martins@oracle.com>, Linux MM <linux-mm@kvack.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Naoya Horiguchi <naoya.horiguchi@nec.com>, Matthew Wilcox <willy@infradead.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>, 
	Muchun Song <songmuchun@bytedance.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
	Jonathan Corbet <corbet@lwn.net>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 14, 2021 at 2:48 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 14 Jul 2021 20:35:28 +0100 Joao Martins <joao.m.martins@oracle.com> wrote:
>
> > This series, attempts at minimizing 'struct page' overhead by
> > pursuing a similar approach as Muchun Song series "Free some vmemmap
> > pages of hugetlb page"[0] but applied to devmap/ZONE_DEVICE which is now
> > in mmotm.
> >
> > [0] https://lore.kernel.org/linux-mm/20210308102807.59745-1-songmuchun@bytedance.com/
>
> [0] is now in mainline.
>
> This patch series looks like it'll clash significantly with the folio
> work and it is pretty thinly reviewed,

Sorry about that, I've promised Joao some final reviewed-by tags and
testing for a while, and the gears are turning now.

> so I think I'll take a pass for now.  Matthew, thoughts?

I'll defer to Matthew about folio collision, but I did not think this
compound page geometry setup for memremap_pages() would collide with
folios that want to clarify passing multi-order pages around the
kernel.

Joao is solving a long standing criticism of memremap_pages() usage
for PMEM where the page metadata is too large to fit in RAM and the
page array in PMEM is noticeably slower to pin for frequent
pin_user_pages() events.

memremap_pages() is a good first candidate for this solution given
it's pages never get handled by the page allocator. If anything it
allows folios to seep deeper into the DAX code as it knocks down the
"base-pages only" assumption of those paths.
