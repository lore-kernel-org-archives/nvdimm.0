Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
In-Reply-To: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Jun 2018 19:10:51 -0700
Message-ID: <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com>
Subject: Re: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-ext4@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, zhibli@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 27, 2018 at 6:45 PM Eric Sandeen <sandeen@redhat.com> wrote:
>
> Thus the invalid flag combination of (MAP_SHARED|MAP_PRIVATE) now
> passes without error, which is a regression.

It's not a regression, it's just new behavior.

"regression" doesn't mean "things changed". It means "something broke".

What broke?

Because if it's some manual page breakage, just fix the manual. That's
what "new behavior" is all about.

There is nothing that says that "MAP_SHARED_VALIDATE" can't work with
just the legacy flags.

Because I'd be worried about your patch breaking some actual new user
of MAP_SHARED_VALIDATE.

Because it's actual *users* of behavior we care about, not some
test-suite or manual pages.

              Linus
