Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1448312664.19320.9.camel@hpe.com>
Subject: Re: [PATCH] dax: Split pmd map when fallback on COW
From: Toshi Kani <toshi.kani@hpe.com>
Date: Mon, 23 Nov 2015 14:04:24 -0700
In-Reply-To: <CAPcyv4hafiv+EJaWGDhrV4Fe7=h=naALTwY0b=pfC2yfS7NShw@mail.gmail.com>
References: <1448309120-20911-1-git-send-email-toshi.kani@hpe.com>
	 <CAPcyv4ibgtMJdKG19vaS_s2_eFy8ufZm92G2DH6N7brDiE+LYA@mail.gmail.com>
	 <1448311559.19320.2.camel@hpe.com>
	 <CAPcyv4hafiv+EJaWGDhrV4Fe7=h=naALTwY0b=pfC2yfS7NShw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2015-11-23 at 12:56 -0800, Dan Williams wrote:
> On Mon, Nov 23, 2015 at 12:45 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> > On Mon, 2015-11-23 at 12:45 -0800, Dan Williams wrote:
> > > On Mon, Nov 23, 2015 at 12:05 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> [..]
> > > This is a nop if CONFIG_TRANSPARENT_HUGEPAGE=n, so I don't think it's
> > > a complete fix.
> > 
> > Well, __dax_pmd_fault() itself depends on CONFIG_TRANSPARENT_HUGEPAGE.
> > 
> 
> Indeed it is... I think that's wrong because transparent huge pages
> rely on struct page??

I do not think this issue is related with struct page.  wp_huge_pmd() calls
either do_huge_pmd_wp_page() or dax_pmd_fault().  do_huge_pmd_wp_page() splits a
pmd page when it returns with VM_FAULT_FALLBACK.  So, this change keeps them
consistent on VM_FAULT_FALLBACK.

Thanks,
-Toshi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
