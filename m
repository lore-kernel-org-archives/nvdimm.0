Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <541050E5.60502@gmail.com>
Date: Wed, 10 Sep 2014 16:23:49 +0300
From: Boaz Harrosh <openosd@gmail.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [PATCH v2] pmem: Initial version of persistent
 memory driver
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>	<1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>	<540F2977.7010006@plexistor.com> <CAPcyv4gZBdtup+DuaYL2zOhP9KcRzDAq6vLih0tbpL+abGQv-g@mail.gmail.com>
In-Reply-To: <CAPcyv4gZBdtup+DuaYL2zOhP9KcRzDAq6vLih0tbpL+abGQv-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boaz@plexistor.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Nick Piggin <npiggin@kernel.dk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 09/09/2014 07:53 PM, Dan Williams wrote:
> On Tue, Sep 9, 2014 at 9:23 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
<>
> 
> Hmm this looks like a "ACPI/DeviceTree-over-kernel-command-line"
> description language.  I understand that this is borrowed from the
> memmap= precedent, but, if I'm not mistaken, that's really more for
> debug rather than a permanent platform-device descriptor.

So what is bad about that ?

> <strawman>
> Since this looks like firmware why not go ahead and use
> request_firmware() to request a pmem range descriptor blob
</strawman>?

What? God no! How is this a firmware at all. No this is all BUS info, it is
 "where on the bus this device's resource was allocated"

Firmware is static compile time thing common to all of my devices
but this here is where in the bus this was stuck in. What is your
suggestion that I compile a kernel and "make install" it (initrd)
for every DIMM I insert ? since when? and what tool will tell me
what to put there?

>  Given you can compile such a blob into a kernel image  or provide it
> in an initrd I think it makes deployment more straightforward, also
> the descriptor format can be extended going forward 

What ? really Dan I think you got confused. The nn@ss thing is just:
   "what connector I stuck my DIMM disk in (and what other empty slots I have)"

Would you have me compile and install my kernel every time my sdX
number change, or my sata channel moved. I do not think so.

> whereas the
> command line approach mandates ever increasingly complicated strings.

This is the first API, I intend, there is even a TODO in the patchset, to
also have a dynamic sysfs add/remove/grow API for on the fly changes.
All these can be easily driven by a simple udev rule to plug and play them.

Usually in the Kernel, buses do not directly load devices drivers. The
bus driver sends an "event" with a new discovered resource, then user-mode
udev rule will load an associated driver, which will scan for its device or
receive its identification somewhere, that can be the sysfs interface above,
or even commandline.

Farther down the road we might want a Kernel API, through to the DIMM-manager
when each device's ID is Identified to managed volumes of DIMMs. (And what
happens to them if they move in physical addressing), but even with DIMM-manager
I would have gone through a udev-event and pmem-probe because, this way user
mode can add a chain of commands associated with new insertions. So since we
have a DIMM-manager event going on why not have the udev rule load pmem as well
and not have any API. But All this is way down the line.

Regardless of which, commandline API of pmem will always stay as this is for
the pmem emulation as we use it now, in accord with memmap=.
(And it works very nice in our lab with DDR3 NvDIMMs that need an memmap= as well)

We please need to start somewhere, no?

Thanks
Boaz

