Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com
 [IPv6:2607:f8b0:4864:20::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9C855211CD9C9
 for <linux-nvdimm@lists.01.org>; Fri,  1 Mar 2019 17:35:32 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id s16so21079413oih.9
 for <linux-nvdimm@lists.01.org>; Fri, 01 Mar 2019 17:35:32 -0800 (PST)
MIME-Version: 1.0
References: <20190228201218.12501-1-toshi.kani@hpe.com>
In-Reply-To: <20190228201218.12501-1-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 1 Mar 2019 17:35:19 -0800
Message-ID: <CAPcyv4g0rderGJ+tQvfzNvhrndLWJSsTYPiM=FjL+eoKcHDKkA@mail.gmail.com>
Subject: Re: [PATCH] update NFIT flags error message
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 28, 2019 at 12:14 PM Toshi Kani <toshi.kani@hpe.com> wrote:
>
> ACPI NFIT flags field reports major errors on NVDIMM, which need
> user's attention.
>
> Update the current log to a proper error message with dev_err().
> The current message string is kept for grep-compatibility.
>

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
