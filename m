Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Jun 2015 08:39:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 12/21] libnvdimm: namespace indices: read and
	validate
Message-ID: <20150609063900.GD9804@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001514.4506.13974.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150602001514.4506.13974.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

> +#include <asm-generic/io-64-nonatomic-lo-hi.h>
> +
> +#ifndef __io_virt
> +#define __io_virt(x) ((void __force *) (x))
> +#endif

NAK. driver code mus never include asm-generic headers directly,
and __io_virt isn't something that's up to a driver to redefine either.

I think we really need the memremap series in first before trying to
do the things done in this patch.
