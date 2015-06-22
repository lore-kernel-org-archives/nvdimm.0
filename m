Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 22 Jun 2015 18:34:53 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/15] libnvdimm: infrastructure for btt devices
Message-ID: <20150622163453.GA9187@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235458.12943.23425.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150617235458.12943.23425.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, linux-nvdimm@lists.01.org, boaz@plexistor.com, toshi.kani@hp.com, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

FYI, the mess calls into libnvdimm for each register pmem or blk device
which then walks partitions to find your btt metadata is an absolutely
no go and suggest that the layering is completely fucked up.

Please go and revisit it for a sensible model, where the different
drivers attach to a nvdimm bus instead of stacking up with a little
detour through the block layer.  From all that it's pretty clear
pmem, blk and btt should be peers in the hierarchy.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
