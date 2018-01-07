Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7628021A143F0
 for <linux-nvdimm@lists.01.org>; Sun,  7 Jan 2018 13:46:20 -0800 (PST)
Date: Sun, 7 Jan 2018 16:51:24 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] dax: Pass detailed error code from dax_iomap_fault()
Message-ID: <20180107215124.GE17380@thunk.org>
References: <20180103100844.12787-1-jack@suse.cz>
 <20180103100844.12787-2-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180103100844.12787-2-jack@suse.cz>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 03, 2018 at 11:08:43AM +0100, Jan Kara wrote:
> Ext4 needs to pass through error from its iomap handler to the page
> fault handler so that it can properly detect ENOSPC and force
> transaction commit and retry the fault (and block allocation). Add
> argument to dax_iomap_fault() for passing such error.
> 
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

						- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
