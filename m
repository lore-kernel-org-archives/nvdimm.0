Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x242.google.com (mail-io0-x242.google.com
 [IPv6:2607:f8b0:4001:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF6F5210F41E1
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 12:01:49 -0700 (PDT)
Received: by mail-io0-x242.google.com with SMTP id u4-v6so17826020iof.2
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 12:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <1461620099-11933-1-git-send-email-toshi.kani@hpe.com>
 <1461620099-11933-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1461620099-11933-2-git-send-email-toshi.kani@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Jun 2018 12:01:37 -0700
Message-ID: <CAA9_cmenbY9GStibRjO0BfTq0kzzzqThiLeOygJsT9L03BFsBQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] acpi/nfit: Update nfit driver to comply with ACPI
 6.1
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Bob Moore <robert.moore@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 25, 2016 at 2:43 PM Toshi Kani <toshi.kani@hpe.com> wrote:
>
> ACPI 6.1, Table 5-133, updates NVDIMM Control Region Structure
> as follows.
>  - Valid Fields, Manufacturing Location, and Manufacturing Date
>    are added from reserved range.  No change in the structure size.
>  - IDs (SPD values) are stored as arrays of bytes (i.e. big-endian
>    format).  The spec clarifies that they need to be represented
>    as arrays of bytes as well.
>

Circling back on this a couple years too late... where are you reading
this "arrays of bytes" note. As far as I can see this is wrong. JEDEC
says that vendor id is stored LSB of the id is stored at the lowest
byte in SPD, which is little endian. So it seems Linux has showing the
incorrect value for a long time now.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
