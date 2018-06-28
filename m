Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sandeen.net (sandeen.net [63.231.237.45])
 by ml01.01.org (Postfix) with ESMTP id 8E0C9202E53F3
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 19:17:57 -0700 (PDT)
Subject: Re: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
References: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
 <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1e2ad827-6ff4-4b1e-c4d9-79ca4e432a6c@sandeen.net>
Date: Wed, 27 Jun 2018 21:17:55 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com>
Content-Language: en-US
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
To: Linus Torvalds <torvalds@linux-foundation.org>, Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, zhibli@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 6/27/18 9:10 PM, Linus Torvalds wrote:
> On Wed, Jun 27, 2018 at 6:45 PM Eric Sandeen <sandeen@redhat.com> wrote:
>>
>> Thus the invalid flag combination of (MAP_SHARED|MAP_PRIVATE) now
>> passes without error, which is a regression.
> 
> It's not a regression, it's just new behavior.
> 
> "regression" doesn't mean "things changed". It means "something broke".
> 
> What broke?

My commit log perhaps was not clear enough.

What broke is that mmap(MAP_SHARED|MAP_PRIVATE) now succeeds without error,
whereas before it rightly returned -EINVAL.

What behavior should a user expect from a successful mmap(MAP_SHARED|MAP_PRIVATE)?

-Eric

> Because if it's some manual page breakage, just fix the manual. That's
> what "new behavior" is all about.
> 
> There is nothing that says that "MAP_SHARED_VALIDATE" can't work with
> just the legacy flags.
> 
> Because I'd be worried about your patch breaking some actual new user
> of MAP_SHARED_VALIDATE.
> 
> Because it's actual *users* of behavior we care about, not some
> test-suite or manual pages.
> 
>               Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
