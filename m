Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 97F602130C4BF
 for <linux-nvdimm@lists.01.org>; Mon, 12 Aug 2019 21:58:38 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x7D4rxGY121955
 for <linux-nvdimm@lists.01.org>; Tue, 13 Aug 2019 00:56:21 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2ubnk69u8c-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 13 Aug 2019 00:56:21 -0400
Received: from localhost
 by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <bharata@linux.ibm.com>;
 Tue, 13 Aug 2019 05:56:19 +0100
Date: Tue, 13 Aug 2019 10:26:11 +0530
From: Bharata B Rao <bharata@linux.ibm.com>
Subject: Re: [PATCH 5/5] memremap: provide a not device managed memremap_pages
References: <20190811081247.22111-1-hch@lst.de>
 <20190811081247.22111-6-hch@lst.de>
 <20190812145058.GA16950@in.ibm.com> <20190812150012.GA12700@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190812150012.GA12700@lst.de>
Message-Id: <20190813045611.GB16950@in.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: bharata@linux.ibm.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jason Gunthorpe <jgg@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 12, 2019 at 05:00:12PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 12, 2019 at 08:20:58PM +0530, Bharata B Rao wrote:
> > On Sun, Aug 11, 2019 at 10:12:47AM +0200, Christoph Hellwig wrote:
> > > The kvmppc ultravisor code wants a device private memory pool that is
> > > system wide and not attached to a device.  Instead of faking up one
> > > provide a low-level memremap_pages for it.  Note that this function is
> > > not exported, and doesn't have a cleanup routine associated with it to
> > > discourage use from more driver like users.
> > 
> > The kvmppc secure pages management code will be part of kvm-hv which
> > can be built as module too. So it would require memremap_pages() to be
> > exported.
> > 
> > Additionally, non-dev version of the cleanup routine
> > devm_memremap_pages_release() or equivalent would also be requried.
> > With device being present, put_device() used to take care of this
> > cleanup.
> 
> Oh well.  We can add them fairly easily if we really need to, but I
> tried to avoid that.  Can you try to see if this works non-modular
> for you for now until we hear more feedback from Dan?

Yes, this patchset works non-modular and with kvm-hv as module, it
works with devm_memremap_pages_release() and release_mem_region() in the
cleanup path. The cleanup path will be required in the non-modular
case too for proper recovery from failures.

Regards,
Bharata.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
