Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7A3D2212735A0
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 10:09:11 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id f4so10576794oib.4
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 10:09:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190516055422.16939-1-vaibhav@linux.ibm.com>
 <CAPcyv4j6Jhpqg9SqAAmz2A6PDry7UUtnniNVoc_qG=WXwuVOWA@mail.gmail.com>
 <87bm01mylr.fsf@vajain21.in.ibm.com>
In-Reply-To: <87bm01mylr.fsf@vajain21.in.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 May 2019 10:08:59 -0700
Message-ID: <CAPcyv4j-OQbN=rYY6MH3XFCF+dPpooCYekYF7PJL+N-tCJey3g@mail.gmail.com>
Subject: Re: [PATCH] dax: Fix last_page check in __bdev_dax_supported()
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
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Chandan Rajendra <chandan@linux.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 16, 2019 at 10:37 PM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > On Wed, May 15, 2019 at 10:55 PM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
> >>
> >> Presently __bdev_dax_supported() checks if first sector of last
> >> page ( last_page ) on the block device is aligned to page
> >> boundary. However the code to compute 'last_page' assumes that there
> >> are 8 sectors/page assuming a 4K page-size.
> >>
> >> This assumption breaks on architectures which use a different page
> >> size specifically PPC64 where page-size == 64K. Hence a warning is
> >> seen while trying to mount a xfs/ext4 file-system with dax enabled:
> >>
> >> $ sudo mount -o dax /dev/pmem0 /mnt/pmem
> >> XFS (pmem0): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> >> XFS (pmem0): DAX unsupported by block device. Turning off DAX.
> >>
> >> The patch fixes this issue by updating calculation of 'last_var' to
> >> take into account number-of-sectors/page instead of assuming it to be
> >> '8'.
> >
> > Yes, I noticed this too and fixed it up in a wider change that also
> > allows device-mapper to validate each component device. Does this
> > patch work for you?
> >
> > https://lore.kernel.org/lkml/155789172402.748145.11853718580748830476.stgit@dwillia2-desk3.amr.corp.intel.com/
>
> Thanks Dan, I tested your patch and not seeing the issue anymore.

Thanks, I recorded a "Tested-by" for you.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
