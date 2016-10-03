Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 31BC01A1E83
 for <linux-nvdimm@lists.01.org>; Mon,  3 Oct 2016 07:52:12 -0700 (PDT)
Date: Mon, 3 Oct 2016 16:52:09 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/6] mm: Invalidate DAX radix tree entries only if
 appropriate
Message-ID: <20161003145209.GC14183@quack2.suse.cz>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <1474994615-29553-6-git-send-email-jack@suse.cz>
 <20160928001839.GE9806@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160928001839.GE9806@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 28-09-16 10:18:40, Dave Chinner wrote:
> On Tue, Sep 27, 2016 at 06:43:34PM +0200, Jan Kara wrote:
> > +/*
> > + * Invalidate exceptional DAX entry if it is clean.
> > + */
> > +int dax_invalidate_mapping_entry2(struct address_space *mapping, pgoff_t index)
> > +{
> > +	return __dax_invalidate_mapping_entry(mapping, index, false);
> >  }
> 
> dax_try_invalidate_mapping_entry()

Or maybe dax_invalidate_clean_mapping_entry()? I was originally trying to keep
consistency with how functions in mm/truncate.c are traditionally called but
even there it's not quite consistent so better have a more descriptive name.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
