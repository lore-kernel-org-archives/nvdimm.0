Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x232.google.com (mail-ob0-x232.google.com
 [IPv6:2607:f8b0:4003:c01::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF65D1A1E1B
 for <linux-nvdimm@lists.01.org>; Wed, 29 Jun 2016 16:22:53 -0700 (PDT)
Received: by mail-ob0-x232.google.com with SMTP id ru5so47482993obc.1
 for <linux-nvdimm@lists.01.org>; Wed, 29 Jun 2016 16:22:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467242324.10222.0.camel@intel.com>
References: <1467241230-15054-1-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4gFZc2CizeMhc7v+ZzdLpL5tWRO+0JrTY-GDTFMryVefA@mail.gmail.com>
 <1467242324.10222.0.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 29 Jun 2016 16:22:16 -0700
Message-ID: <CAPcyv4igt1jL4PmLdwHZ2kUYmXgg9eA5kk3SLU6xBnAiAxM7aA@mail.gmail.com>
Subject: Re: [PATCH] acpi, nfit: print command names instead of numbers
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 29, 2016 at 4:19 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Wed, 2016-06-29 at 16:12 -0700, Dan Williams wrote:
>> On Wed, Jun 29, 2016 at 4:00 PM, Vishal Verma <vishal.l.verma@intel.co
>> m> wrote:
>> >
>> > For the debug prints in acpi_nfit_ctl(), all the prints except the
>> > input
>> > buffer dump printed the command name. Make this also do the same for
>> > better readability.
>> >
>> > Cc: Dan Williams <dan.j.williams@intel.com>
>> > Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>> > ---
>> >  drivers/acpi/nfit.c | 4 ++--
>> >  1 file changed, 2 insertions(+), 2 deletions(-)
>> We used to do this, but nvdimm_cmd_name() currently only knows the
>> names for the "Intel" DSMs.  At a minimum we should force cmd_name to
>> "unknown" for the other formats until support is added.
>
> Looks like both the cmd_name functions (for bus and dimm) already do
> return 'unknown' when a match isn't found?

If the value is out of range, but if the cmd number is < 10 it will
print the Intel name which might be wrong.  nvdimm_cmd_name() needs to
take a new 'family id' parameter.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
