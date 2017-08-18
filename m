Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F0942095B9E9
 for <linux-nvdimm@lists.01.org>; Fri, 18 Aug 2017 15:05:32 -0700 (PDT)
Date: Fri, 18 Aug 2017 16:08:00 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 04/13] dax: Create local variable for VMA in
 dax_iomap_pte_fault()
Message-ID: <20170818220800.GC32627@linux.intel.com>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-5-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-5-jack@suse.cz>
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
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 17, 2017 at 06:08:06PM +0200, Jan Kara wrote:
> There are already two users and more are coming.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Sure.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
