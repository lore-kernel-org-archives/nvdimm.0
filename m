Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BFC8D226C7C3A
 for <linux-nvdimm@lists.01.org>; Tue,  3 Apr 2018 14:13:22 -0700 (PDT)
Date: Tue, 3 Apr 2018 17:13:20 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v9] dax, dm: introduce ->fs_{claim, release}() dax_device
 infrastructure
Message-ID: <20180403211320.GA7835@redhat.com>
References: <CAPcyv4gSh29g7ZSuWnZVTdgXXS_027qvQNLgAUA+JrFwefXW+w@mail.gmail.com>
 <152278769715.7139.9560094354006725491.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152278769715.7139.9560094354006725491.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, dm-devel@redhat.com, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 03 2018 at  4:36pm -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for allowing filesystems to augment the dev_pagemap
> associated with a dax_device, add an ->fs_claim() callback. The
> ->fs_claim() callback is leveraged by the device-mapper dax
> implementation to iterate all member devices in the map and repeat the
> claim operation across the array.
> =

> In order to resolve collisions between filesystem operations and DMA to
> DAX mapped pages we need a callback when DMA completes. With a callback
> we can hold off filesystem operations while DMA is in-flight and then
> resume those operations when the last put_page() occurs on a DMA page.
> The ->fs_claim() operation arranges for this callback to be registered,
> although that implementation is saved for a later patch.
> =

> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: "J=E9r=F4me Glisse" <jglisse@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Changes since v8:
> * make __fs_dax_claim and __fs_dax_release private to
>   drivers/dax/super.c
> =

> * rename dm_dax_iterate to dm_dax_interate_devices (Mike)
> =

> * drop the return value from dm_dax_interate_devices since nothing uses
>   it (Mike)

Acked-by: Mike Snitzer <snitzer@redhat.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
