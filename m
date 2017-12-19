Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD7B6221C195F
 for <linux-nvdimm@lists.01.org>; Tue, 19 Dec 2017 06:57:58 -0800 (PST)
Date: Tue, 19 Dec 2017 16:02:42 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/17] mm: pass the vmem_altmap to arch_remove_memory
 and __remove_pages
Message-ID: <20171219150242.GA13124@lst.de>
References: <20171215140947.26075-1-hch@lst.de>
 <20171215140947.26075-7-hch@lst.de>
 <CAPcyv4iNDonroVQy7YFsM-uC_0GMsjQgSBj=ZfdOB-XUK5tsKw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iNDonroVQy7YFsM-uC_0GMsjQgSBj=ZfdOB-XUK5tsKw@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 15, 2017 at 06:04:37PM -0800, Dan Williams wrote:
> On Fri, Dec 15, 2017 at 6:09 AM, Christoph Hellwig <hch@lst.de> wrote:
> > We can just pass this on instead of having to do a radix tree lookup
> > without proper locking 2 levels into the callchain.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>wip
> 
> I assume that "wip" is a typo?

It was the description of the patch this got folded into in my
local tree.  So basically equivalent to a typo :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
