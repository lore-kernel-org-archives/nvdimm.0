Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9F83FC0
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 19:03:30 +0000 (UTC)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17KJ37ZR135590;
	Fri, 20 Aug 2021 15:03:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Bha1BAQCFKf7lKrFWrjTX5d61Zy+QrJJIsGDTCsLrWQ=;
 b=rIMsH4hyGtr3bnAaZufNpFirTwTsOCaTfifEFiVFVvgAmbeRNmHuAOlb6ObJKhgDzo64
 LVhGDGDqUIiTuZ4sX2FkjJGu1sCZyJT8VRX/2XJFaSexV2i0aJCCHJUfgL0CiUE1oIBS
 GQ7pApzbP45x6em4hovOZKOr4rSRSTaITd/bISasDCDJkSEYZs9o85GzQ4mwezpMt7ql
 uIXLFOH5cG6lZmJo1HY2n+eJpn+McGezVj3vCxp82ccj+hf0UASZ5Ti90qHkFZ4xfw4D
 KT+iykQ3hQ3cxZaAELfccwMxnlVLRg8KA1oG9/b8Hk+PYDGl279SsGAptnOlxBziNjn3 cA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3ahp9yd10v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Aug 2021 15:03:28 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17KJ38uK013051;
	Fri, 20 Aug 2021 19:03:25 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by ppma03fra.de.ibm.com with ESMTP id 3agh2xmbvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Aug 2021 19:03:25 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17KJ3LhU52101480
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Aug 2021 19:03:21 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9D4AAE87F;
	Fri, 20 Aug 2021 19:03:21 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14D15AE88B;
	Fri, 20 Aug 2021 19:03:21 +0000 (GMT)
Received: from thinkpad (unknown [9.171.25.125])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Fri, 20 Aug 2021 19:03:20 +0000 (GMT)
Date: Fri, 20 Aug 2021 21:03:18 +0200
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@de.ibm.com>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390
 <linux-s390@vger.kernel.org>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
Message-ID: <20210820210318.187742e8@thinkpad>
In-Reply-To: <CAPcyv4jpHX4U3XisqVoaMf_qADDzKyDS1wOijCs3JR_ByrXmHA@mail.gmail.com>
References: <20210820054340.GA28560@lst.de>
	<CAPcyv4i5GHUXPCEu4RbD1x_=usTdK2VWqHfvHFEHijDYBg+CLw@mail.gmail.com>
	<CAPcyv4jpHX4U3XisqVoaMf_qADDzKyDS1wOijCs3JR_ByrXmHA@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QFfO0GbI0Uzbpj3_ZJPXMowAwt0e0-pO
X-Proofpoint-GUID: QFfO0GbI0Uzbpj3_ZJPXMowAwt0e0-pO
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-20_08:2021-08-20,2021-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1011
 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108200107

On Fri, 20 Aug 2021 10:42:14 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> [ fix Gerald's email ]
> 
> On Fri, Aug 20, 2021 at 8:41 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > [ add Gerald and Joao ]
> >
> > On Thu, Aug 19, 2021 at 10:44 PM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > Hi all,
> > >
> > > looking at the recent ZONE_DEVICE related changes we still have a
> > > horrible maze of different code paths.  I already suggested to
> > > depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern
> > > architectures have anyway.  But the other odd special case is
> > > CONFIG_FS_DAX_LIMITED which is just used for the xpram driver.  Does
> > > this driver still see use?  If so can we make it behave like the
> > > other DAX drivers and require a pgmap?  I think the biggest missing
> > > part would be to implement ARCH_HAS_PTE_DEVMAP for s390.
> > >
> >
> > Gerald,
> >
> > Might you still be looking to help dcssblk get out of FS_DAX_LIMITED
> > jail [1]? I recall Martin saying that 'struct page' overhead was
> > prohibitive. I don't know if Joao's 'struct page' diet patches could
> > help alleviate that at all (would require the filesystem to only
> > allocate blocks in large page sizes).
> >
> > [1]: https://lore.kernel.org/r/20180523205017.0f2bc83e@thinkpad

Ouch, yes, that is actually (still) on my list. Also, adding struct
pages for dcssblk in XIP / DAX mode is not really prohibitive. The
whole feature was designed to allow saving memory when the same
binaries need to be executed from many z/VM guests. The XIP
(execute-in-place) part allows to execute them directly from the
DCSS (shared) memory segment, saving page cache usage on all guests.

Additionally saving the struct pages for the DCSS memory itself can
be considered a bonus, but it's just 1/64th of the otherwise saved
memory. For this reason, and also because there are hardly any users
of that feature left, we certainly can do w/o that, i.e. live with
having the struct pages.

I must admit that I neglected this a bit, and it was only a question
of time until this popped up again (rightfully). I understand that
having and maintaining this FS_DAX_LIMITED workaround is really ugly.

So I will give this some priority now, and I hope that it still only
affects dcssblk, and we did not get any other non-s390 users in the
meantime.

BTW, s390 xpram driver should not be affected. AFAIR, we also might
not have struct pages there, but it also is not possible to use it
with DAX, so it should not care about FS_DAX_LIMITED.
