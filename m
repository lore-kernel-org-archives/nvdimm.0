Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 317F41A1E43
 for <linux-nvdimm@lists.01.org>; Thu, 21 Jul 2016 13:00:30 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id l72so133688313oig.2
 for <linux-nvdimm@lists.01.org>; Thu, 21 Jul 2016 12:59:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1dba81aa-3ca2-a843-7175-6216be8ee4a3@hpe.com>
References: <1469065850-32401-1-git-send-email-vishal.l.verma@intel.com>
 <1469065850-32401-3-git-send-email-vishal.l.verma@intel.com>
 <57912512.5060202@hpe.com>
 <CAPcyv4hAb=qG2j+ibKwKGU+a1myq2OBDAAUXMHMT7Res1ZnoWA@mail.gmail.com>
 <1dba81aa-3ca2-a843-7175-6216be8ee4a3@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Jul 2016 12:59:37 -0700
Message-ID: <CAPcyv4jEp6qrHUcBHoO2VmauacB7O5wZdnkZCXN-QYiXa=ecWg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] nfit, libnvdimm: allow an ARS scrub to be
 triggered on demand
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Tony Luck <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 21, 2016 at 12:55 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>
>
> On 7/21/2016 3:46 PM, Dan Williams wrote:
>> On Thu, Jul 21, 2016 at 12:40 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
>>> On 07/20/2016 09:50 PM, Vishal Verma wrote:
>>>> Normally, an ARS (Address Range Scrub) only happens at
>>>> boot/initialization time. There can however arise situations where a
>>>> bus-wide rescan is needed - notably, in the case of discovering a latent
>>>> media error, we should do a full rescan to figure out what other sectors
>>>> are bad, and thus potentially avoid triggering an mce on them in the
>>>> future. Also provide a sysfs trigger to start a bus-wide scrub.
>>>
>>> I don't see anything in here that checks to see if the platform actually
>>> supports ARS before setting all this stuff up.  Setting up an MCE handler
>>> and exposing a sysfs trigger for something that is optional and perhaps
>>> not implemented doesn't seem helpful.  Or is there a check that I missed?
>>
>> We'll get -ENOTTY to ars_start(), but you're right it's a good idea to
>> hide the scrub attribute if a platform does not have ars support.
>>
>> Vishal, can you add an is_visible() routine to
>> acpi_nfit_attribute_group() to hide 'scrub' on platforms that do not
>> implement the ARS commands?
>
> It's also possible that a platform might only support ARS at boot time
> so subsequent scrubs would fail or not return any new information.
> I don't think there's a way to know that in advice though.

I would hope a platform like that just marks the "ARS - Start" command
as not supported so that we don't even generate the failure.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
