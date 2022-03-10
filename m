Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9957A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 00:59:13 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id mv5-20020a17090b198500b001bf2a039831so6813109pjb.5
        for <nvdimm@lists.linux.dev>; Wed, 09 Mar 2022 16:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NQaSIZIxO5KOdOicjkb1cFrwib5bGbIpCqk65gAppCI=;
        b=VS2xx8r9PIGwCLa64CuDfWCjlfdzMZcrNjPDuGSm77clH/PVMaEZN2pFx9+sRO7bqW
         NT6d5L8XGp5XpSuR6KuMouThtrdyDHbkITw+k9eisuQJylQgdSTzNjL6hXN+HdOsOAiQ
         cpFH7NrpzwaP8f7q7dqp322hrR0wM5RwN+VGHbpilCz8ADGA8IPs2ZX55ZR+0G7xPGsC
         CSwwKUf//3X1p7hREN0WgucPZ5yZc7YRbwvGPR1udtiTEZJao3XE/m/Hn1NBh7rCglRm
         fbhq4iAW9AUvr0m7gEOlYSgkuwWgsA4XYTxNaspmnJFzTOItrpijpGdy7OsrHpvYytSU
         Da9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NQaSIZIxO5KOdOicjkb1cFrwib5bGbIpCqk65gAppCI=;
        b=SaFpyGhXhW5p7MXRRqwMGXRYinG1O3prrVDnZEvjB+tJzliB0LqmC2vA1FgdbL0tLy
         lE2i5TaJK+FuryqKPH5sJgsxsK+OJvu74ZaFJqa0VI9p+HEaHlPjhwptqfj8ZX9aekE6
         aFtke67TZ6gWpRWqMaJ9LOZ06swLtyQaC8cW1+xRg13Ajg8lw38hPtu7MTqxAZ6XdW8V
         kUPzBw/LoCJZ7xLUJyjnyzYL96tAe0q0DCtuIJ+oWyZ74GprSMG+N8q09lOZoLsTFGDZ
         zSnHGeFkrdB9HQS6l/uzKlpEJqZFG6qkawaUVoMBdprg0fRJa9+qFOFcXTUWwg6YfaTh
         4o3g==
X-Gm-Message-State: AOAM5326tmy+/zltVZXP3eR5KKOI9qfDJ4RTP+fXOHfC/TOmPMr4JxmI
	mwvt5zdGkeyid36HddmeNlow0wtmkyXN6/61nkOx+w==
X-Google-Smtp-Source: ABdhPJw96a/Eq6dU3OeebKd8y0NUTDNVyL9MKec/ynBgpi4ejJZav6ILrpB7Vds7D2x6nUx/OKPBrD3KR+tlbTRAg84=
X-Received: by 2002:a17:902:7296:b0:14b:4bc6:e81 with SMTP id
 d22-20020a170902729600b0014b4bc60e81mr2486890pll.132.1646873952956; Wed, 09
 Mar 2022 16:59:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220302082718.32268-1-songmuchun@bytedance.com> <20220302082718.32268-6-songmuchun@bytedance.com>
In-Reply-To: <20220302082718.32268-6-songmuchun@bytedance.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Mar 2022 16:59:02 -0800
Message-ID: <CAPcyv4hsMWe1AreVVhGJD-St3FGtGBMeA-BX7XbA_kVX97tw4Q@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] dax: fix missing writeprotect the pte entry
To: Muchun Song <songmuchun@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andrew Morton <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>, 
	Yang Shi <shy828301@gmail.com>, Ralph Campbell <rcampbell@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, xiyuyang19@fudan.edu.cn, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ross Zwisler <zwisler@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, 
	duanxiongchun@bytedance.com, Muchun Song <smuchun@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 2, 2022 at 12:30 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> Currently dax_mapping_entry_mkclean() fails to clean and write protect
> the pte entry within a DAX PMD entry during an *sync operation. This
> can result in data loss in the following sequence:
>
>   1) process A mmap write to DAX PMD, dirtying PMD radix tree entry and
>      making the pmd entry dirty and writeable.
>   2) process B mmap with the @offset (e.g. 4K) and @length (e.g. 4K)
>      write to the same file, dirtying PMD radix tree entry (already
>      done in 1)) and making the pte entry dirty and writeable.
>   3) fsync, flushing out PMD data and cleaning the radix tree entry. We
>      currently fail to mark the pte entry as clean and write protected
>      since the vma of process B is not covered in dax_entry_mkclean().
>   4) process B writes to the pte. These don't cause any page faults since
>      the pte entry is dirty and writeable. The radix tree entry remains
>      clean.
>   5) fsync, which fails to flush the dirty PMD data because the radix tree
>      entry was clean.
>   6) crash - dirty data that should have been fsync'd as part of 5) could
>      still have been in the processor cache, and is lost.

Excellent description.

>
> Just to use pfn_mkclean_range() to clean the pfns to fix this issue.

So the original motivation for CONFIG_FS_DAX_LIMITED was for archs
that do not have spare PTE bits to indicate pmd_devmap(). So this fix
can only work in the CONFIG_FS_DAX_LIMITED=n case and in that case it
seems you can use the current page_mkclean_one(), right? So perhaps
the fix is to skip patch 3, keep patch 4 and make this patch use
page_mkclean_one() along with this:

diff --git a/fs/Kconfig b/fs/Kconfig
index 7a2b11c0b803..42108adb7a78 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -83,6 +83,7 @@ config FS_DAX_PMD
        depends on FS_DAX
        depends on ZONE_DEVICE
        depends on TRANSPARENT_HUGEPAGE
+       depends on !FS_DAX_LIMITED

 # Selected by DAX drivers that do not expect filesystem DAX to support
 # get_user_pages() of DAX mappings. I.e. "limited" indicates no support

...to preclude the pmd conflict in that case?
