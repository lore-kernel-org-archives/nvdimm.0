Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8997881F87
 for <linux-nvdimm@lists.01.org>; Wed,  1 Feb 2017 01:28:02 -0800 (PST)
Date: Wed, 1 Feb 2017 10:28:00 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 10/17] block: introduce bdev_dax_direct_access()
Message-ID: <20170201092800.GA1050@lst.de>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com>
 <148559261791.11180.12085685820239925499.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170130123226.GD9043@lst.de>
 <CAPcyv4iARmZQSBybJ1iJhwkndVxSe62rk4hjP1T9prBuOqVQ-A@mail.gmail.com>
 <20170201081020.GD29170@lst.de>
 <CAPcyv4g419yOyH_UnMAxMUpxjEbAWDbL2NAG4ScfF+iNHdLfAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g419yOyH_UnMAxMUpxjEbAWDbL2NAG4ScfF+iNHdLfAQ@mail.gmail.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 01, 2017 at 01:21:40AM -0800, Dan Williams wrote:
> > In/Out parameters are always a bit problematic in terms of API clarity.
> > And updating a device-relative address with an absolute physical one
> > sounds like an odd API for sure.
> 
> Yes, it does, and I thought better of it shortly after sending that. How about:
> 
> long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> unsigned long nr_pages, void **kaddr, pfn_t *pfn)

Yes, that looks good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
