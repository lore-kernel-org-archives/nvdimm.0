Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22c.google.com (mail-ot0-x22c.google.com
 [IPv6:2607:f8b0:4003:c0f::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A2FA121967BE8
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 16:20:06 -0700 (PDT)
Received: by mail-ot0-x22c.google.com with SMTP id a2so45761454oth.2
 for <linux-nvdimm@lists.01.org>; Fri, 09 Jun 2017 16:21:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149703990158.20620.16257541455791191783.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149703982465.20620.14881139332926778446.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149703990158.20620.16257541455791191783.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Jun 2017 16:21:16 -0700
Message-ID: <CAPcyv4jyM5HqNw0efE+03ZzSN-4YnqSQ9z2jkx7nDBgqwSsg3w@mail.gmail.com>
Subject: Re: [PATCH v3 14/14] libnvdimm, pmem: disable dax flushing when pmem
 is fronting a volatile region
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, X86 ML <x86@kernel.org>, dm-devel@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 9, 2017 at 1:25 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> The pmem driver attaches to both persistent and volatile memory ranges
> advertised by the ACPI NFIT. When the region is volatile it is redundant
> to spend cycles flushing caches at fsync(). Check if the hosting region
> is volatile and do not set QUEUE_FLAG_WC if it is.
>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/pmem.c        |   13 ++++++++-----
>  drivers/nvdimm/region_devs.c |    6 ++++++
>  include/linux/libnvdimm.h    |    1 +
>  3 files changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 06f6c27ec1e9..5cac9fb39db8 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -279,10 +279,10 @@ static int pmem_attach_disk(struct device *dev,
>         struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
>         struct nd_region *nd_region = to_nd_region(dev->parent);
>         struct vmem_altmap __altmap, *altmap = NULL;
> +       int nid = dev_to_node(dev), fua, wbc;
>         struct resource *res = &nsio->res;
>         struct nd_pfn *nd_pfn = NULL;
>         struct dax_device *dax_dev;
> -       int nid = dev_to_node(dev);
>         struct nd_pfn_sb *pfn_sb;
>         struct pmem_device *pmem;
>         struct resource pfn_res;
> @@ -308,9 +308,12 @@ static int pmem_attach_disk(struct device *dev,
>         dev_set_drvdata(dev, pmem);
>         pmem->phys_addr = res->start;
>         pmem->size = resource_size(res);
> -       if (!IS_ENABLED(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE)
> -                       || nvdimm_has_flush(nd_region) < 0)
> -               dev_warn(dev, "unable to guarantee persistence of writes\n");
> +       fua = nvdimm_has_flush(nd_region);
> +       if (!IS_ENABLED(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) || fua < 0)
> +               dev_warn(dev, "unable to guarantee persistence of writes\n"); {

I sent this patch with local uncommitted changes. Will send a v2
shortly, and also update stg mail to abort if the tree is dirty.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
