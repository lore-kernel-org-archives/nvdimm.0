Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7402B2244E41C
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 17:14:33 -0700 (PDT)
Date: Mon, 16 Apr 2018 20:14:22 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] dax: Change return type to vm_fault_t
Message-ID: <20180417001421.GH22870@thunk.org>
References: <20180414155059.GA18015@jordon-HP-15-Notebook-PC>
 <CAPcyv4g+Gdc2tJ1qrM5Xn9vtARw-ZqFXaMbiaBKJJsYDtSNBig@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g+Gdc2tJ1qrM5Xn9vtARw-ZqFXaMbiaBKJJsYDtSNBig@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Matthew Wilcox <willy@infradead.org>, Linux MM <linux-mm@kvack.org>, Souptick Joarder <jrdr.linux@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 16, 2018 at 09:14:48AM -0700, Dan Williams wrote:
> Ugh, so this change to vmf_insert_mixed() went upstream without fixing
> the users? This changelog is now misleading as it does not mention
> that is now an urgent standalone fix. On first read I assumed this was
> part of a wider effort for 4.18.

Why is this an urgent fix?  I thought all the return type change was
did something completely innocuous that would not cause any real
difference.

Otherwise there are a dozen plus "fixups" to change the users that
will now become urgent fixes, which I did *not* expect to be the case.
(Where two are in ext2 and ext4, and where I planned to take my time
and get them fixed in the next merge window, precisely becuase I did
not *think* they were urgent.)

    	    	 			- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
