From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Tue, 6 Dec 2016 14:47:04 -0700
Message-ID: <bedaa7a2-e42d-da83-5c2b-9d639b0397c5@deltatee.com>
References: <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com>
 <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
 <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
 <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
 <ac07a73f2601f6ca35cecc83c553feb0.squirrel@webmail.raithlin.com>
 <20161206163850.GC28066@obsidianresearch.com>
 <ec136c34-417d-8a55-c176-2c1d759a5fb8@deltatee.com>
 <20161206172838.GB19318@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161206172838.GB19318-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "christian.koenig-5C7GfCeVMHo@public.gmane.org" <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org" <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "John.Bridgman-5C7GfCeVMHo@public.gmane.org" <john.bridgman-5C7GfCeVMHo@public.gmane.org>, "Alexander.Deucher-5C7GfCeVMHo@public.gmane.org" <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org" <serguei.sagalov>
List-Id: linux-nvdimm@lists.01.org

Hey,

> Okay, so clearly this needs a kernel side NVMe specific allocator
> and locking so users don't step on each other..

Yup, ideally. That's why device dax isn't ideal for this application: it
doesn't provide any way to prevent users from stepping on each other.

> Or as Christoph says some kind of general mechanism to get these
> bounce buffers..

Yeah, I imagine a general allocate from BAR/region system would be very
useful.

> Ah, I see.
> 
> As a first draft I'd stick with some kind of API built into the
> /dev/nvmeX that backs the filesystem. The user app would fstat the
> target file, open /dev/block/MAJOR(st_dev):MINOR(st_dev), do some
> ioctl to get a CMB mmap, and then proceed from there..
> 
> When that is all working kernel-side, it would make sense to look at a
> more general mechanism that could be used unprivileged??

That makes a lot of sense to me. I suggested mmapping the char device
because it's really easy, but I can see that an ioctl on the block
device does seem more general and device agnostic.

> This is similar to the GPU issues too.. On NVMe you don't need to pin
> the pages, you just need to lock that VMA so it doesn't get freed from
> the NVMe CMB allocator while the IO is running...
> Probably in the long run the get_user_pages is going to have to be
> pushed down into drivers.. Future MMU coherent IO hardware also does
> not need the pinning or other overheads.

Yup. Yup.

Logan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
