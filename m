Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 9 Aug 2019 16:42:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] mm/memremap: Fix reuse of pgmap instances with
 internal references
Message-ID: <20190809144219.GB10269@lst.de>
References: <156530042781.2068700.8733813683117819799.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156530042781.2068700.8733813683117819799.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Fan Du <fan.du@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgg@mellanox.com>, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
