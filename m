Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F06B681C71
 for <linux-nvdimm@lists.01.org>; Thu,  3 Nov 2016 13:46:54 -0700 (PDT)
Date: Thu, 3 Nov 2016 21:46:22 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/21 v4] dax: Clear dirty bits after flushing caches
Message-ID: <20161103204622.GD24234@quack2.suse.cz>
References: <1478039794-20253-1-git-send-email-jack@suse.cz>
 <20161101231318.GC20418@quack2.suse.cz>
 <20161102100217.GC20724@node.shutemov.name>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161102100217.GC20724@node.shutemov.name>
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
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 02-11-16 13:02:17, Kirill A. Shutemov wrote:
> On Wed, Nov 02, 2016 at 12:13:18AM +0100, Jan Kara wrote:
> > Hi,
> > 
> > forgot to add Kirill to CC since this modifies the fault path he changed
> > recently. I don't want to resend the whole series just because of this so
> > at least I'm pinging him like this...
> 
> I see strange mix x/20 and x/21 patches. Which should I look at?

Ah, sorry, I've messed up the send out (I already had the old series
formatted in that directory). I'll send it again with you in CC.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
