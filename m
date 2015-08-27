Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: Re: [PATCH 2/2]: acpica/nfit: Rename not-armed bit definition
References: <1440606024-29873-1-git-send-email-toshi.kani@hp.com>
 <1440606024-29873-3-git-send-email-toshi.kani@hp.com>
 <CAPcyv4ifkE4kZ3fc3qqwQwBa1QabMcZotLJm+gXALZbNKYQ3aQ@mail.gmail.com>
 <1440623522.14237.57.camel@hp.com>
 <CAPcyv4he-kQ7ZoNXNH29ARG9_eX4fR-1yzuqT750z2yUDFxEUw@mail.gmail.com>
 <1440625466.14237.62.camel@hp.com>
 <CAPcyv4iy-_foyLcBGr9TSoR=9gmkS1c7g1c=TKVommdtfPCumA@mail.gmail.com>
 <55DF21FC.8020106@hp.com>
 <CAPcyv4grdxvWnLE1v7xPx0bw7K_CbZooWzN4_ToGS98gkrU_Hg@mail.gmail.com>
 <55DF2E26.30701@hp.com>
 <CAPcyv4h8iu+4yWvREyocdfFKDEo6QsV_17z=kougVBZNCeRjaQ@mail.gmail.com>
 <55DF3BA7.7070909@hp.com>
 <CAPcyv4hahUFB13tLvQ4CPsf+ZDu8xg668Rxqf5GkUHj1AFXs3g@mail.gmail.com>
From: Linda Knippers <linda.knippers@hp.com>
Message-ID: <55DF4432.6080300@hp.com>
Date: Thu, 27 Aug 2015 13:09:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hahUFB13tLvQ4CPsf+ZDu8xg668Rxqf5GkUHj1AFXs3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Elliott, Robert (Server Storage)" <elliott@hp.com>
List-ID: <linux-nvdimm@lists.01.org>

On 8/27/2015 1:04 PM, Dan Williams wrote:
> On Thu, Aug 27, 2015 at 9:32 AM, Linda Knippers <linda.knippers@hp.com> wrote:
>> I know this seems like a nit but we've going to live with this stuff for
>> a long time.
> 
> Along those lines, Bob just came by my office and gave me a decisive
> argument that I think trumps my ABI concerns, and one I'd be willing
> to argue for 4.2 inclusion.  Some BIOS implementers may do the work to
> get the polarity correct others may just read the flag name and get it
> wrong.  Once that happens the field loses all meaning regardless of
> whether Linux interprets it correctly.

BIOS developers, BIOS testers, and the OS folks working with those teams
will be grateful.

Thanks,

-- ljk



