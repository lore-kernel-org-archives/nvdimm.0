Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 47D3F2034A76F
 for <linux-nvdimm@lists.01.org>; Wed,  6 Dec 2017 14:40:11 -0800 (PST)
Date: Wed, 6 Dec 2017 23:44:41 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] mm: fix dev_pagemap reference counting around
 get_dev_pagemap
Message-ID: <20171206224441.GA14274@lst.de>
References: <20171205003443.22111-1-hch@lst.de>
 <20171205003443.22111-3-hch@lst.de>
 <CAPcyv4i3RP12-3T8R4tazfVvC+UG-FaUjorcbHnC1OPsc-5+YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i3RP12-3T8R4tazfVvC+UG-FaUjorcbHnC1OPsc-5+YQ@mail.gmail.com>
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
Cc: Linux MM <linux-mm@kvack.org>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 05, 2017 at 06:43:36PM -0800, Dan Williams wrote:
> I don't think we need this change, but perhaps the reasoning should be
> added to the code as a comment... details below.

Hmm, looks like we are ok at least.  But even if it's not a correctness
issue there is no good point in decrementing and incrementing the
reference count every time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
