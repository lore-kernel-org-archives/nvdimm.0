Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 264A7208F79CB
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 09:11:16 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id c18so19805048otl.13
 for <linux-nvdimm@lists.01.org>; Wed, 20 Feb 2019 09:11:16 -0800 (PST)
MIME-Version: 1.0
References: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155000668075.348031.9371497273408112600.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 20 Feb 2019 09:11:04 -0800
Message-ID: <CAPcyv4j9uEn9j=Y0Vo3oQJaXo-d-Xf=2-=0ucufhcXWeYOb0Yg@mail.gmail.com>
Subject: Re: [PATCH 0/7] libnvdimm/pfn: Fix section-alignment padding
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm <linux-nvdimm@lists.01.org>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 12, 2019 at 1:37 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Lately Linux has encountered platforms that collide Persistent Memory
> regions between each other, specifically cases where ->start_pad needed
> to be non-zero. This lead to commit ae86cbfef381 "libnvdimm, pfn: Pad
> pfn namespaces relative to other regions". That commit allowed
> namespaces to be mapped with devm_memremap_pages(). However dax
> operations on those configurations currently fail if attempted within the
> ->start_pad range because pmem_device->data_offset was still relative to
> raw resource base not relative to the section aligned resource range
> mapped by devm_memremap_pages().
>
> Luckily __bdev_dax_supported() caught these failures and simply disabled
> dax. However, to fix this situation a non-backwards compatible change
> needs to be made to the interpretation of the nd_pfn info-block.
> ->start_pad needs to be accounted in ->map.map_offset (formerly
> ->data_offset), and ->map.map_base (formerly ->phys_addr) needs to be
> adjusted to the section aligned resource base used to establish
> ->map.map formerly (formerly ->virt_addr).
>
> See patch 7 "libnvdimm/pfn: Fix 'start_pad' implementation" for more
> details, and the ndctl patch series "Improve support + testing for
> labels + info-blocks" for the corresponding regression test.

Hello valued reviewers, can I plead for a sanity check of at least
"libnvdimm/pfn: Introduce super-block minimum version requirements"
and "libnvdimm/pfn: Fix 'start_pad' implementation"? In particular
Jeff / Johannes this has end user / distro impact in that users may
lose access to namespaces that are upgraded to v1.3 info-blocks and
then boot an old kernel. I did not see a way around that sharp edge.

> ---
>
> Dan Williams (7):
>       libnvdimm/pfn: Account for PAGE_SIZE > info-block-size in nd_pfn_init()
>       libnvdimm/pmem: Honor force_raw for legacy pmem regions
>       dax: Check the end of the block-device capacity with dax_direct_access()
>       libnvdimm/pfn: Introduce super-block minimum version requirements
>       libnvdimm/pfn: Remove dax_label_reserve
>       libnvdimm/pfn: Introduce 'struct pfn_map_info'
>       libnvdimm/pfn: Fix 'start_pad' implementation
>
>
>  drivers/dax/pmem.c              |    9 +-
>  drivers/dax/super.c             |   39 ++++++--
>  drivers/nvdimm/namespace_devs.c |    4 +
>  drivers/nvdimm/nd.h             |   15 +++
>  drivers/nvdimm/pfn.h            |    4 +
>  drivers/nvdimm/pfn_devs.c       |  181 ++++++++++++++++++++++++++++-----------
>  drivers/nvdimm/pmem.c           |  111 +++++++++++-------------
>  drivers/nvdimm/pmem.h           |   12 ---
>  tools/testing/nvdimm/pmem-dax.c |   15 ++-
>  9 files changed, 244 insertions(+), 146 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
