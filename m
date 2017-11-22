Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9331321A04E2F
 for <linux-nvdimm@lists.01.org>; Wed, 22 Nov 2017 08:48:22 -0800 (PST)
Received: by mail-ot0-x243.google.com with SMTP id 18so14100179oty.9
 for <linux-nvdimm@lists.01.org>; Wed, 22 Nov 2017 08:52:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <638b3b80-5cb9-97c2-5055-fef3a1ec25b9@suse.cz>
References: <20171101153648.30166-1-jack@suse.cz>
 <20171101153648.30166-2-jack@suse.cz>
 <638b3b80-5cb9-97c2-5055-fef3a1ec25b9@suse.cz>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 22 Nov 2017 08:52:37 -0800
Message-ID: <CAPcyv4gGRHWc6AH5Enb7njtmqHgd=g+0-mYMdd5wWjJMW0+d7g@mail.gmail.com>
Subject: Re: [PATCH 01/18] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
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
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Florian Weimer <fweimer@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, Andy Lutomirski <luto@kernel.org>, John Hubbard <jhubbard@nvidia.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 22, 2017 at 4:02 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> On 11/01/2017 04:36 PM, Jan Kara wrote:
>> From: Dan Williams <dan.j.williams@intel.com>
>>
>> The mmap(2) syscall suffers from the ABI anti-pattern of not validating
>> unknown flags. However, proposals like MAP_SYNC need a mechanism to
>> define new behavior that is known to fail on older kernels without the
>> support. Define a new MAP_SHARED_VALIDATE flag pattern that is
>> guaranteed to fail on all legacy mmap implementations.
>
> So I'm trying to make sense of this together with Michal's attempt for
> MAP_FIXED_SAFE [1] where he has to introduce a completely new flag
> instead of flag modifier exactly for the reason of not validating
> unknown flags. And my conclusion is that because MAP_SHARED_VALIDATE
> implies MAP_SHARED and excludes MAP_PRIVATE, MAP_FIXED_SAFE as a
> modifier cannot build on top of this. Wouldn't thus it be really better
> long-term to introduce mmap3 at this point? ...

We have room to define MAP_PRIVATE_VALIDATE in MAP_TYPE on every arch
except parisc. Can we steal an extra bit for MAP_TYPE from somewhere
else on parisc?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
