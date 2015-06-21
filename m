Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sun, 21 Jun 2015 12:05:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/15] libnvdimm, nfit, nd_blk: driver for BLK-mode
	access persistent memory
Message-ID: <20150621100535.GB5915@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235508.12943.25057.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150617235508.12943.25057.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, linux-nvdimm@lists.01.org, boaz@plexistor.com, toshi.kani@hp.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

> +#include <asm-generic/io-64-nonatomic-hi-lo.h>

As mentioned last time only arch asm/ headers may include asm-generic
headers.

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
