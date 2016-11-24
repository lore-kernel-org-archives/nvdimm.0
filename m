Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 33A6181EF0
 for <linux-nvdimm@lists.01.org>; Thu, 24 Nov 2016 11:30:14 -0800 (PST)
Received: by mail-oi0-x235.google.com with SMTP id v84so60134746oie.3
 for <linux-nvdimm@lists.01.org>; Thu, 24 Nov 2016 11:30:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161124000458.GS31101@dastard>
References: <147977413859.13657.2181994710415174471.stgit@djiang5-desk3.ch.intel.com>
 <20161122084754.GA25596@gmail.com>
 <CAPcyv4i+2NxdTc1xzVL+KQs8hLfUhbpGX3zstO_b=RY3hCy64w@mail.gmail.com>
 <CAGXu5jKwJaqXcmkB9Tt-sXOYhrixSRmFWA7r4QxKp10qCfCyuA@mail.gmail.com>
 <CAPcyv4jR8cVG4y90aCNycc8-PY29Jm3J89-w87dgE4hBpfVxWw@mail.gmail.com>
 <20161124000458.GS31101@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Nov 2016 11:30:12 -0800
Message-ID: <CAPcyv4iHMg_-aAzk+f8MJ9_cscL8hz6g1sQ9ER+4gNLRP43ZfQ@mail.gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Kees Cook <keescook@chromium.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 23, 2016 at 4:04 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Nov 22, 2016 at 11:01:32AM -0800, Dan Williams wrote:
>> On Tue, Nov 22, 2016 at 10:54 AM, Kees Cook <keescook@chromium.org> wrote:
>> > On Tue, Nov 22, 2016 at 9:26 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> >> No, you're right, we need to handle multiple ranges.  Since the
>> >> mem_avoid array is statically allocated perhaps we can handle up to 4
>> >> memmap= entries, but past that point disable kaslr for that boot?
>> >
>> > Yeah, that seems fine to me. I assume it's rare to have 4?
>> >
>>
>> It should be rare to have *one* since ACPI 6.0 added support for
>> communicating persistent memory ranges.  However there are legacy
>> nvdimm users that I know are doing at least 2, but I have hard time
>> imagining they would ever do more than 4.
>
> I doubt it's rare amongst the people using RAM to emulate pmem for
> filesystem testing purposes. My "pmem" test VM always has at least 2
> ranges set to give me two discrete pmem devices, and I have used 4
> from time to time to do things like test multi-volume scratch XFS
> filesystems in xfstests (i.e. data, log and realtime volumes) so I
> didn't need to play games with partitioning or DM...

Right, but for testing do you need kaslr to be active? You can have as
many memmap regions as you want, we'll just stop trying to find a
random kernel base address after you've defined 4.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
