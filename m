Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A858921D491A3
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 06:43:52 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id a84so2441554oii.1
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 06:46:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170824132801.GM11771@tardis>
References: <20170823152542.5150-1-boqun.feng@gmail.com>
 <20170823152542.5150-2-boqun.feng@gmail.com>
 <alpine.DEB.2.20.1708241507160.1860@nanos> <20170824132801.GM11771@tardis>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 24 Aug 2017 15:46:26 +0200
Message-ID: <CAK8P3a1bVCxJCi_84abo4Bk7LFr7ynO1=7bW5dm=jbLvH9sR2Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] nfit: Use init_completion() in acpi_nfit_flush_probe()
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
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-team@lge.com, Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-nvdimm@lists.01.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, willy@infradead.org, Byungchul Park <byungchul.park@lge.com>, Linux-MM <linux-mm@kvack.org>, Nicholas Piggin <npiggin@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michel Lespinasse <walken@google.com>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 3:28 PM, Boqun Feng <boqun.feng@gmail.com> wrote:
> On Thu, Aug 24, 2017 at 03:07:42PM +0200, Thomas Gleixner wrote:
>> On Wed, 23 Aug 2017, Boqun Feng wrote:
>>
>> > There is no need to use COMPLETION_INITIALIZER_ONSTACK() in
>> > acpi_nfit_flush_probe(), replace it with init_completion().
>>
>> You completely fail to explain WHY.
>>
>
> I thought COMPLETION_INITIALIZER_ONSTACK() should only use in assigment
> or compound literals, so the usage here is obviously wrong, but seems
> I was wrong?
>
> Ingo,
>
> Is the usage of COMPLETION_INITIALIZER_ONSTACK() correct? If not,
> I could rephrase my commit log saying this is a fix for wrong usage of
> COMPLETION_INITIALIZER_ONSTACK(), otherwise, I will rewrite the commit
> indicating this patch is a necessary dependency for patch #2. Thanks!

I think your patch is correct, but your changelog text is useless, as
Thomas mentioned: you should instead explain that it breaks with the
other fix in the series, and what the difference between init_completion()
and COMPLETION_INITIALIZER_ONSTACK() is.

      Arnd
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
