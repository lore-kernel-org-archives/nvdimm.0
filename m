Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Sun, 21 Jun 2015 12:03:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/15] nd_btt: atomic sector updates
Message-ID: <20150621100329.GA5915@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235503.12943.76918.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150617235503.12943.76918.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, linux-nvdimm@lists.01.org, boaz@plexistor.com, toshi.kani@hp.com, Vishal Verma <vishal.l.verma@linux.intel.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, linux-acpi@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, hch@lst.de, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

> +config ND_MAX_REGIONS
> +	int "Maximum number of regions supported by the sub-system"
> +	default 64
> +	---help---
> +	  A 'region' corresponds to an individual DIMM or an interleave
> +	  set of DIMMs.  A typical maximally configured system may have
> +	  up to 32 DIMMs.
> +
> +	  Leave the default of 64 if you are unsure.

Having static limits in Kconfig is a bad idea.  What prevents you
from handling any (reasonable) number dynamically?
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
