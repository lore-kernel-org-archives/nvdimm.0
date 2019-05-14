Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D87C12121797E
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 12:04:51 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id r136so12973931oie.7
 for <linux-nvdimm@lists.01.org>; Tue, 14 May 2019 12:04:51 -0700 (PDT)
MIME-Version: 1.0
References: <155727335978.292046.12068191395005445711.stgit@dwillia2-desk3.amr.corp.intel.com>
 <059859ca-3cc8-e3ff-f797-1b386931c41e@deltatee.com>
 <17ada515-f488-d153-90ef-7a5cc5fefb0f@deltatee.com>
 <8a7cfa6b-6312-e8e5-9314-954496d2f6ce@oracle.com>
In-Reply-To: <8a7cfa6b-6312-e8e5-9314-954496d2f6ce@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 14 May 2019 12:04:38 -0700
Message-ID: <CAPcyv4i28tQMVrscQo31cfu1ZcMAb74iMkKYhu9iO_BjJvp+9A@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] mm/devm_memremap_pages: Fix page release race
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
To: Jane Chu <jane.chu@oracle.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 14, 2019 at 11:53 AM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 5/13/2019 12:22 PM, Logan Gunthorpe wrote:
>
> On 2019-05-08 11:05 a.m., Logan Gunthorpe wrote:
>
> On 2019-05-07 5:55 p.m., Dan Williams wrote:
>
> Changes since v1 [1]:
> - Fix a NULL-pointer deref crash in pci_p2pdma_release() (Logan)
>
> - Refresh the p2pdma patch headers to match the format of other p2pdma
>    patches (Bjorn)
>
> - Collect Ira's reviewed-by
>
> [1]: https://lore.kernel.org/lkml/155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com/
>
> This series looks good to me:
>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
>
> However, I haven't tested it yet but I intend to later this week.
>
> I've tested libnvdimm-pending which includes this series on my setup and
> everything works great.
>
> Just wondering in a difference scenario where pmem pages are exported to
> a KVM guest, and then by mistake the user issues "ndctl destroy-namespace -f",
> will the kernel wait indefinitely until the user figures out to kill the guest
> and release the pmem pages?

It depends on whether the pages are pinned. Typically DAX memory
mappings assigned to a guest are not pinned in the host and can be
invalidated at any time. The pinning only occurs with VFIO and
device-assignment which isn't the common case, especially since that
configuration is blocked by fsdax. However, with devdax, yes you can
arrange for the system to go into an indefinite wait.

This somewhat ties back to the get_user_pages() vs DAX debate. The
indefinite stall issue with device-assignment could be addressed with
a requirement to hold a lease and expect that a lease revocation event
may escalate to SIGKILL in response to 'ndctl destroy-namespace'. The
expectation with device-dax is that it is already a raw interface with
pointy edges and caveats, but I would not be opposed to introducing a
lease semantic.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
