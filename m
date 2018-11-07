Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com
 [IPv6:2607:f8b0:4864:20::329])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5928E21A00AE6
 for <linux-nvdimm@lists.01.org>; Wed,  7 Nov 2018 11:34:34 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id f24so15874495otl.5
 for <linux-nvdimm@lists.01.org>; Wed, 07 Nov 2018 11:34:34 -0800 (PST)
MIME-Version: 1.0
References: <20181107185241.26982-1-toshi.kani@hpe.com>
In-Reply-To: <20181107185241.26982-1-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Nov 2018 11:34:22 -0800
Message-ID: <CAPcyv4hE49JiFdaM_L0+KPQayZ0qRYokNRPxD5YuwCCp4fzkqQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: Fix __nd_ioctl() to check error in cmd_rc
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 7, 2018 at 10:52 AM Toshi Kani <toshi.kani@hpe.com> wrote:
>
> ndctl zero-labels completes with a large number of zeroed nmems when
> it fails to do zeroing on a protected NVDIMM.
>
>   # ndctl zero-labels nmem1
>   zeroed 65504 nmems
>
> When an ACPI call completes with error, xlat_status() called from
> acpi_nfit_ctl() sets error to *cmd_rc.  __nd_ioctl(), however, does
> not check this error and returns with success.
>
> Fix __nd_ioctl() to check this error in cmd_rc.

So this arrangement is by design and the bug is in the ndctl utility.

A successful return code from the ioctl means that the command was
successfully submitted to firmware. It's then up to userspace to parse
if there was a command specific error returned in the response
payload. Automatically returning cmd_rc removes the ability for
userspace tooling to do its own command specific error handling. With
this change userspace could no longer be sure if the failure is in the
submission or the execution of the command, or determine if the
command response payload is valid.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
