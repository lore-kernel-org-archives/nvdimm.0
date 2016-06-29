Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80F031A1DF5
 for <linux-nvdimm@lists.01.org>; Wed, 29 Jun 2016 13:29:59 -0700 (PDT)
Date: Wed, 29 Jun 2016 22:29:20 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] mm: Export follow_pte()
Message-ID: <20160629202920.GD16831@quack2.suse.cz>
References: <1466523915-14644-1-git-send-email-jack@suse.cz>
 <1466523915-14644-3-git-send-email-jack@suse.cz>
 <20160624215512.GB20730@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160624215512.GB20730@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri 24-06-16 15:55:12, Ross Zwisler wrote:
> On Tue, Jun 21, 2016 at 05:45:14PM +0200, Jan Kara wrote:
> > DAX will need to implement its own version of check_page_address(). To
> 						page_check_address()

Thanks. Fixed.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
