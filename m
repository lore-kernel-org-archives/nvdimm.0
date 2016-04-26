Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C46D71A1E02
 for <linux-nvdimm@lists.01.org>; Tue, 26 Apr 2016 16:54:38 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id k142so32571094oib.1
 for <linux-nvdimm@lists.01.org>; Tue, 26 Apr 2016 16:54:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461620099-11933-1-git-send-email-toshi.kani@hpe.com>
References: <1461620099-11933-1-git-send-email-toshi.kani@hpe.com>
Date: Tue, 26 Apr 2016 16:54:37 -0700
Message-ID: <CAPcyv4h5dq3gDWcQLP9oN95Nbqar9tkirA0-U8ZO+cLRtoYQ+g@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] Support ACPI 6.1 update in NFIT Control Region
 Structure
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Robert Moore <robert.moore@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 25, 2016 at 2:34 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
> ACPI 6.1, Table 5-133, updates NVDIMM Control Region Structure as
> follows.
>  - Valid Fields, Manufacturing Location, and Manufacturing Date
>    are added from reserved range.  No change in the structure size.
>  - IDs (SPD values) are stored as arrays of bytes (i.e. big-endian
>    format).  The spec clarifies that they need to be represented
>    as arrays of bytes as well.
>
> Patch 1 changes the NFIT driver to comply with ACPI 6.1.
> Patch 2 adds a new sysfs file "id" to show NVDIMM ID defined in ACPI 6.1.
>
> The patch-set applies on linux-pm.git acpica.
>
> link: http://www.uefi.org/sites/default/files/resources/ACPI_6_1.pdf
>
> ---
> v3:
>  - Need to coordinate with ACPICA update (Bob Moore, Dan Williams)
>  - Integrate with ACPICA changes in struct acpi_nfit_control_region.
>    (commit 138a95547ab0)
>
> v2:
>  - Remove 'mfg_location' and 'mfg_date'. (Dan Williams)
>  - Rename 'unique_id' to 'id' and make this change as a separate patch.
>    (Dan Williams)
>
> ---
> Toshi Kani (3):
>  1/2 acpi/nfit: Update nfit driver to comply with ACPI 6.1
>  2/3 acpi/nfit: Add sysfs "id" for NVDIMM ID

Thanks Toshi, I've applied these.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
