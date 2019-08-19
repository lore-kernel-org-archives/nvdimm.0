Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B90F202110B0
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 13:35:02 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id e12so2923481otp.10
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 13:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190809074520.27115-1-aneesh.kumar@linux.ibm.com>
 <20190809074520.27115-4-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hc_-oGMp6jGVknnYs+rmj4W1A_gFCbmAX2LFw0hsfL5g@mail.gmail.com>
 <87v9ut1vev.fsf@linux.ibm.com> <87mug5biyg.fsf@linux.ibm.com>
In-Reply-To: <87mug5biyg.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Aug 2019 13:33:26 -0700
Message-ID: <CAPcyv4hTQ8iVPbOmQNHEeT9-Z6-52k4dxexq5mTr-A4cru0OkQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] mm/nvdimm: Use correct #defines instead of open
 coding
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 19, 2019 at 2:32 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com> writes:
>
> > Dan Williams <dan.j.williams@intel.com> writes:
> >
> >> On Fri, Aug 9, 2019 at 12:45 AM Aneesh Kumar K.V
> >> <aneesh.kumar@linux.ibm.com> wrote:
> >>>
> >>
>
> ...
>
> >>> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> >>> index 37e96811c2fc..c1d9be609322 100644
> >>> --- a/drivers/nvdimm/pfn_devs.c
> >>> +++ b/drivers/nvdimm/pfn_devs.c
> >>> @@ -725,7 +725,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
> >>>                  * when populating the vmemmap. This *should* be equal to
> >>>                  * PMD_SIZE for most architectures.
> >>>                  */
> >>> -               offset = ALIGN(start + SZ_8K + 64 * npfns, align) - start;
> >>> +               offset = ALIGN(start + SZ_8K + sizeof(struct page) * npfns,
> >>
> >> I'd prefer if this was not dynamic and was instead set to the maximum
> >> size of 'struct page' across all archs just to enhance cross-arch
> >> compatibility. I think that answer is '64'.
> >
> >
> > That still doesn't take care of the case where we add new elements to
> > struct page later. If we have struct page size changing across
> > architectures, we should still be ok as long as new size is less than what is
> > stored in pfn superblock? I understand the desire to keep it
> > non-dynamic. But we also need to make sure we don't reserve less space
> > when creating a new namespace on a config that got struct page size >
> > 64?
>
>
> How about
>
> libnvdimm/pfn_dev: Add a build check to make sure we notice when struct page size change
>
> When namespace is created with map device as pmem device, struct page is stored in the
> reserve block area. We need to make sure we account for the right struct page
> size while doing this. Instead of directly depending on sizeof(struct page)
> which can change based on different kernel config option, use the max struct
> page size (64) while calculating the reserve block area. This makes sure pmem
> device can be used across kernels built with different configs.
>
> If the above assumption of max struct page size change, we need to update the
> reserve block allocation space for new namespaces created.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
>
> 1 file changed, 7 insertions(+)
> drivers/nvdimm/pfn_devs.c | 7 +++++++
>
> modified   drivers/nvdimm/pfn_devs.c
> @@ -722,7 +722,14 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>                  * The altmap should be padded out to the block size used
>                  * when populating the vmemmap. This *should* be equal to
>                  * PMD_SIZE for most architectures.
> +                *
> +                * Also make sure size of struct page is less than 64. We
> +                * want to make sure we use large enough size here so that
> +                * we don't have a dynamic reserve space depending on
> +                * struct page size. But we also want to make sure we notice
> +                * if we end up adding new elements to struct page.
>                  */
> +               BUILD_BUG_ON(64 < sizeof(struct page));

Looks ok to me. There are ongoing heroic efforts to make sure 'struct
page' does not grown beyond the size of cacheline. The fact that
'struct page_ext' is allocated out of line makes it safe to assume
that 'struct page' will not be growing larger in the foreseeable
future.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
