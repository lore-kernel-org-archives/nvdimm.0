Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 15F731A206C
 for <linux-nvdimm@lists.01.org>; Thu, 21 Apr 2016 04:52:18 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id x201so79425729oif.3
 for <linux-nvdimm@lists.01.org>; Thu, 21 Apr 2016 04:52:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160420174105.GC29474@tevye.fc.hp.com>
References: <cover.1460936121.git.jerry.hoemann@hpe.com>
 <9f04df3b80c68dd6406cfee5ce11a2cd8ed33b64.1460936121.git.jerry.hoemann@hpe.com>
 <CAPcyv4jiaoYnMi60ThWyeKVxj-3cWfd6ZgZq9Ot4Qfe4gXmvUQ@mail.gmail.com>
 <20160420174105.GC29474@tevye.fc.hp.com>
Date: Thu, 21 Apr 2016 04:52:17 -0700
Message-ID: <CAPcyv4iqcaaB+S-1ZMqq+nFCNsiWgs0K8hRCEoTqOzhTnA5vVA@mail.gmail.com>
Subject: Re: [RFC v9 5/5] nvdimm: Add ioctl to return command mask.
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
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 20, 2016 at 10:41 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Tue, Apr 19, 2016 at 10:45:48AM -0700, Dan Williams wrote:
>> On Sun, Apr 17, 2016 at 4:38 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
>> > The pass thru calls return command mask.  Previously, bit zero
>> > wasn't part of command mask, but as it is now, this left commands_show
>> > displaying "unknown" for function zero.  Add an ioctl interface
>> > to return command mask.
>> >
>> > Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
>> > ---
>> >  drivers/nvdimm/bus.c       | 10 ++++++++--
>> >  include/uapi/linux/ndctl.h |  9 +++++++++
>> >  2 files changed, 17 insertions(+), 2 deletions(-)
>>
>> Let's not add yet another ioctl for this...  just add a 'dsm_mask'
>> attribute to the nfit_mem device in acpi_nfit_dimm_attributes.
>
> I don't understand this comment.

So, I'm trying to find the change that made bit zero part of the
command mask, I think that is the source of the confusion.  Why do we
need to ever set bit zero in the cmd_mask?

> I can change just
>         static const char * const names[] = {
> +               [ND_CMD_IMPLEMENTED] = "cmd_mask",
>                 [ND_CMD_ARS_CAP] = "ars_cap",
>                 [ND_CMD_ARS_START] = "ars_start",
>                 [ND_CMD_ARS_STATUS] = "ars_status",
> @@ -150,6 +155,7 @@ static inline const char *nvdimm_bus_cmd_name(unsigned cmd)
>  static inline const char *nvdimm_cmd_name(unsigned cmd)
>  {
>         static const char * const names[] = {
> +               [ND_CMD_IMPLEMENTED] = "cmd_mask",
>
> And have same effect w/o adding the full ioctl support.

...but there's no ND_IOCTL_IMPLEMENTED, so why would userspace ever
care to know the name of a command it can't issue?

> But I don't see how modifying acpi_nfit_dimm_attributes affects what
> commands show will display.

It doesn't, but I was wondering if you were trying to add support for
discovering the dsm_mask via an ioctl.

> Are you asking me to also add a new attribute to sysfs to display the
> command mask?

Yes, I think it would be useful to communicate the *dsm_mask* in
sysfs, but the cmd_mask can stay as is without adding an
ND_CMD_IMPLEMENTED entry.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
