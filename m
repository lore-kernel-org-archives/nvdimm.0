Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E301202E5CFD
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 21:12:43 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id h200so23261966oib.4
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 21:16:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171021032008.GA27694@bombadil.infradead.org>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150846714747.24336.14704246566580871364.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171020075735.GA14378@lst.de>
 <CAPcyv4hA1nrhDf=DA6_j7s7ezGOBhvEVZ8cu81DNui_p3bhhaA@mail.gmail.com>
 <20171020162933.GA26320@lst.de>
 <CAPcyv4jP0ws7dcBrXafS7ON+0_J1BTp_LCB6XB3od4d6db071A@mail.gmail.com>
 <20171021032008.GA27694@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Oct 2017 21:16:21 -0700
Message-ID: <CAPcyv4hYFAFsyF8RVc2kQwf-q2SWVPA4BFaerNbQXQBvhDONmg@mail.gmail.com>
Subject: Re: [PATCH v3 02/13] dax: require 'struct page' for filesystem dax
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 20, 2017 at 8:20 PM, Matthew Wilcox <willy@infradead.org> wrote:
> On Fri, Oct 20, 2017 at 03:29:57PM -0700, Dan Williams wrote:
>> Ok, I'd also like to kill DAX support in the brd driver. It's a source
>> of complexity and maintenance burden for zero benefit. It's the only
>> ->direct_access() implementation that sleeps and it's the only
>> implementation where there is a non-linear relationship between
>> sectors and pfns. Having a 1:1 sector to pfn relationship will help
>> with the dma-extent-busy management since we don't need to keep
>> calling into the driver to map pfns back to sectors once we know the
>> pfn[0] sector[0] relationship.
>
> But these are important things that other block devices may / will want.
>
> For example, I think it's entirely sensible to support ->direct_access
> for RAID-0.  Dell are looking at various different options for having
> one pmemX device per DIMM and using RAID to lash them together.
> ->direct_access makes no sense for RAID-5 or RAID-1, but RAID-0 makes
> sense to me.
>
> Last time we tried to take sleeping out, there were grumblings from people
> with network block devices who thought they'd want to bring pages in
> across the network.  I'm a bit less sympathetic to this because I don't
> know anyone actively working on it, but the RAID-0 case is something I
> think we should care about.

True, good point. In fact we already support device-mapper striping
with ->direct_access(). I'd still like to go ahead with the sleeping
removal. When those folks come back and add network direct_access they
can do the hard work of figuring out cases where we need to call
direct_access in atomic contexts.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
