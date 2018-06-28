Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA8F8202E53F1
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 21:18:33 -0700 (PDT)
Subject: Re: [PATCH] mm: reject MAP_SHARED_VALIDATE without new flags
References: <60052659-7b37-cb69-bf9f-1683caa46219@redhat.com>
 <CA+55aFzeA7N3evSF2jKHu8JoTQuKDLCMKx7RiPhmym97-8HY7A@mail.gmail.com>
 <1e2ad827-6ff4-4b1e-c4d9-79ca4e432a6c@sandeen.net>
 <CA+55aFxs7Cc30fCiENw0R+XDJhUJ-w=z=NLLzYfT5gF2Qh-60Q@mail.gmail.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <52d82353-2746-269a-c1e3-e4aec4fbf0f9@redhat.com>
Date: Wed, 27 Jun 2018 23:18:30 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxs7Cc30fCiENw0R+XDJhUJ-w=z=NLLzYfT5gF2Qh-60Q@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>, Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, zhibli@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 6/27/18 9:37 PM, Linus Torvalds wrote:
> On Wed, Jun 27, 2018 at 7:17 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> What broke is that mmap(MAP_SHARED|MAP_PRIVATE) now succeeds without error,
>> whereas before it rightly returned -EINVAL.
> 
> You're still confusing *behavior* with breakage.
> 
> Yes. New *behavior* is that MAP_SHARED|MAP_PRIVATE is now a valid
> thing. It means "MAP_SHARED_VALIDATE".
> 
> Behavior changed.  That's normal. Every single time we add a system
> call, behavior changes: a system call that used to return -ENOSYS now
> returns something else.
> 
> That's not breakage, that's just intentional new behavior.

*shrug* semantics aside, the new behavior is out there in a public
API, so I guess there's nothing to do at this point other than
to document the change more clearly.  It's true that my patch could
possibly break existing users.

The man page is clearly wrong at this point, both in terms of the
error code section, and the claim that MAP_SHARED and MAP_PRIVATE
behave as described in POSIX (because POSIX states that these
two flags may not be specified together.)

-Eric
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
