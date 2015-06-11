Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 11 Jun 2015 09:28:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 17/21] libnvdimm: infrastructure for btt devices
Message-ID: <20150611072812.GB1905@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001541.4506.90125.stgit@dwillia2-desk3.amr.corp.intel.com> <20150609064200.GE9804@lst.de> <20150610184616.GL2729@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150610184616.GL2729@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 10, 2015 at 02:46:16PM -0400, Matthew Wilcox wrote:
> Don't screw up rw_page.  The point of rw_page is to read or write a page
> cache page.  It can sleep, and it indicates success by using the page
> flags.  Don't try and scqueeze rw_bytes into it.  If you want rw_bytes
> to be a queue operation, that's one thing, but don't mess with rw_page.

Oh, I forgot about the page manipulating nature.  Yes, we'll need a different
operation in this case.
