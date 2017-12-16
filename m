Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E7E0320352AA6
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 18:11:01 -0800 (PST)
Received: by mail-ot0-x241.google.com with SMTP id j2so9327008ota.13
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 18:15:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hN6obiLuMGLpufL83E42fu=9ax_dU5YQ5dZjTE78c0Mg@mail.gmail.com>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <20171214021019.13579-2-ross.zwisler@linux.intel.com>
 <CAPcyv4gnZ3NJsEUugjBrsBHcs9-yqxkvs_G4V1HHGWF2JDi13g@mail.gmail.com>
 <1658696.rIK19Js0WO@aspire.rjw.lan>
 <CAPcyv4hN6obiLuMGLpufL83E42fu=9ax_dU5YQ5dZjTE78c0Mg@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sat, 16 Dec 2017 03:15:43 +0100
Message-ID: <CAJZ5v0j63w4xZ+82z3Y8TE_nmCqDvic3RNT8RK7W7FDvEredHw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] acpi: HMAT support in acpi_parse_entries_array()
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, "Robert  <robert.moore@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Odzioba, Lukasz" <lukasz.odzioba@intel.com>, "Schmauss, Erik  <erik.schmauss@intel.com>, Len Brown <lenb@kernel.org>, John Hubbard" <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Kogut,, "Marcin  <marcin.koss@intel.com>, Brice Goglin <brice.goglin@gmail.com>, Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 16, 2017 at 2:57 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Dec 15, 2017 at 5:53 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> On Friday, December 15, 2017 2:10:17 AM CET Dan Williams wrote:
>>> On Wed, Dec 13, 2017 at 6:10 PM, Ross Zwisler
>>> <ross.zwisler@linux.intel.com> wrote:
>>> > The current implementation of acpi_parse_entries_array() assumes that each
>>> > subtable has a standard ACPI subtable entry of type struct
>>> > acpi_subtable_header.  This standard subtable header has a one byte length
>>> > followed by a one byte type.
>>> >
>>> > The HMAT subtables have to allow for a longer length so they have subtable
>>> > headers of type struct acpi_hmat_structure which has a 2 byte type and a 4
>>> > byte length.
>>>
>>> Hmm, NFIT has a 2 byte type and a 2 byte length, so its one more
>>> permutation. I happened to reinvent sub-table parsing in the NFIT
>>> driver, but it might be nice in the future to refactor that to use the
>>> common parsing.
>>>
>>> >
>>> > Enhance the subtable parsing in acpi_parse_entries_array() so that it can
>>> > handle these new HMAT subtables.
>>> >
>>> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>>> > ---
>>> >  drivers/acpi/tables.c | 52 ++++++++++++++++++++++++++++++++++++++++-----------
>>> >  1 file changed, 41 insertions(+), 11 deletions(-)
>>> >
>>> > diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
>>> > index 80ce2a7d224b..f777b94c234a 100644
>>> > --- a/drivers/acpi/tables.c
>>> > +++ b/drivers/acpi/tables.c
>>> > @@ -218,6 +218,33 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
>>> >         }
>>> >  }
>>> >
>>> > +static unsigned long __init
>>> > +acpi_get_entry_type(char *id, void *entry)
>>> > +{
>>> > +       if (strncmp(id, ACPI_SIG_HMAT, 4) == 0)
>>> > +               return ((struct acpi_hmat_structure *)entry)->type;
>>> > +       else
>>> > +               return ((struct acpi_subtable_header *)entry)->type;
>>> > +}
>>>
>>> It seems inefficient to make all checks keep asking "is HMAT?".
>>
>> Well, ideally, the signature should be checked once.  I guess that can be
>> arranged for here.
>>
>>> Especially if we want to extend this to other table types should we
>>> instead setup and pass a pair of function pointers to parse the
>>> sub-table format?
>>
>> Function pointers may be too much even. :-)
>
> True, how about an enum of acpi sub-table header types?

That works.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
