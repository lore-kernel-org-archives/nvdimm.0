Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <1426618410.15575.1.camel@x220>
Subject: Re: [PATCH 1/6] pmem: Initial version of persistent memory driver
From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 17 Mar 2015 19:53:30 +0100
In-Reply-To: <1426540380-24503-2-git-send-email-ross.zwisler@linux.intel.com>
References: <1426540380-24503-1-git-send-email-ross.zwisler@linux.intel.com>
	 <1426540380-24503-2-git-send-email-ross.zwisler@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@infradead.org, riel@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

Just a license nit.

On Mon, 2015-03-16 at 15:12 -0600, Ross Zwisler wrote:
> --- /dev/null
> +++ b/drivers/block/pmem.c

> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.

This states the license is GPL v2.

> +MODULE_LICENSE("GPL");

And using
    MODULE_LICENSE("GPL v2");

would match that statement.


Paul Bolle

