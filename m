Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x231.google.com (mail-it0-x231.google.com
 [IPv6:2607:f8b0:4001:c0b::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D799F2007E7E6
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 14:05:59 -0700 (PDT)
Received: by mail-it0-x231.google.com with SMTP id 144-v6so15059422iti.5
 for <linux-nvdimm@lists.01.org>; Tue, 01 May 2018 14:05:59 -0700 (PDT)
MIME-Version: 1.0
References: <152520750404.36522.15462513519590065300.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152520750404.36522.15462513519590065300.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 01 May 2018 21:05:48 +0000
Message-ID: <CA+55aFwoOee_8H-1KRnY1G-Ud4Rez16s8xjVbG8YOPn1jqxxtg@mail.gmail.com>
Subject: Re: [PATCH 0/6] use memcpy_mcsafe() for copy_to_iter()
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
Cc: Tony Luck <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 1, 2018 at 1:55 PM Dan Williams <dan.j.williams@intel.com>
wrote:

> The result of the bypass is that the kernel treats machine checks during
> read as system fatal (reboot) when they could simply be flagged as an
> I/O error, similar to performing reads through the pmem driver. Prevent
> this fatal condition by deploying memcpy_mcsafe() in the fsdax read
> path.

How about just changing the rules, and go the old "Don't do that then" way?

IOW, get rid of the whole idea that MCS errors should be fatal. It's wrong
and pointless anyway.

The while approach seems fundamentally buggered, if you ever want to mmap
one of these things. And don't you want that?

So why continue down a fundamentally broken path?

                  Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
