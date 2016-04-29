Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id EDFEF1A1F7C
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 13:04:03 -0700 (PDT)
Date: Fri, 29 Apr 2016 14:03:45 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 14/18] dax: Define DAX lock bit for radix tree
 exceptional entry
Message-ID: <20160429200345.GH5888@linux.intel.com>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
 <1461015341-20153-15-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461015341-20153-15-git-send-email-jack@suse.cz>
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

On Mon, Apr 18, 2016 at 11:35:37PM +0200, Jan Kara wrote:
> We will use lowest available bit in the radix tree exceptional entry for
> locking of the entry. Define it. Also clean up definitions of DAX entry
> type bits in DAX exceptional entries to use defined constants instead of
> hardcoding numbers and cleanup checking of these bits to not rely on how
> other bits in the entry are set.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
