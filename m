Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id F23BD1A1FB8
 for <linux-nvdimm@lists.01.org>; Tue, 22 Mar 2016 02:26:49 -0700 (PDT)
Date: Tue, 22 Mar 2016 05:27:08 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 02/10] radix-tree: make 'indirect' bit available to
 exception entries.
Message-ID: <20160322092708.GV23727@linux.intel.com>
References: <1458566575-28063-1-git-send-email-jack@suse.cz>
 <1458566575-28063-3-git-send-email-jack@suse.cz>
 <20160321173458.GO23727@linux.intel.com>
 <20160322091232.GD4459@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160322091232.GD4459@quack.suse.cz>
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

On Tue, Mar 22, 2016 at 10:12:32AM +0100, Jan Kara wrote:
> 		if (unlikely(!page))	// False since
> 					// RADIX_TREE_INDIRECT_PTR is set
> 		if (radix_tree_exception(page))	// False - no exeptional bit

Oops, you got confused:

static inline int radix_tree_exception(void *arg)
{
        return unlikely((unsigned long)arg &
                (RADIX_TREE_INDIRECT_PTR | RADIX_TREE_EXCEPTIONAL_ENTRY));
}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
