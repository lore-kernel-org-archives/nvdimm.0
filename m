Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3FA9621A16ECF
 for <linux-nvdimm@lists.01.org>; Tue, 13 Jun 2017 14:33:57 -0700 (PDT)
Date: Tue, 13 Jun 2017 15:35:11 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/2] mm: always enable thp for dax mappings
Message-ID: <20170613213511.GB5135@linux.intel.com>
References: <149713136649.17377.3742583729924020371.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149713137723.17377.8854203820807564559.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170612120714.zypyvp3e4zypqfvf@black.fi.intel.com>
 <CAPcyv4jb6Vqvm-rZ84z44LaoerMcJUZiR59TAiQ2itTqwb0j7A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jb6Vqvm-rZ84z44LaoerMcJUZiR59TAiQ2itTqwb0j7A@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@lst.de>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 12, 2017 at 07:47:19AM -0700, Dan Williams wrote:
> On Mon, Jun 12, 2017 at 5:07 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > On Sat, Jun 10, 2017 at 02:49:37PM -0700, Dan Williams wrote:
> >> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> >> index c4706e2c3358..901ed3767d1b 100644
> >> --- a/include/linux/huge_mm.h
> >> +++ b/include/linux/huge_mm.h
> >> @@ -1,6 +1,8 @@
> >>  #ifndef _LINUX_HUGE_MM_H
> >>  #define _LINUX_HUGE_MM_H
> >>
> >> +#include <linux/fs.h>
> >> +
> >
> > It means <linux/mm.h> now depends on <linux/fs.h>. I don't think it's a
> > good idea.
> 
> Seems to be ok as far as 0day-kbuild-robot is concerned. The
> alternative is to move vma_is_dax() out of line. I think
> transparent_hugepage_enabled() is called frequently enough to make it
> worth it to keep it inline.

Yea, I played with moving vma_is_dax() to include/linux/mm.h instead, but ran
into the issue where IS_DAX() is defined in include/linux/fs.h.  So, any way
we slice it we end up requiring both MM and FS includes for this to work.

Since the way you have it here apparently works and passes zero-day, my vote
is to just go with it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
