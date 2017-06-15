Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA1EF21CA359A
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 14:43:58 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id s3so14960340oia.0
 for <linux-nvdimm@lists.01.org>; Thu, 15 Jun 2017 14:44:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170608183658.24731-2-toshi.kani@hpe.com>
References: <20170608183658.24731-1-toshi.kani@hpe.com>
 <20170608183658.24731-2-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Jun 2017 14:44:42 -0700
Message-ID: <CAPcyv4guO6dJO5xsQ=OMOY-s2j0X+xuN+zDwexsfc2wT7okniw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] acpi/nfit: Add support of NVDIMM memory error
 notification in ACPI 6.2
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 8, 2017 at 11:36 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> ACPI 6.2 defines a new ACPI notification value to NVDIMM Root Device
> in Table 5-169.
>
>  0x81 Unconsumed Uncorrectable Memory Error Detected
>       Used to pro-actively notify OSPM of uncorrectable memory errors
>       detected (for example a memory scrubbing engine that continuously
>       scans the NVDIMMs memory). This is an optional notification. Only
>       locations that were mapped in to SPA by the platform will generate
>       a notification.
>
> Add support of this notification value by initiating an ARS scan. This
> will find new error locations and add their badblocks information.
>

Looks good to me, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
