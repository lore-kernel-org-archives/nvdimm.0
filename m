Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x242.google.com (mail-it0-x242.google.com
 [IPv6:2607:f8b0:4001:c0b::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 46B0220958992
 for <linux-nvdimm@lists.01.org>; Thu,  6 Jul 2017 15:34:36 -0700 (PDT)
Received: by mail-it0-x242.google.com with SMTP id v193so2750916itc.2
 for <linux-nvdimm@lists.01.org>; Thu, 06 Jul 2017 15:36:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170706222200.GA31795@linux.intel.com>
References: <20170706215233.11329-1-ross.zwisler@linux.intel.com>
 <20170706215233.11329-3-ross.zwisler@linux.intel.com>
 <CAJZ5v0gUA4d+NFqEdsXPVktXf+2AX9MurEQAiCFGxU_eaoYE5A@mail.gmail.com>
 <20170706222200.GA31795@linux.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 7 Jul 2017 00:36:16 +0200
Message-ID: <CAJZ5v0g-j5MsDnOOR2KhPp-dtQLro0XGcPHneEvLV-Z1F4LB+g@mail.gmail.com>
Subject: Re: [RFC v2 2/5] acpi: HMAT support in acpi_parse_entries_array()
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
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Box,, "Lv  <lv.zheng@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, "Robert  <robert.moore@intel.com>, ACPI Devel Maling List" <linux-acpi@vger.kernel.org>, Odzioba,, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, Jerome Glisse <jglisse@redhat.com>, "devel@acpica.org" <devel@acpica.org>, "Kogut, Jaroslaw  <Jaroslaw.Kogut@intel.com>, Linux Memory Management List" <linux-mm@kvack.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Nachimuthu, Murugasamy  <murugasamy.nachimuthu@intel.com>, Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Lahtinen, Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 7, 2017 at 12:22 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, Jul 07, 2017 at 12:13:54AM +0200, Rafael J. Wysocki wrote:
>> On Thu, Jul 6, 2017 at 11:52 PM, Ross Zwisler
>> <ross.zwisler@linux.intel.com> wrote:
>> > The current implementation of acpi_parse_entries_array() assumes that each
>> > subtable has a standard ACPI subtable entry of type struct
>> > acpi_sutbable_header.  This standard subtable header has a one byte length
>> > followed by a one byte type.
>> >
>> > The HMAT subtables have to allow for a longer length so they have subtable
>> > headers of type struct acpi_hmat_structure which has a 2 byte type and a 4
>> > byte length.
>> >
>> > Enhance the subtable parsing in acpi_parse_entries_array() so that it can
>> > handle these new HMAT subtables.
>> >
>> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> > ---
>> >  drivers/acpi/numa.c   |  2 +-
>> >  drivers/acpi/tables.c | 52 ++++++++++++++++++++++++++++++++++++++++-----------
>> >  2 files changed, 42 insertions(+), 12 deletions(-)

[cut]

>> > diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
>> > index ff42539..7979171 100644
>> > --- a/drivers/acpi/tables.c
>> > +++ b/drivers/acpi/tables.c
>> > @@ -218,6 +218,33 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
>> >         }
>> >  }
>> >
>> > +static unsigned long __init
>> > +acpi_get_entry_type(char *id, void *entry)
>> > +{
>> > +       if (!strncmp(id, ACPI_SIG_HMAT, 4))
>> > +               return ((struct acpi_hmat_structure *)entry)->type;
>> > +       else
>> > +               return ((struct acpi_subtable_header *)entry)->type;
>> > +}
>>
>> I slightly prefer to use ? : in similar situations.
>
> Hmm..that becomes rather long, and seems complex for the already hard to read
> ?: operator?  Let's see, this:
>
>         if (!strncmp(id, ACPI_SIG_HMAT, 4))
>                 return ((struct acpi_hmat_structure *)entry)->type;
>         else
>                 return ((struct acpi_subtable_header *)entry)->type;
>
> becomes
>
>         return strncmp(id, ACPI_SIG_HMAT, 4)) ?
>                 ((struct acpi_subtable_header *)entry)->type :
>                 ((struct acpi_hmat_structure *)entry)->type;
>
> Hmm...we only save one line, and I personally find that a lot harder to read,
> but that being said if you feel strongly about it I'll make the change.

Well, I said "slightly". :-)

Thanks,
Rafael
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
