Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40B55211EC673
 for <linux-nvdimm@lists.01.org>; Thu, 11 Apr 2019 07:56:47 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id s24so5452411otk.13
 for <linux-nvdimm@lists.01.org>; Thu, 11 Apr 2019 07:56:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190410040826.24371-1-pagupta@redhat.com>
 <20190410040826.24371-4-pagupta@redhat.com>
In-Reply-To: <20190410040826.24371-4-pagupta@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Apr 2019 07:56:36 -0700
Message-ID: <CAPcyv4gXwE2k3JU94GPav0xn2LEgR6-7ZEVYyTHFRjCfTYjerw@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] libnvdimm: add dax_dev sync flag
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
To: Pankaj Gupta <pagupta@redhat.com>
Cc: cohuck@redhat.com, Jan Kara <jack@suse.cz>, KVM list <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, david <david@fromorbit.com>, Qemu Developers <qemu-devel@nongnu.org>, virtualization@lists.linux-foundation.org, Andreas Dilger <adilger.kernel@dilger.ca>, Ross Zwisler <zwisler@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Len Brown <lenb@kernel.org>, kilobyte@angband.pl, Rik van Riel <riel@surriel.com>, yuval.shaia@oracle.com, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>, Nitesh Narayan Lal <nilal@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 9, 2019 at 9:10 PM Pankaj Gupta <pagupta@redhat.com> wrote:
>
> This patch adds 'DAXDEV_SYNC' flag which is set
> for nd_region doing synchronous flush. This later
> is used to disable MAP_SYNC functionality for
> ext4 & xfs filesystem for devices don't support
> synchronous flush.
>
> Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> ---
>  drivers/dax/bus.c            |  2 +-
>  drivers/dax/super.c          | 13 ++++++++++++-
>  drivers/md/dm.c              |  2 +-
>  drivers/nvdimm/pmem.c        |  3 ++-
>  drivers/nvdimm/region_devs.c |  7 +++++++
>  include/linux/dax.h          |  9 +++++++--
>  include/linux/libnvdimm.h    |  1 +
>  7 files changed, 31 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 2109cfe80219..431bf7d2a7f9 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -388,7 +388,7 @@ struct dev_dax *__devm_create_dev_dax(struct dax_region *dax_region, int id,
>          * No 'host' or dax_operations since there is no access to this
>          * device outside of mmap of the resulting character device.
>          */
> -       dax_dev = alloc_dax(dev_dax, NULL, NULL);
> +       dax_dev = alloc_dax(dev_dax, NULL, NULL, true);

I find apis that take a boolean as unreadable. What does 'true' mean?
It wastes time to go look at the function definition vs something
like:

    alloc_dax(dev_dax, NULL, NULL, DAXDEV_F_SYNC);
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
