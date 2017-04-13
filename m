Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F08AD21A0483A
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 22:21:43 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id
 v3D5IcYp136004
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 01:21:43 -0400
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
 by mx0b-001b2d01.pphosted.com with ESMTP id 29snvjqfvx-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 01:21:42 -0400
Received: from localhost
 by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.vnet.ibm.com>;
 Thu, 13 Apr 2017 15:21:40 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
 by d23relay10.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 v3D5LTP045285494
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:21:37 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
 by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 v3D5L05E003660
 for <linux-nvdimm@lists.01.org>; Thu, 13 Apr 2017 15:21:01 +1000
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/9] powerpc/mm: Add _PAGE_DEVMAP for ppc64.
In-Reply-To: <20170411174233.21902-4-oohall@gmail.com>
References: <20170411174233.21902-1-oohall@gmail.com>
 <20170411174233.21902-4-oohall@gmail.com>
Date: Thu, 13 Apr 2017 10:50:43 +0530
MIME-Version: 1.0
Message-Id: <87zifkq3x0.fsf@skywalker.in.ibm.com>
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
To: Oliver O'Halloran <oohall@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc: bsingharora@gmail.com, arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Oliver O'Halloran <oohall@gmail.com> writes:

> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>
> Add a _PAGE_DEVMAP bit for PTE and DAX PMD entires. PowerPC doesn't
> currently support PUD faults so we haven't extended it to the PUD
> level.
>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>


Few changes we would need. We will now need to make sure a devmap
pmd entry is not confused with THP. ie,

we should compare against _PAGE_PTE and _PAGE_DEVMAP in
pmd_trans_huge(). hash already has one bit we use to differentiate
between hugetlb and THP. May be we can genarlize this and come up with a
way to differentiate THP, HUGETLB,pmd DEVMAP entries ?


also I don't see you handing get_user_pages_fast() ?


-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
