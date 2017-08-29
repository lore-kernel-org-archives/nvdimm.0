Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3280821E11D2D
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 09:23:33 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id w10so31571214oie.1
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 09:26:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170829190859.F14D.E1E9C6FF@jp.fujitsu.com>
References: <20170829100344.C729.E1E9C6FF@jp.fujitsu.com>
 <CAPcyv4jp5Q9XZ=ZEp=NvUgJyh+zYoDTOGy=+4ETLjX2RDvAg-w@mail.gmail.com>
 <20170829190859.F14D.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 09:26:12 -0700
Message-ID: <CAPcyv4ik7b63bdONJu6Ads8Q34S9rkULMAELoep3PjaHJhj0CA@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: clean up command definitions
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 29, 2017 at 3:09 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> On Mon, Aug 28, 2017 at 6:03 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>> >> On Mon, Aug 28, 2017 at 1:50 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> >> >
>> >> > On Mon, Aug 28, 2017 at 08:45:32AM -0700, Dan Williams wrote:
>> >> >> Remove the command payloads that do not have an associated libnvdimm
>> >> >> ioctl. I.e. remove the payloads that would only ever be carried in the
>> >> >> ND_CMD_CALL envelope. This prevents userspace from growing unnecessary
>> >> >> dependencies on this kernel header when userspace already has everything
>> >> >> it needs to craft and send these commands.
>> >> >
>> >> > Userspace needs to include linux/ndctl.h to make the call as
>> >> > that is where nd_cmd_pkg is defined.
>> >> >
>> >> > So you want to have some structures defined in ndctl.h and other
>> >> > defined in the to be created libndctl-nfit.h?  Plus a third header
>> >> > file for the HPE non-root calls?
>> >>
>> >> Yes. ndctl.h exports the ioctl command payloads, everything that goes
>> >> inside of ND_CMD_CALL is defined by userspace headers. The
>> >> libndctl-nfit.h header is proposed as a place to land vendor agnostic
>> >> NFIT-defined payloads, and any vendor specific definitions would
>> >> remain internal to libndctl as they are today.
>> >>
>> >> > Will libndctl-nfit.h be generally available and installed?
>> >>
>> >> Yes, that's the plan.
>> >>
>> >> > Will it be clean so that other applications can use it to get these
>> >> > definitions?  Or will it be loaded w/ a bunch of stuff only useful
>> >> > to your ndctl command?
>> >>
>> >> Yes, that's the plan. It's a bug if libndctl-nfit.h is not generically
>> >> clean for issuing the NFIT root device commands via some ND_CMD_CALL
>> >> helpers from the base libndctl library.
>> >>
>> >> In other words libndctl-nfit.h defines the payload and libndctl
>> >> defines some general helpers for issuing commands.
>> >
>> > Maybe I don't understand your idea yet, let me confirm it.
>> >
>> > Certainly, current acpi driver does not need these definitions.
>> > But, I think nfit_test.ko will need them to emulate these features.
>> >
>> > Do you intend that libndctl-nfit.h should be defined at "include/uapi/linux/"
>> > directory?
>> > Otherwise, it should be defined at "tools/testing/nvdimm/" or
>> > "tools/testing/nvdimm/test" ?
>>
>> nfit_test will need its own internal / private copy of these payloads
>> in tools/testing/nvdimm/test so it can emulate how the bios behaves.
>> The include/uapi/linux directory is for user to kernel interface
>> definitions and these command payloads are purely an interface to bios
>> / firmware.
>>
>
> Hmm,
>
> I'm trying to make libndctl-nfit.h under tools/testing/nvdimm/nfit/,
> and trying to move NFIT_CMD_TRANSLATE_SPA from drivers/acpi/nfit/core.c to it.
>
> But I noticed that drivers/acpi/nfit/core.c still uses the definition
> in acpi_nfit_init_dsms().
>
> ----
> static void acpi_nfit_init_dsms(struct acpi_nfit_desc *acpi_desc)
> {
>         struct nvdimm_bus_descriptor *nd_desc = &acpi_desc->nd_desc;
>         const guid_t *guid = to_nfit_uuid(NFIT_DEV_BUS);
>
>         :
>
>         dsm_mask =
>                 (1 << ND_CMD_ARS_CAP) |
>                 (1 << ND_CMD_ARS_START) |
>                 (1 << ND_CMD_ARS_STATUS) |
>                 (1 << ND_CMD_CLEAR_ERROR) |
>                 (1 << NFIT_CMD_TRANSLATE_SPA) |
>                 (1 << NFIT_CMD_ARS_INJECT_SET) |
>                 (1 << NFIT_CMD_ARS_INJECT_CLEAR) |
>                 (1 << NFIT_CMD_ARS_INJECT_GET);
>         for_each_set_bit(i, &dsm_mask, BITS_PER_LONG)
>                 if (acpi_check_dsm(adev->handle, guid, 1, 1ULL << i))
>                         set_bit(i, &nd_desc->bus_dsm_mask);
> ---
>
> Though it seems to be necessary yet,
> do you have any idea to remove it?

Here's the end state I'm looking for...

1/ drivers/acpi/nfit/core.c keeps its current definitions of the
NFIT_CMD_ numbers since it needs to validate the DSM command number
mask

2/ tools/testing/nvdimm/test/nfit.h grows private definitions of only
the command payloads that it emulates

3/ ndctl in userspace grows a new ndctl/libndctl-nfit.h with all the
payloads defined in ACPI. Ideally we can deprecate all the payload
definitions in ndctl.h and only use the ND_CMD_CALL ioctl plus the
ndctl/libndctl-nfit.h definitions. Although, since label reading has
moved away from DSMs we'll always need the separate
ND_CMD_{GET,SET}_CONFIG_DATA ioctls. The libndctl-nfit.h header should
be listed in pkginclude_HEADERS.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
