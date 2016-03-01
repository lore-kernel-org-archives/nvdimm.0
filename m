Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x22f.google.com (mail-ob0-x22f.google.com
 [IPv6:2607:f8b0:4003:c01::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AEAF91A1E3D
 for <linux-nvdimm@lists.01.org>; Tue,  1 Mar 2016 10:14:41 -0800 (PST)
Received: by mail-ob0-x22f.google.com with SMTP id fz5so42677703obc.0
 for <linux-nvdimm@lists.01.org>; Tue, 01 Mar 2016 10:14:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456853819.15454.45.camel@hpe.com>
References: <1456178130-26468-1-git-send-email-toshi.kani@hpe.com>
 <1456178130-26468-2-git-send-email-toshi.kani@hpe.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37E44D64B@ORSMSX110.amr.corp.intel.com>
 <1456850284.15454.23.camel@hpe.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37E44D6E1@ORSMSX110.amr.corp.intel.com>
 <1456853819.15454.45.camel@hpe.com>
Date: Tue, 1 Mar 2016 10:14:32 -0800
Message-ID: <CAPcyv4hS44abMCs1sxdLW0YgMjP33Td0LbEWhXi9jqJ_ARU7CA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ACPI/NFIT: Update Control Region Structure to
 comply ACPI 6.1
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "Moore, Robert  <robert.moore@intel.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Zheng," Lv" <lv.zheng@intel.com>, "devel@acpica.org,  <devel@acpica.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 1, 2016 at 9:36 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
> On Tue, 2016-03-01 at 16:03 +0000, Moore, Robert wrote:
>> We have a bunch of macros in include/acmacros.h -- like this:
>>
>> ACPI_MOVE_16_TO_16(d, s)
>
> There is a problem in using the ACPICA byte-swap macros.  ACPI is little-
> endian arch, so the macros are set to perform byte-swappings when the CPU
> arch is big-endian.  This case, however, is the other way around.  The
> fields in question are defined & stored as arrays of bytes.  If you treat
> them as multi-bytes numeric values, then you need to byte-swap them when
> the CPU arch is little-endian because arrays of bytes have the same
> addressing as big-endian.
>
> Another issue is that it is not clear who needs to perform the byte-
> swapping among ACPICA and drivers.  If ACPICA, drivers must agree that
> these fields are always treated as multi-bytes numeric values despite of
> the spec.  If drivers, we need to make sure that only a single driver
> performs this byte-swapping one time as ACPI tables are global structures.
>
> I think it is much clearer to define the structure according to the ACPI
> spec.

I think the "ACPI tables are little-endian" assumption is pervasive
throughout the implementation.

Toshi, it seems all we need is conversions like:

- sprintf(buf, "%#x\n", dcr->vendor_id);
+ sprintf(buf, "%#x\n", le16_to_cpu(dcr->vendor_id));

...for the values exported to userspace through sysfs, but otherwise
leave the base table definitions as is.  Will this suffice?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
