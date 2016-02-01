Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 1 Feb 2016 15:10:19 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 4/6] dax: Use PAGE_CACHE_SIZE where appropriate
Message-ID: <20160201131019.GC29337@node.shutemov.name>
References: <1454242795-18038-1-git-send-email-matthew.r.wilcox@intel.com>
 <1454242795-18038-5-git-send-email-matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1454242795-18038-5-git-send-email-matthew.r.wilcox@intel.com>
Sender: owner-linux-mm@kvack.org
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, willy@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jan 31, 2016 at 11:19:53PM +1100, Matthew Wilcox wrote:
> We were a little sloppy about using PAGE_SIZE instead of PAGE_CACHE_SIZE.

PAGE_CACHE_SIZE is non-sense. It never had any meaning. At least in
upstream. And only leads to confusion on border between vfs and mm.

We should just drop it.

I need to find time at some point to prepare patchset...

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
