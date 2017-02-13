Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A32781FF2
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 09:28:27 -0800 (PST)
Received: by mail-ot0-x233.google.com with SMTP id f9so73349260otd.1
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 09:28:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5d86cd3620ca9eb3cda38cce0401b2984526cad7.1486750247.git.linda.knippers@hpe.com>
References: <cover.1486750246.git.linda.knippers@hpe.com>
 <5d86cd3620ca9eb3cda38cce0401b2984526cad7.1486750247.git.linda.knippers@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Feb 2017 09:28:26 -0800
Message-ID: <CAPcyv4gRNeuQFwDtwGzBbs+CKZnkYibCMm0UXCD2ZWyOZN0GJg@mail.gmail.com>
Subject: Re: [PATCH 1/3] Allow all supported HPE DSM functions to be called
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 13, 2017 at 8:27 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> As it is today, we can't enable or test new functions in firmware without
> changing the kernel.
>
> With this patch we allow function 0 for the HPE DSM families,
> as is already allowed with the MS family. We now only restrict
> the functions to the currently documented set if the module parameter
> "disable_vendor_specific" is set.  Since the module parameter
> description says "Limit commands to the publicly specified set",
> this approach seems correct.
>

My concern is that this makes the kernel less strict by default. Given
this is only a test capability lets add a module option to override
the default dsm_mask. That would also seem to combine well with the
new 'default_dsm_family' option.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
