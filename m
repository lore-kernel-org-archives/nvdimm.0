Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 24 Jun 2015 14:11:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] libnvdimm: support read-only btt backing devices
Message-ID: <20150624121152.GD17542@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235602.12943.24958.stgit@dwillia2-desk3.amr.corp.intel.com> <20150621101346.GF5915@lst.de> <CAPcyv4jjTU8MA1zWnbRsyxcnxC+EJK9pJdLBkYeGtgHXeDkKVQ@mail.gmail.com> <20150621135406.GA9572@lst.de> <CAPcyv4iAkSaCOzpJHJLLtJG_9M=5Jp75Kc9tVeCr__OjEB=ajQ@mail.gmail.com> <20150622063028.GA30434@lst.de> <20150623193043.GE1971@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150623193043.GE1971@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 23, 2015 at 03:30:43PM -0400, Matthew Wilcox wrote:
> > I can't make any guarantees, especially not without verification.  But
> > if correctly implemented any filesystems that does out of place metadata
> > writes (and that includes a traditional log) and uses checksum to ensure
> > the integrity of these updates it should be fine.  You'd still have
> > the issue of sector atomicy of file I/O though.
> 
> Is ext4 one of the filesystems that copes with torn updates to the log?
> I see there's a checksum in the tail of at least some blocks, but I'd
> like someone who understands ext4 to reassure me that it also doesn't
> need the ability to put its log on a BTT.

In theory it should if the log checksums are enabled, but I wouldn't rely
on it without without confirmation and validation from the ext4 folks.
