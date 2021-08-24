Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B063FC1
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 19:09:16 +0000 (UTC)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17OI2pXD088938;
	Tue, 24 Aug 2021 14:24:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=CQSjhBqa9IhwtYPuxQFmZCtU1qfdpGE9cPYZK/auCdI=;
 b=Op4Ba4wSJ61c8cVhurJT+aTzEwLmGlZEfTdplgPQFVgMVijDpHLCABZ01CIrjT64wOGm
 n63kMjg3FHBx/B9ha0RzOPh042XOzJStY/oCsahnVqoueez3jFONqzCV7ARkkp/Ufdcg
 D8G+7Kzds3ZlZOtlcJzzaVKRSxLPmRaRy4pOgb/1UyUK9ynvLuHyOl4hWK2RdGg++im+
 LiyPb+89QeWbznhcgDpfEgJyX/R2JEX6vWZ+H2r6yXX6Bk9VikjBLnk829z+GewqfuuN
 2hvdKMY/PwOGWSBMk7h5qqkUP5Tn6+ciYrWhTld8TGFFUAKkzQKQp5gE1D+cjwrj6Wso jA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3an5nu8mbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Aug 2021 14:24:57 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17OI8WZN004717;
	Tue, 24 Aug 2021 18:24:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma03ams.nl.ibm.com with ESMTP id 3ajs48dnnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Aug 2021 18:24:55 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17OIOqEu52494822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Aug 2021 18:24:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5B6AAE06E;
	Tue, 24 Aug 2021 18:24:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75B62AE057;
	Tue, 24 Aug 2021 18:24:51 +0000 (GMT)
Received: from thinkpad (unknown [9.171.26.150])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Tue, 24 Aug 2021 18:24:51 +0000 (GMT)
Date: Tue, 24 Aug 2021 20:24:49 +0200
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>, Christoph Hellwig
 <hch@lst.de>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux
 NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
Message-ID: <20210824202449.19d524b5@thinkpad>
In-Reply-To: <CAPcyv4jYXPWmT2EzroTa7RDz1Z68Qz8Uj4MeheQHPbBXdfS4pA@mail.gmail.com>
References: <20210820054340.GA28560@lst.de>
	<20210823160546.0bf243bf@thinkpad>
	<20210823214708.77979b3f@thinkpad>
	<CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
	<e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com>
	<CAPcyv4jYXPWmT2EzroTa7RDz1Z68Qz8Uj4MeheQHPbBXdfS4pA@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aDSOrzBDX7qNcPzvxKb_e1iSh3ps2dXR
X-Proofpoint-GUID: aDSOrzBDX7qNcPzvxKb_e1iSh3ps2dXR
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-24_05:2021-08-24,2021-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 phishscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108240119

On Tue, 24 Aug 2021 07:53:22 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Tue, Aug 24, 2021 at 7:10 AM Joao Martins <joao.m.martins@oracle.com> wrote:
> >
> >
> >
> > On 8/23/21 9:21 PM, Dan Williams wrote:
> > > On Mon, Aug 23, 2021 at 12:47 PM Gerald Schaefer
> > > <gerald.schaefer@linux.ibm.com> wrote:
> > >>
> > >> On Mon, 23 Aug 2021 16:05:46 +0200
> > >> Gerald Schaefer <gerald.schaefer@linux.ibm.com> wrote:
> > >>
> > >>> On Fri, 20 Aug 2021 07:43:40 +0200
> > >>> Christoph Hellwig <hch@lst.de> wrote:
> > >>>
> > >>>> Hi all,
> > >>>>
> > >>>> looking at the recent ZONE_DEVICE related changes we still have a
> > >>>> horrible maze of different code paths.  I already suggested to
> > >>>> depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern
> > >>
> > >> Oh, we do have PTE_SPECIAL, actually that took away the last free bit
> > >> in the pte. So, if there is a chance that ZONE_DEVICE would depend
> > >> on PTE_SPECIAL instead of PTE_DEVMAP, we might be back in the game
> > >> and get rid of that CONFIG_FS_DAX_LIMITED.
> > >
> > > So PTE_DEVMAP is primarily there to coordinate the
> > > get_user_pages_fast() path, and even there it's usage can be
> > > eliminated in favor of PTE_SPECIAL. I started that effort [1], but
> > > need to rebase on new notify_failure infrastructure coming from Ruan
> > > [2]. So I think you are not in the critical path until I can get the
> > > PTE_DEVMAP requirement out of your way.
> > >
> >
> > Isn't the implicit case that PTE_SPECIAL means that you
> > aren't supposed to get a struct page back? The gup path bails out on
> > pte_special() case. And in the fact in this thread that you quote:
> >
> > > [1]: https://lore.kernel.org/r/161604050866.1463742.7759521510383551055.stgit@dwillia2-desk3.amr.corp.intel.com
> >
> > (...) we were speaking about[1.1] using that same special bit to block
> > longterm gup for fs-dax (while allowing it device-dax which does support it).
> >
> > [1.1] https://lore.kernel.org/nvdimm/a8c41028-c7f5-9b93-4721-b8ddcf2427da@oracle.com/
> >
> > Or maybe that's what you mean for this particular case of FS_DAX_LIMITED. Most _special*()
> > cases in mm match _devmap*() as far I've experimented in the past with PMD/PUD and dax
> > (prior to [1.1]).
> >
> > I am just wondering would you differentiate the case where you have metadata for the
> > !FS_DAX_LIMITED case in {gup,gup_fast} path in light of removing PTE_DEVMAP. I would have
> > thought of checking that a pgmap exists for the pfn (without grabbing a ref to it).
> 
> So I should clarify, I'm not proposing removing PTE_DEVMAP, I'm
> proposing relaxing its need for architectures that can not afford the
> PTE bit. Those architectures would miss out on get_user_pages_fast()
> for devmap pages. Then, once PTE_SPECIAL kicks get_user_pages() to the
> slow path, get_dev_pagemap() is used to detect devmap pages.

Thanks, I was also a bit confused, but I think I got it now. Does that mean
that you also plan to relax the pte_devmap(pte) check in follow_page_pte(),
before calling get_dev_pagemap() in the slow path? So that it could also be
called for pte_special(), maybe with additional vma_is_dax() check. And then
rely on get_dev_pagemap() finding the pages for those "very special" PTEs that
actually would have struct pages (at least for s390 DCSS with DAX)?
