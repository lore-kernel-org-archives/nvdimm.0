Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jvTB4Aiei1-fGybyJNopXQy9zADpnFcuRNdZCS4Mf1QQ@mail.gmail.com>
References: <150413449482.5923.1348069619036923853.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150413450616.5923.7069852068237042023.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170831100359.GD21443@lst.de> <CAPcyv4jvTB4Aiei1-fGybyJNopXQy9zADpnFcuRNdZCS4Mf1QQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Aug 2017 18:27:31 -0700
Message-ID: <CA+55aFwsfUj1f41w8hqt9LN3-ajmJ=2AB1Nb6ZzwHgE1OKxGOw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: introduce MAP_VALIDATE, a mechanism for for
 safely defining new mmap flags
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 31, 2017 at 6:01 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>
> Ugh, nommu defeats the MAP_SHARED_VALIDATE proposal from Linus.
>
>         if ((flags & MAP_TYPE) != MAP_PRIVATE &&
>             (flags & MAP_TYPE) != MAP_SHARED)
>                 return -EINVAL;
>
> ...parisc strikes again.

Why? That's no different from the case statement for the mmu case,
just written differently.

You *want* existing kernels to fail, since they don't test the bits
you want to test.

So you just want to rewrite these all as

    switch (flags & MAP_TYPE) {
    case MAP_SHARED_VALIDATE:
        .. validate the other bits...
        /* fallhtough */
    case MAP_SHARED:
        .. do the shared case ..
    case MAP_PRIVATE:
        .. do the private case ..
    default:
        return -EINVAL;
    }

and you're all good.

I'm not seeing the problem.

Of course, I also suspect that for nommu you might as well just always
return -EINVAL anyway. The only people who would ever use
MAP_SHARED_VALIDATE are the kinds of people who do things that just
aren't likely relevant on nommu, but whatever..

               Linus

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
