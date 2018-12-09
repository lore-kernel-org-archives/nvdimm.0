Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com
 [IPv6:2a00:1450:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 494E72119A47D
 for <linux-nvdimm@lists.01.org>; Sun,  9 Dec 2018 10:02:12 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id g11-v6so7605133ljk.3
 for <linux-nvdimm@lists.01.org>; Sun, 09 Dec 2018 10:02:12 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com.
 [209.85.167.50])
 by smtp.gmail.com with ESMTPSA id z15-v6sm1883619ljb.9.2018.12.09.10.02.08
 for <linux-nvdimm@lists.01.org>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sun, 09 Dec 2018 10:02:08 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id l10so6356101lfh.9
 for <linux-nvdimm@lists.01.org>; Sun, 09 Dec 2018 10:02:08 -0800 (PST)
MIME-Version: 1.0
References: <6be0835bf256755375f3b5822bf70d74538d1d6e.camel@intel.com>
In-Reply-To: <6be0835bf256755375f3b5822bf70d74538d1d6e.camel@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Dec 2018 10:01:51 -0800
Message-ID: <CAHk-=wgAONwr6pMn+D2OsMZjAB5zNaMWSW5KdTM+L72gGnhV2Q@mail.gmail.com>
Subject: Re: [GIT PULL] dax fixes for 4.20-rc6
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
To: dan.j.williams@intel.com
Cc: Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 8, 2018 at 10:26 PM Williams, Dan J
<dan.j.williams@intel.com> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-fixes-4.20-rc6

What's going on with the odd non-exclusive exclusive wait?

        prepare_to_wait_exclusive(wq, &ewait.wait, TASK_UNINTERRUPTIBLE);
        ...
        /*
         * Entry lock waits are exclusive. Wake up the next waiter since
         * we aren't sure we will acquire the entry lock and thus wake
         * the next waiter up on unlock.
         */
        if (waitqueue_active(wq))
                __wake_up(wq, TASK_NORMAL, 1, &ewait.key);

that seems to make little or no sense.

Why isn't that prepare_to_wait_exclusive() just a regular
prepare_to_wait(), and then the whole "let's wake up anybody else" can
be removed?

I've pulled it, but am awaiting explanation of what looks like some
pretty crazy code. I *suspect* it's a copy-and-paste situation where
you took the exclusive wait from somewhere else.

                Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
