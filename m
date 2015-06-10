Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1433960682.32607.45.camel@linux.intel.com>
Subject: Re: [PATCH v5 18/21] nd_btt: atomic sector updates
From: Vishal Verma <vishal.l.verma@linux.intel.com>
Date: Wed, 10 Jun 2015 12:24:42 -0600
In-Reply-To: <20150610073434.GC3369@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150602001546.4506.15713.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150609064425.GF9804@lst.de> <1433874431.32607.37.camel@linux.intel.com>
	 <20150610073434.GC3369@lst.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2015-06-10 at 09:34 +0200, Christoph Hellwig wrote:
> Hi Vishal,
> 
> I'm mostly worried about handling scalability to large CPU counts
> properly.  If you think this is the best way to handle it that fine,
> but please document the decisions on the changelog in a similar form
> to what you did below.

Thanks Christoph.

I'll update the changelog for the next version. Scalability and
performance are of course at the top of my head - this implementation is
a first shot at what we think will work best, but if there are
experiments/changes/data that show otherwise, I'll be more than happy to
incorporate those.

	-Vishal

