Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D414D20311205
 for <linux-nvdimm@lists.01.org>; Wed, 14 Aug 2019 02:00:44 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x7E8v7MF060461
 for <linux-nvdimm@lists.01.org>; Wed, 14 Aug 2019 04:58:36 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2uccdaeu5w-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 14 Aug 2019 04:58:36 -0400
Received: from localhost
 by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <bharata@linux.ibm.com>;
 Wed, 14 Aug 2019 09:58:34 +0100
Date: Wed, 14 Aug 2019 14:28:26 +0530
From: Bharata B Rao <bharata@linux.ibm.com>
Subject: Re: [PATCH 5/5] memremap: provide a not device managed memremap_pages
References: <20190811081247.22111-1-hch@lst.de>
 <20190811081247.22111-6-hch@lst.de>
 <20190812145058.GA16950@in.ibm.com> <20190812150012.GA12700@lst.de>
 <20190813045611.GB16950@in.ibm.com> <20190814061150.GA24835@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190814061150.GA24835@lst.de>
Message-Id: <20190814085826.GB8784@in.ibm.com>
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

On Wed, Aug 14, 2019 at 08:11:50AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 13, 2019 at 10:26:11AM +0530, Bharata B Rao wrote:
> > Yes, this patchset works non-modular and with kvm-hv as module, it
> > works with devm_memremap_pages_release() and release_mem_region() in the
> > cleanup path. The cleanup path will be required in the non-modular
> > case too for proper recovery from failures.
> 
> Can you check if the version here:
> 
>     git://git.infradead.org/users/hch/misc.git pgmap-remove-dev
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/pgmap-remove-dev
> 
> works for you fully before I resend?

Yes, this works for us. This and migrate-vma-cleanup series helps to
really simplify the kvmppc secure pages management code. Thanks.

Regards,
Bharata.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
