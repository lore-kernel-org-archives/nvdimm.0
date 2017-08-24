Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3CDBF21E79020
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 09:43:22 -0700 (PDT)
Date: Thu, 24 Aug 2017 18:45:54 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 11/13] dax, iomap: Add support for synchronous faults
Message-ID: <20170824164554.GA14410@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-12-jack@suse.cz>
 <20170824122720.GA9961@infradead.org>
 <20170824123451.GA6187@quack2.suse.cz>
 <20170824133809.GA29607@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170824133809.GA29607@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 24-08-17 06:38:09, Christoph Hellwig wrote:
> On Thu, Aug 24, 2017 at 02:34:51PM +0200, Jan Kara wrote:
> > In a subtle but important way ;). The main difference is that if the extent
> > has been already allocated by previous write, but the changing transaction
> > is not yet committed, we will return IOMAP_F_NEEDDSYNC but not IOMAP_F_NEW.
> 
> Ok.  How about a IOMAP_F_DIRTY flag and a better explanation?

OK, will change it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
