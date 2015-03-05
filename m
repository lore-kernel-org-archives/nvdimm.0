Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1425587707.24292.246.camel@x220>
Subject: Re: [PATCH 1/8] pmem: Initial version of persistent memory driver
From: Paul Bolle <pebolle@tiscali.nl>
Date: Thu, 05 Mar 2015 21:35:07 +0100
In-Reply-To: <54F84420.40209@plexistor.com>
References: <54F82CE0.4040502@plexistor.com>
	 <54F830D4.7030205@plexistor.com> <54F84420.40209@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

For what it's worth, at this moment, I found a license nit.

On Thu, 2015-03-05 at 13:55 +0200, Boaz Harrosh wrote:
> --- /dev/null
> +++ b/drivers/block/pmem.c
> @@ -0,0 +1,334 @@
> +/*
> + * Persistent Memory Driver
> + * Copyright (c) 2014, Intel Corporation.
> + * Copyright (c) 2014, Boaz Harrosh <boaz@plexistor.com>.
> + *
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

So you probably want
    MODULE_LICENSE("GPL v2");

here.


Paul Bolle

