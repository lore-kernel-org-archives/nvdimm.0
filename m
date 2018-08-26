Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x243.google.com (mail-it0-x243.google.com
 [IPv6:2607:f8b0:4001:c0b::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0542E2194D387
 for <linux-nvdimm@lists.01.org>; Sat, 25 Aug 2018 18:32:17 -0700 (PDT)
Received: by mail-it0-x243.google.com with SMTP id d10-v6so6808875itj.5
 for <linux-nvdimm@lists.01.org>; Sat, 25 Aug 2018 18:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <e8622920d68c008edf72bcd93a8716fc59c2f55d.camel@intel.com>
In-Reply-To: <e8622920d68c008edf72bcd93a8716fc59c2f55d.camel@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Aug 2018 18:32:05 -0700
Message-ID: <CA+55aFyQAZxhJsbh8G3U=EPdKyfmeLRGwkqaRUbfOV0e5T=vXw@mail.gmail.com>
Subject: Re: [GIT PULL]: libnvdimm updates for 4.19-rc1 v2 [2/2]
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 22, 2018 at 1:22 PM Jiang, Dave <dave.jiang@intel.com> wrote:
>
> Please pull to receive the libnvdimm dax-memory-failure series for v4.19-rc1. I have removed the
> offending ilog2() call and fixed up the patch accordingly.

Ok, not only does the code look fine now, I actually find this split
to have been much easier to look through, with the drivers split from
the memory-failure code. Please do this in the future too when you
have this kind of "driver changes and very core infrastructure
changes".

It may _look_ like more work to me when I do two pulls, but if they
are separated out sanely, it makes review so much easier that it's
actually less work overall. Thanks.

So pulled.

Well, this second one is not actually pulled quite yet - I'm still
doing the build tests for 1/2, but 2/2 has already passed my
sniff-test, so it's just waiting for the build tests to finish.

                Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
