Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <541050E5.60502@gmail.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
	<1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
	<540F2977.7010006@plexistor.com>
	<CAPcyv4gZBdtup+DuaYL2zOhP9KcRzDAq6vLih0tbpL+abGQv-g@mail.gmail.com>
	<541050E5.60502@gmail.com>
Date: Wed, 10 Sep 2014 10:03:19 -0700
Message-ID: <CAPcyv4hfNX4Q75AERfF4g5MVvG82j3tXWcunWiGpBgDS2+7_1Q@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2] pmem: Initial version of persistent
 memory driver
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <openosd@gmail.com>
Cc: Boaz Harrosh <boaz@plexistor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Nick Piggin <npiggin@kernel.dk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Boaz,

On Wed, Sep 10, 2014 at 6:23 AM, Boaz Harrosh <openosd@gmail.com> wrote:
> On 09/09/2014 07:53 PM, Dan Williams wrote:
>> On Tue, Sep 9, 2014 at 9:23 AM, Boaz Harrosh <boaz@plexistor.com> wrote:
> <>
>>
>> Hmm this looks like a "ACPI/DeviceTree-over-kernel-command-line"
>> description language.  I understand that this is borrowed from the
>> memmap= precedent, but, if I'm not mistaken, that's really more for
>> debug rather than a permanent platform-device descriptor.
>
> So what is bad about that ?
>
>> <strawman>
>> Since this looks like firmware why not go ahead and use
>> request_firmware() to request a pmem range descriptor blob
> </strawman>?
>
> What? God no! How is this a firmware at all. No this is all BUS info, it is
>  "where on the bus this device's resource was allocated"
>
> Firmware is static compile time thing common to all of my devices
> but this here is where in the bus this was stuck in. What is your
> suggestion that I compile a kernel and "make install" it (initrd)
> for every DIMM I insert ? since when? and what tool will tell me
> what to put there?
>
>>  Given you can compile such a blob into a kernel image  or provide it
>> in an initrd I think it makes deployment more straightforward, also
>> the descriptor format can be extended going forward
>
> What ? really Dan I think you got confused. The nn@ss thing is just:
>    "what connector I stuck my DIMM disk in (and what other empty slots I have)"
>
> Would you have me compile and install my kernel every time my sdX
> number change, or my sata channel moved. I do not think so.
>
>> whereas the
>> command line approach mandates ever increasingly complicated strings.
>
> This is the first API, I intend, there is even a TODO in the patchset, to
> also have a dynamic sysfs add/remove/grow API for on the fly changes.
> All these can be easily driven by a simple udev rule to plug and play them.
>
> Usually in the Kernel, buses do not directly load devices drivers. The
> bus driver sends an "event" with a new discovered resource, then user-mode
> udev rule will load an associated driver, which will scan for its device or
> receive its identification somewhere, that can be the sysfs interface above,
> or even commandline.
>
> Farther down the road we might want a Kernel API, through to the DIMM-manager
> when each device's ID is Identified to managed volumes of DIMMs. (And what
> happens to them if they move in physical addressing), but even with DIMM-manager
> I would have gone through a udev-event and pmem-probe because, this way user
> mode can add a chain of commands associated with new insertions. So since we
> have a DIMM-manager event going on why not have the udev rule load pmem as well
> and not have any API. But All this is way down the line.
>
> Regardless of which, commandline API of pmem will always stay as this is for
> the pmem emulation as we use it now, in accord with memmap=.
> (And it works very nice in our lab with DDR3 NvDIMMs that need an memmap= as well)
>
> We please need to start somewhere, no?

Sure, but you used the operative term "start", as in you already
expect to enhance this capability down the road, right?

It's fine to dismiss this request_firmware() based approach, but don't
mis-characterize it in the process.  With regards to describing device
boundaries, a bus-descriptor-blob handed to the kernel is a superset
of the capability provided by the kernel command line.  It can be
injected statically at compile time, or dynamically loaded from the
initrd or the rootfs.  It has the added benefit of being flexible to
change whereas the kernel command line is a more permanent contract
that we will need to maintain compatibility with in perpetuity.

If you already see this bus description as a "starting" point, then I
think we need an interface that is more amenable to ongoing change,
that's not the kernel-command-line.
