Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x243.google.com (mail-wm0-x243.google.com
 [IPv6:2a00:1450:400c:c09::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CDF3881E8D
 for <linux-nvdimm@lists.01.org>; Wed, 16 Nov 2016 06:27:53 -0800 (PST)
Received: by mail-wm0-x243.google.com with SMTP id g23so11728901wme.1
 for <linux-nvdimm@lists.01.org>; Wed, 16 Nov 2016 06:27:58 -0800 (PST)
Date: Wed, 16 Nov 2016 17:27:55 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 11/21] mm: Remove unnecessary vma->vm_ops check
Message-ID: <20161116142755.GA28051@node.shutemov.name>
References: <1478233517-3571-1-git-send-email-jack@suse.cz>
 <1478233517-3571-12-git-send-email-jack@suse.cz>
 <20161115222819.GK23021@node>
 <20161116132918.GK21785@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161116132918.GK21785@quack2.suse.cz>
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
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 16, 2016 at 02:29:18PM +0100, Jan Kara wrote:
> On Wed 16-11-16 01:28:19, Kirill A. Shutemov wrote:
> > On Fri, Nov 04, 2016 at 05:25:07AM +0100, Jan Kara wrote:
> > > We don't check whether vma->vm_ops is NULL in do_shared_fault() so
> > > there's hardly any point in checking it in wp_page_shared() or
> > > wp_pfn_shared() which get called only for shared file mappings as well.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > Well, I'm not sure about this.
> > 
> > do_shared_fault() doesn't have the check since we checked it upper by
> > stack: see vma_is_anonymous() in handle_pte_fault().
> > 
> > In principal, it should be fine. But random crappy driver has potential to
> > blow it up.
> 
> Ok, so do you prefer me to keep this patch or discard it? Either is fine with
> me. It was just a cleanup I wrote when factoring out the functionality.

I would rather drop it.

Eventually, we need to make sure that all file-backed vma has vm_ops.
I tried to do this once, but that back-fired...

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
