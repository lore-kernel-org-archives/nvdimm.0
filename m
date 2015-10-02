Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 2 Oct 2015 17:28:42 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/3] Revert "dax: fix NULL pointer in __dax_pmd_fault()"
Message-ID: <20151002232842.GA19721@linux.intel.com>
References: <1443819752-17091-1-git-send-email-ross.zwisler@linux.intel.com>
 <1443819752-17091-2-git-send-email-ross.zwisler@linux.intel.com>
 <CAPcyv4jDuKnDat6keMpz0j-G3P4QTdTLm00+_=LE-GQLMR1x5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jDuKnDat6keMpz0j-G3P4QTdTLm00+_=LE-GQLMR1x5w@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 02, 2015 at 02:11:03PM -0700, Dan Williams wrote:
> On Fri, Oct 2, 2015 at 2:02 PM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
> > This reverts commit 8346c416d17bf5b4ea1508662959bb62e73fd6a5.
> >
> > This commit did fix the issue it intended to fix, but it turns out that
> > the locking changes introduced by these two commits:
> >
> > commit 843172978bb9 ("dax: fix race between simultaneous faults")
> > commit 46c043ede471 ("mm: take i_mmap_lock in unmap_mapping_range() for DAX")
> >
> > had other issues as well, so they need to just be reverted.
> 
> Wait, why introduce two points in the kernel history where we have a
> known uninitialized variable?  I'd say fix up the revert of "mm: take
> i_mmap_lock in unmap_mapping_range() for DAX" to address the conflict
> with the fix, one less patch and keeps the stability rolling forward.

Essentially because I wasn't sure about the rules regarding reverts, if there
are any.  I assumed (perhaps incorrectly) that you'd want a 1:1 relationship
between original commits and reverts.  If it's better to not have intermediate
breakage, sure, let's squash them.
