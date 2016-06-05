Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5C1D1A1E53
 for <linux-nvdimm@lists.01.org>; Sun,  5 Jun 2016 10:42:04 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id p204so439229oih.3
 for <linux-nvdimm@lists.01.org>; Sun, 05 Jun 2016 10:41:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 5 Jun 2016 10:41:26 -0700
Message-ID: <CALCETrVfxGYjL7mD95ku5E+nPeSKXdGPj+kJjjp=BHr5_1T3dg@mail.gmail.com>
Subject: Re: [PATCH 00/13] deprecate pcommit
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
Cc: X86 ML <x86@kernel.org>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Christoph Hellwig <hch@lst.de>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>

On Jun 4, 2016 1:53 PM, "Dan Williams" <dan.j.williams@intel.com> wrote:
>
> Platforms supporting NVDIMMs are now required to provide persistence
> guarantees once pmem stores are accepted by the memory subsystem.

Can you point us to a precise definition of what exactly constitutes
stores being "accepted by the memory subsystem"?  Back when pcommit
was a thing (hah!), it was precisely documented in the SDM.

> is usually achieved by a platform-level feature known as ADR
> (Asynchronous DRAM Refresh) that flushes any memory subsystem write
> pending queues on power loss/shutdown.

Blech.  Does this mean that we need some NMI handler or similar that
does wbinvd?  Will CPU caches automatically write themselves back on
power loss?  Will we lose data if something goes wrong with an SMI
handler?

>
> The 'pcommit' instruction (which has not shipped on any product) is no
> longer needed and is deprecated.

Does this mean it will never ship?

--Andy
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
