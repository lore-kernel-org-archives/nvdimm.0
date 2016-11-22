Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 91CC881DD3
 for <linux-nvdimm@lists.01.org>; Tue, 22 Nov 2016 11:01:34 -0800 (PST)
Received: by mail-oi0-x232.google.com with SMTP id b126so28454412oia.2
 for <linux-nvdimm@lists.01.org>; Tue, 22 Nov 2016 11:01:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKwJaqXcmkB9Tt-sXOYhrixSRmFWA7r4QxKp10qCfCyuA@mail.gmail.com>
References: <147977413859.13657.2181994710415174471.stgit@djiang5-desk3.ch.intel.com>
 <20161122084754.GA25596@gmail.com>
 <CAPcyv4i+2NxdTc1xzVL+KQs8hLfUhbpGX3zstO_b=RY3hCy64w@mail.gmail.com>
 <CAGXu5jKwJaqXcmkB9Tt-sXOYhrixSRmFWA7r4QxKp10qCfCyuA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 22 Nov 2016 11:01:32 -0800
Message-ID: <CAPcyv4jR8cVG4y90aCNycc8-PY29Jm3J89-w87dgE4hBpfVxWw@mail.gmail.com>
Subject: Re: [PATCH] x86: fix kaslr and memmap collision
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
To: Kees Cook <keescook@chromium.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, david <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 22, 2016 at 10:54 AM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Nov 22, 2016 at 9:26 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> [ replying for Dave since he's offline today and tomorrow ]
>>
>> On Tue, Nov 22, 2016 at 12:47 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>>
>>> * Dave Jiang <dave.jiang@intel.com> wrote:
>>>
>>>> CONFIG_RANDOMIZE_BASE relocates the kernel to a random base address.
>>>> However it does not take into account the memmap= parameter passed in from
>>>> the kernel commandline.
>>>
>>> memmap= parameters are often used as a list.
>>>
>>>> [...] This results in the kernel sometimes being put in the middle of the user
>>>> memmap. [...]
>>>
>>> What does this mean? If memmap= is used to re-define the memory map then the
>>> kernel getting in the middle of a RAM area is what we want, isn't it? What we
>>> don't want is for the kernel to get into reserved areas, right?
>>
>> Right, this is about teaching kaslr to not land the kernel in newly
>> defined reserved regions that were not marked reserved in the initial
>> e820 map from platform firmware.
>>
>>>> [...] Check has been added in the kaslr in order to avoid the region marked by
>>>> memmap.
>>>
>>> What does this mean?
>>
>> Is this clearer? "Update the set of 'mem_avoid' entries to exclude
>> 'memmap=' defined reserved regions from the set of valid address range
>> to land the kernel image."
>>
>>>
>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>>> ---
>>>>  arch/x86/boot/boot.h             |    2 ++
>>>>  arch/x86/boot/compressed/kaslr.c |   45 ++++++++++++++++++++++++++++++++++++++
>>>>  arch/x86/boot/string.c           |   25 +++++++++++++++++++++
>>>>  3 files changed, 72 insertions(+)
>>>>
>>>> diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
>>>> index e5612f3..0d5fe5b 100644
>>>> --- a/arch/x86/boot/boot.h
>>>> +++ b/arch/x86/boot/boot.h
>>>> @@ -332,6 +332,8 @@ int strncmp(const char *cs, const char *ct, size_t count);
>>>>  size_t strnlen(const char *s, size_t maxlen);
>>>>  unsigned int atou(const char *s);
>>>>  unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base);
>>>> +unsigned long simple_strtoul(const char *cp, char **endp, unsigned int base);
>>>> +long simple_strtol(const char *cp, char **endp, unsigned int base);
>>>>  size_t strlen(const char *s);
>>>>
>>>>  /* tty.c */
>>>> diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
>>>> index a66854d..6fb8f1ec 100644
>>>> --- a/arch/x86/boot/compressed/kaslr.c
>>>> +++ b/arch/x86/boot/compressed/kaslr.c
>>>> @@ -11,6 +11,7 @@
>>>>   */
>>>>  #include "misc.h"
>>>>  #include "error.h"
>>>> +#include "../boot.h"
>>>>
>>>>  #include <generated/compile.h>
>>>>  #include <linux/module.h>
>>>> @@ -61,6 +62,7 @@ enum mem_avoid_index {
>>>>       MEM_AVOID_INITRD,
>>>>       MEM_AVOID_CMDLINE,
>>>>       MEM_AVOID_BOOTPARAMS,
>>>> +     MEM_AVOID_MEMMAP,
>>>>       MEM_AVOID_MAX,
>>>>  };
>>>>
>>>> @@ -77,6 +79,37 @@ static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
>>>>       return true;
>>>>  }
>>>>
>>>> +#include "../../../../lib/cmdline.c"
>>>> +
>>>> +static int
>>>> +parse_memmap(char *p, unsigned long long *start, unsigned long long *size)
>>>> +{
>>>> +     char *oldp;
>>>> +
>>>> +     if (!p)
>>>> +             return -EINVAL;
>>>> +
>>>> +     /* we don't care about this option here */
>>>> +     if (!strncmp(p, "exactmap", 8))
>>>> +             return -EINVAL;
>>>> +
>>>> +     oldp = p;
>>>> +     *size = memparse(p, &p);
>>>> +     if (p == oldp)
>>>> +             return -EINVAL;
>>>> +
>>>> +     switch (*p) {
>>>> +     case '@':
>>>> +     case '#':
>>>> +     case '$':
>>>> +     case '!':
>>>> +             *start = memparse(p+1, &p);
>>>> +             return 0;
>>>> +     }
>>>> +
>>>> +     return -EINVAL;
>>>> +}
>>>> +
>>>>  /*
>>>>   * In theory, KASLR can put the kernel anywhere in the range of [16M, 64T).
>>>>   * The mem_avoid array is used to store the ranges that need to be avoided
>>>> @@ -158,6 +191,8 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
>>>>       u64 initrd_start, initrd_size;
>>>>       u64 cmd_line, cmd_line_size;
>>>>       char *ptr;
>>>> +     char arg[38];
>>>
>>> Where does the magic '38' come from?
>>>
>>>> +     unsigned long long memmap_start, memmap_size;
>>>>
>>>>       /*
>>>>        * Avoid the region that is unsafe to overlap during
>>>> @@ -195,6 +230,16 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
>>>>       add_identity_map(mem_avoid[MEM_AVOID_BOOTPARAMS].start,
>>>>                        mem_avoid[MEM_AVOID_BOOTPARAMS].size);
>>>>
>>>> +     /* see if we have any memmap areas */
>>>> +     if (cmdline_find_option("memmap", arg, sizeof(arg)) > 0) {
>>>> +             int rc = parse_memmap(arg, &memmap_start, &memmap_size);
>>>> +
>>>> +             if (!rc) {
>>>> +                     mem_avoid[MEM_AVOID_MEMMAP].start = memmap_start;
>>>> +                     mem_avoid[MEM_AVOID_MEMMAP].size = memmap_size;
>>>> +             }
>>>> +     }
>>>> +
>>>
>>> This only handles a single (first) memmap argument, is that sufficient?
>>
>> No, you're right, we need to handle multiple ranges.  Since the
>> mem_avoid array is statically allocated perhaps we can handle up to 4
>> memmap= entries, but past that point disable kaslr for that boot?
>
> Yeah, that seems fine to me. I assume it's rare to have 4?
>

It should be rare to have *one* since ACPI 6.0 added support for
communicating persistent memory ranges.  However there are legacy
nvdimm users that I know are doing at least 2, but I have hard time
imagining they would ever do more than 4.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
