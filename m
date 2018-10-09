Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 480A121144CE3
 for <linux-nvdimm@lists.01.org>; Tue,  9 Oct 2018 12:43:43 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
References: <20181002100531.GC4135@quack2.suse.cz>
Date: Tue, 09 Oct 2018 15:43:41 -0400
In-Reply-To: <20181002100531.GC4135@quack2.suse.cz> (Jan Kara's message of
 "Tue, 2 Oct 2018 12:05:31 +0200")
Message-ID: <x49woqqykgi.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Jan Kara <jack@suse.cz> writes:

> Hello,
>
> commit e1fb4a086495 "dax: remove VM_MIXEDMAP for fsdax and device dax" has
> removed VM_MIXEDMAP flag from DAX VMAs. Now our testing shows that in the
> mean time certain customer of ours started poking into /proc/<pid>/smaps
> and looks at VMA flags there and if VM_MIXEDMAP is missing among the VMA
> flags, the application just fails to start complaining that DAX support is
> missing in the kernel. The question now is how do we go about this?
>
> Strictly speaking, this is a userspace visible regression (as much as I
> think that application poking into VMA flags at this level is just too
> bold). Is there any precedens in handling similar issues with smaps which
> really exposes a lot of information that is dependent on kernel
> implementation details?
>
> I have attached a patch that is an obvious "fix" for the issue - just fake
> VM_MIXEDMAP flag in smaps. But I'm open to other suggestions...

Hi, Jan,

I'm intrigued by the use case.  Do I understand you correctly that the
database in question does not intend to make data persistent from
userspace?  In other words, fsync/msync system calls are being issued by
the database?

I guess what I'm really after is a statement of requirements or
expectations.  It would be great if you could convince the database
developer to engage in this discussion directly.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
