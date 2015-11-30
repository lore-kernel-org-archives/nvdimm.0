Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20151130050833.18366.21963.stgit@dwillia2-desk3.jf.intel.com>
References: <20151130050833.18366.21963.stgit@dwillia2-desk3.jf.intel.com>
Date: Mon, 30 Nov 2015 11:12:29 -0800
Message-ID: <CAPcyv4jKxV-Uq2+AbwVyvTyb8SNeHaVXTf5A_YYDiptNkPnfFQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] get_user_pages() for dax mappings
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Linux MM <linux-mm@kvack.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Dave Hansen <dave@sr71.net>, "Kani, Toshimitsu" <toshi.kani@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Mel Gorman <mgorman@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Nov 29, 2015 at 9:08 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> The full set in context with other changes is available here:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm libnvdimm-pending

Note, I refreshed the branch to fix a randconfig compile error
reported by the kbuild robot, but no other substantive changes
relative to the posted patches.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
