Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 59BA21A1F7E
 for <linux-nvdimm@lists.01.org>; Thu, 12 May 2016 12:03:18 -0700 (PDT)
Date: Thu, 12 May 2016 13:03:04 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] dax: Fix condition for filling of PMD holes
Message-ID: <20160512190304.GB32376@linux.intel.com>
References: <1463070560-1979-1-git-send-email-jack@suse.cz>
 <1463070560-1979-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1463070560-1979-2-git-send-email-jack@suse.cz>
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
Cc: Ted Tso <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 12, 2016 at 06:29:14PM +0200, Jan Kara wrote:
> Currently dax_pmd_fault() decides to fill a PMD-sized hole only if
> returned buffer has BH_Uptodate set. However that doesn't get set for
> any mapping buffer so that branch is actually a dead code. The
> BH_Uptodate check doesn't make any sense so just remove it.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

With the note that when we reenable PMD faults we need to either test this
huge zero page path or just get rid of it and fall back to 4k zero pages.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
