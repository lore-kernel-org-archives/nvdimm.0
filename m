From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Mon, 5 Dec 2016 11:39:13 -0700
Message-ID: <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
References: <20161128165751.GB28381@obsidianresearch.com>
 <1480357179.19407.13.camel@mellanox.com>
 <20161128190244.GA21975@obsidianresearch.com>
 <c0ddccf3-52ce-d883-a57a-70d8a1febf85@mellanox.com>
 <20161130162353.GA24639@obsidianresearch.com>
 <5f5b7989-84f5-737e-47c8-831f752d6280@deltatee.com>
 <c1ead8a0-6850-fc84-2793-b986f5c1f726@mellanox.com>
 <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com>
 <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "John.Bridgman-5C7GfCeVMHo@public.gmane.org" <john.bridgman-5C7GfCeVMHo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Felix.Kuehling-5C7GfCeVMHo@public.gmane.org" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org" <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>, "Paul.Blinzer-5C7GfCeVMHo@public.gmane.org" <paul.blinzer-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, "ben.sander-5C7GfCeVMHo@public.gmane.org" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org" <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Alexander.Deucher-5C7GfCeVMHo@public.gmane.org" <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "christian.koenig-5C7GfCeVMHo@public.gmane.org" <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-media@>
List-Id: linux-nvdimm@lists.01.org

On 05/12/16 11:08 AM, Dan Williams wrote:
> I've already recommended that iopmem not be a block device and instead
> be a device-dax instance. I also don't think it should claim the PCI
> ID, rather the driver that wants to map one of its bars this way can
> register the memory region with the device-dax core.
>
> I'm not sure there are enough device drivers that want to do this to
> have it be a generic /sys/.../resource_dmableX capability. It still
> seems to be an exotic one-off type of configuration.

Yes, this is essentially my thinking. Except I think the userspace 
interface should really depend on the device itself. Device dax is a 
good  choice for many and I agree the block device approach wouldn't be 
ideal.

Specifically for NVME CMB: I think it would make a lot of sense to just 
hand out these mappings with an mmap call on /dev/nvmeX. I expect CMB 
buffers would be volatile and thus you wouldn't need to keep track of 
where in the BAR the region came from. Thus, the mmap call would just be 
an allocator from BAR memory. If device-dax were used, userspace would 
need to lookup which device-dax instance corresponds to which nvme drive.

Logan
