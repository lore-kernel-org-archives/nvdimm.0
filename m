Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A99E1A1E04
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 12:48:54 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id f189so36346013oig.3
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 12:48:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471546104-28520-1-git-send-email-vishal.l.verma@intel.com>
References: <1471546104-28520-1-git-send-email-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 18 Aug 2016 12:48:49 -0700
Message-ID: <CAPcyv4ixygjD8St5YP2SjfEJnVeWMsAHjqDTF8xxWPvvDWw_bw@mail.gmail.com>
Subject: Re: [PATCH] acpi, nfit: fix acpi event notifications for nfit
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 18, 2016 at 11:48 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The nfit driver had an acpi event notification handler, but it never
> would've worked because we weren't setting the
> ACPI_DRIVER_ALL_NOTIFY_EVENTS flag in acpi_driver.

Let's update the changelog to be helpful for someone implementing a
backport or taking this back to a -stable branch.  Something like:

Subject: acpi, nfit: fix event notifications

Commit 209851649dc4 "acpi: nfit: Add support for hot-add" added
support for _FIT notifications, but it neglected to set the
ACPI_DRIVER_ALL_NOTIFY_EVENTS flag that acpi_bus_notify() uses to gate
notification delivery.

Fixes: 209851649dc4 ("acpi: nfit: Add support for hot-add")
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
