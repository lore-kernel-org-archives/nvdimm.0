Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A71BC2128D885
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jun 2019 10:06:55 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id a127so10465405oii.2
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jun 2019 10:06:55 -0700 (PDT)
MIME-Version: 1.0
References: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156092356065.979959.6681003754765958296.stgit@dwillia2-desk3.amr.corp.intel.com>
 <877e9hk06d.fsf@linux.ibm.com>
In-Reply-To: <877e9hk06d.fsf@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jun 2019 10:06:43 -0700
Message-ID: <CAPcyv4gZfLoG2tOGFWK56rr1vadF71+ny951brtunbPUNW-W1w@mail.gmail.com>
Subject: Re: [PATCH v10 12/13] libnvdimm/pfn: Fix fsdax-mode namespace
 info-block zero-fields
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
Cc: Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 19, 2019 at 9:30 AM Aneesh Kumar K.V
<aneesh.kumar@linux.ibm.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > At namespace creation time there is the potential for the "expected to
> > be zero" fields of a 'pfn' info-block to be filled with indeterminate
> > data. While the kernel buffer is zeroed on allocation it is immediately
> > overwritten by nd_pfn_validate() filling it with the current contents of
> > the on-media info-block location. For fields like, 'flags' and the
> > 'padding' it potentially means that future implementations can not rely
> > on those fields being zero.
> >
> > In preparation to stop using the 'start_pad' and 'end_trunc' fields for
> > section alignment, arrange for fields that are not explicitly
> > initialized to be guaranteed zero. Bump the minor version to indicate it
> > is safe to assume the 'padding' and 'flags' are zero. Otherwise, this
> > corruption is expected to benign since all other critical fields are
> > explicitly initialized.
> >
> > Note The cc: stable is about spreading this new policy to as many
> > kernels as possible not fixing an issue in those kernels. It is not
> > until the change titled "libnvdimm/pfn: Stop padding pmem namespaces to
> > section alignment" where this improper initialization becomes a problem.
> > So if someone decides to backport "libnvdimm/pfn: Stop padding pmem
> > namespaces to section alignment" (which is not tagged for stable), make
> > sure this pre-requisite is flagged.
>
> Don't we need a change like below in this patch?
>
> modified   drivers/nvdimm/pfn_devs.c
> @@ -452,10 +452,11 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>         if (memcmp(pfn_sb->parent_uuid, parent_uuid, 16) != 0)
>                 return -ENODEV;
>
> -       if (__le16_to_cpu(pfn_sb->version_minor) < 1) {
> -               pfn_sb->start_pad = 0;
> -               pfn_sb->end_trunc = 0;
> -       }
> +       if ((__le16_to_cpu(pfn_sb->version_minor) < 1) ||
> +           (__le16_to_cpu(pfn_sb->version_minor) >= 3)) {
> +                       pfn_sb->start_pad = 0;
> +                       pfn_sb->end_trunc = 0;
> +               }

No, this kills off start_pad and end_trunc permanently.

> IIUC we want to force the start_pad and end_truc to zero if the pfn_sb
> minor version number >= 3. So once we have this patch backported and
> older kernel finds a pfn_sb with minor version 3, it will ignore the
> start_pad read from the nvdimm and overwrite that with zero here.
> This patch doesn't enforce that right? After the next patch we can have
> values other than 0 in pfn_sb->start_pad?

The reason for the version bump is for the kernel to safely assume
that uninitialized fields default to zero, but it's otherwise a nop
when the implementation is explicitly initializing every field by
default.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
