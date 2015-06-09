Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Jun 2015 08:33:12 +0200
From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH v5 02/21] libnvdimm, nfit: initial libnvdimm
	infrastructure and NFIT support
Message-ID: <20150609063312.GA9804@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001419.4506.41953.stgit@dwillia2-desk3.amr.corp.intel.com> <20150603145704.GA22311@lst.de> <1433359473.21035.27.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1433359473.21035.27.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "neilb@suse.de" <neilb@suse.de>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "rafael@kernel.org" <rafael@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 03, 2015 at 07:24:34PM +0000, Williams, Dan J wrote:
> > > +static inline struct acpi_nfit_memory_map *__to_nfit_memdev(struct nfit_mem *nfit_mem)
> > 
> > This line is over 80 characters.
> 
> I generally don't see the point of fixing up occasional small incursions
> over 80 characters if it makes the code more amenable to grep.

Just use shorter type names or add a line break before the symbol
names.  Too long lines are highly annoying.
