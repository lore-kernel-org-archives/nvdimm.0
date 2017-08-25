Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A66632095DCB2
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 17:33:48 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id j144so9463797oib.1
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 17:36:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170824142239.15178-1-boqun.feng@gmail.com>
References: <20170823152542.5150-2-boqun.feng@gmail.com>
 <20170824142239.15178-1-boqun.feng@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 24 Aug 2017 17:36:22 -0700
Message-ID: <CAPcyv4gHgdpyqbv8gs5MiEtEHSdC-JLhutdfn81fhQ1woQSh_Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] nfit: Fix the abuse of
 COMPLETION_INITIALIZER_ONSTACK()
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
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, kernel-team@lge.com, Peter Zijlstra <peterz@infradead.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Byungchul Park <byungchul.park@lge.com>, Linux MM <linux-mm@kvack.org>, Nicholas Piggin <npiggin@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michel Lespinasse <walken@google.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 7:22 AM, Boqun Feng <boqun.feng@gmail.com> wrote:
> COMPLETION_INITIALIZER_ONSTACK() is supposed to used as an initializer,
> in other words, it should only be used in assignment expressions or
> compound literals. So the usage in drivers/acpi/nfit/core.c:
>
>         COMPLETION_INITIALIZER_ONSTACK(flush.cmp);
>
> , is inappropriate.
>
> Besides, this usage could also break compilations for another fix to
> reduce stack sizes caused by COMPLETION_INITIALIZER_ONSTACK(), because
> that fix changes COMPLETION_INITIALIZER_ONSTACK() from rvalue to lvalue,
> and usage as above will report error:
>
>         drivers/acpi/nfit/core.c: In function 'acpi_nfit_flush_probe':
>         include/linux/completion.h:77:3: error: value computed is not used [-Werror=unused-value]
>           (*({ init_completion(&work); &work; }))
>
> This patch fixes this by replacing COMPLETION_INITIALIZER_ONSTACK() with
> init_completion() in acpi_nfit_flush_probe(), which does the same
> initialization without any other problem.
>
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
