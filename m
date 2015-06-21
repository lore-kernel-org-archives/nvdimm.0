Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sun, 21 Jun 2015 12:08:01 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/15] libnvdimm: fix up max_hw_sectors
Message-ID: <20150621100801.GC5915@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235541.12943.86562.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150617235541.12943.86562.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, linux-nvdimm@lists.01.org, boaz@plexistor.com, toshi.kani@hp.com, Vishal Verma <vishal.l.verma@linux.intel.com>, linux-kernel@vger.kernel.org, hch@lst.de, linux-acpi@vger.kernel.org, linux-fsdevel@vger.kernel.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

> +void nd_blk_queue_init(struct request_queue *q)
> +{
> +	blk_queue_max_hw_sectors(q, UINT_MAX);
> +	blk_queue_bounce_limit(q, BLK_BOUNCE_ANY);
> +}

Please just add the calls to the drivers instead of this helper which
hides the intent.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
