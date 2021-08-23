Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9992F3FC0
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 19:47:18 +0000 (UTC)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17NJWsdK179055;
	Mon, 23 Aug 2021 15:47:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=PJxEuxRmEIHlb0OAOevNy3NFmY3DbCPNlzGEHrbXp00=;
 b=XwxKGdZ79GK09DXzh1sxkLlUIjH/VpGHs1jTA2+uGIQQcNIUBkFOGoEe96EjfWfkGd6R
 G7M9mBfp3jgf9G4GC9E7TfDF4soGFzFYJsL4lFd2Txm3tyt9hAAlppEwPChJv3TxPkCT
 J+M0PZ2I0eoMSc+qb7YPIziFPKbH9Yn8U4tkfe39uxZos6FVhuJcreVN65Z3YCsTApx6
 4Zv56EdVvFhWKejZbyOcRiTysGol8biDkhEk6jS93tditoXli+U/dlmwyU8vTGLXbUak
 C5d8tnILW8PDvjjqerwxGU35vVjHHqdCyvb7t8WWsKS+nEVaf+1h1vjmYiosgk4jzRhB OA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3amhemh1vs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Aug 2021 15:47:16 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
	by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17NJgPrV030829;
	Mon, 23 Aug 2021 19:47:14 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma02fra.de.ibm.com with ESMTP id 3ajs48b95n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Aug 2021 19:47:14 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17NJlARH53018902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Aug 2021 19:47:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 816DCAE056;
	Mon, 23 Aug 2021 19:47:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11114AE051;
	Mon, 23 Aug 2021 19:47:10 +0000 (GMT)
Received: from thinkpad (unknown [9.171.9.196])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
	Mon, 23 Aug 2021 19:47:09 +0000 (GMT)
Date: Mon, 23 Aug 2021 21:47:08 +0200
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dan Williams
 <dan.j.williams@intel.com>, nvdimm@lists.linux.dev,
        linux-s390@vger.kernel.org
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
Message-ID: <20210823214708.77979b3f@thinkpad>
In-Reply-To: <20210823160546.0bf243bf@thinkpad>
References: <20210820054340.GA28560@lst.de>
	<20210823160546.0bf243bf@thinkpad>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gxt_o5tcJYTtr5UwTuOdZVZ3Rjui3-TT
X-Proofpoint-ORIG-GUID: gxt_o5tcJYTtr5UwTuOdZVZ3Rjui3-TT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-23_04:2021-08-23,2021-08-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=801 adultscore=0 impostorscore=0 phishscore=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230133

On Mon, 23 Aug 2021 16:05:46 +0200
Gerald Schaefer <gerald.schaefer@linux.ibm.com> wrote:

> On Fri, 20 Aug 2021 07:43:40 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Hi all,
> > 
> > looking at the recent ZONE_DEVICE related changes we still have a
> > horrible maze of different code paths.  I already suggested to
> > depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern

Oh, we do have PTE_SPECIAL, actually that took away the last free bit
in the pte. So, if there is a chance that ZONE_DEVICE would depend
on PTE_SPECIAL instead of PTE_DEVMAP, we might be back in the game
and get rid of that CONFIG_FS_DAX_LIMITED.

Or did you rather mean depend on ARCH_HAS_PTE_SPECIAL on top of
ARCH_HAS_PTE_DEVMAP?

> > architectures have anyway.  But the other odd special case is
> > CONFIG_FS_DAX_LIMITED which is just used for the xpram driver.  Does
> > this driver still see use?  If so can we make it behave like the
> > other DAX drivers and require a pgmap?  I think the biggest missing
> > part would be to implement ARCH_HAS_PTE_DEVMAP for s390.
> 
> Puh, yes, that seems to be needed in order to enable ZONE_DEVICE, and
> then we could use devm_memremap_pages(), at least that was my plan
> some time ago. However, either the ARCH_HAS_PTE_DEVMAP dependency
> is new, or I overlooked it before, but we do not have any free bits
> in the pte left, so this is not going to work.
> 
> Would it strictly be necessary to implement ZONE_DEVICE, or would
> it be enough if we would use e.g. add_memory() instead of just
> adding the DCSS memory directly to the kernel mapping via
> vmem_add_mapping()? That way we might at least get the struct pages,
> but somehow it doesn't feel completely right.

