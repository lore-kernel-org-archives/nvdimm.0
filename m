Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <6932657.HzjR3A75KT@vostro.rjw.lan>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<2235175.7DaGPJD1E4@vostro.rjw.lan>
	<CAPcyv4iuPy+KR1YgE+jc91XoHSueR_k0zry-8umJWBjXzcUasg@mail.gmail.com>
	<6932657.HzjR3A75KT@vostro.rjw.lan>
Date: Mon, 4 May 2015 16:46:57 -0700
Message-ID: <CAPcyv4hiYYhYJ8n5nnSsbyWM2U9Vujz44PN7RxJT02HgKmoCNQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/20] libnd, nd_acpi: initial libnd infrastructure and
 NFIT support
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Box <david.e.box@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 4, 2015 at 4:58 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Friday, May 01, 2015 09:23:38 AM Dan Williams wrote:
>> On Thu, Apr 30, 2015 at 6:21 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> > On Thursday, April 30, 2015 05:39:06 PM Dan Williams wrote:
>> >> On Thu, Apr 30, 2015 at 4:23 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
[..]
>> > If ND_E820 and ND_ACPI aren't mutually exclusive, I still don't see a good
>> > enough reason for asking users about ND_ACPI.  Why would I ever say "No"
>> > here if I said "Yes" or "Module" to ND_DEVICES?
>>
>> I agree that if the user selects ND_DEVICES then ND_ACPI should
>> probably default on, but otherwise turning it off is a useful option.
>> If you know your system is pre-ACPI-6 then why bother including
>> support?
>
> If you're a distro, you don't care.  You have to support it regardless.
>
> You might care if you're an end user building a kernel for yourself and just
> for this particular specific machine.  Honestly, how many *server* users do
> that?
>
> And fewer user-selectable options means fewer combination of options to test
> during development/validation.
>
> Also unrelated, but applies to this patch.
>
> Since your new driver will handle device ID ACPI0012 which is defined by the
> spec proper, it should go into drivers/acpi/, because there's where such things
> go as a rule.

Ok, I think the move to drivers/acpi/ will kill two birds with one
stone as selecting ACPI_NFIT from there will select the libnd support
without prompting.
