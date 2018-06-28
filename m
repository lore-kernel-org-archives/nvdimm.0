Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x241.google.com (mail-it0-x241.google.com
 [IPv6:2607:f8b0:4001:c0b::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 976D6211F8864
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 19:37:13 -0700 (PDT)
Received: by mail-it0-x241.google.com with SMTP id 76-v6so10477424itx.4
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 19:37:13 -0700 (PDT)
MIME-Version: 1.0
References: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
 <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com>
 <1e2ad827-6ff4-4b1e-c4d9-79ca4e432a6c@sandeen.net>
In-Reply-To: <1e2ad827-6ff4-4b1e-c4d9-79ca4e432a6c@sandeen.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Jun 2018 19:37:01 -0700
Message-ID: <CA+55aFxs7Cc30fCiENw0R+XDJhUJ-w=z=NLLzYfT5gF2Qh-60Q@mail.gmail.com>
Subject: Re: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, zhibli@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 27, 2018 at 7:17 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> What broke is that mmap(MAP_SHARED|MAP_PRIVATE) now succeeds without error,
> whereas before it rightly returned -EINVAL.

You're still confusing *behavior* with breakage.

Yes. New *behavior* is that MAP_SHARED|MAP_PRIVATE is now a valid
thing. It means "MAP_SHARED_VALIDATE".

Behavior changed.  That's normal. Every single time we add a system
call, behavior changes: a system call that used to return -ENOSYS now
returns something else.

That's not breakage, that's just intentional new behavior.

> What behavior should a user expect from a successful mmap(MAP_SHARED|MAP_PRIVATE)?

MAP_SHARED|MAP_PRIVATE makes no sense and nobody uses it (because it
has always returned an error and never done anything interesting).

Nobody uses it, and it used to return an error is *exactly* why it was
defined to be MAP_SHARED_VALIDATE.

So you should expect MAP_SHARED_VALIDATE behavior - which is
MAP_SHARED together with "validate that all the flags are things that
we support".

Actual BREAKAGE is if some application or user workflow no longer
works. Did LibreOffice stop working? That is breakage.

And by application, I mean exactly that: a real program.  Not some
manual-page, and not some test-program that people don't actually rely
on, and that just reports on some particular behavior.

Because I can write a test program that verifies that system call #335
doesn't exist:

    #define _GNU_SOURCE
    #include <unistd.h>
    #include <sys/syscall.h>
    #include <errno.h>
    #include <assert.h>

    int main(int argc, char **argv)
    {
        assert(syscall(335, 0) == -1 && errno == ENOSYS);
        return 0;
    }

and the next system call we add will break that test program on x86-64.

And that's still not a "regression" - it's just a change in behavior.

But if firefox no longer runs, because it depended on that system call
not existing (or it depended on that MAP_SHARED_VALIDATE returning
EINVAL) then it's a regression.

See the difference?

One case is "we added new behavior".

The other case is "we have a regression".

                Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
