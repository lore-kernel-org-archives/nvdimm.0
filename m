Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x231.google.com (mail-ob0-x231.google.com
 [IPv6:2607:f8b0:4003:c01::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E01A1A1EC9
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 14:44:42 -0800 (PST)
Received: by mail-ob0-x231.google.com with SMTP id fz5so29341570obc.0
 for <linux-nvdimm@lists.01.org>; Tue, 08 Mar 2016 14:44:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFxPn3J68MsqQd7OVv7jetZjPduP53MFmw2f_-z7=ebpXQ@mail.gmail.com>
References: <1457460530-17959-1-git-send-email-toshi.kani@hpe.com>
 <CA+55aFy=V-esUXZa2AogS685k+r9PyyNStkZrrUUkWSKvLFUGQ@mail.gmail.com>
 <CAPcyv4gT1RvnEquYXVo7sZscdUrkiWpG-Yvr_EX4=L25397X0g@mail.gmail.com>
 <CA+55aFxPn3J68MsqQd7OVv7jetZjPduP53MFmw2f_-z7=ebpXQ@mail.gmail.com>
Date: Tue, 8 Mar 2016 14:44:28 -0800
Message-ID: <CAPcyv4i2GwujqK=MDJpSKhvufJprmCV4vmQRpS_UP-n1kau+mg@mail.gmail.com>
Subject: Re: [PATCH v2-UPDATE2 3/4] resource: Add device-managed
 insert/remove_resource()
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 8, 2016 at 2:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Mar 8, 2016 at 12:59 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> Here's the usage patch from Toshi [1] (copied below).  It is indeed a
>> resource injected by nfit / nvdimm bus implementation.  We just happen
>> to support nfit and libnvdimm as modules.
>>
>> The goal of these patches is to use the ACPI NFIT data to create a
>> "Persistent Memory" rather than "reserved" resource.  This is for
>> platform-firmware implementations that use E820-Type2 rather than
>> E820-Type7 to describe pmem.
>
> So my worry is that there is likely exactly one or two of these kinds of sites.
>
> Why couldn't they just use insert_resource() and then remove it manually?

You mean instead of introducing a devm_insert_resource() as a helpful
first-class-citizen api, just arrange for the resource to be inserted
locally?  Sure.

I assume Toshi was looking to keep the devm semantics like the rest of
the nfit driver, but we can do that locally with devm_add_action() and
skip the new general purpose api.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
