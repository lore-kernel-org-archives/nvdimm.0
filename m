Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22f.google.com (mail-ot0-x22f.google.com
 [IPv6:2607:f8b0:4003:c0f::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B835C21967BE1
 for <linux-nvdimm@lists.01.org>; Thu,  8 Jun 2017 10:33:14 -0700 (PDT)
Received: by mail-ot0-x22f.google.com with SMTP id a2so27008425oth.2
 for <linux-nvdimm@lists.01.org>; Thu, 08 Jun 2017 10:34:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b91c4a7b-3e19-df5d-12e7-61cdf1bc2c84@hpe.com>
References: <20170607184947.18733-1-toshi.kani@hpe.com>
 <CAPcyv4i7bLU17QEmdUBQrtWP3AZxPRyKK0NN105XrTj8K3nAAQ@mail.gmail.com>
 <1496869051.9288.1.camel@hpe.com>
 <CAPcyv4hwhRc6+JW8m3zVn_tKz__wE9BHOfpjy69RS6OwiqV-PA@mail.gmail.com>
 <1496871186.9288.3.camel@hpe.com>
 <b91c4a7b-3e19-df5d-12e7-61cdf1bc2c84@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Jun 2017 10:34:22 -0700
Message-ID: <CAPcyv4hocL=1Mzqa+nJCdmRz7YgxUc3P1w-nn7F=uQG8wu94KA@mail.gmail.com>
Subject: Re: [PATCH] Add support of NVDIMM memory error notification in ACPI
 6.2
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 8, 2017 at 10:30 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
[..]
> Wasn't Dan concerned about how the OS can know whether the FW supports
> that bit in the Start ARS?
>
> The Query ARS Capabilities DSM has a bit that tells the OS whether the
> platform supports the notification and the point of the notification was
> to tell the OS it could do a Start ARS with bit 1 set.  Of course, if
> you get the notification then that means the platform has the capability
> to deliver it, but it might not hurt to check the flag from the Query
> Capabilities bit.

Good point, yes, I think it is safe to assume that a BIOS that claims
to support un-correctable error notification also supports this Start
ARS flag.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
