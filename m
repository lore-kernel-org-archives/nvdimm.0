Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x230.google.com (mail-io0-x230.google.com
 [IPv6:2607:f8b0:4001:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B24D21939304
 for <linux-nvdimm@lists.01.org>; Mon, 10 Apr 2017 12:03:57 -0700 (PDT)
Received: by mail-io0-x230.google.com with SMTP id a103so43697812ioj.1
 for <linux-nvdimm@lists.01.org>; Mon, 10 Apr 2017 12:03:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49vaqc3yww.fsf@segfault.boston.devel.redhat.com>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <CAGXu5jJ-Pny8_rrEBtO8W86zjw2Edk7a-My4EfRf7jePS4sQeg@mail.gmail.com>
 <x49d1ck5kkk.fsf@segfault.boston.devel.redhat.com>
 <CAGXu5jLN=HNRj1DGwzWP5kU9iZ54oxzYoPYnnnqzWc9M-gcwfw@mail.gmail.com>
 <x49vaqc3yww.fsf@segfault.boston.devel.redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 10 Apr 2017 12:03:55 -0700
Message-ID: <CAGXu5jLRFYbJ_pDj1MKzES3qfmTq4krON3CwAFfPsD0X_KXG6w@mail.gmail.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Baoquan He <bhe@redhat.com>, linux-nvdimm@lists.01.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Thomas Garnier <thgarnie@google.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 10, 2017 at 11:22 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> On Mon, Apr 10, 2017 at 8:49 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Kees Cook <keescook@chromium.org> writes:
>>>
>>>> On Fri, Apr 7, 2017 at 7:41 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>>> Hi,
>>>>>
>>>>> commit 021182e52fe01 ("x86/mm: Enable KASLR for physical mapping memory
>>>>> regions") causes some of my systems with persistent memory (whether real
>>>>> or emulated) to fail to boot with a couple of different crash
>>>>> signatures.  The first signature is a NMI watchdog lockup of all but 1
>>>>> cpu, which causes much difficulty in extracting useful information from
>>>>> the console.  The second variant is an invalid paging request, listed
>>>>> below.
>>>>
>>>> Just to rule out some of the stuff in the boot path, does booting with
>>>> "nokaslr" solve this? (i.e. I want to figure out if this is from some
>>>> of the rearrangements done that are exposed under that commit, or if
>>>> it is genuinely the randomization that is killing the systems...)
>>>
>>> Adding "nokaslr" to the boot line does indeed make the problem go away.
>>
>> Are you booting with a memmap= flag?
>
> From my first email:
>
> [ 0.000000] Command line: BOOT_IMAGE=/vmlinuz-4.11.0-rc5+
> root=/dev/mapper/rhel_intel--lizardhead--04-root ro memmap=192G!1024G
> crashkernel=auto rd.lvm.lv=rhel_intel-lizardhead-04/root
> rd.lvm.lv=rhel_intel-lizardhead-04/swap console=ttyS0,115200n81
> LANG=en_US.UTF-8
>
> Did you not receive the attachments?

I see it now, thanks!

The memmap parsing was added in -rc1 (f28442497b5ca), so I'd expect
that to be handled. Hmmm.

-Kees

-- 
Kees Cook
Pixel Security
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
