Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pa0-x233.google.com (mail-pa0-x233.google.com
 [IPv6:2607:f8b0:400e:c03::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B3AAE1A2053
 for <linux-nvdimm@lists.01.org>; Thu, 22 Sep 2016 19:33:41 -0700 (PDT)
Received: by mail-pa0-x233.google.com with SMTP id hm5so35123836pac.0
 for <linux-nvdimm@lists.01.org>; Thu, 22 Sep 2016 19:33:41 -0700 (PDT)
Date: Thu, 22 Sep 2016 19:33:34 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/2] shmem: fix tmpfs to handle the huge= option properly
In-Reply-To: <8737ksw69p.fsf@linux.vnet.ibm.com>
Message-ID: <alpine.LSU.2.11.1609221904020.19987@eggly.anvils>
References: <1473459863-11287-1-git-send-email-toshi.kani@hpe.com>
 <1473459863-11287-2-git-send-email-toshi.kani@hpe.com>
 <8737ksw69p.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mawilcox@microsoft.com, Hillf Danton <hillf.zj@alibaba-inc.com>, hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 22 Sep 2016, Aneesh Kumar K.V wrote:
> Toshi Kani <toshi.kani@hpe.com> writes:
> 
> > shmem_get_unmapped_area() checks SHMEM_SB(sb)->huge incorrectly,
> > which leads to a reversed effect of "huge=" mount option.
> >
> > Fix the check in shmem_get_unmapped_area().
> >
> > Note, the default value of SHMEM_SB(sb)->huge remains as
> > SHMEM_HUGE_NEVER.  User will need to specify "huge=" option to
> > enable huge page mappings.
> >
> 
> Any update on getting this merged ?
> 
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Yikes, how did we ever not notice this?  Very embarrassing.

Huge thank you to Hillf for spotting it (only now do I rediscover
your June mail: I'm sorry, my attention has been fully elsewhere).

Big thank you to Toshi for sending the patch,
and to Aneesh for now sounding the alarm.

The only reassurance is that at least all the rest of it has
been under test for the last few months, via the SHMEM_HUGE_FORCE
override.  So it's not as if none of the code has been tested,
but I am still mystified why it hasn't been obvious without.

To the patch,
Acked-by: Hugh Dickins <hughd@google.com>
but I wish I could dream up a more emphatic tag.

Andrew, please please grab this and send it in!

Thank you,
Hugh

> 
> > Reported-by: Hillf Danton <hillf.zj@alibaba-inc.com>
> > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Cc: Hugh Dickins <hughd@google.com>
> > ---
> >  mm/shmem.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index fd8b2b5..aec5b49 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1980,7 +1980,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
> >  				return addr;
> >  			sb = shm_mnt->mnt_sb;
> >  		}
> > -		if (SHMEM_SB(sb)->huge != SHMEM_HUGE_NEVER)
> > +		if (SHMEM_SB(sb)->huge == SHMEM_HUGE_NEVER)
> >  			return addr;
> >  	}
> >  
> >
> > --
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
