Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0019E81CC1
 for <linux-nvdimm@lists.01.org>; Thu,  3 Nov 2016 21:32:16 -0700 (PDT)
Date: Fri, 4 Nov 2016 05:32:14 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/21] mm: Join struct fault_env and vm_fault
Message-ID: <20161104043214.GA3569@quack2.suse.cz>
References: <1478039794-20253-1-git-send-email-jack@suse.cz>
 <1478039794-20253-3-git-send-email-jack@suse.cz>
 <20161102095848.GB20724@node.shutemov.name>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161102095848.GB20724@node.shutemov.name>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 02-11-16 12:58:48, Kirill A. Shutemov wrote:
> On Tue, Nov 01, 2016 at 11:36:08PM +0100, Jan Kara wrote:
> > Currently we have two different structures for passing fault information
> > around - struct vm_fault and struct fault_env. DAX will need more
> > information in struct vm_fault to handle its faults so the content of
> > that structure would become event closer to fault_env. Furthermore it
> > would need to generate struct fault_env to be able to call some of the
> > generic functions. So at this point I don't think there's much use in
> > keeping these two structures separate. Just embed into struct vm_fault
> > all that is needed to use it for both purposes.
> 
> What about just reference fault_env from vm_fault? We don't always need
> vm_fault where we nee fault_env. It may save space on stack for some
> codepaths.

I was considering that as well but there is some duplication between those
two which I'd prefer to avoid and you would need both structures for the
fault handler which you eventually end up calling anyway (and that is very
likely the most stack-demanding path) so maximum stack consumption would
likely be even slightly higher.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
