Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <155925716254.3775979.16716824941364738117.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155925716783.3775979.13301455166290564145.stgit@dwillia2-desk3.amr.corp.intel.com>
 <4965161.Uu1Nigf0I0@kreacher>
In-Reply-To: <4965161.Uu1Nigf0I0@kreacher>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 31 May 2019 07:52:24 -0700
Message-ID: <CAPcyv4ib1twvDBz6W=JU18JyvtYmyHeAU4iOruRGHf_cY+3Yvg@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] acpi: Drop drivers/acpi/hmat/ directory
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-efi@vger.kernel.org, Len Brown <lenb@kernel.org>, Keith Busch <keith.busch@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 31, 2019 at 1:24 AM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> On Friday, May 31, 2019 12:59:27 AM CEST Dan Williams wrote:
> > As a single source file object there is no need for the hmat enabling to
> > have its own directory.
>
> Well, I asked Keith to add that directory as the code in hmat.c is more related to mm than to
> the rest of the ACPI subsystem.

...but hmat/hmat.c does not say anything about mm?

> Is there any problem with retaining it?

It feels redundant for no benefit to type hmat/hmat.c. How about create:

    drivers/acpi/numa/ or drivers/acpi/mm/

...and move numa.c and hmat.c there if you want to separate mm
concerns from the rest of drivers/acpi/?
