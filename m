Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6DB0B1A1EC9
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jul 2016 07:58:29 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id l72so20667248oig.2
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jul 2016 07:57:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <578878E7.9060504@intel.com>
References: <146855333714.573.13934675433503265133.stgit@dwillia2-desk3.amr.corp.intel.com>
 <578878E7.9060504@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Jul 2016 07:57:40 -0700
Message-ID: <CAPcyv4ja17tfRA218R40eOtVRAk2WJ2oSp=a2G-LYwFB+G0abw@mail.gmail.com>
Subject: Re: [PATCH 1/2] nfit: fix _FIT evaluation memory leak
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
To: Xiao Guangrong <guangrong.xiao@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 14, 2016 at 10:47 PM, Xiao Guangrong
<guangrong.xiao@intel.com> wrote:
>
>
> On 07/15/2016 11:28 AM, Dan Williams wrote:
>>
>> acpi_evaluate_object() allocates memory. Free the buffer allocated
>> during acpi_nfit_add().
>>
>
> Dan, thanks for your fix.
>
> Another one is the use-after-free issue in acpi_nfit_notify():
>
>         /* Evaluate _FIT */
>         status = acpi_evaluate_object(adev->handle, "_FIT", NULL, &buf);
>         ...
>                 acpi_desc->nfit =
>                         (struct acpi_nfit_header *)obj->buffer.pointer;
>         ...
>         kfree(buf.pointer);

grep for acpi_desc->nfit usages, there are no usages after
acpi_nfit_init(). We go through the hassle of setting up nfit_saved
for no reason.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
