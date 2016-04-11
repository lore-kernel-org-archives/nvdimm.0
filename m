Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x236.google.com (mail-ob0-x236.google.com
 [IPv6:2607:f8b0:4003:c01::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E6C01A1F3F
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 15:19:04 -0700 (PDT)
Received: by mail-ob0-x236.google.com with SMTP id bg3so120175640obb.1
 for <linux-nvdimm@lists.01.org>; Mon, 11 Apr 2016 15:19:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cover.1458583367.git.jerry.hoemann@hpe.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
Date: Mon, 11 Apr 2016 15:19:03 -0700
Message-ID: <CAPcyv4gs+YGY2XJ02sZigdKVZ46THh3y=LzFOO8fRgDZfsfChQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/10] nvdimm: Add an IOCTL pass thru for DSM calls
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 21, 2016 at 12:37 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>
> The NVDIMM code in the kernel supports an IOCTL interface to user
> space based upon the Intel Example DSM:
>
>         http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
>
> This interface cannot be used by other NVDIMM DSMs that support
> incompatible functions.
>
> An alternative DSM specification for Type N DSM being developed
> by Hewlett Packard Enterprise can be found at:
>
>         https://github.com/HewlettPackard/hpe-nvm/tree/master/Documentation

These links should appear in the patch changelog that uses details
from the given specification.  Otherwise useful information like this
is simply thrown away since the cover letter of a patch series is not
stored in the git history.

> To accommodate multiple and conflicting DSM specifications, this patch
> set adds a generic "pass-thru" IOCTL interface which is not tied to
> a particular DSM.
>
> A new _IOC_NR ND_CMD_CALL == "10" is added for the pass thru call.
>
> The new data structure nd_cmd_pkg serves as a wrapper for the
> pass-thru calls.  This wrapper supplies the data that the kernel
> needs to make the _DSM call.
>
> Unlike the definitions of the _DSM functions themselves, the nd_cmd_pkg
> provides the calling information (input/output sizes) in an uniform
> manner making the kernel marshaling of the arguments straight
> forward.
>
> This shifts the marshaling burden from the kernel to the user
> space application while still permitting the kernel to internally
> call _DSM functions.
>
> The kernel functions __nd_ioctl and acpi_nfit_ctl were modified
> to accommodate ND_CMD_CALL.
>

I have applied the first 4 patches with some fixups to the change log
and squashing the patch4 into patch2.  Please base the next revision
of this series on top of the for-4.7/dsm branch:

https://git.kernel.org/cgit/linux/kernel/git/djbw/nvdimm.git/log/?h=for-4.7/dsm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
