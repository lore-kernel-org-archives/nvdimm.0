Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2834921B02822
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 09:10:05 -0800 (PST)
Date: Wed, 28 Nov 2018 09:10:04 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/2] dax: Don't access a freed inode
Message-ID: <20181128171004.GI10377@bombadil.infradead.org>
References: <20181127211634.4995-1-willy@infradead.org>
 <20181127211634.4995-3-willy@infradead.org>
 <20181128115330.GB15604@quack2.suse.cz>
 <CAPcyv4iqYNq1FMwU9W-oq+2mWGHotK=Ff9YvEyJOxRz3E+eDzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iqYNq1FMwU9W-oq+2mWGHotK=Ff9YvEyJOxRz3E+eDzQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 28, 2018 at 09:08:40AM -0800, Dan Williams wrote:
> > Can we add a comment here like:
> >
> >         /*
> >          * Entry lock waits are exclusive. Wake up the next waiter since we
> >          * aren't sure we will acquire the entry lock and thus wake the
> >          * next waiter up on unlock.
> >          */
> >
> > Because I always wonder for a moment why this is needed.
> 
> Looks good, I'll add that when applying.

Thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
