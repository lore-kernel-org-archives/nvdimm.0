Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com
 [148.163.143.35])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D9CD1202E53C6
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 09:03:56 -0800 (PST)
Received: from pps.filterd (m0148664.ppops.net [127.0.0.1])
 by mx0b-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x1EGuGjR018001
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 17:03:54 GMT
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 by mx0b-002e3701.pphosted.com with ESMTP id 2qn9mh1ndh-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 17:03:54 +0000
Received: from G2W6311.americas.hpqcorp.net (g2w6311.austin.hp.com
 [16.197.64.53])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3427.houston.hpe.com (Postfix) with ESMTPS id 426947B
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 17:03:53 +0000 (UTC)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [ndctl PATCH 1/2] autoconf: Check for MAP_SHARED_VALIDATE
Date: Thu, 14 Feb 2019 17:03:28 +0000
Message-ID: <AT5PR8401MB116943788DB1A028C35CF3E9AB670@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20190214163422.15221-1-elliott@hpe.com>
 <CAPcyv4hWy-w2UVYzi=8BNnm24Ts4A6QPU9qrDOVw9UP4OPsG5A@mail.gmail.com>
In-Reply-To: <CAPcyv4hWy-w2UVYzi=8BNnm24Ts4A6QPU9qrDOVw9UP4OPsG5A@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Dan Williams [mailto:dan.j.williams@intel.com]
> Sent: Thursday, February 14, 2019 10:54 AM
> To: Elliott, Robert (Persistent Memory) <elliott@hpe.com>
> Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
> Subject: Re: [ndctl PATCH 1/2] autoconf: Check for MAP_SHARED_VALIDATE
> 
> On Thu, Feb 14, 2019 at 8:29 AM Robert Elliott <elliott@hpe.com> wrote:
> >
> > Some ndctl tests use two new mmap() flags named MAP_SHARED_VALIDATE
> > and MAP_SYNC that were added by linux kernel-4.15, intended to be
> > defined for applications by sys/mman.h. However, these do not exist
> > unless the distro has glibc-2.28.
> >
> > In addition to the existing check for MAP_SYNC, check that
> > MAP_SHARED_VALIDATE is provided.
> >
> > Fixes: 94679e6b78aa ("ndctl, test: check availability of MAP_SYNC for poison test")
> > Signed-off-by: Robert Elliott <elliott@hpe.com>
> 
> Does this really fix anything? How can a system have MAP_SYNC without
> MAP_SHARED_VALIDATE?

In glibc, MAP_SHARED_VALIDATE went into all architectures while
MAP_SYNC did not - these are left out: 
    alpha hppa mips powerpc sparc tile 

Checking both provides a breadcrumb about whether it's an overall
glibc version problem or an architecture-specific problem.

BTW, the glibc patches at git://sourceware.org/git/glibc.git are
these on 2018-02-06:
    e76def72eb74 ("Add MAP_SYNC from Linux 4.15.")
    92669d6ee3f2 ("Add MAP_SHARED_VALIDATE from Linux 4.15.")


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
