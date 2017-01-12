Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 12 Jan 2017 18:14:31 -0500
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [LSF/MM TOPIC] Memory hotplug, ZONE_DEVICE, and the future of
 struct page
Message-ID: <20170112231430.GA10096@redhat.com>
References: <CAPcyv4hWNL7=MmnUj65A+gz=eHAnUrVzqV+24QiNQDW--ag8WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hWNL7=MmnUj65A+gz=eHAnUrVzqV+24QiNQDW--ag8WQ@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, linux-block@vger.kernel.org, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 12, 2017 at 02:43:03PM -0800, Dan Williams wrote:
> Back when we were first attempting to support DMA for DAX mappings of
> persistent memory the plan was to forgo 'struct page' completely and
> develop a pfn-to-scatterlist capability for the dma-mapping-api. That
> effort died in this thread:
> =

>     https://lkml.org/lkml/2015/8/14/3
> =

> ...where we learned that the dependencies on struct page for dma
> mapping are deeper than a PFN_PHYS() conversion for some
> architectures. That was the moment we pivoted to ZONE_DEVICE and
> arranged for a 'struct page' to be available for any persistent memory
> range that needs to be the target of DMA. ZONE_DEVICE enables any
> device-driver that can target "System RAM" to also be able to target
> persistent memory through a DAX mapping.
> =

> Since that time the "page-less" DAX path has continued to mature [1]
> without growing new dependencies on struct page, but at the same time
> continuing to rely on ZONE_DEVICE to satisfy get_user_pages().
> =

> Peer-to-peer DMA appears to be evolving from a niche embedded use case
> to something general purpose platforms will need to comprehend. The
> "map_peer_resource" [2] approach looks to be headed to the same
> destination as the pfn-to-scatterlist effort. It's difficult to avoid
> 'struct page' for describing DMA operations without custom driver
> code.
> =

> With that background, a statement and a question to discuss at LSF/MM:
> =

> General purpose DMA, i.e. any DMA setup through the dma-mapping-api,
> requires pfn_to_page() support across the entire physical address
> range mapped.

Note that in my case it is even worse. The pfn of the page does not
correspond to anything so it need to go through a special function
to find if a page can be mapped for another device and to provide a
valid pfn at which the page can be access by other device.

Basicly the PCIE bar is like a window into the device memory that is
dynamicly remap to specific page of the device memory. Not all device
memory can be expose through PCIE bar because of PCIE issues.

> =

> Is ZONE_DEVICE the proper vehicle for this? We've already seen that it
> collides with platform alignment assumptions [3], and if there's a
> wider effort to rework memory hotplug [4] it seems DMA support should
> be part of the discussion.

Obvioulsy i would like to join this discussion :)

Cheers,
J=E9r=F4me
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
