Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1435072798.11808.240.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/3] mm, x86: Remove region_is_ram() call from ioremap
From: Toshi Kani <toshi.kani@hp.com>
Date: Tue, 23 Jun 2015 09:19:58 -0600
In-Reply-To: <20150623090154.GA3402@gmail.com>
References: <1434750245-6304-1-git-send-email-toshi.kani@hp.com>
	 <1434750245-6304-3-git-send-email-toshi.kani@hp.com>
	 <55883605.5020706@sgi.com> <20150623090154.GA3402@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Travis <travis@sgi.com>, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, roland@purestorage.com, dan.j.williams@intel.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Clive Harding <clive@sgi.com>, Russ Anderson <rja@sgi.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2015-06-23 at 11:01 +0200, Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
> > <<<
> > We have a large university system in the UK that is experiencing
> > very long delays modprobing the driver for a specific I/O device.
> > The delay is from 8-10 minutes per device and there are 31 devices
> > in the system.  This 4 to 5 hour delay in starting up those I/O
> > devices is very much a burden on the customer.
> > ...
> > The problem was tracked down to a very slow IOREMAP operation and
> > the excessively long ioresource lookup to insure that the user is
> > not attempting to ioremap RAM.  These patches provide a speed up
> > to that function.
> > >>>
> > 
> > The speed up was pretty dramatic, I think to about 15-20 minutes
> > (the test was done by our local CS person in the UK).  I think this
> > would prove the function was working since it would have fallen
> > back to the previous page_is_ram function and the 4 to 5 hour
> > startup.
> 
> Btw., I think even 15-20 minutes is still in the 'ridiculously slow' category.
> Any chance to fix all of this properly, not just hack by hack?

I agree that 15-20 minutes is till slow, but this slowness did not come
from this ioremap RAM check because region_is_ram() used in this test
had bugs, which led it return immediately.  The slowness came from other
places, such as page table initialization.

I do not think the number of the resource table entries increase
significantly on large systems.  So, walk_system_ram_range() and fixed
region_is_ram() should still perform fine on large systems.

Thanks,
-Toshi


