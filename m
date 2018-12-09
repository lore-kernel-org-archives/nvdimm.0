Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1EE74211963F6
 for <linux-nvdimm@lists.01.org>; Sun,  9 Dec 2018 10:27:05 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id e12so8373965otl.5
 for <linux-nvdimm@lists.01.org>; Sun, 09 Dec 2018 10:27:05 -0800 (PST)
MIME-Version: 1.0
References: <6be0835bf256755375f3b5822bf70d74538d1d6e.camel@intel.com>
 <CAHk-=wgAONwr6pMn+D2OsMZjAB5zNaMWSW5KdTM+L72gGnhV2Q@mail.gmail.com>
In-Reply-To: <CAHk-=wgAONwr6pMn+D2OsMZjAB5zNaMWSW5KdTM+L72gGnhV2Q@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 9 Dec 2018 10:26:54 -0800
Message-ID: <CAPcyv4jznHRB=BCsm8Y3d-uqDy_OWHSgTsPZoPK-L80FiQftFg@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

[ add Willy and Jan ]

On Sun, Dec 9, 2018 at 10:02 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Dec 8, 2018 at 10:26 PM Williams, Dan J
> <dan.j.williams@intel.com> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/dax-fixes-4.20-rc6
>
> What's going on with the odd non-exclusive exclusive wait?
>
>         prepare_to_wait_exclusive(wq, &ewait.wait, TASK_UNINTERRUPTIBLE);
>         ...
>         /*
>          * Entry lock waits are exclusive. Wake up the next waiter since
>          * we aren't sure we will acquire the entry lock and thus wake
>          * the next waiter up on unlock.
>          */
>         if (waitqueue_active(wq))
>                 __wake_up(wq, TASK_NORMAL, 1, &ewait.key);
>
> that seems to make little or no sense.
>
> Why isn't that prepare_to_wait_exclusive() just a regular
> prepare_to_wait(), and then the whole "let's wake up anybody else" can
> be removed?
>
> I've pulled it, but am awaiting explanation of what looks like some
> pretty crazy code. I *suspect* it's a copy-and-paste situation where
> you took the exclusive wait from somewhere else.

Yes, I believe that's true. In the other instances of waiting for an
entry to be in unlocked there is a guarantee that the waiter will
attain the lock and perform an unlock + wakeup. In the dax_lock_page()
path there is the possibility that the inode dies before the lock is
attained and a subsequent unlock sequence is not guaranteed. So, I
believe the intent, Willy correct me if I am wrong, was to keep all
waits "exclusive" for some sense of symmetry, but this one can and
should be a non-exclusive wait.

I can send a cleanup, do you want one immediately, or is post -rc6 ok?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
