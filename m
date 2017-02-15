Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 15 Feb 2017 09:24:47 +0900
From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Subject: Re: [PATCH 0/2] fix devm_memremap_pages() mem hotplug locking
In-Reply-To: <CAPcyv4j0eC3=CPkP6NOMkTpcuik3Ln-D4cj6Nhz50H-srjkbAQ@mail.gmail.com>
References: <58A10B25.6030508@jp.fujitsu.com> <CAPcyv4j0eC3=CPkP6NOMkTpcuik3Ln-D4cj6Nhz50H-srjkbAQ@mail.gmail.com>
Message-Id: <20170215092435.7EC0.61FB500B@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>


On Sun, 12 Feb 2017 17:35:00 -0800 Dan Williams wrote:

> On Sun, Feb 12, 2017 at 5:25 PM, Masayoshi Mizuma
> <m.mizuma@jp.fujitsu.com> wrote:
> > Hi Dan,
> >
> > On Sun, 12 Feb 2017 14:34:11 -0800 Dan Williams wrote:
> >>
> >> Ben notes that commit f931ab479dd2 "mm: fix devm_memremap_pages crash,
> >> use mem_hotplug_{begin, done}" is incomplete and broken. Writes to
> >> mem_hotplug.active_writer need to be coordinated under the device
> >> hotplug lock. Otherwise, we can potentially corrupt mem_hotplug.refcount
> >> leading to soft lockups.
> >
> >
> > I think mem_hotplug_{begin,done} is not suitable to exclude
> > devm_memremap_pages()
> > because it seems that memory hotplug is not related to this context.
> > How about using pgmap_lock instead?
> 
> The problem with that switch is the race in
> kernel_physical_mapping_init(), see commit f931ab479dd2. As far as I
> can see we need all paths that call kernel_physical_mapping_init() to
> agree on the same lock, and can't use a private lock in
> devm_memremap_pages().

I understand. Thanks.

---
Masayoshi Mizuma
