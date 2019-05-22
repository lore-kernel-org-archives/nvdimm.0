Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5393521276749
 for <linux-nvdimm@lists.01.org>; Tue, 21 May 2019 22:41:28 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x4M5b1wc097808
 for <linux-nvdimm@lists.01.org>; Wed, 22 May 2019 01:41:27 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2smyx6h9tp-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 22 May 2019 01:41:27 -0400
Received: from localhost
 by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Wed, 22 May 2019 06:41:27 +0100
Subject: Re: [PATCH] mm/nvdimm: Use correct #defines instead of opencoding
References: <20190514025604.9997-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4iNgFbSq0Hqb+CStRhGWMHfXx7tL3vrDaQ95DcBBY8QCQ@mail.gmail.com>
 <f99c4f11-a43d-c2d3-ab4f-b7072d090351@linux.ibm.com>
 <CAPcyv4gOr8SFbdtBbWhMOU-wdYuMCQ4Jn2SznGRsv6Vku97Xnw@mail.gmail.com>
 <02d1d14d-650b-da38-0828-1af330f594d5@linux.ibm.com>
 <CAPcyv4jcSgg0wxY9FAM4ke9JzVc9Pu3qe6dviS3seNgHfG2oNw@mail.gmail.com>
 <87mujgcf0h.fsf@linux.ibm.com>
 <CAPcyv4j5Y+AFkbvYjDnfqTdmN_Sq=O0qfGUorgpjAE8Ww7vH=A@mail.gmail.com>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Date: Wed, 22 May 2019 11:11:19 +0530
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j5Y+AFkbvYjDnfqTdmN_Sq=O0qfGUorgpjAE8Ww7vH=A@mail.gmail.com>
Content-Language: en-US
Message-Id: <d328ce41-4a65-c35e-72d7-74e722795428@linux.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 5/21/19 9:37 PM, Dan Williams wrote:
> On Tue, May 21, 2019 at 2:51 AM Aneesh Kumar K.V
> <aneesh.kumar@linux.ibm.com> wrote:


....

>>
>> Something like the below (Not tested). I am not sure what we will init the page_size
>> for minor version < 3. This will mark the namespace disabled if the
>> PAGE_SIZE and sizeof(struct page) doesn't match with the values used
>> during namespace create.
> 
> Yes, this is on the right track.
> 
> I would special-case page_size == 0 as 4096 and page_struct_size == 0
> as 64. If either of those is non-zero then the info-block version
> needs to be revved and it needs to be crafted to make older kernels
> fail to parse it.
> 

page_size = SZ_4K implies we fail to enable namesepaces created on ppc64 
till now. We do work fine with page_size = PAGE_SIZE. It is a few error 
check and pfn_sb->npfns that got wrong values. We do reserve the correct 
space for the required pfns even when we recorded wrong pfn_sb->npfs.


> There was an earlier attempt to implement minimum info-block versions here:
> 
> https://lore.kernel.org/lkml/155000670159.348031.17631616775326330606.stgit@dwillia2-desk3.amr.corp.intel.com/
> 
> ...but that was dropped in favor of the the "sub-section" patches.
> 

Ok i will pick that too.

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
