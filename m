Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E92221A0483B
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 20:07:40 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id
 v3C2wgre047615
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 23:07:40 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
 by mx0a-001b2d01.pphosted.com with ESMTP id 29s91j6646-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 23:07:39 -0400
Received: from localhost
 by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.vnet.ibm.com>;
 Tue, 11 Apr 2017 21:07:39 -0600
Subject: Re: [PATCH 3/9] powerpc/mm: Add _PAGE_DEVMAP for ppc64.
References: <20170411174233.21902-1-oohall@gmail.com>
 <20170411174233.21902-4-oohall@gmail.com>
 <20170412101922.572b59ca@canb.auug.org.au>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Wed, 12 Apr 2017 08:37:30 +0530
MIME-Version: 1.0
In-Reply-To: <20170412101922.572b59ca@canb.auug.org.au>
Message-Id: <19df521f-ed1b-a351-9141-c3ba11c96cfb@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Oliver O'Halloran <oohall@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On Wednesday 12 April 2017 05:49 AM, Stephen Rothwell wrote:
> Hi Oliver,
>
> On Wed, 12 Apr 2017 03:42:27 +1000 Oliver O'Halloran <oohall@gmail.com> wrote:
>>
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>>
>> Add a _PAGE_DEVMAP bit for PTE and DAX PMD entires. PowerPC doesn't
>> currently support PUD faults so we haven't extended it to the PUD
>> level.
>>
>> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
>
> This needs Aneesh's Signed-off-by.
>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
