Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BA00F21942349
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 07:51:23 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <CAJcbSZGWLC+QCk8GuBneL2ho2eXfyKdVrP4uUgvbSv-GoXissg@mail.gmail.com>
Date: Fri, 07 Apr 2017 10:51:21 -0400
In-Reply-To: <CAJcbSZGWLC+QCk8GuBneL2ho2eXfyKdVrP4uUgvbSv-GoXissg@mail.gmail.com>
 (Thomas Garnier's message of "Fri, 7 Apr 2017 07:49:43 -0700")
Message-ID: <x49o9w86zkm.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Thomas Garnier <thgarnie@google.com>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, linux-nvdimm@lists.01.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Thomas Garnier <thgarnie@google.com> writes:

> CCing Kees for information.
>
> On Fri, Apr 7, 2017 at 7:41 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Hi,
>>
>> commit 021182e52fe01 ("x86/mm: Enable KASLR for physical mapping memory
>> regions") causes some of my systems with persistent memory (whether real
>> or emulated) to fail to boot with a couple of different crash
>> signatures.  The first signature is a NMI watchdog lockup of all but 1
>> cpu, which causes much difficulty in extracting useful information from
>> the console.  The second variant is an invalid paging request, listed
>> below.
>>
>> On some systems, I haven't hit this problem at all.  Other systems
>> experience a failed boot maybe 20-30% of the time.  To reproduce it,
>> configure some emulated pmem on your system.  You can find directions
>> for that here: https://nvdimm.wiki.kernel.org/
>
> Did you try to repro on qemu?

I did not.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
