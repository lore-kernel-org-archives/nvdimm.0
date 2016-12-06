From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Tue, 6 Dec 2016 10:28:38 -0700
Message-ID: <20161206172838.GB19318@obsidianresearch.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ec136c34-417d-8a55-c176-2c1d759a5fb8-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "John.Bridgman-5C7GfCeVMHo@public.gmane.org" <john.bridgman-5C7GfCeVMHo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Felix.Kuehling-5C7GfCeVMHo@public.gmane.org" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org" <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>, "Paul.Blinzer-5C7GfCeVMHo@public.gmane.org" <paul.blinzer-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, "ben.sander-5C7GfCeVMHo@public.gmane.org" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org" <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Alexander.Deucher-5C7GfCeVMHo@public.gmane.org" <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "christian.koenig-5C7GfCeVMHo@public.gmane.org" <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-media@>
List-Id: linux-nvdimm@lists.01.org

On Tue, Dec 06, 2016 at 09:51:15AM -0700, Logan Gunthorpe wrote:
> Hey,
> 
> On 06/12/16 09:38 AM, Jason Gunthorpe wrote:
> >>> I'm not opposed to mapping /dev/nvmeX.  However, the lookup is trivial
> >>> to accomplish in sysfs through /sys/dev/char to find the sysfs path of the
> >>> device-dax instance under the nvme device, or if you already have the nvme
> >>> sysfs path the dax instance(s) will appear under the "dax" sub-directory.
> >>
> >> Personally I think mapping the dax resource in the sysfs tree is a nice
> >> way to do this and a bit more intuitive than mapping a /dev/nvmeX.
> > 
> > It is still not at all clear to me what userpsace is supposed to do
> > with this on nvme.. How is the CMB usable from userspace?
> 
> The flow is pretty simple. For example to write to NVMe from an RDMA device:
> 
> 1) Obtain a chunk of the CMB to use as a buffer(either by mmaping
> /dev/nvmx, the device dax char device or through a block layer interface
> (which sounds like a good suggestion from Christoph, but I'm not really
> sure how it would look).

Okay, so clearly this needs a kernel side NVMe specific allocator
and locking so users don't step on each other..

Or as Christoph says some kind of general mechanism to get these
bounce buffers..

> 2) Create an MR with the buffer and use an RDMA function to fill it with
> data from a remote host. This will cause the RDMA hardware to write
> directly to the memory in the NVMe card.
> 
> 3) Using O_DIRECT, write the buffer to a file on the NVMe filesystem.
> When the address reaches hardware the NVMe will recognize it as local
> memory and copy it directly there.

Ah, I see.

As a first draft I'd stick with some kind of API built into the
/dev/nvmeX that backs the filesystem. The user app would fstat the
target file, open /dev/block/MAJOR(st_dev):MINOR(st_dev), do some
ioctl to get a CMB mmap, and then proceed from there..

When that is all working kernel-side, it would make sense to look at a
more general mechanism that could be used unprivileged??

> Thus we are able to transfer data to any file on an NVMe device without
> going through system memory. This has benefits on systems with lots of
> activity in system memory but step 3 is likely to be slowish due to the
> need to pin/unpin the memory for every transaction.

This is similar to the GPU issues too.. On NVMe you don't need to pin
the pages, you just need to lock that VMA so it doesn't get freed from
the NVMe CMB allocator while the IO is running...

Probably in the long run the get_user_pages is going to have to be
pushed down into drivers.. Future MMU coherent IO hardware also does
not need the pinning or other overheads.

Jason
