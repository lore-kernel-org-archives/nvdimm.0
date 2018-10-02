Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD7AC21161AE5
 for <linux-nvdimm@lists.01.org>; Tue,  2 Oct 2018 08:07:10 -0700 (PDT)
Date: Tue, 2 Oct 2018 17:07:08 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181002150708.GF9127@quack2.suse.cz>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142959.GD9127@quack2.suse.cz>
 <20181002143713.GA19845@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181002143713.GA19845@infradead.org>
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
Cc: linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue 02-10-18 07:37:13, Christoph Hellwig wrote:
> On Tue, Oct 02, 2018 at 04:29:59PM +0200, Jan Kara wrote:
> > > OK naive question from me, how do we want an application to be able to
> > > check if it is running on a DAX mapping?
> > 
> > The question from me is: Should application really care?
> 
> No, it should not.  DAX is an implementation detail thay may change
> or go away at any time.

I agree that whether / how pagecache is used for filesystem access is an
implementation detail of the kernel.  OTOH for some workloads it is about
whether kernel needs gigabytes of RAM to cache files or not, which is not a
detail anymore if you want to fully utilize the machine. So people will be
asking for this and will be finding odd ways to determine whether DAX is
used or not (such as poking in smaps). And once there is some widely enough
used application doing this, it is not "stupid application" problem anymore
but the kernel's problem of not maintaining backward compatibility.

So I think we would be better off providing *some* API which applications
can use to determine whether pagecache is used or not and make sure this
API will convey the right information even if we change DAX
implementation or remove it altogether.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
