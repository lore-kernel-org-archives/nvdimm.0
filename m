Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE18222283518
 for <linux-nvdimm@lists.01.org>; Tue,  6 Mar 2018 08:46:08 -0800 (PST)
Received: by mail-oi0-x244.google.com with SMTP id h23so150633oib.5
 for <linux-nvdimm@lists.01.org>; Tue, 06 Mar 2018 08:52:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180306040630.GA9905@linux.intel.com>
References: <20180302122049.13900-1-jthumshirn@suse.de>
 <20180306040630.GA9905@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Mar 2018 08:52:21 -0800
Message-ID: <CAPcyv4giwg1mStkA+7hXnABb8fV6VH2qQPstRfYU26-P56X4ug@mail.gmail.com>
Subject: Re: [PATCH] acpi, nfit: remove redundant __func__ in dev_dbg
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 5, 2018 at 8:06 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, Mar 02, 2018 at 01:20:49PM +0100, Johannes Thumshirn wrote:
>> Dynamic debug can be instructed to add the function name to the debug
>> output using the +f switch, so there is no need for the nfit module to
>> do it again. If a user decides to add the +f switch for nfit's dynamic
>> debug this results in double prints of the function name like the
>> following:
>>
>> [ 2391.935383] acpi_nfit_ctl: nfit ACPI0012:00: acpi_nfit_ctl:nmem8 cmd: 10: func: 1 input length: 0
>>
>> Thus remove the stray __func__ printing.
>>
>> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>
> Oh, Johannes I noticed that here is one stray one still in
> drivers/acpi/nfit/mce.c.  Do you mind pulling it into your patch to keep the
> drivers/acpi/nfit/* changes together?

I'll fix this locally.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
