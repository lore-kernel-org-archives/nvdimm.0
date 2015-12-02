Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <1449078237.31589.30.camel@hpe.com>
References: <1448309082-20851-1-git-send-email-toshi.kani@hpe.com>
	<CAPcyv4gY2SZZwiv9DtjRk4js3gS=vf4YLJvmsMJ196aps4ZHcQ@mail.gmail.com>
	<1449022764.31589.24.camel@hpe.com>
	<CAPcyv4hzjMkwx3AA+f5Y9zfp-egjO-b5+_EU7cGO5BGMQaiN_g@mail.gmail.com>
	<1449078237.31589.30.camel@hpe.com>
Date: Wed, 2 Dec 2015 09:01:36 -0800
Message-ID: <CAPcyv4ikJ73nzQTCOfnBRThkv=rZGPM76S7=6O3LSB4kQBeEpw@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix mmap MAP_POPULATE for DAX pmd mapping
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, mauricio.porto@hpe.com, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 2, 2015 at 9:43 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> Oh, I see.  I will setup the memmap array and run the tests again.
>
> But, why does the PMD mapping depend on the memmap array?  We have observed
> major performance improvement with PMD.  This feature should always be enabled
> with DAX regardless of the option to allocate the memmap array.
>

Several factors drove this decision, I'm open to considering
alternatives but here's the reasoning:

1/ DAX pmd mappings caused crashes in the get_user_pages path leading
to commit e82c9ed41e8 "dax: disable pmd mappings".  The reason pte
mappings don't crash and instead trigger -EFAULT is due to the
_PAGE_SPECIAL pte bit.

2/ To enable get_user_pages for DAX, in both the page and huge-page
case, we need a new pte bit _PAGE_DEVMAP.

3/ Given the pte bits are hard to come I'm assuming we won't get two,
i.e. both _PAGE_DEVMAP and a new _PAGE_SPECIAL for pmds.  Even if we
could get a _PAGE_SPECIAL for pmds I'm not in favor of pursuing it.

End result is that DAX pmd mappings must be fully enabled through the
get_user_pages paths with _PAGE_DEVMAP or turned off completely.  In
general I think the "page less" DAX implementation was a good starting
point, but we need to shift to page-backed by default until we can
teach more of the kernel to operate on bare pfns.  That "default" will
need to be enforced by userspace tooling.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
