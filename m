Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C43221D491AB
 for <linux-nvdimm@lists.01.org>; Thu, 27 Jul 2017 07:07:06 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
References: <20170727131245.28279-1-jack@suse.cz>
Date: Thu, 27 Jul 2017 10:09:07 -0400
In-Reply-To: <20170727131245.28279-1-jack@suse.cz> (Jan Kara's message of
 "Thu, 27 Jul 2017 15:12:38 +0200")
Message-ID: <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
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
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Jan Kara <jack@suse.cz> writes:

Hi, Jan,

Thanks for looking into this!

> There are couple of open questions with this implementation:
>
> 1) Is it worth the hassle?
> 2) Is S_SYNC good flag to use or should we use a new inode flag?
> 3) VM_FAULT_RO and especially passing of resulting 'pfn' from
>    dax_iomap_fault() through filesystem fault handler to dax_pfn_mkwrite() in
>    vmf->orig_pte is a bit of a hack. So far I'm not sure how to refactor
>    things to make this cleaner.

4) How does an application discover that it is safe to flush from
   userspace?

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
