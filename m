Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F00681E88
 for <linux-nvdimm@lists.01.org>; Thu, 10 Nov 2016 20:12:33 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id
 uAB48TQD010106
 for <linux-nvdimm@lists.01.org>; Thu, 10 Nov 2016 23:12:36 -0500
Received: from e23smtp08.au.ibm.com (e23smtp08.au.ibm.com [202.81.31.141])
 by mx0a-001b2d01.pphosted.com with ESMTP id 26n1byt5n8-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 10 Nov 2016 23:12:36 -0500
Received: from localhost
 by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <khandual@linux.vnet.ibm.com>;
 Fri, 11 Nov 2016 14:12:34 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
 by d23dlp02.au.ibm.com (Postfix) with ESMTP id 30E782BB0057
 for <linux-nvdimm@lists.01.org>; Fri, 11 Nov 2016 15:12:33 +1100 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
 by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 uAB4CWiW36634732
 for <linux-nvdimm@lists.01.org>; Fri, 11 Nov 2016 15:12:32 +1100
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
 by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 uAB4CWmc022121
 for <linux-nvdimm@lists.01.org>; Fri, 11 Nov 2016 15:12:32 +1100
Subject: Re: [PATCH] mm: add ZONE_DEVICE statistics to smaps
References: <147881591739.39198.1358237993213024627.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date: Fri, 11 Nov 2016 09:42:18 +0530
MIME-Version: 1.0
In-Reply-To: <147881591739.39198.1358237993213024627.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-Id: <58254522.70008@linux.vnet.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 11/11/2016 03:41 AM, Dan Williams wrote:
> ZONE_DEVICE pages are mapped into a process via the filesystem-dax and
> device-dax mechanisms.  There are also proposals to use ZONE_DEVICE
> pages for other usages outside of dax.  Add statistics to smaps so
> applications can debug that they are obtaining the mappings they expect,
> or otherwise accounting them.

This might also help when we will have ZONE_DEVICE based solution for
HMM based device memory.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
