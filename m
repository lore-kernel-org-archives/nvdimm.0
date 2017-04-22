Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x242.google.com (mail-qk0-x242.google.com
 [IPv6:2607:f8b0:400d:c09::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 16D7C21A04817
 for <linux-nvdimm@lists.01.org>; Sat, 22 Apr 2017 00:04:43 -0700 (PDT)
Received: by mail-qk0-x242.google.com with SMTP id k139so15005698qke.2
 for <linux-nvdimm@lists.01.org>; Sat, 22 Apr 2017 00:04:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4i3KRK7ede=qh7Br0Aw0JXviAFkfyjJyzDObuvhd3zddQ@mail.gmail.com>
References: <20170421071219.18744-1-oohall@gmail.com>
 <20170421071219.18744-2-oohall@gmail.com>
 <CAPcyv4i3KRK7ede=qh7Br0Aw0JXviAFkfyjJyzDObuvhd3zddQ@mail.gmail.com>
From: "Oliver O'Halloran" <oohall@gmail.com>
Date: Sat, 22 Apr 2017 17:04:41 +1000
Message-ID: <CAOSf1CG3fL=PrtnfotFsCYtMwJnEk0PQky2uyxGZ_48sEf_h0Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] ndctl,
 create-namespace: read default alignment from sysfs
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Apr 22, 2017 at 3:19 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Apr 21, 2017 at 12:12 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
>> Read the default alignment from the hpage_pmd_size in sysfs. On PPC the
>> PMD size depends on the MMU being used. When the traditional hash MMU is
>> used (P9 and earlier) the PMD size is 16MB while the newer radix MMU
>> uses a 2MB PMD size. The choice of MMU is done at runtime depending on
>> what the hardware supports so we need to detect this at runtime rather
>> than hardcoding it.
>>
>> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
>> ---
>>  ndctl/Makefile.am                 |  3 ++-
>>  ndctl/builtin-xaction-namespace.c | 41 +++++++++++++++++++++++++++++----------
>>  2 files changed, 33 insertions(+), 11 deletions(-)
>>
>> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
>> index c563e9411cc3..6d565c643efd 100644
>> --- a/ndctl/Makefile.am
>> +++ b/ndctl/Makefile.am
>> @@ -10,7 +10,8 @@ ndctl_SOURCES = ndctl.c \
>>                  ../util/log.c \
>>                 builtin-list.c \
>>                 builtin-test.c \
>> -               ../util/json.c
>> +               ../util/json.c \
>> +               ../util/sysfs.c
>>
>>  if ENABLE_SMART
>>  ndctl_SOURCES += util/json-smart.c
>> diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
>> index d6c38dc15984..713a95987d91 100644
>> --- a/ndctl/builtin-xaction-namespace.c
>> +++ b/ndctl/builtin-xaction-namespace.c
>> @@ -22,6 +22,7 @@
>>  #include <sys/types.h>
>>  #include <util/size.h>
>>  #include <util/json.h>
>> +#include <util/sysfs.h>
>>  #include <json-c/json.h>
>>  #include <util/filter.h>
>>  #include <ndctl/libndctl.h>
>> @@ -54,6 +55,8 @@ static struct parameters {
>>         const char *align;
>>  } param;
>>
>> +char default_align_buf[SYSFS_ATTR_SIZE];
>> +
>>  void builtin_xaction_namespace_reset(void)
>>  {
>>         /*
>> @@ -137,7 +140,24 @@ enum namespace_action {
>>         ACTION_DESTROY,
>>  };
>>
>> -static int set_defaults(enum namespace_action mode)
>> +const char *sysfs_read_default_align(struct ndctl_ctx *ctx, const char *def,
>> +               const char *path)
>> +{
>> +       /*
>> +        * HACK: The command handlers aren't supposed to write into
>> +        *       the ndctl command context, but we want the debug
>> +        *       output to go somewhere sensible.
>> +        */
>> +       if (__sysfs_read_attr((struct log_ctx *)ctx, path, default_align_buf))
>> +               return strdup(def);
>> +
>> +       if (!strlen(default_align_buf))
>> +               return def;
>> +
>> +       return default_align_buf;
>
> I chatted with Dave Hansen about this and we're thinking we should go
> ahead and add a new attribute to the device-dax sysfs with the list of
> supported alignments, similar to what we have in the btt case for
> supported sector sizes.
>
> The reason is that the sensitivity to page sizes is a device-dax
> internal requirement. Theoretically device-dax could support any
> alignment and handle it with a mix of page sizes. However, since
> device-dax wants to be strict and predictable about the tlb size
> backing a given device-dax mapping then it should list the possible
> options.

Sounds good to me. Using the thp sysfs entries was always going to be
a bit of hack job, but I couldn't find anything better to use as a
sane default. I'll post a patch Monday (unless you already wrote one?)

> Looking at the transparent_hugepage sysfs is a bit of a layering
> violation. There is no strict guarantee that device-dax is tied to thp
> in the longterm. The thp sysfs is also awkward because it does not
> tell us the pud page size.

Are there any concrete plans on moving device-dax away from THP? THP
under hash has some horrible quirks and although the hardware supports
up to 16G pages they're impossible to use outside of hugetlbfs. It
would be nice to make use of the larger page sizes with dax devs, but
I'm not sure I want to jump down that rabbit hole...

Oliver
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
