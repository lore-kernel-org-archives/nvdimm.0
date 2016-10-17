Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5736A1A1E10
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 02:04:54 -0700 (PDT)
Date: Mon, 17 Oct 2016 11:04:51 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/20] mm: Trim __do_fault() arguments
Message-ID: <20161017090451.GF3359@quack2.suse.cz>
References: <1474992504-20133-1-git-send-email-jack@suse.cz>
 <1474992504-20133-6-git-send-email-jack@suse.cz>
 <20161014203147.GD27575@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161014203147.GD27575@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri 14-10-16 14:31:47, Ross Zwisler wrote:
> On Tue, Sep 27, 2016 at 06:08:09PM +0200, Jan Kara wrote:
> > Use vm_fault structure to pass cow_page, page, and entry in and out of
> > the function. That reduces number of __do_fault() arguments from 4 to 1.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> In looking at this I realized that vmf->entry is actually unused, as is the
> entry we used to return back via __do_fault().  I guess they must have been in
> there because at one point they were needed for dax_unlock_mapping_entry()?
> Anyway, looking ahead I see patch 10 removes vmf->entry altogether. :)

Yes :).

> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
