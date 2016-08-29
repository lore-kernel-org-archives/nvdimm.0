Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x233.google.com (mail-it0-x233.google.com
 [IPv6:2607:f8b0:4001:c0b::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 247371A1E05
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 14:50:57 -0700 (PDT)
Received: by mail-it0-x233.google.com with SMTP id g62so7726547ith.1
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 14:50:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <147198925154.3136.14739108342311837939.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147198925154.3136.14739108342311837939.stgit@dwillia2-desk3.amr.corp.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 29 Aug 2016 23:50:55 +0200
Message-ID: <CAJZ5v0j3+DHgU1A_0w-yCDyEzO2OneC=8UgexrnjGYOOqyW13A@mail.gmail.com>
Subject: Re: [PATCH 0/3] acpi, nfit: nvdimm notification support + tests
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 23, 2016 at 11:54 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> ACPI 6.1 added an "NFIT Health Event Notification" for nvdimm devices.
> When this fires, system software is expected to issue a DSM to retrieve
> the latest health values.  For the NFIT driver this notification
> arrives as an event on the sysfs 'flags' attribute for an nfit/nvdimm
> device.  The 'flags' attribute reflects the "NVDIMM State Flags" of the
> "5.2.25.3 NVDIMM Region Mapping Structure", and when read indicates if
> the platform supports sending health events.
>
> ---
>
> Dan Williams (3):
>       tools/testing/nvdimm: unit test for acpi_nfit_notify()
>       acpi, nfit: add dimm device notification support
>       tools/testing/nvdimm: unit test for acpi_nvdimm_notify()

ACK for the series from the ACPI core perspective.

Thanks,
Rafael
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
