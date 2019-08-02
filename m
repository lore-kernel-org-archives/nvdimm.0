Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 2 Aug 2019 10:32:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] memremap: move from kernel/ to mm/
Message-ID: <20190802083230.GB11000@lst.de>
References: <20190722094143.18387-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722094143.18387-1-hch@lst.de>
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Andrew,

I've seen you've queued this up in -mm, but the explicit intent here was
to quickly merge this after -rc1 so that the move doesn't conflict with
further development for 5.3.  Any chance you could send this patch on
to Linus?
