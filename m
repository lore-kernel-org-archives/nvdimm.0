Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <541188ED.9090709@plexistor.com>
Date: Thu, 11 Sep 2014 14:35:09 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [Linux-nvdimm] [PATCH 1/9] SQUASHME: pmem: Remove unused #include
 headers
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com> <540F1EC6.4000504@plexistor.com> <540F1F6F.7090905@plexistor.com> <1410301783.8366.1.camel@rzwisler-mobl1.amr.corp.intel.com> <20140910191642.GI27730@localhost.localdomain>
In-Reply-To: <20140910191642.GI27730@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@fb.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 09/10/2014 10:16 PM, Matthew Wilcox wrote:
<>
> 
> Woah, woah, woah, what is this craziness?  You shouldn't ever rely on
> implicitly included files.
> 

It is fine I do not mind the language ;-)

I'm not going to fight you over this *I could really care less*, but for
the record you are wrong.

If header B has an API like
typeA1 b_foo(typeA2 a2, typeA3 a3);
where typeA1, typeA2, typeA3 are from an included header A
and code in C.c needs the use of b_foo(), or even say b_foo is a vector
that C.c needs to implement. Then typeA1, typeA2, typeA3 are explicit
by B not implicit.

Implicit is if B has private structures with say typeXy from header X
but my code does not need to declare or implement any X types. in order
to use public API of B.

[Ax]
The mathematical proof as I said is. If B can be changed in such a way
that C.c code will not compile, but the only changes to C.c will be an
#include <X> directive "then X is implicitly included from B".
But if for C.c to compile after the changes to B more than #include
fixes, but actual code need changing, "then X is explicitly included from B"

That said. my opinion from 35 years of coding (Yes 1989) is that since there
is no tool that can measure [Ax] then the only sane/logical programming model
is actually the "minimal set". Which has performance merits as well.
And when a developer changes such an important aspects of B, its includes
chain, he needs to pay and fix miss-compiling users. All efforts measured,
this is a least-maintenance effort. My $0.017

sigh
Boaz

