Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1443819752-17091-2-git-send-email-ross.zwisler@linux.intel.com>
References: <1443819752-17091-1-git-send-email-ross.zwisler@linux.intel.com>
	<1443819752-17091-2-git-send-email-ross.zwisler@linux.intel.com>
Date: Fri, 2 Oct 2015 14:11:03 -0700
Message-ID: <CAPcyv4jDuKnDat6keMpz0j-G3P4QTdTLm00+_=LE-GQLMR1x5w@mail.gmail.com>
Subject: Re: [PATCH 1/3] Revert "dax: fix NULL pointer in __dax_pmd_fault()"
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 2, 2015 at 2:02 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> This reverts commit 8346c416d17bf5b4ea1508662959bb62e73fd6a5.
>
> This commit did fix the issue it intended to fix, but it turns out that
> the locking changes introduced by these two commits:
>
> commit 843172978bb9 ("dax: fix race between simultaneous faults")
> commit 46c043ede471 ("mm: take i_mmap_lock in unmap_mapping_range() for DAX")
>
> had other issues as well, so they need to just be reverted.

Wait, why introduce two points in the kernel history where we have a
known uninitialized variable?  I'd say fix up the revert of "mm: take
i_mmap_lock in unmap_mapping_range() for DAX" to address the conflict
with the fix, one less patch and keeps the stability rolling forward.
