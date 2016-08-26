Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DCE2D1A1E59
 for <linux-nvdimm@lists.01.org>; Fri, 26 Aug 2016 11:39:24 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id 188so31783624oif.2
 for <linux-nvdimm@lists.01.org>; Fri, 26 Aug 2016 11:39:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1472235940.1532.23.camel@hpe.com>
References: <147198925154.3136.14739108342311837939.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147198926249.3136.6163137762013359047.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1472235940.1532.23.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Aug 2016 11:39:23 -0700
Message-ID: <CAPcyv4hdLdGR7LLyHVZsyXK6dNL1+jF927Siqt_D2DfPSifwwA@mail.gmail.com>
Subject: Re: [PATCH 2/3] acpi, nfit: add dimm device notification support
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Wysocki, Rafael J  <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 26, 2016 at 11:26 AM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Tue, 2016-08-23 at 14:54 -0700, Dan Williams wrote:
>> Per "ACPI 6.1 Section 9.20.3" NVDIMM devices, children of the
>> ACPI0012 NVDIMM Root device, can receive health event notifications.
>>
>> Given that these devices are precluded from registering a
>> notification handler via acpi_driver.acpi_device_ops (due to no
>> _HID), we use acpi_install_notify_handler() directly.
>
> I've confirmed that this ACPI notify handler is called properly.
>
>> The registered handler, acpi_nvdimm_notify(), triggers a poll(2)
>> event on the nmemX/nfit/flags sysfs attribute when a health event
>> notification is received.
>
> This sounds good idea, but should we document that the value of sysfs
> 'flags' itself does not get updated?  User space program will then need
> to call its _DSM to get health status.

Yes, this plus the new scrub attribute behavior need documentation.
I'll prepare a refresh for Documentation/nvdimm/nvdimm.txt.

The need to call a _DSM after a notification event is documented in
the ACPI spec, but you're right, we do need to connect that language
to the Linux specific mechanism.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
