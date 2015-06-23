Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 23 Jun 2015 12:19:17 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/15] libnvdimm: infrastructure for btt devices
Message-ID: <20150623101917.GG24894@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235458.12943.23425.stgit@dwillia2-desk3.amr.corp.intel.com> <20150622163453.GA9187@lst.de> <CAPcyv4jAA0=aSUDazG5hS1FS0o+qg4SyMXicqF_0M0s7_cXBGw@mail.gmail.com> <20150622164837.GB9393@lst.de> <x49k2uvvbje.fsf@segfault.boston.devel.redhat.com> <CAPcyv4hSAPTRNLkfKGndUrxjzTp-FAW+4G8t926YZdVH2c-Q=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hSAPTRNLkfKGndUrxjzTp-FAW+4G8t926YZdVH2c-Q=g@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 12:02:54PM -0700, Dan Williams wrote:
> I don't see the need to re-invent partitioning which is the path this
> requested rework is putting us on...
> 
> However, when the need arises for smaller granularity BTT we can have
> the partition fight then.  To be clear, I believe that need is already
> here today, but I'm not in a position to push that agenda at this late
> date.


Instead of all this complaining and moaning let's figure out what
architecture you'd actually want.  The one I had in mind is:

+------------------------------+
|  block layer (& partitions)  |
+---------------+--------------+--------------------+
|  pmem driver  |  btt driver  |  other consumers   |
+---------------+--------------+--------------------+
|        pmem API through libnvdimm                 |
+---------------------------------------------------+

If you really want btt to stack on top of pmem it really
needs to be moved out entirely of libnvdimm and be a
generic block driver just using ->rw_bytes, e.g.:


+------------------------------+
|  btt driver                  |
+------------------------------+
|  block layer (& partitions)  |
+------------------------------+--------------------+
|  pmem driver                 | other consumers    |
+------------------------------+--------------------+
|        pmem API through libnvdimm                 |
+---------------------------------------------------+

Not the current mess where btt pretends to be a stacking block
driver but still ties into libnvdimm.

Add blk mode access to all the schemes, but it's really just
another next to the pmem driver each time.  In fact while
looking over the code a bit more I start to wonder why
we need the blk driver at all - just hook into the nfit
do_io routines instead of the low-level API based on what
libnvdimm provides, and don't offer DAX for it.  It mostly
seems duplicate code.
