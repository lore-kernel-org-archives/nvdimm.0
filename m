Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB25D22526482
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 18:03:35 -0700 (PDT)
Date: Thu, 5 Apr 2018 09:03:30 +0800
From: Xiong Zhou <xzhou@redhat.com>
Subject: Re: Can't hit dax pmd fault on nvdimm in raw mode
Message-ID: <20180405010330.c62r3ianwbmwlhx4@XZHOUW.usersys.redhat.com>
References: <20180404143713.t4lsufodbe7pr2jm@XZHOUW.usersys.redhat.com>
 <CAPcyv4iyzpSVKmV_dC2TyUkbX0J69bqzNT_eQGM9vMXqBac1qA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iyzpSVKmV_dC2TyUkbX0J69bqzNT_eQGM9vMXqBac1qA@mail.gmail.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 04, 2018 at 07:48:23AM -0700, Dan Williams wrote:
> On Wed, Apr 4, 2018 at 7:37 AM, Xiong Zhou <xzhou@redhat.com> wrote:
> > Hi,
> >
> > It works fine in memory mode. Both tested on latest Linus tree with xfs.
> >
> > Referring https://nvdimm.wiki.kernel.org/2mib_fs_dax
> >
> > Did I miss anything?
> 
> No, this behavior is by design. See commit ee82c9ed41e8 "dax: disable
> pmd mappings". The short summary is that struct page is needed to
> support get_user_pages() on dax pmd mappings, and raw mappings do not
> provide struct page.

Thanks very much Dan!

> 
> Details here: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ee82c9ed41e8
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
