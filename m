Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 345881A1FDA
 for <linux-nvdimm@lists.01.org>; Mon, 21 Mar 2016 16:44:50 -0700 (PDT)
Resent-Message-ID: <20160321234507.GS23727@linux.intel.com>
Resent-To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
 linux-nvdimm@lists.01.org, NeilBrown <neilb@suse.com>,
 "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
Date: Mon, 21 Mar 2016 13:25:48 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 01/10] DAX: move RADIX_DAX_ definitions to dax.c
Message-ID: <20160321172548.GN23727@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1458566575-28063-2-git-send-email-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, "Wilcox," Matthew R" <matthew.r.wilcox@intel.com>, NeilBrown <neilb@suse.com>," linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 21, 2016 at 02:22:46PM +0100, Jan Kara wrote:
> These don't belong in radix-tree.c any more than PAGECACHE_TAG_* do.
> Let's try to maintain the idea that radix-tree simply implements an
> abstract data type.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
