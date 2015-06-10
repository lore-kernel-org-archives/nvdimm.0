Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 10 Jun 2015 09:34:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 18/21] nd_btt: atomic sector updates
Message-ID: <20150610073434.GC3369@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001546.4506.15713.stgit@dwillia2-desk3.amr.corp.intel.com> <20150609064425.GF9804@lst.de> <1433874431.32607.37.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1433874431.32607.37.camel@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vishal Verma <vishal.l.verma@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Vishal,

I'm mostly worried about handling scalability to large CPU counts
properly.  If you think this is the best way to handle it that fine,
but please document the decisions on the changelog in a similar form
to what you did below.
