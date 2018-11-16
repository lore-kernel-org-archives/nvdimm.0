Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FF932118F359
 for <linux-nvdimm@lists.01.org>; Fri, 16 Nov 2018 03:39:53 -0800 (PST)
Date: Fri, 16 Nov 2018 03:39:47 -0800
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [Ksummit-discuss] [RFC PATCH 3/3] libnvdimm, MAINTAINERS:
 Subsystem Profile
Message-ID: <20181116033947.5689b51c@silica.lan>
In-Reply-To: <e4efcfd8c99ef197714230cb1eb246b39dc83151.camel@perches.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225761038.2499188.1270468803677883744.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAMuHMdVOJsM=66RrnbOzVthsT9=dFRQtL2rv99tCPC02M=hiXw@mail.gmail.com>
 <20181115061036.1575223d@silica.lan>
 <20181115162008.GO3759@mtr-leonro.mtl.com>
 <20181115110919.46978343@silica.lan>
 <20181115193520.GA24359@mtr-leonro.mtl.com>
 <3908561D78D1C84285E8C5FCA982C28F7D459E55@ORSMSX110.amr.corp.intel.com>
 <e4efcfd8c99ef197714230cb1eb246b39dc83151.camel@perches.com>
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
To: Joe Perches <joe@perches.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Leon Romanovsky <leon@kernel.org>, "ksummit-discuss@lists.linuxfoundation.org" <ksummit-discuss@lists.linuxfoundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "zwisler@kernel.org" <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Em Thu, 15 Nov 2018 11:43:51 -0800
Joe Perches <joe@perches.com> escreveu:

> On Thu, 2018-11-15 at 19:40 +0000, Luck, Tony wrote:
> > > I would recommend to remove this section at all.
> > > New maintainers won't come out of blue, but will be come
> > > from existing community and such individuals for sure will see
> > > and judge by themselves to whom they trust and to whom not.  
> > 
> > Perhaps this is more of a hint to contributors than to maintainers
> > (see earlier discussion on who is the target audience for these documents).
> > 
> > It would help contributors know some names of useful reviewers (and
> > thus this list should be picked up by scripts/get_maintainer.pl to help
> > the user compose Cc: lists for e-mail patches).  
> 
> Trusted reviewers should be specifically listed
> in the MAINTAINERS file with an "R:" entry.
> 
> get_maintainers should not look anywhere else.

I know that making get_maintainers to look elsewhere can make it more
complex and slower, but IMHO, by having a per-subsystem profile, this is
unavoidable.

The thing is that touching at a single MAINTAINERS file every time a new
reviewer comes is painful. Also, MAINTAINERS file format doesn't allow
adding free text explaining the criteria for someone to become a
reviewer.

IMO, having reviewers on a per-subsystem file, where one could explain
the criteria for being added there will make easier to attract more
reviewers.

Cheers,
Mauro
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
