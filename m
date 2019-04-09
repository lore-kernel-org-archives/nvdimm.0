Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 99647211F9D4C
 for <linux-nvdimm@lists.01.org>; Mon,  8 Apr 2019 21:47:10 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x394kviI097367
 for <linux-nvdimm@lists.01.org>; Tue, 9 Apr 2019 00:47:09 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2rrkk5t3u4-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 09 Apr 2019 00:47:08 -0400
Received: from localhost
 by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Tue, 9 Apr 2019 05:47:07 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v2] mm: Fix modifying of page protection by
 insert_pfn_pmd()
In-Reply-To: <20190403122939.C4187214AF@mail.kernel.org>
References: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
 <20190403122939.C4187214AF@mail.kernel.org>
Date: Tue, 09 Apr 2019 10:16:59 +0530
MIME-Version: 1.0
Message-Id: <87o95fn5to.fsf@linux.ibm.com>
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
To: Sasha Levin <sashal@kernel.org>Sasha Levin <sashal@kernel.org>, dan.j.williams@intel.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Sasha Levin <sashal@kernel.org> writes:

> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.0.5, v4.19.32, v4.14.109, v4.9.166, v4.4.177, v3.18.137.
>
> v5.0.5: Build OK!
> v4.19.32: Build OK!

Considering this only impact ppc64 for now I guess it is ok to apply
this to the above two kernel versions. The SCM support for ppc64 was
added via

git describe --contains b5beae5e224f1c72c4482b0ab36fc3d89481a6b2
v4.20-rc1~24^2~68

powerpc/pseries: Add driver for PAPR SCM regions

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
