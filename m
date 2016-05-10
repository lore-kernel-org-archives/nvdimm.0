Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 680081A1E6E
 for <linux-nvdimm@lists.01.org>; Tue, 10 May 2016 13:30:04 -0700 (PDT)
Date: Tue, 10 May 2016 14:30:03 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [RFC v3] [PATCH 0/18] DAX page fault locking
Message-ID: <20160510203003.GA5314@linux.intel.com>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <20160506203308.GA12506@linux.intel.com>
 <20160509093828.GF11897@quack2.suse.cz>
 <20160510152814.GQ11897@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160510152814.GQ11897@quack2.suse.cz>
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
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 10, 2016 at 05:28:14PM +0200, Jan Kara wrote:
> On Mon 09-05-16 11:38:28, Jan Kara wrote:
> Somehow, I'm not able to reproduce the warnings... Anyway, I think I see
> what's going on. Can you check whether the warning goes away when you
> change the condition at the end of page_cache_tree_delete() to:
> 
>         if (!dax_mapping(mapping) && !workingset_node_pages(node) &&
>             list_empty(&node->private_list)) {

Yep, this took care of both of the issues that I reported.  I'll restart my
testing with this in my baseline, but as of this fix I don't have any more
open testing issues. :)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
