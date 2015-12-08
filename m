Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <5667249F.6040507@deltatee.com>
References: <20151208013236.25030.68781.stgit@dwillia2-desk3.jf.intel.com>
	<5667249F.6040507@deltatee.com>
Date: Tue, 8 Dec 2015 10:50:06 -0800
Message-ID: <CAPcyv4iKE4U1fniZyQZ8QdGrPj74tTz0bX-=VLvc4=4WjSEj-g@mail.gmail.com>
Subject: Re: [PATCH -mm 00/25] get_user_pages() for dax pte and pmd mappings
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Hansen <dave@sr71.net>, David Airlie <airlied@linux.ie>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Linux MM <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Andrea Arcangeli <aarcange@redhat.com>, kbuild test robot <lkp@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jeff Dike <jdike@addtoit.com>, Jens Axboe <axboe@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Jan Kara <jack@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Stephen Bates <Stephen.Bates@pmcs.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 8, 2015 at 10:42 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
> Hi Dan,
>
> Perfect. This latest version of the patch set is once again passing all
> my tests without any issues.
>
> Tested-By: Logan Gunthorpe <logang@deltatee.com>
>
> Thanks,
>
> Logan

Thank you for the testing, Logan!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
