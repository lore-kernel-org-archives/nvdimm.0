Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5EFF5202E617C
 for <linux-nvdimm@lists.01.org>; Sat, 21 Oct 2017 01:12:17 -0700 (PDT)
Date: Sat, 21 Oct 2017 10:15:56 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
Message-ID: <20171021081556.GC21101@lst.de>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171020075735.GA14378@lst.de>
 <CAPcyv4hA1nrhDf=DA6_j7s7ezGOBhvEVZ8cu81DNui_p3bhhaA@mail.gmail.com>
 <20171020162933.GA26320@lst.de>
 <CAPcyv4jP0ws7dcBrXafS7ON+0_J1BTp_LCB6XB3od4d6db071A@mail.gmail.com>
 <20171021032008.GA27694@bombadil.infradead.org>
 <CAPcyv4hYFAFsyF8RVc2kQwf-q2SWVPA4BFaerNbQXQBvhDONmg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hYFAFsyF8RVc2kQwf-q2SWVPA4BFaerNbQXQBvhDONmg@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 20, 2017 at 09:16:21PM -0700, Dan Williams wrote:
> > For example, I think it's entirely sensible to support ->direct_access
> > for RAID-0.  Dell are looking at various different options for having
> > one pmemX device per DIMM and using RAID to lash them together.
> > ->direct_access makes no sense for RAID-5 or RAID-1, but RAID-0 makes
> > sense to me.
> >
> > Last time we tried to take sleeping out, there were grumblings from people
> > with network block devices who thought they'd want to bring pages in
> > across the network.  I'm a bit less sympathetic to this because I don't
> > know anyone actively working on it, but the RAID-0 case is something I
> > think we should care about.
> 
> True, good point. In fact we already support device-mapper striping
> with ->direct_access(). I'd still like to go ahead with the sleeping
> removal. When those folks come back and add network direct_access they
> can do the hard work of figuring out cases where we need to call
> direct_access in atomic contexts.

It would be great to move DAX striping out of DM so that we don't need
to keep fake block devices around just for that.  In fact if Dell is so
interested in it it would be great if they get a strip/concact table
into ACPI so that the bios and OS can agree on it in a standardized way,
and we can just implement it in the nvdimm layer.

I agree that there is no reason at all to support sleeping in
->direct_access - it makes life painful for no gain at all.  If you
network access remote memory you will need local memory to support
mmap, so we might as well use the page cache instead of reinventing
it. (saying that with my remote pmem over NFS hat on).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
