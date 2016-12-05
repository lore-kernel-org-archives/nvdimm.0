From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Enabling peer to peer device transactions for PCIe devices
Date: Mon, 5 Dec 2016 12:06:32 -0800
Message-ID: <20161205200632.GA24497@infradead.org>
References: <61a2fb07344aacd81111449d222de66e.squirrel@webmail.raithlin.com>
 <20161205171830.GB27784@obsidianresearch.com>
 <CAPcyv4hdMkXOxj9hUDpnftA7UTGDa498eBugdePp8EWr6S80gA@mail.gmail.com>
 <20161205180231.GA28133@obsidianresearch.com>
 <CAPcyv4iEXwvtDbZgnWzdKU6uN_sOGmXH1KtW_Nws6kUftJUigQ@mail.gmail.com>
 <a3a1c239-297d-c091-7758-54acdf00f74e@deltatee.com>
 <CAPcyv4iVHhOSxPrLMZ53Xw3CK+9cOWn9zEG8smMtqF_LAcKKpg@mail.gmail.com>
 <20161205191438.GA20464@obsidianresearch.com>
 <10356964-c454-47fb-7fb3-8bf2a418b11b@deltatee.com>
 <20161205194614.GA21132@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161205194614.GA21132-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "John.Bridgman-5C7GfCeVMHo@public.gmane.org" <john.bridgman-5C7GfCeVMHo@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "Felix.Kuehling-5C7GfCeVMHo@public.gmane.org" <felix.kuehling-5C7GfCeVMHo@public.gmane.org>, "serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org" <serguei.sagalovitch-5C7GfCeVMHo@public.gmane.org>, "Paul.Blinzer-5C7GfCeVMHo@public.gmane.org" <paul.blinzer-5C7GfCeVMHo@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, "ben.sander-5C7GfCeVMHo@public.gmane.org" <ben.sander-5C7GfCeVMHo@public.gmane.org>, "Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org" <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Alexander.Deucher-5C7GfCeVMHo@public.gmane.org" <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "christian.koenig-5C7GfCeVMHo@public.gmane.org" <christian.koenig-5C7GfCeVMHo@public.gmane.org>, "Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-media@>
List-Id: linux-nvdimm@lists.01.org

On Mon, Dec 05, 2016 at 12:46:14PM -0700, Jason Gunthorpe wrote:
> In any event the allocator still needs to track which regions are in
> use and be able to hook 'free' from userspace. That does suggest it
> should be integrated into the nvme driver and not a bolt on driver..

Two totally different use cases:

 - a card that exposes directly byte addressable storage as a PCI-e
   bar.  Thin of it as a nvdimm on a PCI-e card.  That's the iopmem
   case.
 - the NVMe CMB which exposes a byte addressable indirection buffer for
   I/O, but does not actually provide byte addressable persistent
   storage.  This is something that needs to be added to the NVMe driver
   (and the block layer for the abstraction probably).
