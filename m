Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam03on0703.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe49::703])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B06C1A1E04
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 12:52:55 -0700 (PDT)
Subject: Re: [PATCH] acpi, nfit: fix acpi event notifications for nfit
References: <1471546104-28520-1-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4ixygjD8St5YP2SjfEJnVeWMsAHjqDTF8xxWPvvDWw_bw@mail.gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <07af328e-d703-fd80-20be-725f00e54812@hpe.com>
Date: Thu, 18 Aug 2016 15:52:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ixygjD8St5YP2SjfEJnVeWMsAHjqDTF8xxWPvvDWw_bw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 8/18/2016 3:48 PM, Dan Williams wrote:
> On Thu, Aug 18, 2016 at 11:48 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
>> The nfit driver had an acpi event notification handler, but it never
>> would've worked because we weren't setting the
>> ACPI_DRIVER_ALL_NOTIFY_EVENTS flag in acpi_driver.
> 
> Let's update the changelog to be helpful for someone implementing a
> backport or taking this back to a -stable branch.  Something like:
> 
> Subject: acpi, nfit: fix event notifications
> 
> Commit 209851649dc4 "acpi: nfit: Add support for hot-add" added
> support for _FIT notifications, but it neglected to set the
> ACPI_DRIVER_ALL_NOTIFY_EVENTS flag that acpi_bus_notify() uses to gate
> notification delivery.

While we're at it, should we update the notifier function to explicitly check
for event 0x80 before re-evaluating the _FIT?  I'm thinking about some time
in the future when there might be more than one event.

-- ljk
> 
> Fixes: 209851649dc4 ("acpi: nfit: Add support for hot-add")
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
