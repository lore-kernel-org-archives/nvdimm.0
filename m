Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 28 Dec 2015 12:11:21 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 1/8] mm: Add optional support for PUD-sized transparent
 hugepages
Message-ID: <20151228101121.GB4589@node.shutemov.name>
References: <1450974037-24775-1-git-send-email-matthew.r.wilcox@intel.com>
 <1450974037-24775-2-git-send-email-matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1450974037-24775-2-git-send-email-matthew.r.wilcox@intel.com>
Sender: owner-linux-mm@kvack.org
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 24, 2015 at 11:20:30AM -0500, Matthew Wilcox wrote:
> The only major difference is how the new ->pud_entry method in mm_walk
> works.  The ->pmd_entry method replaces the ->pte_entry method, whereas
> the ->pud_entry method works along with either ->pmd_entry or ->pte_entry.

I think it makes pagewalk API confusing. We need something more coherent.

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
