Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 23 Jun 2015 11:01:55 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] mm, x86: Remove region_is_ram() call from ioremap
Message-ID: <20150623090154.GA3402@gmail.com>
References: <1434750245-6304-1-git-send-email-toshi.kani@hp.com>
 <1434750245-6304-3-git-send-email-toshi.kani@hp.com>
 <55883605.5020706@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55883605.5020706@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Travis <travis@sgi.com>
Cc: Toshi Kani <toshi.kani@hp.com>, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, roland@purestorage.com, dan.j.williams@intel.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Clive Harding <clive@sgi.com>, Russ Anderson <rja@sgi.com>
List-ID: <linux-nvdimm@lists.01.org>


* Mike Travis <travis@sgi.com> wrote:

> <<<
> We have a large university system in the UK that is experiencing
> very long delays modprobing the driver for a specific I/O device.
> The delay is from 8-10 minutes per device and there are 31 devices
> in the system.  This 4 to 5 hour delay in starting up those I/O
> devices is very much a burden on the customer.
> ...
> The problem was tracked down to a very slow IOREMAP operation and
> the excessively long ioresource lookup to insure that the user is
> not attempting to ioremap RAM.  These patches provide a speed up
> to that function.
> >>>
> 
> The speed up was pretty dramatic, I think to about 15-20 minutes
> (the test was done by our local CS person in the UK).  I think this
> would prove the function was working since it would have fallen
> back to the previous page_is_ram function and the 4 to 5 hour
> startup.

Btw., I think even 15-20 minutes is still in the 'ridiculously slow' category.
Any chance to fix all of this properly, not just hack by hack?

Thanks,

	Ingo
